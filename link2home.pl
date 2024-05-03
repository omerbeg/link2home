#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;
use Getopt::Long;
use Socket;

# Read configuration
sub read_config {
    my ($filename) = @_;
    open my $fh, '<', $filename or die "Cannot open configuration file: $!";
    my %config;
    my $current_section;
    while (my $line = <$fh>) {
        chomp $line;
        $line =~ s/^\s+|\s+$//g; # Trim spaces
        next if $line eq "" || $line =~ /^#/; # Skip empty lines and comments
        if ($line =~ /^\[(.*)\]$/) {
            $current_section = $1;
            next;
        }
        if ($line =~ /^(.*?)\s*=\s*(.*)$/) {
            $config{$current_section}{$1} = $2;
        }
    }
    close $fh;
    return %config;
}

my %config = read_config('config.ini');
my $MAC_ADDRESS = $config{'General'}{'MAC_ADDRESS'};
my $BROADCAST_IP = $config{'General'}{'BROADCAST_IP'};
my $PORT = $config{'General'}{'PORT'};

my $COMMAND_PREFIX = "a104";
my %COMMAND_SUFFIX = (
    1 => "000901f202d171500101",
    2 => "000901f202d171500102"
);
my %STATE_CODES = (
    'on' => 'FF',
    'off' => '00'
);

# Command line options
my $relay;
my $state;
GetOptions(
    "relay=i" => \$relay,
    "state=s" => \$state
) or die "Error in command line arguments\n";

unless(defined $relay and exists $COMMAND_SUFFIX{$relay} and defined $state and exists $STATE_CODES{$state}) {
    die "Usage: $0 --relay [1|2] --state [on|off]\n";
}

# Create a UDP socket
my $sock = IO::Socket::INET->new(
    Proto => 'udp',
    Broadcast => 1,
    LocalPort => 0
) or die "Could not create socket: $!\n";

# Prepare the command
my $command = $COMMAND_PREFIX . $MAC_ADDRESS . $COMMAND_SUFFIX{$relay} . $STATE_CODES{$state};
my $message = pack("H*", $command);

# Prepare sockaddr_in
my $iaddr = inet_aton($BROADCAST_IP) or die "Invalid IP address: $BROADCAST_IP\n";
my $sockaddr = sockaddr_in($PORT, $iaddr);

# Send the command
$sock->send($message, 0, $sockaddr) or die "Send error: $!\n";
print "Command sent to relay $relay: " . ($state eq 'on' ? 'ON' : 'OFF') . "\n";

# Close the socket
$sock->close();
