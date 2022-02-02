On Error Resume Next
Dim net
Set net = CreateObject("WScript.Network")    
net.AddWindowsPrinterConnection "\\******\RICOH SP 4510DN"
net.RemovePrinterConnection "\\*****\RICOH Maribor"
net.RemovePrinterConnection "\\*****\RICOH Maribor"
