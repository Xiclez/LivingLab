# PowerShell Script to Clear User Data and Cache in Windows 10
# Check if the script is running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Relaunch the script as an administrator
    try {
        # Get the current script's path
        $scriptPath = $MyInvocation.MyCommand.Definition

        # Start a new instance of the script as an administrator
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    } catch {
        # Error handling
        Write-Warning "Failed to start the script with administrative privileges. Please run the script as an administrator."
        exit
    }

    # Exit the current script instance
    exit
}
# ASCII Art and Welcome Message
$asciiArt = @"
                                                 
                                                            
                                                            
                                                            
                        .*/////////*.                       
                   /////////////////////(.                  
                ////////////////////////////*               
              //////////      ,//////////     *             
            //////////,  ,///             */////            
           ///////////*   //      .*(////////////,          
            ////////////*    ,////////////////////.         
          .     ////////////////(      ////////////         
          ////,         .*/////   *//   *//////////         
          ////////////,           *//   *//////////         
          ,//////////////////////      //////////           
           .//////////////      ///////////////              
            *//////////   *//,  .///////*      *            
            . /////////.  .//             *///*             
                *////////.    ,/////////////.               
                   ,/////////////////////                   
                         ,*///////*.                  


 __   ___ _    _            _      _       _             _           _      
 \ \ / (_) |  | |          | |    (_)     (_)           | |         | |     
  \ V / _| | _| | ___ ____ | |     ___   ___ _ __   __ _| |     __ _| |__   
   > < | | |/ / |/ _ \_  / | |    | \ \ / / | '_ \ / _` | |    / _` | '_ \  
  / . \| |   <| |  __// /  | |____| |\ V /| | | | | (_| | |___| (_| | |_) | 
 /_/ \_\_|_|\_\_|\___/___| |______|_|_\_/ |_|_| |_|\__, |______\__,_|_.__/  
 |  \/  |         | |           / ____| |           __/ |                   
 | \  / | __ _ ___| |_ ___ _ __| |    | | ___  __ _|___/   ___ _ __         
 | |\/| |/ _` / __| __/ _ \ '__| |    | |/ _ \/ _` | '_ \ / _ \ '__|        
 | |  | | (_| \__ \ ||  __/ |  | |____| |  __/ (_| | | | |  __/ |           
 |_|  |_|\__,_|___/\__\___|_|   \_____|_|\___|\__,_|_| |_|\___|_|                                                             
"@

Write-Host $asciiArt
Write-Host "Coded by Xiklez for LivingLabCUU on Dec - 11th - 23"
$null = Read-Host -Prompt "Press any key to continue"

# 1. Clear Browser Cache and History
# Get the username of the current user
$user = $env:USERNAME

# Define the path where Edge user data is stored
$edgeUserDataPath = "C:\Users\$user\AppData\Local\Microsoft\Edge\User Data"

# Kill any running Edge processes
try {
    Get-Process 'msedge' -ErrorAction Stop | Stop-Process -Force
    Write-Host "Microsoft Edge processes terminated."
} catch {
    Write-Host "No Microsoft Edge processes found or unable to terminate."
}

# Check if the User Data path exists
if (Test-Path $edgeUserDataPath) {
    # Remove the User Data
    Remove-Item -Path $edgeUserDataPath -Recurse -Force
    Write-Host "Edge User Data cleared."
} else {
    Write-Host "Edge User Data path not found."
}
# 2. Clear Browser Cache and History for Google Chrome
# Get the username of the current user
$user = $env:USERNAME

# Define the path where Chrome user data is stored
$chromeUserDataPath = "C:\Users\$user\AppData\Local\Google\Chrome\User Data"

# Kill any running Chrome processes
try {
    Get-Process 'chrome' -ErrorAction Stop | Stop-Process -Force
    Write-Host "Google Chrome processes terminated."
} catch {
    Write-Host "No Google Chrome processes found or unable to terminate."
}

# Check if the User Data path exists
if (Test-Path $chromeUserDataPath) {
    # Remove the User Data
    Remove-Item -Path $chromeUserDataPath -Recurse -Force
    Write-Host "Chrome User Data cleared."
} else {
    Write-Host "Chrome User Data path not found."
}

# 2. Delete System Cache
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# 3. Clear Windows Update Cache
Stop-Service wuauserv
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv

# 4. Remove Temporary Files
function Clear-TempFiles {
    Write-Host "Deleting Windows temporary files..."
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
}

function Perform-DiskCleanup {
    Write-Host "Performing Disk Cleanup..."
    cleanmgr /sagerun:1
}

function Clear-DownloadsFolder {
    Write-Host "Clearing the Downloads folder..."
    Remove-Item -Path "$env:USERPROFILE\Downloads\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Start cleanup
Clear-TempFiles
Perform-DiskCleanup
Clear-DownloadsFolder

# 5. Clear System Restore Points
Disable-ComputerRestore -Drive "C:\"
Enable-ComputerRestore -Drive "C:\"

# 6. Delete User Profiles and Data
# WARNING: This will remove user profiles and should be used with caution
# Uncomment the next line to enable
# Get-CimInstance -ClassName Win32_UserProfile | Where-Object { !$_.Special } | Remove-CimInstance

# 7. Flush DNS Cache
Clear-DnsClientCache

# Wait for user input
Read-Host -Prompt "Press any key to exit"

# Script End
