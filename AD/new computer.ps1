#The script has to be changed due to sensitive data - also it is work in progress
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Na HyperV
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

New-Item -ItemType directory "C:\...VMLOCATION...\$COMPUTERNAME"

New-VM -Name $COMPUTERNAME -MemoryStartupBytes 6GB -BootDevice VHD -NewVHDPath C:\...VMLOCATION...\$COMPUTERNAME\$COMPUTERNAME-OS.vhdx -Path "C:\...VMLOCATION...\$COMPUTERNAME" -NewVHDSizeBytes 70GB -Generation 2 -Switch VM-SWITCH
Set-VMProcessor $COMPUTERNAME -Count 4
Add-VMDvdDrive -VMName $COMPUTERNAME -Path "C:\temp\SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-3_MLF_X21-30350.ISO"
Set-VMFirmware -VMName "$COMPUTERNAME" -FirstBootDevice $(Get-VMDvdDrive -VMName "$COMPUTERNAME")
Add-ClusterVirtualMachineRole -VirtualMachine $COMPUTERNAME -Name "$COMPUTERNAME"
SET-VM -name $COMPUTERNAME -AutomaticStartAction Nothing
(Get-ClusterGroup $COMPUTERNAME).Priority=0
Get-VM -name $COMPUTERNAME | set-VMNetworkAdaptervlan -access -Vlanid 998

Start-VM $COMPUTERNAME
vmconnect $hypervHOST $COMPUTERNAME /edit

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Add disk:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
New-Item -ItemType directory "C:\...VMLOCATION...\$COMPUTERNAME\$COMPUTERNAME"

NEW-VHD -Dynamic C:\...VMLOCATION...\$COMPUTERNAME\$COMPUTERNAME-DATA.vhdx -SizeBytes 150GB
Add-VMHardDiskDrive -VMName $COMPUTERNAME -Path  C:\ClusterStorage\E5700_SATA_CSVVol01\$COMPUTERNAME\$COMPUTERNAME-DATA.vhdx

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SQL:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
New-Item -ItemType directory "C:\ClusterStorage\E5700_SATA_CSVVol01\$COMPUTERNAME\$COMPUTERNAME"

NEW-VHD -Dynamic C:\ClusterStorage\E5700_SATA_CSVVol01\$COMPUTERNAME\$COMPUTERNAME-DATA.vhdx -SizeBytes 150GB
Add-VMHardDiskDrive -VMName $COMPUTERNAME -Path  C:\...VMLOCATION...\$COMPUTERNAME\$COMPUTERNAME-DATA.vhdx

NEW-VHD -Dynamic C:\ClusterStorage\E5700_SATA_CSVVol01\$COMPUTERNAME\$COMPUTERNAME-LOG.vhdx -SizeBytes 90GB
Add-VMHardDiskDrive -VMName $COMPUTERNAME -Path  C:\...VMLOCATION...\$COMPUTERNAME\$COMPUTERNAME-LOG.vhdx

NEW-VHD -Dynamic C:\ClusterStorage\E5700_SATA_CSVVol01\$COMPUTERNAME\$COMPUTERNAME-BACKUP.vhdx -SizeBytes 50GB
Add-VMHardDiskDrive -VMName $COMPUTERNAME -Path  C:\...VMLOCATION...\$COMPUTERNAME\$COMPUTERNAME-BACKUP.vhdx

NEW-VHD -Dynamic C:\ClusterStorage\E5700_SATA_CSVVol01\$COMPUTERNAME\$COMPUTERNAME-TEMPDB.vhdx -SizeBytes 100GB
Add-VMHardDiskDrive -VMName $COMPUTERNAME -Path  C:\...VMLOCATION...\$COMPUTERNAME\$COMPUTERNAME-TEMPDB.vhdx

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
OS Install by hand
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

New-ADComputer -Name "$COMPUTERNAME" -SamAccountName "$COMPUTERNAME" -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------"
Set-ADComputer -Identity "$COMPUTERNAME" -description "DEV SQL43"

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


LA$COMPUTERNAME
New-ADGroup -Name "LA$COMPUTERNAME" -SamAccountName LA$COMPUTERNAME -GroupCategory Security -GroupScope Domainlocal -DisplayName "LA$COMPUTERNAME" -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------"

RDS$COMPUTERNAME
New-ADGroup -Name "RDS$COMPUTERNAME" -SamAccountName RDS$COMPUTERNAME -GroupCategory Security -GroupScope Domainlocal -DisplayName "RDS$COMPUTERNAME" -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------"

