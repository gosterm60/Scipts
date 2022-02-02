$date = Get-Date
 
# Variables
$MailFrom = '****@****.si'
$MailTo = '****@****.si'
$MailSubject = "Hyper-V Replica Report $date"
$MailServer = 'mail.****.si'
 
# Get replication status in HTML format
$status = Get-VMReplication -VMName APP01 | Select-Object Name, State, Health, Mode, FrequencySec, PrimaryServer, ReplicaServer, ReplicaPort | ConvertTo-Html
 
# Send email message
Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -BodyAsHtml -Body "$status" -SmtpServer $MailServer