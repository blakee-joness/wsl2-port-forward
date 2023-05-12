# WSL2 Auto-Port-Forward

## Table of Contents

- [About](#about)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

A PowerShell script to that will setup port-forwarding from the Windows host to WSL2. 
This enables the exposed ports in WSL to be reachable by other hosts on the LAN.

This is a forked from here: https://gist.github.com/killshot13/8e776a3acb7760f8ebafe9a025e302f7

The script does the following:
 - Obtains your WSL2 instance's IP address.
 - Resets all `netsh interface portproxy` configurations on the Windows host.
 - Iterates through each port and issues the following `netsh` command: 
   - netsh interface portproxy add v4tov4 listenport=`$port` connectport=`$port` connectaddress=`$remoteport`
 - Creates Windows Firewall rules 
   - Inbound TCP/UDP for each ports specified in the `$ports` variable.
   - Inbound TCP/UDP for each ports specified in the `$ports` variable.

## Prerequisites
### ```You must run this script in an Admin PowerShell terminal.```

## Usage <a name = "usage"></a>
I've installed this in my Windows startup directory so that it executes upon boot.
You will need to modify the `$ports` variable to serve your needs. 

## Disclaimer <a name = "usage"></a>
This script comes with `no warranty`. Please evaluate and make adjustments that fit your needs. 
