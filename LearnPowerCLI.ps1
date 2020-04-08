#Basic One liners for managing vSphere

# Connects to a vCenter
Connect-VIServer -Server mzvmvcs001.martinez.local

# Get approved verbs
Get-Verb

# Find commands
Get-Command get-*host*

# Find commands from specific module
Get-Command get-*host* -Module VMware*

# Get help on a command
Get-Help Get-VMHost

# Show examples on a command
Get-Help Get-VMHost -Examples

# Detailed Help
Get-Help Get-VMHost -Detailed

# Show Full Help
Get-Help Get-VMHost -Full

# Gets all ESXi Hosts
Get-VMHost 

# Gets all ESXi Hosts and all of it's properties
Get-VMHost | Select-Object *

# Gets ESXi hosts with number 1,2,or 3 in the 10th spot
Get-VMHost -Server mzvmvcs00[1-3]*

# Gets single ESXi host and all the VMs running on it
Get-VMHost mzvmesx001.martinez.local | Get-VM 

# Gets single ESXi host and all the VMs running on it sorted by PowerState
Get-VMHost mzvmesx001.martinez.local | Get-VM | Sort-Object PowerState

# Gets single ESXi host and all the VMs running on it where the PowerState is PoweredOn
Get-VMHost mzvmesx001.martinez.local | Get-VM | Where-Object {$_.PowerState -eq "PoweredOn"}

# Gets all VMs where the Number of CPUs is Greater Than or Equal to 2
Get-VM | Where-Object {$_.NumCpu -ge 2}

# Gets a VM by a specific name
Get-VM -Name mzvmvro001

# Gets a VM by a specific name and stores the result in a variable
$vRO = Get-VM -Name mzvmvro001

# Using the Variable to return only a property value
$vRO.Version

# Using the Variable object and selecting only a Property and it's value
$vRO | Select-Object Version

# Gettimg all ESXi hosts and storing object result in a variable
$esx = Get-VMHost

# Returning the Model property value from a variable
$esx.Model

# Storing the host network information of an ESXi host in a variable
$esx = Get-VMHostNetwork -VMHost mzvmesx001.martinez.local

# Viewing the ESXi host network variable object
$esx

# Viewing all the properties of an ESXi host network variable object
$esx | Select-Object *

# Return the DNS Address value(s) of ESXi host network info from variable
$esx.DnsAddress

# Return the 2nd DNS address value of ESXi host network info from variable
$esx.DnsAddress[1]

# Searching for commands in the VMware Modules that contain the word "start"
Get-Command start-* -Module VMware*

# Get the help information from the command "Start-VM"
Get-Help Start-VM

# Getting a specific VM and then powering it on
Get-VM -Name mzvmvro001 | Start-VM

# Starting specific VMs
Start-VM -VM mzvmesx006, mzvmesx007

# Gracefully shutting down a specific VM and NOT have it prompt for confirmation 
Shutdown-VMGuest -VM mzvmvro001 -Confirm:$false

# Search for command with "guest" in the name in the VMware modules
Get-Command *guest* -module VMware*

# Get help examples on the command "Move-VM"
Get-Help Move-VM -Examples

# Get all ESX hosts, then get their Host Network Information, and only return the Properties and Values VMHost & HostName
Get-VMHost | Get-VMHostNetwork | Select-Object VMHost, HostName

# Get all ESXi hosts and get their configured NTP server(s)
Get-VMHost | Get-VMHostNtpServer

#################################
# Break Point
#################################

# Connect to a vCenter server
# Connect-VIServer mzvmvcs001.martinez.local

# Get specific VM and get it's network adapter info
Get-VM test | Get-NetworkAdapter

# Get specific VM and get information aobut the Guest OS
Get-VM test | Get-VMGuest

# Get specific VM and get ALL information aobut the Guest OS
Get-VM test | Get-VMGuest | Select-Object *

# Get specific VM and only specific properties/values
Get-VMGuest -VM test | Select-Object OSFullName, IPAddress, State, Nics

# Get specific VM and only specific properties/values and show in list format
Get-VMGuest -VM test | Select-Object OSFullName, IPAddress, State, Nics | Format-List

# Open VM Console Window
Open-VMConsoleWindow -VM Test

# Get Windows network adapter info
Get-NetAdapter

# Get Windows network adapter info in List Format
Get-NetAdapter | Format-List

# Get Windows IP address configuration
Get-NetIPAddress

# Get Windows IP address configuration with value Ethernet0
Get-NetIPAddress | Where-Object {$_.InterfaceAlias -eq "Ethernet0"}

# Get Windows IP address configuration with values Ethernet0 and only IPv4
Get-NetIPAddress | Where-Object {($_.InterfaceAlias -eq "Ethernet0") -and ($_.AddressFamily -eq "IPv4")}

# Get Windows IP address configuration with values Ethernet0 and IPv4 and only return those Properties/Values
Get-NetIPAddress | Where-Object {($_.InterfaceAlias -eq "Ethernet0") -and ($_.AddressFamily -eq "IPv4")} | 
Select-Object InterfaceAlias, IPAddress, AddressFamily, InterfaceIndex | Format-List

# Get help on Invoke-VMScript with examples
Get-Help Invoke-VMScript -Examples

# Store credentials in a variable
$winCreds = Get-Credential

# Show the credential info
$winCreds

# Check for IP Addr availablity
Test-NetConnection 10.100.20.45
Test-NetConnection 10.100.20.210
Test-NetConnection www.google.com

# Store IP command script in a variable
$ipScript = 'New-NetIPAddress -InterfaceIndex 3 -IPAddress 10.100.20.45 -PrefixLength 24 -DefaultGateway 10.100.20.1'

# Store DNS command script in a variable
$dnsScript = 'Set-DnsClientServerAddress -InterfaceIndex 3 -ServerAddresses 10.100.20.210'

# Send network adapter commands to Guest OS through VM tools to set IP addr
Invoke-VMScript -ScriptText $ipScript -VM test -GuestCredential $winCreds -ScriptType Powershell

# Send network adapter commands to Guest OS through VM tools to set DNS
Invoke-VMScript -ScriptText $dnsScript -VM test -GuestCredential $winCreds -ScriptType Powershell

# Test pinging VM by name and IP
Test-NetConnection test
Test-NetConnection 10.100.20.45

# View Windows Firewall Profiles
Invoke-VMScript -ScriptText 'Get-NetFirewallProfile' -VM test -GuestCredential $winCreds -ScriptType Powershell

# View Windows Firewall Profile Names & State
Invoke-VMScript -ScriptText 'Get-NetFirewallProfile | Select-Object Name, Enabled' -VM test -GuestCredential $winCreds -ScriptType Powershell

# Turn off Windows Firewall
Invoke-VMScript -ScriptText 'Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False' -VM test -GuestCredential `
$winCreds -ScriptType Powershell

# Test pinging VM by name and IP
Test-NetConnection test
Test-NetConnection 10.100.20.45
