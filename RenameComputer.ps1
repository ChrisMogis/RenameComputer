<#
.DESCRIPTION
This script is used to change computer name with Microsoft Intune

.NOTES
  Version:        1.0
  Author:         Christopher Mogis
  Creation Date:  30/03/2023
#>

#Variables
    $Date = Get-Date
    $CurrentName = (Get-CimInstance -ClassName Win32_ComputerSystem).Name
    $Suffixe = "W0010"
    $Logs = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\RenameComputer.log"

#Delete old Logs files
    Remove-Item -Path $Logs -Force

#Computer Name 
    Write-Output "$($Date) : The current computer name is $($CurrentName)" | Tee-Object -FilePath $Logs -Append

#Check Platform type
    $ComputerType = (Get-ComputerInfo).CsSystemFamily
    If($ComputerType -eq "Virtual Machine")
        {
            Write-Output "$($Date) : Platform detection - $($ComputerType), using an automatically generated computer name." | Tee-Object -FilePath $Logs -Append
            $Serial = Get-Random
        }
    else
        {
            Write-Output "$($Date) : Platform detection - $($ComputerType), using the service tag to generate the computer name." | Tee-Object -FilePath $Logs -Append
            $Serial = (Get-CimInstance win32_bios).serialnumber
        }

#Change Computer Name
    Write-Output "$($Date) : The script change the computer name because it's not compliant with the naming convention" | Tee-Object -FilePath $Logs -Append
    Rename-Computer -NewName "$($Suffixe)$($Serial)" -Force
    Write-Output "$($Date) : The new computer name is $($Suffixe)$($Serial)" | Tee-Object -FilePath $Logs -Append
        
#Send message to user for request computer restart & reboot
    Shutdown -r -t 120 -f -c "Your administrator has implemented changes. To finalize the process, we will reboot your computer in 2 minutes."
