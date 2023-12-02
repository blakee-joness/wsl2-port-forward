<#
        .SYNOPSIS
        A simple script to that will setup port-forwarding between WSL2 and Windows. 
        This is a forked from here: https://gist.github.com/killshot13/8e776a3acb7760f8ebafe9a025e302f7

        .DESCRIPTION
        The script will create 4 Firewall rules (outlined below) and issue netsh commands corelated with the ports outlined in the ports argument. 
        There is a 'self-cleaning' idea in place that will remove the firewall rules and netsh proxyport forwarding every time the script is executed. 

        - Inbound Firewall Rules
          - Firewall Rule #1 will allow and enable Inbound TCP Traffic based on the port list provided.
          - Firewall Rule #2 will allow and enable Inbound UDP Traffic based on the port list provided.

        - Outbound Firewall Rules
          - Firewall Rule #3 will allow and enable Outbound TCP Traffic based on the port list provided.
          - Firewall Rule #4 will allow and enable Outbound UDP Traffic based on the port list provided.

#>

[String[]]$ports = @("80", "8080", "443");


If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

$remoteport = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if ( $found ) {
  $remoteport = $matches[0];
}
else {
  Write-Output "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

Invoke-Expression "netsh interface portproxy reset"; # Disable this line if you do not want portproxy to be removed each time the script is ran. 

for ( $i = 0; $i -lt $ports.length; $i++ ) {
  $port = $ports[$i];
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port connectport=$port connectaddress=$remoteport";
}

[String]$script_location = (Get-Location).tostring() + "\" + ($MyInvocation.MyCommand.Name).tostring()

foreach ( $protocol in @("TCP", "UDP") ) {
  $ErrorActionPreference = "silentlycontinue"
  Remove-NetFirewallRule -DisplayName "($protocol) Docker Inbound AutoPortFoward" 
  Remove-NetFirewallRule -DisplayName "($protocol) Docker Outbound AutoPortFoward" 
  $ErrorActionPreference = "Continue"
  New-NetFirewallRule -DisplayName "($protocol) Docker Inbound AutoPortFoward" -LocalPort $ports -Action Allow -Description "Inbound Rule for: $ports (Created by script: $script_location)" -Profile "Any" -Protocol $protocol -Direction Inbound
  New-NetFirewallRule -DisplayName "($protocol) Docker Outbound AutoPortFoward" -LocalPort $ports -Action Allow -Description "Outbound Rule for: $ports (Created by script: $script_location)" -Profile "Any" -Protocol $protocol -Direction Outbound
}

Invoke-Expression "netsh interface portproxy show v4tov4";
