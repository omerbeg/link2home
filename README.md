# Link2Home Socket Controller

This repository contains scripts to enable remote control of Link2Home sockets via UDP, allowing users to switch specified relays on or off based on command-line inputs. Both Python and Perl versions of the script read configuration details from an INI file and send a hex-encoded UDP command to the specified IP and port.

## Requirements

### Python
    - Python 3.x
    - ConfigParser module (included in the Python Standard Library)

### Perl
    - Perl 5.x
    - IO::Socket::INET module (typically included with Perl)
    - Socket module (typically included with Perl)

## Configuration File Setup

    Before running any script, ensure you have the `config.ini` file in the same directory as the script or specify its path in the script. The configuration file should be formatted as follows:

    [General]
    MAC_ADDRESS=98D863AABBCC
    BROADCAST_IP=192.168.1.255
    PORT=35932

## Installation

### Python
    No installation is required beyond having Python 3.x installed on your system. Simply download the script and the configuration file to the same directory.

### Perl
    Ensure Perl is installed on your system. No additional installation is necessary. Just ensure the script and configuration file are in the same directory.

## Usage

### Python Script

    To use the Python script, specify the relay and state as command-line arguments. Here is the basic syntax:

    python link2home.py <relay> <state>

### Perl Script

    To use the Perl script, specify the relay and state as command-line arguments. Here is the basic syntax:

    perl link2home.pl --relay <relay> --state <state>

### Arguments

    - `<relay>`: The relay number to control (1 or 2).
    - `<state>`: The desired state of the relay (`on` or `off`).

### Examples

#### Python

    Turn on relay 1:

    python link2home.py 1 on

    Turn off relay 2:

    python link2home.py 2 off

#### Perl

    Turn on relay 1:

    perl link2home.pl --relay 1 --state on

    Turn off relay 2:

    perl link2home.pl --relay 1 --state off

## Contributing

    Contributions to these scripts are welcome, especially in areas such as error handling, logging, and extending functionality. Please submit a pull request or raise an issue if you have suggestions or improvements.

## License

    This script is released under the GNU GENERAL PUBLIC LICENSE. See `LICENSE` file for more details.
