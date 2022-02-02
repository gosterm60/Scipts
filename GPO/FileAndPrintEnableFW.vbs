On Error Resume Next
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Run "netsh firewall set service type = FILEANDPRINT mode = ENABLE profile = DOMAIN", 0