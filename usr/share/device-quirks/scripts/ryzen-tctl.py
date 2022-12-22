#!/usr/sbin/python3
import logging
import os
import signal
import socket
import sys
import warnings
from asyncio import (all_tasks, CancelledError, create_task, current_task,
                     ensure_future, get_event_loop, InvalidStateError,
                     Protocol, sleep)

from ryzenadj_controller.support import SUPPORTED_DEVICES

logging.basicConfig(format='[%(asctime)s | %(filename)s:%(lineno)s:%(funcName)s] %(message)s',
                    datefmt='%y%m%d_%H:%M:%S',
                    level=logging.INFO
                    )

logger = logging.getLogger(__name__)
warnings.filterwarnings('ignore', category=DeprecationWarning)
RYZENADJ_DELAY = 0.5

class DataProtocol(Protocol):
    def __init__(self, on_con_lost, message_cb):
        self.transport = None
        self.on_con_lost = on_con_lost
        self.message_cb = message_cb

    def connection_made(self, transport):
        self.transport = transport

    def data_received(self, data):
        self.message_cb(data.decode('utf-8'))
        self.transport.close()

    def connection_lost(self, exc):
        try:
            self.on_con_lost.set_result(True)
        except InvalidStateError:
            return False

class RyzenTCTL():
    def __init__(self):
        self.cpu = None
        self.current_settings = None
        self.last_command = None
        self.performance_selected = '--power-saving'
        self.performance_set = None
        self.protocol = None
        self.running = False
        self.set_tctl = 95
        self.socket = None
        self.socket_address = '/tmp/ryzenadj_socket'
        self.transport = None

        self.check_ryzen_installed()
        self.check_supported()
        self.running = True
        self.task = None

        logger.info('ryzen-tctl service started')
        ensure_future(self.connect_socket())
        ensure_future(self.check_tctl_set())

        self.loop = get_event_loop()

        for s in (signal.SIGHUP, signal.SIGTERM, signal.SIGINT, signal.SIGQUIT):
            self.loop.add_signal_handler(s, lambda s=s: create_task(self.stop_loop(self.loop)))

        self.loop.run_forever()

    def check_ryzen_installed(self):
        if not os.path.exists("/usr/bin/ryzenadj"):
            logger.error('RyzenAdj is not installed.')
            exit(1)

    def check_supported(self):
        cmd = 'lscpu | grep "Model name" | grep -v "BIOS" | cut -d : -f 2 | xargs'
        self.cpu = os.popen(cmd).read().strip()
        logger.debug(f'found {self.cpu}')
        if self.cpu not in SUPPORTED_DEVICES:
            logger.error('{self.cpu} is not supported.')
            exit(2)

    def send_message(self, message):
        logger.debug(f'Sending command: {message}')
        self.loop.call_soon(self.socket.send, message.encode())

    def receive_message(self, message):
        logger.debug(f'reveived message:\n{message}')
        match(self.last_command):
            case '-i':
                self.current_settings = message.splitlines()
                logger.debug(f'{self.current_settings}')
            case _:
                logger.info(f'{message}')

    async def connect_socket(self):
        while self.running:
            if not os.path.exists(self.socket_address):
                await sleep(RYZENADJ_DELAY)
                continue
            if not self.socket:
                try:
                    self.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                    self.socket.connect(self.socket_address)
                except ConnectionRefusedError:
                    logger.warn('Could not connect to RyzenaAdj Control')
                    await sleep(RYZENADJ_DELAY)
                    continue

            if not self.transport or not self.protocol:
                try:
                    on_con_lost = self.loop.create_future()
                    self.transport, self.protocol = await self.loop.create_unix_connection(lambda: DataProtocol(on_con_lost, self.receive_message), sock=self.socket)
                    logger.debug(f"got {self.transport}, {self.protocol}")
                    try:
                        await self.protocol.on_con_lost
                    finally:
                        self.transport.close()
                        self.socket.close
                        self.transport = None
                        self.socket = None
                except ConnectionRefusedError:
                    logger.warn('Could not connect to RyzenaAdj Control')
                    await sleep(RYZENADJ_DELAY)
                    continue

    async def check_tctl_set(self):

        # Check if this model is one that will not set tctl properly
        if self.cpu in [
                'AMD Ryzen 5 5560U with Radeon Graphics',
                ]:
            logger.info(f'{self.cpu} does not support tctl setting. Skipping automatic tctl management.')
            return

        while self.running:
            if not os.path.exists(self.socket_address):
                await sleep(RYZENADJ_DELAY)
                continue
            if not self.socket or not self.transport or not self.protocol:
                await sleep(RYZENADJ_DELAY)
                continue
            # Ensure safe temp ctl settings. Ensures OXP devices dont fry themselves.
            self.send_message('-i')
            self.last_command = '-i'
            if self.current_settings == None:
                await sleep(RYZENADJ_DELAY)
                continue
            await sleep(RYZENADJ_DELAY)
            tctl = [i for i in self.current_settings if 'THM LIMIT CORE' in i][0].split()[5]
            if tctl != f'{self.set_tctl}.000':
                logger.info(f'found tctl set to {tctl}')
                self.send_message(f'-f {self.set_tctl}')
                self.last_command = '-f'

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

    RyzenTCTL = RyzenTCTL()

