import socket
import sys

# Create a UDS socket
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = '/tmp/ryzenadj_socket'
print(f'connecting to {server_address}')
try:
    sock.connect(server_address)
except socket.error as err:
    print(f'error {err}')
    sys.exit(1)

try:
    
    # Send data
    message = b'This is the message.  It will be repeated.'
    print(f'sending {message}')
    sock.sendall(message)

    amount_received = 0
    amount_expected = len(message)
    
    while amount_received < amount_expected:
        data = sock.recv(4096)
        amount_received += len(data)
        print('received {data}')

finally:
    print('closing socket')
    sock.close()
