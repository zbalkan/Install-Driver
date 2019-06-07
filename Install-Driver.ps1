<#
.Synopsis
   Install drivers from a directory
.DESCRIPTION
   Function seeks INF files in the specified directory and utilizes PnPUtil to install the drivers. This will overwrite existing ones, so use carefully.
.EXAMPLE
   Install-Driver -DriverPath "C:\\MyDrivers"
.EXAMPLE
   Install-Driver -DriverPath "C:\\MyDrivers" -Reboot
.NOTES
   This will overwrite existing ones, so use carefully.
#>
function Install-Driver
{
    
    [Cmdletbinding(SupportsShouldProcess=$True)]
    [Alias()]
    Param
    (
        # Path to the directory
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $DriverPath,

        # Reboot after install if required
        [switch]
        $Reboot
    )

    Begin
    {
        if((Test-Path -Path $DriverPath) -eq $false) { Write-Error "Directory not found"}
    }
    Process
    {
        $drivers = Get-ChildItem $DriverPath -Recurse -Filter "*.inf" 
        if($drivers -eq $null -or $drivers.Count -eq 0) { Write-Error "No drivers found." -ErrorAction Stop -Category ObjectNotFound}

        $drivers | ForEach-Object {
            
            if($Reboot.IsPresent) {
                pnputil /add-driver $_.FullName /install /reboot
            } else {
                pnputil /add-driver $_.FullName /install
            }
            
            switch ($LASTEXITCODE) {
                0 {Write-Verbose "Installation of driver $($_.FullName) is completed successfully."; break;}
                3010 { Write-Verbose "Installation of driver $($_.FullName) is completed successfully. REBOOT REQUIRED"; break; }
                1641 { Write-Verbose "Installation of driver $($_.FullName) is completed successfully. REBOOT INITIATED"; break; }
                default { Write-Error "An error occured on installing driver $($_.FullName). Error code: $LASTEXITCODE"; break; }
            }
        }
    }
    End
    {
        $drivers = $null
    }
}
