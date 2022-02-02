Dim WshNetwork
Set WshNetwork = WScript.CreateObject("WScript.Network")
WshNetwork.MapNetworkDrive "M:", "\\***\****", true