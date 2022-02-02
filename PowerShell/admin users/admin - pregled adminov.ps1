$path = 'C:\admin'
$output=''

#Get-ADComputer -SearchBase 'OU=Desktops,OU=***,DC=***,DC=***,DC=SI' -Filter '*' | Select -Expand Name > $path'desktops.txt'
#Get-ADComputer -SearchBase 'OU=Notebooks,OU=***,DC=***,DC=***,DC=SI' -Filter '*' | Select -Expand Name > $path'notebooks.txt'

gc $path'desktops.txt',$path'notebooks.txt' | out-file $path'combined.txt'

$day_current = (Get-Date).DayOfWeek

if ($day_current -eq "Thursday") {
	$output = $path+'adminsThursday.csv'
}
else {
	$output = $path+'admins.csv'
}

$computers= get-content $path'combined.txt'
$results = @()
$skip = "false";

foreach($computer in $computers) {
	try {
		$admins = @()
		$group =[ADSI]"WinNT://$computer/Administrators"
		$members = @($group.psbase.Invoke("Members"))
		$members | foreach {
			$obj = new-object psobject -Property @{
				Computer = $computer
				User = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
			}
			if ("$obj.toString()".ToLower().contains("prototip") -or "$obj.toString()".ToLower().contains("administrator") -or "$obj.toString()".ToLower().contains("u_delegate_wks_technicians_lj") -or "$obj.toString()".ToLower().contains("u_delegate_wks_technicians_ng") -or "$obj.toString()".ToLower().contains("domain admins") -or "$obj.toString()".ToLower().contains("safcsmom") -or "$obj.toString()".ToLower().contains("ciscohistrprtusr")){
				$skip = "true";
			}
			else {
				$skip = "false";
			}
			
			if ($skip -eq "false"){
				$admins += $obj
			}		
		 }
		 
		$results += $admins
		
	} catch { }
}

$results| Export-csv $Output -NoTypeInformation