#This scripts installs Features updates - not working at the last command -----Start-Process -FilePath $file -ArgumentList '/quietinstall /skipeula /auto upgrade /copylogs $dir'}

#powershell "C:\automation\SrvUpdate\ScriptFeatureUpdatePerComp.ps1" > C:\automation\SrvUpdate\ScriptRemoteUpdatePerComp.log

$path = 'C:\automation\SrvUpdate\'
$output=''
#$computers= get-content $path'UpdateSrv.txt'
$results = @()
$skip = "false";
$output = $path+'UpdateSrv-results.txt'
$computer ="COMPUTERNAME"
$webClient = New-Object System.Net.WebClient
$url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
$file = "$($dir)\Win10Upgrade.exe"
$dir = 'C:\temp\_Windows_FU\packages'		
		
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
		#Invoke-Command -ComputerName $computer -ScriptBlock {Import-Module PSWindowsUpdate}
		Invoke-Command -ComputerName $computer -ScriptBlock {New-PSSessionConfigurationFile -RunAsVirtualAccount -Path .\VirtualAccount.pssc}
		Invoke-Command -ComputerName $computer -ScriptBlock {Register-PSSessionConfiguration -Name 'VirtualAccount'  -Path .\VirtualAccount.pssc -Force}
		Invoke-Command -ComputerName $computer -ScriptBlock {Set-ExecutionPolicy -ExecutionPolicy Unrestricted}
		Invoke-Command -ComputerName $computer -ScriptBlock {
		
		$webClient = New-Object System.Net.WebClient
		$url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
		$dir = 'C:\temp\_Windows_FU\packages'
		mkdir $dir
		$file = "$($dir)\Win10Upgrade.exe"
		$webClient.DownloadFile($url,$file)		
		Start-Process -FilePath $file -ArgumentList '/quietinstall /skipeula /auto upgrade /copylogs $dir'}

		#Start-Sleep -s 10
		#Invoke-Command -ComputerName $computer -ScriptBlock {New-PSSession -ComputerName $computer -ConfigurationName 'VirtualAccount' | Enter-PSSession}
		#Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -ScriptBlock {Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install}
		#Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -ScriptBlock {Unregister-PSSessionConfiguration -Name 'VirtualAccount'}
	} catch { }
}

$results| Export-csv $Output -NoTypeInformation