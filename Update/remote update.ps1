#the whole script is just notes

Enable-PSRemoting -Force


$Computer = XXX

enter-pssession -computername $Computer
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
exit
enter-pssession -computername $Computer
echo Y|PowerShell.exe -Command 'Register-PSRepository -Default -Verbose' 
echo Y|PowerShell.exe -Command 'Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted'
echo Y|PowerShell.exe -Command 'Install-Module PSWindowsUpdate'
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Import-Module PSWindowsUpdate
New-PSSessionConfigurationFile -RunAsVirtualAccount -Path .\VirtualAccount.pssc
Register-PSSessionConfiguration -Name 'VirtualAccount'  -Path .\VirtualAccount.pssc -Force
New-PSSession -ComputerName $Computer -ConfigurationName 'VirtualAccount' | Enter-PSSession
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install
shutdown /r /t 10 /f


# še enkrat ali večkrat za feature update
New-PSSession -ComputerName $Computer -ConfigurationName 'VirtualAccount' | Enter-PSSession
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install


Get-WUHistory

---------------------------------------------------------------------------------------------------------------------------------------------------------------
zapiski
---------------------------------------------------------------------------------------------------------------------------------------------------------------
Windows OS verzija:
(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId
[System.Environment]::OSVersion.Version

#[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Register-ScheduledJob -Name GetUpdates -ScriptBlock { Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install } -RunNow
Register-ScheduledJob -Name GetUpdates -ScriptBlock { Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install } -RunNow

Start-Job -DefinitionName GetUpdates
Unregister-ScheduledJob -Name GetUpdates

#Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -AutoReboot
powershell scheduledjobs
Register-ScheduledJob -Name GetUpdates -ScriptBlock { get-windowsupate -install } -RunNow
Register-ScheduledJob -Name GetUpdates2 -ScriptBlock { Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install } -RunNow

Update install status:
get-wmiobject -class win32_quickfixengineering


#Register-PSRepository -Default -Verbose 

#cmd.exe /c "echo Y|PowerShell.exe -NoProfile -Command 'Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted'"
#cmd.exe /c "echo Y|PowerShell.exe -NoProfile -Command 'Install-Module PSWindowsUpdate'"
[Net.ServicePointManager]::SecurityProtocol
#prej: Ssl3, Tls
#potem: Tls, Tls11, Tls12

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

cmd.exe /c PowerShell.exe -Command 'get-windowsupdate'
Invoke-Command -ComputerName geningapp20 -ScriptBlock {get-windowsupdate}
[Net.ServicePointManager]::SecurityProtocol