
#Create Logs Directory
New-Item -Force -Path "C:\Windows\Temp\Logs" -ItemType Directory

#Variables
$Date = Get-Date
$Name = (Get-CimInstance -ClassName Win32_ComputerSystem).Name
$Serial = (Get-CimInstance win32_bios).serialnumber
$Suffixe = "CCMT"
$Logs = "C:\Windows\Temp\Logs\RenameComputer.log"

#Computer Name 
    Write-Output "$($Date) : Your computer name is $($Name)" | Tee-Object -FilePath $Logs -Append

#Change Computer Name
if ($Name -match "Desktop-") 
{
    Write-Output "$($Date) : The script change the computer name because it's not compliant with the naming convention" | Tee-Object -FilePath $Logs -Append
    Rename-Computer -NewName "$($Suffixe)$($Serial)" -Force <# Action to perform if the condition is true #>
    Write-Output "$($Date) : Computer is pending reboot" | Tee-Object -FilePath $Logs -Append
}
else
{
    Write-Output "$($Date) : The computer name $($Name) is compliant with the naming convention" | Tee-Object -FilePath $Logs -Append <# Action to perform if the condition is false #>
}
