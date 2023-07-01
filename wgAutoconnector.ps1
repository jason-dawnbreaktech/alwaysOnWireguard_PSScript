## Define the trusted SSIDs where the VPN will not autoconnect

$TrustedSSIDs = @("SSID1", "SSID2")

## Define two variables: one for connecting, and one for disconnecting.

$Connect = {
& "C:\Program Files\WireGuard\wireguard.exe" /installtunnelservice "C:\path\to\config.conf"
}


$Disconnect = {
& "C:\Program Files\WireGuard\wireguard.exe" /uninstalltunnelservice yourpeername
}

## shows the current VPN interface

function Is-VPNConnected {
   try {
      $VPNStatus = wg show
      if ($VPNStatus -ne $null) {
      return $true
   } else {
      return $false
      }
   }
   catch {
      Write-Host "Error occurred while checking VPN status: $_"
      return $false
   }
}

## Gets the name of the connected SSID 

function Get-CurrentSSID {
    # Get the network interfaces and split into lines
    $interfaces = (netsh wlan show interfaces) -split "`n"

    # Find the line containing the current SSID
    $SSIDLine = $interfaces | Where-Object {$_ -like "*SSID*" -and $_ -notlike "*BSSID*"} 

    # Check if SSIDLine is not null, and if so, return its value
    if ($SSIDLine) {
        # Extract the SSID by trimming the line at the : and splitting the whitespace
        $currentSSID = ($SSIDLine -split ":")[1].Trim()
        # Return current SSID
        return $currentSSID
    }
    else {
    # If no SSID, return null or a placeholder value indicating no network. 
    Write-Host "You are not connected to the internet."
    return $null
    }
}

function Disconnect-VPN {
& $Disconnect
}


function Terminate-Program {
    Write-Host "Terminating/Disconnecting VPN..."
    if (Is-VPNConnected) {
        Disconnect-VPN
    }
    exit
}    


         
try {     
    while ($true) {
        # Clear the console before displaying updated information
        Clear-Host
        
        # Get current SSID
        $currentSSID = Get-CurrentSSID
        $isVPNConnected = Is-VPNConnected

        # Display VPN Status and current SSID
        Write-Host "VPN Status: $isVPNConnected"
        Write-Host "Current SSID: $currentSSID"

        # Check if the user wants to terminate the program by pressing the Escape key
        Write-Host "Press 'ESC' key to terminate the program."
        if ([System.Console]::KeyAvailable -and [System.Console]::ReadKey($true).Key -eq "Escape") {
            Terminate-Program
        }

        # If the current SSID is in trusted SSIDs and VPN is connected, disconnect: 
        if ($TrustedSSIDs -contains $currentSSID -and $isVPNConnected) {
            & $Disconnect
            Write-Host "Welcome home!"
        }
        # otherwise, check if WG is active, and if not, connect the vpn :)
        elseif ($TrustedSSIDs -notcontains $currentSSID -and -not $isVPNConnected) {
            & $Connect
        }

        # Wait however many milliseconds then try again :)    
        Start-Sleep -Milliseconds 10000

     }
} finally {
    Write-Host "See you later :)"
}
