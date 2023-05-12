# WSL2 Auto-Port-Forward

## Table of Contents

- [About](#about)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

A simple script to that will setup port-forwarding between WSL2 and Windows. 

This is a forked from here: https://gist.github.com/killshot13/8e776a3acb7760f8ebafe9a025e302f7

The script does the following:
 - Creates Windows Firewall rules 
   - Inbound TCP/UDP for each ports specified in the `$ports` variable.
   - Inbound TCP/UDP for each ports specified in the `$ports` variable.
 - Iterates through each port and issues the following `netsh` command: 
   - ```netsh interface portproxy add v4tov4 listenport=$port connectport=$port connectaddress=$remoteport```

### Prerequisites
#### ```You must run this script in an Admin PowerShell terminal.```

## Usage <a name = "usage"></a>
I've installed this in my startup directory, so that Docker ports are always exposed between the WSL2 instance and the Windows Host upon boot. 
You will need to modify the `$ports` variable to serve your needs. 

## Disclaimer <a name = "usage"></a>
This script comes with `no warranty`. Please evaluate and make adjustments that fit your needs. 
