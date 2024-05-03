import configparser
import socket
import argparse

def read_config(filename):
    config = configparser.ConfigParser()
    config.read(filename)
    return config

def send_command(mac, state, relay, broadcast_ip, port):
    """Send a command to the Link2Home socket via UDP."""
    command_prefix = "a104"
    command_suffix = {
        1: "000901f202d171500101",
        2: "000901f202d171500102"
    }
    state_codes = {
        'on': 'FF',
        'off': '00'
    }

    command = f"{command_prefix}{mac}{command_suffix[relay]}{state_codes[state]}"
    message = bytes.fromhex(command)
    
    # Set up the socket
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        sock.sendto(message, (broadcast_ip, port))
        print(f"Command sent to relay {relay}: {'ON' if state == 'on' else 'OFF'}")

def main():
    # Command line arguments parsing
    parser = argparse.ArgumentParser(description="Control Link2Home Sockets")
    parser.add_argument("relay", type=int, choices=[1, 2], help="Relay number (1 or 2)")
    parser.add_argument("state", choices=["on", "off"], help="State of the relay (on/off)")
    args = parser.parse_args()

    # Read configuration
    config = read_config('config.ini')
    mac_address = config.get('General', 'MAC_ADDRESS')
    broadcast_ip = config.get('General', 'BROADCAST_IP')
    port = config.getint('General', 'PORT')
    
    # Send the command
    send_command(mac_address, args.state, args.relay, broadcast_ip, port)

if __name__ == "__main__":
    main()
