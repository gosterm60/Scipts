@" 
=============================================================================== 
Title:             Grab-VMSS.ps1 
Description:     List snapshots on all VMWARE ESX/ESXi servers as well as VM's managed by Virtual Center. 
Requirements:     Windows Powershell and the VI Toolkit 
Usage:        .\Get-VmwareSnaphots.ps1 
Creator:         Guowen Su 
=============================================================================== 
"@ 
Add-PSSnapin -Name "VMware.VimAutomation.Core"

#Global Functions 
#This function creates a awesome HTML output that uses only CSS for style formatting. 
function Generate-Report { 
    Write-Output "<html><head><title></title><!-- 
.Error {color:#FF0000;font-weight: bold;}.Title {background: #0077D4;color: #FFFFFF;text-align:center;font-weight: bold;}.Normal {} 
--></head><body><table><tr class=""Title""><td colspan=""5"">VMware Snaphot Report</td></tr><tr class="Title"><td>VM Name  </td><td>Snapshot Name  </td><td>Date Created  </td><td>Description  </td><td>Host  </td></tr>" 
  
                Foreach ($snapshot in $report){ 
                    Write-Output "<td>$($snapshot.vm)</td><td>$($snapshot.name)</td><td>$($snapshot.created)</td><td>$($snapshot.description)</td><td>$($snapshot.host)</td></tr> "  
                } 
        Write-Output "</table></body></html>"  
    } 
 
#Login details for standalone ESXi servers 
$username = 'root' 
$password = 'passs' #Change to the root password you set for you ESXi server 
 
#List of servers including Virtual Center Server.  The account this script will run as will need at least Read-Only access to Cirtual Center 
$ServerList = "192.168.2.2"    #Chance to DNS Names/IP addresses of your ESXi servers or Virtual Center Server 
 
#Initialise Array 
$Report = @() 
 
#Get snapshots from all servers 
        foreach ($server in $serverlist){ 
         
        # Check is server is a Virtual Center Server and connect with current user 
        if ($server -eq "VCServer"){Connect-VIServer $server} 
         
        # Use specific login details for the rest of servers in $serverlist 
        else {Connect-VIServer $server -user $username -password $password} 
         
         
        get-vm | get-snapshot | %{ 
            $Snap = {} | Select VM,Name,Created,Description,Host 
            $Snap.VM = $_.vm.name 
            $Snap.Name = $_.name 
            $Snap.Created = $_.created 
            $Snap.Description = $_.description 
            $Snap.Host = $_.vm.host.name 
            $Report += $Snap 
                                } 
                                        } 
 
# Generate the report and email it as a HTML body of an email 
Generate-Report > "VmwareSnapshots.html" 
    IF ($Report -ne ""){ 
    $SmtpClient = New-Object system.net.mail.smtpClient 
    $SmtpClient.host = "ServerHost"   #Change to a SMTP server in your environment 
    $MailMessage = New-Object system.net.mail.mailmessage 
    $MailMessage.from = "fromsender@domain.com   #Change to email address you want emails to be coming from 
    $MailMessage.To.add("tosender@domain.com")    #Change to email address you would like to receive emails. 
    $MailMessage.IsBodyHtml = 1 
    $MailMessage.Subject = "Vmware Snapshots Virtual1" 
    $MailMessage.Body = Generate-Report 
    $SmtpClient.Send($MailMessage)} 