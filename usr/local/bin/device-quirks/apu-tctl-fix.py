#!/usr/sbin/python3

import asyncio
import logging
import os
import signal
import socket
import sys
import warnings

logging.basicConfig(format="[%(asctime)s | %(filename)s:%(lineno)s:%(funcName)s] %(message)s",
                    datefmt="%y%m%d_%H:%M:%S",
                    level=logging.DEBUG
                    )

logger = logging.getLogger(__name__)

client_address = None
connection = None
performance_selected = "--power-saving"
performance_set = None
running = False

RYZENADJ_DELAY = 5.0

# TODO: asyncio is using a deprecated method in its loop, find an alternative.
# Suppress for now to keep journalctl output clean.
warnings.filterwarnings("ignore", category=DeprecationWarning)

def __init__():
    global running
    # Create socket 
    server_address = '/tmp/ryzenadj_socket'

    # Make sure the socket does not already exist
    try:
        os.unlink(server_address)
    except OSError:
        if os.path.exists(server_address):
            os.remove(server_address)



    # Create a UDS socket
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

    # Bind the socket to the port
    logger.info(f'Starting up {server_address}.')
    sock.bind(server_address)
    
    # Listen for incoming connections
    sock.listen(1)
    running = True


async def await_connection():
    global connection
    global client_address

    while running:

        if connection:
            await asyncio.sleep(RYZENADJ_DELAY)
            continue

        # Wait for a connection
        logger.info('waiting for a connection')
        connection, client_address = sock.accept()

async def await_data():
    
    # Receive the data in small chunks and retransmit it
    while running:
        data = connection.recv(16)
        print >>sys.stderr, 'received "%s"' % data
        if data:
            logger.info('{data}')
        else:
            connection.close()

def toggle_performance():
    global performance_selected
    
    if performance_selected == "--max-performance":
        performance_selected = "--power-saving"
    else:
        performance_selected = "--max-performance"

def set_performance():
    global performance_selected
    global performance_set
    
    ryzenadj_cmd = f"ryzenadj {performance_selected}"
    run = os.popen(ryzenadj_cmd, 'r', 1).read().strip()
    logger.info(run)
    result = run.split()[0]
    if result == "Sucessfully":
        performance_set = performance_selected

async def check_power_modes():
    global performance_selected
    global performance_set

    while running:
        # Ensure safe temp ctl settings. Ensures OXP devices dont fry themselves.
        run = os.popen("ryzenadj -i", 'r', 1).read().splitlines()
        tctl = [i for i in run if "THM LIMIT CORE" in i][0].split()[5]
        if tctl != "95.000":
            logger.info(f"found tctl set to {tctl}")
            ryzenadj_cmd = f"ryzenadj -f 95"
            logger.info(os.popen(ryzenadj_cmd, 'r', 1).read().strip())

       # Ensure performance mode is what we selected.
        if performance_set != performance_selected:
            set_performance()

        await asyncio.sleep(RYZENADJ_DELAY)

async def stop_loop(loop):
    
    # Kill all tasks. They are infinite loops so we will wait forver.
    running = False
    for task in [t for t in asyncio.all_tasks() if t is not asyncio.current_task()]:
        task.cancel()
        try:
            await task
        except asyncio.CancelledError:
            pass
    loop.stop()
    logger.info("apu-tctl-fix service stopped.")

def main():

    asyncio.ensure_future(check_power_modes())
    logger.info("apu-tctl-fix service started.")

    # Run asyncio loop to capture all events.
    loop = asyncio.get_event_loop()

    # Establish signaling to handle gracefull shutdown.
    for s in (signal.SIGHUP, signal.SIGTERM, signal.SIGINT, signal.SIGQUIT):
        loop.add_signal_handler(s, lambda s=s: asyncio.create_task(stop_loop(loop)))

    try:
        loop.run_forever()
        exit_code = 0
    except KeyboardInterrupt:
        logger.info("Keyboard interrupt.")
        exit_code = 1
    except Exception as err:
        logger.error(f"{err} | Hit exception condition.")
        exit_code = 2
    finally:
        loop.stop()
        sys.exit(exit_code)

if __name__ == "__main__":
    __init__()
    main()
