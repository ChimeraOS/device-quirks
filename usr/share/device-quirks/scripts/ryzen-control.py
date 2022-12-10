#!/usr/sbin/python3

import logging
import os
import signal
import socket
import sys
import warnings

from asyncio import all_tasks, CancelledError, coroutine, create_task, current_task, ensure_future, get_event_loop, sleep, start_unix_server
logging.basicConfig(format='[%(asctime)s | %(filename)s:%(lineno)s:%(funcName)s] %(message)s',
                    datefmt='%y%m%d_%H:%M:%S',
                    level=logging.DEBUG
                    )

logger = logging.getLogger(__name__)

warnings.filterwarnings('ignore', category=DeprecationWarning)

RYZENADJ_DELAY = 0.5

class RyzenControl:
    performance_selected = '--power-saving'
    performance_set = None
    running = False
    socket = '/tmp/ryzenadj_socket'
    valid_commands = []
    set_tctl = 95
    def __init__(self):
        self.task = None
        self.running = True
        self.get_valid_commands()
        logger.info(self.handle_cmd([self.performance_selected]))

        ensure_future(self.check_power_modes())
        self.loop = get_event_loop()
        logger.info('ryzenadj-control service started.')
        
        for s in (signal.SIGHUP, signal.SIGTERM, signal.SIGINT, signal.SIGQUIT):
            self.loop.add_signal_handler(s, lambda s=s: create_task(self.stop_loop(self.loop)))

    def get_valid_commands(self):

        run = os.popen('ryzenadj -h', 'r', 1).read().splitlines()
        for raw_cmd in run:
            trunc_cmd = raw_cmd.split()
            for i in range(2):
                if i > len(trunc_cmd) -1 or len(trunc_cmd) == 0:
                    continue
                if '-' in trunc_cmd[i][0]:
                    if not '=' in trunc_cmd[i]:
                        self.valid_commands.append(trunc_cmd[i].strip())
                        continue
                    self.valid_commands.append(trunc_cmd[i].split('=')[0].strip())

    def is_valid_command(self, raw_command):
        if raw_command in self.valid_commands:
            return True
        return False

    def start_task(self, Task):
        self.task = self.loop.create_task(Task)
        self.loop.run_forever()

    def start_server_task(self, Task, handler):
        unix_server = Task(handler, path=self.socket)

        self.loop.create_task(unix_server)

        print('Open Unix socket with Server.')
        self.loop.run_forever()

    @coroutine
    async def handle_message(self, reader, writer):
        raw_data = await reader.read(4096)
        data = raw_data.decode('utf-8').strip().split()
        logger.debug(f'{data}')
        if data:
            result = self.handle_cmd(data)
            logger.info(result)
            writer.write(bytes(result, 'utf-8'))

    def handle_cmd(self, message):
        if not self.is_valid_command(message[0]):
            result = f'Error: Got invalid command: {message[0]}'
        if len(message) == 1:
            result = self.do_adjust(message[0])
        elif len(message) == 2:
            result = self.do_adjust(message[0], message[1])
        elif len(message) > 2:
            result = f'Error: {message[0]} called with too many arguments'

        return result

    def do_adjust(self, cmd, *args):
        ryzenadj_cmd = f'ryzenadj {cmd}'
        if args:
            ryzenadj_cmd = f'ryzenadj {cmd} {args[0]}'
        run = os.popen(ryzenadj_cmd, 'r', 1).read()
        return run
    
    async def check_power_modes(self):

        while self.running:
            # Ensure safe temp ctl settings. Ensures OXP devices dont fry themselves.
            run = self.do_adjust('-i').splitlines()
            tctl = [i for i in run if 'THM LIMIT CORE' in i][0].split()[5]
            if tctl != f'{self.set_tctl}.000':
                logger.info(f'found tctl set to {tctl}')
                logger.info(self.do_adjust(f'-f {self.set_tctl}').strip())
    
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
        logger.info('ryzenadj-control service stopped.')
    

if __name__ == '__main__':

    RyzenControl = RyzenControl()

    server = RyzenControl.start_server_task(start_unix_server, RyzenControl.handle_message)
#    power_loop = RyzenControl.start_task((RyzenControl.check_power_modes()))


