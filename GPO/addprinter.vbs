On Error Resume Next
Dim net
Set net = CreateObject("WScript.Network")    
net.AddWindowsPrinterConnection "\\*****\Kyocera FS-1920 KX"
net.RemovePrinterConnection "\\******\Kyocera FS-1920 PCL5"
net.RemovePrinterConnection "\\******\Kyocera FS-1920 PCL5"
