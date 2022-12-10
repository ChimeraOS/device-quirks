#!/usr/sbin/python3

import logging
import os
import signal
import socket
import sys
import warnings

from asyncio import all_tasks, CancelledError, coroutine, create_task, current_task, ensure_future, get_event_loop, sleep, start_unix_server
logging.basicConfig(format="[%(asctime)s | %(filename)s:%(lineno)s:%(funcName)s] %(message)s",
                    datefmt="%y%m%d_%H:%M:%S",
                    level=logging.DEBUG
                    )

logger = logging.getLogger(__name__)

warnings.filterwarnings("ignore", category=DeprecationWarning)

RYZENADJ_DELAY = 0.5

@coroutine
async def handle(reader, writer):
    data = await reader.read(4096)
    logger.debug(f'{data} received')

class RyzenControl:
    performance_selected = "--power-saving"
    performance_set = None
    running = False
    socket = '/tmp/ryzenadj_socket'
    
    def __init__(self):
        self.task = None
        self.running = True

        ensure_future(self.check_power_modes())
        self.loop = get_event_loop()
        logger.info("ryzenadj-control service started.")
        
        for s in (signal.SIGHUP, signal.SIGTERM, signal.SIGINT, signal.SIGQUIT):
            self.loop.add_signal_handler(s, lambda s=s: create_task(self.stop_loop(self.loop)))

    def start_task(self, Task):
        self.task = self.loop.create_task(Task)
        self.loop.run_forever()

    def start_server_task(self, Task, handler):
        unix_server = Task(handler, path=self.socket)

        self.loop.create_task(unix_server)

        print("Open Unix socket with Server.")
        self.loop.run_forever()

    def toggle_performance(self):
        
        if self.performance_selected == "--max-performance":
            self.performance_selected = "--power-saving"
        else:
            performance_selected = "--max-performance"
    
    def set_performance(self):
        
        ryzenadj_cmd = f"ryzenadj {self.performance_selected}"
        run = os.popen(ryzenadj_cmd, 'r', 1).read().strip()
        logger.info(run)
        result = run.split()[0]
        if result == "Sucessfully":
            self.performance_set = self.performance_selected
    
    async def check_power_modes(self):

        while self.running:
            # Ensure safe temp ctl settings. Ensures OXP devices dont fry themselves.
            run = os.popen("ryzenadj -i", 'r', 1).read().splitlines()
            tctl = [i for i in run if "THM LIMIT CORE" in i][0].split()[5]
            if tctl != "95.000":
                logger.info(f"found tctl set to {tctl}")
                ryzenadj_cmd = f"ryzenadj -f 95"
                logger.info(os.popen(ryzenadj_cmd, 'r', 1).read().strip())
    
           # Ensure performance mode is what we selected.
            if self.performance_set != self.performance_selected:
                self.set_performance()
    
            await sleep(RYZENADJ_DELAY)
    
    async def stop_loop(self, loop):
        
        # Kill all tasks. They are infinite loops so we will wait forver.
        logger.info('Kill signal received. Shutting down.')
        self.running = False
        for task in [t for t in all_tasks() if t is not current_task()]:
            task.cancel()
            try:
                await task
            except CancelledError:
                pass
        loop.stop()
        logger.info("ryzenadj-control service stopped.")
    

if __name__ == '__main__':

    RyzenControl = RyzenControl()

    server = RyzenControl.start_server_task(start_unix_server, handle)
#    power_loop = RyzenControl.start_task((RyzenControl.check_power_modes()))


