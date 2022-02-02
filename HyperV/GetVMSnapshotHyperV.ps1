$smtpsrv = "mail.****.si"
$from = "****@****.si"
$to = "**** **** <****@****.si>"
$encoding = ([System.Text.Encoding]::UTF8)
$HostName = $env:COMPUTERNAME
$VMs = Get-VM

$Output = @()
Foreach($VM in $VMs){
    $Output += Get-VMSnapshot -VMName $VM.VMName | Select-Object ComputerName, VMName, Version, Name, SnapshotType, State, Path, CreationTime, PerentSnapshotName
}

$subject = "$HostName VMs snapshot status"
$body = $Output | Format-Table -AutoSize | Out-String

if ($to -ne $null) {
    if ($body.Length -ne 0){
        Send-MailMessage -smtpserver $smtpsrv -To $to -From $from -Subject $subject -body $body -encoding $encoding
    }
    else {
        # Send-MailMessage -smtpserver $smtpsrv -To $to -From $from -Subject $subject -body "No snapshots detected!" -encoding $encoding
    }
}
$body