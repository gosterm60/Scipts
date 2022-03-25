#Write-Host "[$(Get-Date)] Setting parameters"
$Location = "Medex"
$StartShiftDays = -365
$SmtpSrv = "IP"
$Encoding = ([System.Text.Encoding]::UTF8)
$From = "VCSA <vcsa@>"
$To = " nadzor <nadzor@>"

# cd "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Modules"
# v6.0
#Add-PSSnapin VMware.VimAutomation.Core
#Get-PSSnapin -Name * | ft

#Write-Host "[$(Get-Date)] Importing VMware module(s)"
Import-Module -Name VMware.VimAutomation.Core
#Import-Module -Name VMware.VimAutomation.Vds
#Import-Module -Name VMware.VimAutomation.Cloud
#Import-Module -Name VMware.VimAutomation.PCloud
#Import-Module -Name VMware.VimAutomation.Cis.Core
#Import-Module -Name VMware.VimAutomation.Storage
#Import-Module -Name VMware.VimAutomation.HA
#Import-Module -Name VMware.VimAutomation.vROps
#Import-Module -Name VMware.VumAutomation
#Import-Module -Name VMware.VimAutomation.License
#Get-Module -ListAvailable

#Connect
#Write-Host "[$(Get-Date)] Connecting to VMware environment"
Connect-VIServer -Server vcsa.medex.si -Protocol https # -User admin -Password pass

#Check all VMs in datacenter
Write-Host "[$(Get-Date)] Start checking replication status:"
$VMs = Get-VM
Foreach ($VM in $VMs)
{
    $VMdetail = Get-View $VM
    $Dest = $VMdetail.config.ExtraConfig | select | where {$_.key -eq “hbr_filter.destination”}
    If (($Dest) -and ($Dest.Value)) #get VMs included in replication
    {
        #Write-Host "[$(Get-Date)] $VM is included in replication."

        $Date = (Get-Date).adddays($StartShiftDays)	
        #Write-Host "[$(Get-Date)] Retrieving events for $($VM.name) from $Date"
	    $Events = Get-VIEvent -Start $Date -Entity $VM
	    #Write-Host "[$(Get-Date)] Filtering RPO events"
	    $RPOEvent = $Events | Where-Object {$_.EventTypeID -match "rpo" } | Select-Object EventTypeId, CreatedTime, FullFormattedMessage, @{Name="VMName";Expression={$_.Vm.Name}}
        $RpoEventOk = $RPOEvent | Where-Object {$_.EventTypeID -match "com.vmware.vcHms.rpoRestoredEvent"} | Select-Object -Last 1 #| Format-Table -AutoSize
        $RpoEventOkTime = $RpoEventOk.CreatedTime
        $RpoEventNo = $RPOEvent | Where-Object {$_.EventTypeID -match "com.vmware.vcHms.rpoViolatedEvent"} | Select-Object -Last 1 #| Format-Table -AutoSize
        $RpoEventNoTime = $RpoEventNo.CreatedTime
        if ($RpoEventOkTime -gt $RpoEventNoTime)
        {
            $Subject = "$VM-vm replication status is OK"
	        $Body = "VM replication status is OK: $VM-vm LastRpoRestoreTime is greater than LastRpoViolationTime"
            Send-MailMessage -smtpserver $SmtpSrv -To $To -From $From -Subject $Subject -body $Body -encoding $Encoding
		    Write-Host "[$(Get-Date)] VM replication status is OK    : LastRpoRestoreTime is greater than LastRpoViolationTime          > $VM"
        }
        else
        {
            $Subject = "$VM-vm replication status is NOT OK"
	        $Body = "VM replication status is NOT OK: $VM-vm LastRpoRestoreTime is less than or equal to LastRpoViolationTime"
            Send-MailMessage -smtpserver $Smtpsrv -To $To -From $From -Subject $Subject -body $Body -encoding $Encoding
		    Write-Host "[$(Get-Date)] VM replication status is NOT OK: LastRpoRestoreTime is less than or equal to LastRpoViolationTime > $VM"
        }
    }
}
