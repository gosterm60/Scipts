SQL:
Input:
Get-ADComputer -Identity $Computername | Set-ADAccountControl -TrustedForDelegation $true
Get-ADUser -Identity $UsernameDB | Set-ADUser -TrustedForDelegation $true
SetSPN -s "MSSQLSvc/$Computername.xx.xx.xx" "CORP\$UsernameDB "
SetSPN -s "MSSQLSvc/$Computername.xx.xx.x:1433" "CORP\$UsernameDB "

Verify:
Get-ADComputer -Identity "$Computername" -Properties TrustedForDelegation
Get-ADUser -Identity "$UsernameDB" -Properties TrustedForDelegation
SetSPN -l "CORP\$UsernameDB"


OLAP

Input:
Get-ADComputer -Identity "$Computername" -Properties TrustedForDelegation
Get-ADUser -Identity "$Usernamessas" -Properties TrustedForDelegation
SetSPN -l "CORP\$Usernamessas"

Verify:
Get-ADComputer -Identity $Computername | Set-ADAccountControl -TrustedForDelegation $true
Get-ADUser -Identity $Usernamessas | Set-ADUser -TrustedForDelegation $true
SetSPN -s "MSOLAPSvc.3/$Computername.xx.xx.xx" "CORP\$Usernamessas"
SetSPN -s "MSOLAPSvc.3/$Computername" "CORP\$Usernamessas"


---------------------------------------------------------------------------------------------------------
Get-ADComputer -Identity $Computername | Set-ADAccountControl -TrustedForDelegation $true
Get-ADUser -Identity $UsernameDB | Set-ADUser -TrustedForDelegation $true
SetSPN -s "MSSQLSvc/$Computername.xx.xx.xx" "corp\$UsernameDB"
SetSPN -s "MSSQLSvc/$Computername.xx.xx.xx:55737" "corp\$UsernameDB"
SetSPN -s "MSSQLSvc/$Computername.xx.xx.xx:55737" "corp\$UsernameDB"


 
