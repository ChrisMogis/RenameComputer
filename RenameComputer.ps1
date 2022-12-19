<#
.DESCRIPTION
This script is used to change computer name

.NOTES
  Version:        1.0
  Author:         Christopher Mogis
  Creation Date:  24/11/2022
#>

#Variables
$Date = Get-Date
$Name = (Get-CimInstance -ClassName Win32_ComputerSystem).Name
$Serial = (Get-CimInstance win32_bios).serialnumber
$Suffixe = "CCMT"
$Logs = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\RenameComputer.log"

#Computer Name 
        Write-Output "$($Date) : Your computer name is $($Name)" | Tee-Object -FilePath $Logs -Append

#Change Computer Name
if ($Name -match "Desktop-") 
    {
        Write-Output "$($Date) : The script change the computer name because it's not compliant with the naming convention" | Tee-Object -FilePath $Logs -Append
        Rename-Computer -NewName "$($Suffixe)$($Serial)" -Force <# Action to perform if the condition is true #>
        Write-Output "$($Date) : The new computer name is $($Suffixe)$($Serial)" | Tee-Object -FilePath $Logs -Append
        Write-Output "$($Date) : Computer is pending reboot" | Tee-Object -FilePath $Logs -Append
    }
else
    {
        Write-Output "$($Date) : The computer name $($Name) is compliant with the naming convention" | Tee-Object -FilePath $Logs -Append <# Action to perform if the condition is false #>
    }
