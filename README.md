# Install-Driver
## Synopsis
Powershell Cmdlet to install drivers from a directory
## Description
   Function seeks INF files in the specified directory and utilizes PnPUtil to install the drivers. This will overwrite existing ones, so use carefully.
## Examples
   `Install-Driver -DriverPath "C:\\MyDrivers"`
   
   `Install-Driver -DriverPath "C:\\MyDrivers" -Reboot`
## Notes
   This will overwrite existing ones, so use carefully.
