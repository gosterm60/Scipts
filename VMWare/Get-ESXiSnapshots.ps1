$smtpsrv = "192.168.10.12"
$from = "Admin <smtp>"
$to = "Admin <smtp>"
$encoding = ([System.Text.Encoding]::UTF8)
$HostName = "VIRTUAL8"

# Credentials if not via scheduled tasks
# $Cred = Get-Credential -UserName root -Message "Input your credentials."

# Once per computer
# $(Find-Module VMware*).Name
# Install-Module -Name "VMware.PowerCLI" -AllowClobber -Confirm # –Scope CurrentUser

# Once per ps session
Import-Module "VMware.PowerCLI" # -Prefix VMware
# Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm # -Scope User

# Get-Module
# Get-Command -Module "VMware.PowerCLI"
# Commands: Get-VICommand, Get-PowerCLIHelp, Get-VM, Get-PowerCLICommunity

# Connect to vCenter OR ESXi host
Connect-VIServer -Server $HostName # -Credential $Cred

# Get-PowerCLIConfiguration
# Set-PowerCLIConfiguration

# Check VMs
# Get-VM | Select-Object * | Out-GridView

$VMs = Get-VM
$Output = @()
Foreach($VM in $VMs){
    $Snapshot = Get-Snapshot -VM $VM
    if($Snapshot){
        $found_error = 1
        $error_count++
        # Write-Host  "Snapshot was found:" $VM.Name
		$Output += Get-Snapshot -VM $VM | Select-Object VM,Name,Description,Created,SizeGB
    }
    else{
        # Write-Host "Snapshot not found:" $VM.Name
    }
}

$subject = "$HostName ESXi VMs snapshot status"
$body = $Output | Format-Table -AutoSize | Out-String

if ($to -ne $null) {
    if ($body.Length -ne 0) {
        Send-MailMessage -smtpserver $smtpsrv -To $to -From $from -Subject $subject -body $body -encoding $encoding
    }
    else {
       #Send-MailMessage -smtpserver $smtpsrv -To $to -From $from -Subject $subject -body "No snapshots detected!" -encoding $encoding
    }
}