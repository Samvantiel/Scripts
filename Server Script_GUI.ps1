#################################################################################################################
########################################## Windows Server Interactive UI#########################################
#################################################################################################################
do { 

Function Show-Menu
{
     Param (
           [string]$Title = 'Server configuration Version Beta 1.5'
     )
     Clear-Host
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' Windows Server Configuration and Hostname.(may require an internet connection)"
     Write-Host "2: Press '2' Windows Server Roles and features. (may require an internet connection)"
     Write-Host "3: Press '3' Restart the computer (1 minute countdown)."
     Write-Host "4: Press '4' Open Powershell session."
     Write-Host "5: Press '5' Install Google Chrome."
     Write-Host "Enter: Press 'Enter' to go back to the main menu"
     Write-Host "Q: Press 'Q' to quit."
     $host.ui.RawUI.WindowTitle = “Server configuration Version Beta 1.5”
}


Function Show-Menuoption {
     Param (
          [string]$Title = 'Server configuration Version Beta 1.5'
     )
     Write-Host "[1] Menu 1 is for the basic installation of Windows, Roles and features, and google Chrome"
     Write-Host "[2] Menu 2 is for the configuration of the Roles and Features"
     Write-Host "[3] Menu 3 is for the maintenance for your machine"
     Write-Host "[Q] enter Q to Quit"
}
Clear-Host
Show-Menuoption
[string] $menuoption = Read-Host "Select a menu you want to use"
Write-Host $menuoption
#################################################################################################################
###################################################### Menu 1 ###################################################
#################################################################################################################
if ($menuoption -eq '1') {

do
{
     Clear-Host
     Show-Menu
     $input1 = Read-Host "Please make a selection for menu 1"
     Switch ($input1)
     {
           '1' {
                $host.ui.RawUI.WindowTitle = “Option #1 Windows Server Configuration and Hostname ”
                Clear-Host
                'You chose option #1'
                ## Windows settings
 # Update windows
 Clear-Host
 Write-Host "If you want to install Windows Update Type Y or N (requires an internet connection)"
 Install-Module -Name PSWindowsUpdate -Force
 Install-WindowsUpdate -AcceptAll

 # Enable Remote Desktop
 Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
 Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

 #disables indexing for better performance
$v = Get-WmiObject -Class Win32_Volume -Filter "DriveLetter='C:'"
$v.IndexingEnabled = $false
$v.Put()

     # show file extensions - restart explorer!
     Function ShowFileExtensions()
{
    # http://superuser.com/questions/666891/script-to-set-hide-file-extensions
    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    Set-ItemProperty . HideFileExt "0"
    Pop-Location
    Stop-Process -processName: Explorer -force # This will restart the Explorer service to make this work.
}
 
ShowFileExtensions

#disables Disk timeout
& "powercfg" -x disk-timeout-ac 0
& "powercfg" -x disk-timeout-dc 0

#To Disable BSOD Automatic Restart
wmic RecoverOS set AutoReboot = False

# Change Hostname
$host.ui.RawUI.WindowTitle = “Option #1 Hostname ”
Clear-Host
Write-Host "Would you like to change the hostname of this computer? (Default is No)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-Host "Yes, What should this computer be called?"; ($hostname1 = Read-Host) } 
       N {Write-Host "No, continue program"; break} 
       Default {Write-Host "Default, continue program"; break} 
     }
     if ($hostname1 -eq $null::ok){
     }Else { Rename-Computer -NewName $hostname1 -Verbose
     Pause
     }

## Reboot computer
$host.ui.RawUI.WindowTitle = “Option #1 Reboot Computer ”
Clear-Host
Write-Host "Would you like to Restart this computer? (Default is No)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-Host "Yes, Computer will restart in 1 minute!"; (shutdown -r -t 60) }
       N {Write-Host "No, computer will not shutdown"; break} 
       Default {Write-Host "Default, computer will not shutdown. it is recommended to restart your computer soon!" -ForegroundColor Red; break} 
     }
           } '2' {
                $host.ui.RawUI.WindowTitle = “Option #2 Windows Server Roles and features”
                Clear-Host
                'You chose option #2'
                #Install Windows Features (may require an internet connection)
                #installing ADDS, DCHP, DFS, remote access, print-services, RSAT, Windows Server Backup
                
                Install-WindowsFeature AD-domain-Services -IncludeManagementTools -IncludeAllSubFeature
                Install-WindowsFeature dhcp -IncludeAllSubFeature -IncludeManagementTools
                Install-WindowsFeature FS-DFS-Namespace -IncludeAllSubFeature -IncludeManagementTools
                Install-WindowsFeature FS-DFS-Replication -IncludeAllSubFeature -IncludeManagementTools
                Install-WindowsFeature RemoteAccess -IncludeAllSubFeature -IncludeManagementTools
                Install-WindowsFeature Print-Services -IncludeAllSubFeature -IncludeManagementTools
                Install-WindowsFeature RSAT -IncludeAllSubFeature -IncludeManagementTools
                Install-WindowsFeature Windows-Server-Backup -IncludeAllSubFeature -IncludeManagementTools
                #end

           } '3' {
                $host.ui.RawUI.WindowTitle = “Option #3 Restart Computer ”
                Clear-Host
                'You chose option #3'
                Write-Host "Would you like to Restart this computer? (Default is No)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-Host "Yes, Computer will restart in 1 minute!"; (shutdown -r -t 60) }
       N {Write-Host "No, computer will not shutdown"; break} 
       Default {Write-Host "Default, computer will not shutdown. it is recommended to restart your computer soon!" -ForegroundColor Red; break} 
     }
           } '4' {
            $host.ui.RawUI.WindowTitle = “Option #4 Windows Powershell ”
            Clear-Host
                'You chose option #4 Open Shell'
              powershell
           } '5' {
                $host.ui.RawUI.WindowTitle = “Option #5 Installing Google Chrome ”
                Clear-Host
                Write-Host 'You chose option #5'
                Write-Host 'This action requires an internet connection'
                Write-Host 'trying to install Google Chrome....'
               $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).downloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; do { $ProcessesFound = Get-Process | Where-Object{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } Else { Remove-Item "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
           } '6' { 
               ###
          } 'q' {
                return
           }
     } 
     
}
While ($input1 -eq 'q') 
} 
#################################################################################################################
###################################################### Menu 2 ###################################################
#################################################################################################################
ElseIf 
     ($menuoption -eq '2') {
          Function Show-Menu2
          {
               Param (
                     [string]$Title = 'Server Roles Configuration Version Beta 1.0'
               )
               Clear-Host
               Write-Host "================ $Title ================"
              
               Write-Host "1: Press '1' Installation of a new Active Directory Domain Forest"
               Write-Host "2: Press '2' "
               Write-Host "3: Press '3' "
               Write-Host "4: Press '4' "
               Write-Host "5: Press '5' "
               Write-Host "Enter: Press 'Enter' to go back to the main menu"
               Write-Host "Q: Press 'Q' to quit."
               $host.ui.RawUI.WindowTitle = “Server Roles Configuration Version Beta 1.3”
          }
          
          
          
          do 
          {
               #Clear-Host
               Show-Menu2
               $input2 = Read-Host "Please make a selection for menu 2"
               Switch ($input2)
               {
                     '1' {
                      Clear-Host
                      Write-Host 'You selected New Active Directory domain Forest'
                      Write-Host "do you really want to make a new forest? (Default is No)" -ForegroundColor Yellow 
                      $Readhost = Read-Host " ( y / n ) " 
                      Switch ($Readhost) {
                           Y { 
                                Write-Host "Make sure you do not have a restart pending before setting this up!" -ForegroundColor Red
                              $addsdomainname = Read-Host "Enter the name of your domainname (With extension)"
                             # $addsadminpassword = Read-Host "Enter your new domainAdminPassword"

                              #Declare variables
                             # $addsadminpassword = (ConvertTo-SecureString -String "Pass1w0rd" -AsPlainText -Force) -SafeModeAdministratorPassword $addsadminpassword
                              Install-ADDSForest -CreateDnsDelegation:$false -DomainName $addsdomainname -InstallDns:$true -NoRebootOnCompletion:$false -Force:$true }
                           N { Write-Host "No, computer will not shutdown"; break }
                           Default { Write-Host "No, computer will not shutdown"; break }


                      }
                Pause
                Clear-Host

                     } '2' {
                    Write-Host 'test2'
                    ping 8.8.8.8
                     } '3' {
                    
                     } '4' {
                    
                     } '5' {
                    
                     } '6' { 
                    
                    } 'q' {
                          return
                     }
               } 
          }
          While ($input2 -eq 'q') 
}
#################################################################################################################
###################################################### Menu 3 ###################################################
#################################################################################################################
ElseIf 
     ($menuoption -eq '3') {
          Function Show-Menu3
          {
               Param (
                     [string]$Title = 'Server Roles Configuration Version Beta 1.0'
               )
               Clear-Host
               Write-Host "================ $Title ================"
              
               Write-Host "1: Press '1' harry"
               Write-Host "2: Press '2' potter"
               Write-Host "3: Press '3' "
               Write-Host "4: Press '4' "
               Write-Host "5: Press '5' "
               Write-Host "Enter: Press 'Enter' to go back to the main menu"
               Write-Host "Q: Press 'Q' to quit."
               $host.ui.RawUI.WindowTitle = “Server maintenance Version Beta 1.1”
          }
          
          
          
          do 
          {
               #Clear-Host
               Show-Menu3
               $input3 = Read-Host "Please make a selection for menu 3"
               Switch ($input3)
               {
                     '1' {
                    Write-Host 'test'
                    Read-Host "test"
                    Pause
                     } '2' {
                    Write-Host 'test2'
                    ping 8.8.4.4
                     } '3' {
                    
                     } '4' {
                    
                     } '5' {
                    
                     } '6' { 
                    
                    } 'q' {
                          return
                     }
               } 
          }
          While ($input3 -eq 'q') 
}


    # [string] $terminate = Read-Host "if you want to exit enter Q"
} Until ($menuoption -eq 'q')

