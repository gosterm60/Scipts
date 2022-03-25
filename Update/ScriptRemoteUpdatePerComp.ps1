#this scripts installs all updates on a specific computer
#powershell "C:\automation\SrvUpdate\ScriptRemoteUpdatePerComp.ps1" > C:\automation\SrvUpdate\ScriptRemoteUpdatePerComp.log

$path = 'C:\automation\SrvUpdate\'
$output=''
#$computers= get-content $path'UpdateSrv.txt'
$results = @()
$skip = "false";
$output = $path+'UpdateSrv-results.txt'
$computer ="BUILD04"

foreach($computer) {
	try {
	
		Invoke-Command -ComputerName $computer -ScriptBlock{
		if(-not (Get-Module PSWindowsUpdate -ListAvailable))
		{
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
		echo Y|PowerShell.exe -Command 'Register-PSRepository -Default -Verbose'
		echo Y|PowerShell.exe -Command 'Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted'
		echo Y|PowerShell.exe -Command 'Install-Module PSWindowsUpdate'
		}
	}
		#enter-pssession -computername $computer
		#Invoke-Command -ComputerName $computer -ScriptBlock {Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord}
		#Invoke-Command -ComputerName $computer -ScriptBlock {Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord}
		#exit
		#enter-pssession -computername $computer
		#Invoke-Command -ComputerName $computer -ScriptBlock {echo Y|PowerShell.exe -Command 'Register-PSRepository -Default -Verbose'}
		#Invoke-Command -ComputerName $computer -ScriptBlock {echo Y|PowerShell.exe -Command 'Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted'}
		#Invoke-Command -ComputerName $computer -ScriptBlock {echo Y|PowerShell.exe -Command 'Install-Module PSWindowsUpdate'}
		Invoke-Command -ComputerName $computer -ScriptBlock {Set-ExecutionPolicy -ExecutionPolicy Unrestricted}
		Invoke-Command -ComputerName $computer -ScriptBlock {Import-Module PSWindowsUpdate}
		Invoke-Command -ComputerName $computer -ScriptBlock {New-PSSessionConfigurationFile -RunAsVirtualAccount -Path .\VirtualAccount.pssc}
		Invoke-Command -ComputerName $computer -ScriptBlock {Register-PSSessionConfiguration -Name 'VirtualAccount'  -Path .\VirtualAccount.pssc -Force}
		Start-Sleep -s 10
		#Invoke-Command -ComputerName $computer -ScriptBlock {New-PSSession -ComputerName $computer -ConfigurationName 'VirtualAccount' | Enter-PSSession}
		Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -ScriptBlock {Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install}
		Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -ScriptBlock {Unregister-PSSessionConfiguration -Name 'VirtualAccount'}
	} catch { }
}

$results| Export-csv $Output -NoTypeInformation