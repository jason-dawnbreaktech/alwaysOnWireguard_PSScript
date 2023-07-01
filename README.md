# alwaysOnWireguard_PSScript
This simple powershell script allows you to define 'TrustedSSIDs' that will allow Wireguard to function as an 'always on' VPN, constantly checking to see if you are on a predetermined safe wifi network. 


## How to use:

1. Edit the "TrustedSSIDs" variable list to include the names of Wi-Fi networks you trust. E.g. @("MyHomeWifi", "DougsWifi", "WorkWifi")
2. This script assumes your Wireguard installation path is: "C:\Program Files\WireGuard\wireguard.exe". If it isn't you will need to edit the connect/disconnect functions to point to the appropriate place to call your wireguard.exe file.
3. Edit the argument for the $Connect function: "C:\path\to\peer" to point to the path for your .conf file. For example: "C:\WireguardConfigs\Laptop\peer1.conf"
4. Edit the argument for the $Disconnect function: **yourpeerhere** to include the name of your peer. Run 'wg show' in your CLI while your connection is active to see your peer name. Mine looks like this: & "C:\Program Files\WireGuard\wireguard.exe" /uninstalltunnelservice peer2
6. If you want to easily run the script from your desktop, create a shortcut.
7. Right click desktop > New > Shortcut
8. Enter the following:
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy bypass -NoExit "C:\path\to\yourscript.ps1"
9. Alter the shortcut properties so that it runs as an administrator (required).
10. Run the script, and enjoy your always-on VPN. If you run this from the shortcut, then you'll be able to exit by hitting escape at any time with the window open. This will disconnect the VPN. If you run it from PowerShell ISE, just terminate the script and it will disconnect.

### Notes: 
- Due to some limitations in powershell, I wasn't able to get the Disconnect-VPN function to call on the exiting of the window, hence the 'ESC' key interaction. If anyone has any suggestions I'm all ears.
- If you want to edit the time interval between each SSID check, edit the Start-Sleep command in the primary loop at the bottom of the script. By default, this checks your SSID every 10 seconds, or every 10000 milliseconds. 
