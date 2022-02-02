$computers= get-content D:\PROD\DNSChange\computers.txt
 ForEach ($Computer in $Computers) {
    Write-Host "$($Computer): " -ForegroundColor Yellow
    Invoke-Command -ComputerName $Computer -ScriptBlock {

        $NewDnsServerSearchOrder = "10.***.***.***","10.***.***.***"
        $Adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DHCPEnabled -ne 'True' -and $_.DNSServerSearchOrder -ne $null}
        
        # Show DNS servers before update
        Write-Host "Before: " -ForegroundColor Green
        $Adapters | ForEach-Object {$_.DNSServerSearchOrder}
 
        # Update DNS servers
        $Adapters | ForEach-Object {$_.SetDNSServerSearchOrder($NewDnsServerSearchOrder)} | Out-Null
 
        # Show DNS servers after update
        $Adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DHCPEnabled -ne 'True' -and $_.DNSServerSearchOrder -ne $null}
        Write-Host "After: " -ForegroundColor Green
        $Adapters | ForEach-Object {$_.DNSServerSearchOrder}
    }
}