Invoke-Command -ComputerName $COMPUTERNAME" -ScriptBlock {add-LocalGroupMember -Group "Administrators" -Member corp\LA$COMPUTERNAME }
Invoke-Command -ComputerName $COMPUTERNAME" -ScriptBlock {add-LocalGroupMember -Group "Remote Desktop Users" -Member corp\RDS$COMPUTERNAME }

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Add-ADGroupMember -Identity $Group1$ -Members $COMPUTERNAME
Add-ADGroupMember -Identity $Group2$ -Members $COMPUTERNAME
Add-ADGroupMember -Identity $Group3$ -Members $COMPUTERNAME
Add-ADGroupMember -Identity $Group4$ -Members $COMPUTERNAME
Add-ADGroupMember -Identity $Group5$ -Members $COMPUTERNAME
Add-ADGroupMember -Identity $Group6$ -Members $COMPUTERNAME
Add-ADGroupMember -Identity $Group7$ -Members $COMPUTERNAME

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#SQL Specific:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Users:
#CORP.IGES.SI/Managed Service Accounts:
New-ADUser -Name "sasqlXXDB" -GivenName "Service Account" -Surname "sasqlXXDB" -SamAccountName "sasqlXXDB" -UserPrincipalName "sasqlXXDB@....." -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------" -AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true -PasswordNeverExpires $true -CannotChangePassword $True
New-ADUser -Name "sasqlXXAgent" -GivenName "Service Account" -Surname "sasqlXXAgent" -SamAccountName "sasqlXXAgent" -UserPrincipalName "sasqlXXAgent@....." -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------" -AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true -PasswordNeverExpires $true -CannotChangePassword $True
New-ADUser -Name "sasqlXXssis" -GivenName "Service Account" -Surname "sasqlXXssis" -SamAccountName "sasqlXXssis" -UserPrincipalName "sasqlXXssis@....." -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------" -AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true -PasswordNeverExpires $true -CannotChangePassword $True
New-ADUser -Name "sasqlXXssrs" -GivenName "Service Account" -Surname "sasqlXXssrs" -SamAccountName "sasqlXXssrs" -UserPrincipalName "sasqlXXssrs@....." -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------" -AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true -PasswordNeverExpires $true -CannotChangePassword $True

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#SQL Specific:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#SPN\spn.txt

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#SQL Specific:
U_Delegate-SQL_SysAdmins_SRV_$COMPUTERNAME
New-ADGroup -Name "U_Delegate-SQL_SysAdmins_SRV_$COMPUTERNAME" -SamAccountName U_Delegate-SQL_SysAdmins_SRV_$COMPUTERNAME -GroupCategory Security -GroupScope Universal -DisplayName "U_Delegate-SQL_SysAdmins_SRV_$COMPUTERNAME" -Path "OU=----------,OU=----------,DC=----------,DC=----------,DC=----------" 
Add-ADGroupMember -Identity U_Delegate-SQL_SysAdmins_SRV_$COMPUTERNAME -Members srvadmdomenm
Add-ADGroupMember -Identity U_Delegate-SQL_SysAdmins_SRV_$COMPUTERNAME -Members "Domain Admins"
#samo na PROD
Add-ADGroupMember -Identity U_Delegate-SQL_SysAdmins_SRV_$COMPUTERNAME -Members sqlmonitor

Add-ADGroupMember -Identity LA$COMPUTERNAME -Members srvadmdomenm
#samo na PROD
Add-ADGroupMember -Identity LA$COMPUTERNAME -Members sqlmonitor

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Update 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Update skripta
ScriptRemoteUpdatePerComp.ps1

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# IP v Exchange relay 
\Exchange\relayAddIP.txt
# telegraf install
\remote install.txt
# backup 
# Firewall

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IP change
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
input into local IP DB

Change IP to static:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IP change
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

enter-pssession -computername $COMPUTERNAME
Get-NetAdapter
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddress DNSIP,DNSIP,DNSIP
New-NetIPAddress -IPAddress STATICIP -PrefixLength 24 -DefaultGateway FGWIP -InterfaceAlias "Ethernet"

On hyperV change VLAN
ipconfig /flushdns
Get-VM -name $COMPUTERNAME | set-VMNetworkAdaptervlan -access -Vlanid 999


restart-vm $COMPUTERNAME
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Na: $COMPUTERNAME
Leave Azure AD
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dsregcmd.exe /leave



