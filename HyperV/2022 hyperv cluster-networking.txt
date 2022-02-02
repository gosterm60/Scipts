----------------------------------------------------------------------------------------------------------------------------
https://github.com/microsoft/MSLab/blob/master/Scenarios/Hyper-V%20with%20Shared%20Storage/Scenario.ps1
----------------------------------------------------------------------------------------------------------------------------

#Rename
-----------------------------------------------------------------------------------------------------------------------------------------------
Get-NetAdapterHardwareInfo -Name "*"

#	Name                           Segment Bus Device Function Slot NumaNode PcieLinkSpeed PcieLinkWidth Version
#	----                           ------- --- ------ -------- ---- -------- ------------- ------------- -------
#	PCIe Slot 3 Port 8                   0  55      0        7    3        0      8.0 GT/s            16 1.1
#	PCIe Slot 3 Port 1                   0  55      0        0    3        0      8.0 GT/s            16 1.1
#	PCIe Slot 3 Port 7                   0  55      0        6    3        0      8.0 GT/s            16 1.1
#	PCIe Slot 3 Port 2                   0  55      0        1    3        0      8.0 GT/s            16 1.1

Rename-NetAdapter -Name "PCIe Slot 3 Port 8" -NewName "55-0-7"
Rename-NetAdapter -Name "PCIe Slot 3 Port 1" -NewName "55-0-0"
Rename-NetAdapter -Name "PCIe Slot 3 Port 7" -NewName "55-0-6"
Rename-NetAdapter -Name "PCIe Slot 3 Port 2" -NewName "55-0-1"

New-VMSwitch -Name InfraSwitch -NetAdapterName "55-0-7", "55-0-6" -minimumbandwidthmode Weight
Set-VMSwitchTeam -Name "InfraSwitch" -TeamingMode SwitchIndependent
Set-VMSwitchTeam -Name "InfraSwitch" -LoadBalancingAlgorithm HyperVPort
Set-VMSwitch -Name InfraSwitch -AllowManagementOS $False


New-VMSwitch -Name VM-SWITCH -NetAdapterName "55-0-0", "55-0-1" -minimumbandwidthmode Weight
Set-VMSwitchTeam -Name "VM-SWITCH" -TeamingMode SwitchIndependent
Set-VMSwitchTeam -Name "VM-SWITCH" -LoadBalancingAlgorithm HyperVPort
Set-VMSwitch -Name VM-SWITCH -AllowManagementOS $False


#Add network adapters to switch
Add-VMNetworkAdapter -ManagementOS -Name "Infra" -SwitchName "InfraSwitch"
Add-VMNetworkAdapter -ManagementOS -Name "LM" -SwitchName "InfraSwitch"
Add-VMNetworkAdapter -ManagementOS -Name "CSV" -SwitchName "InfraSwitch"
Add-VMNetworkAdapter -ManagementOS -Name "REPLHV" -SwitchName "InfraSwitch"

#Set network adapters VLANs
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Infra" -Access -VlanId 119
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "LM" -Access -VlanId 260
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "CSV" -Access -VlanId 125
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "REPL" -Access -VlanId 123 
  
#Set network adapters bandwith
Set-VMNetworkAdapter -ManagementOS -Name "Infra" -MinimumBandwidthWeight 5
Set-VMNetworkAdapter -ManagementOS -Name "LM" -MinimumBandwidthWeight 20
Set-VMNetworkAdapter -ManagementOS -Name "CSV" -MinimumBandwidthWeight 40
#Set-VMNetworkAdapter -ManagementOS -Name "REPLHV" -MaximumBandwidth 104857600

#Set network IPs
New-NetIPAddress -IPAddress 10.***.254.235 -PrefixLength 24 -InterfaceAlias "vEthernet (LM)"
New-NetIPAddress -IPAddress 10.***.123.235 -PrefixLength 24 -InterfaceAlias "vEthernet (REPLHV)"
New-NetIPAddress -IPAddress 10.***.225.235 -PrefixLength 24 -InterfaceAlias "vEthernet (CSV)"
New-NetIPAddress -IPAddress 10.***.***.235 -PrefixLength 24 -DefaultGateway 10.***.***.*** -InterfaceAlias "vEthernet (Infra)"
Set-DnsClientServerAddress -InterfaceAlias "vEthernet (Infra)" -ServerAddress 10.***.***.****,10.***.***.***


# Configure the cluster network roles
(get-cluster).samesubnetthreshold = 20
(Get-ClusterNetwork -Name "Management_Network").Role = 3
(Get-ClusterNetwork -Name "CSV").Role = 1
(Get-ClusterNetwork -Name "LM").Role = 1
(Get-ClusterNetwork -Name "REPLHV").Role = 1


----------------------------------------------------------------------------------------------------------------------------------------------
Zanimivi ukazi
----------------------------------------------------------------------------------------------------------------------------------------------
Get-NetAdapter

Odstrani mrežo:
Remove-NetIPAddress -InterfaceAlias "vEthernet (LM)" -confirm:$false
Remove-NetIPAddress -InterfaceAlias "vEthernet (REPLHV)" -confirm:$false
Remove-NetIPAddress -InterfaceAlias "vEthernet (CSV)" -confirm:$false
Remove-NetIPAddress -InterfaceAlias "vEthernet (Infra)" -confirm:$false

Remove-VMNetworkAdapter -ManagementOS -Name "Infra" -SwitchName "InfraSwitch" -confirm:$false
Remove-VMNetworkAdapter -ManagementOS -Name "LM" -SwitchName "InfraSwitch" -confirm:$false
Remove-VMNetworkAdapter -ManagementOS -Name "CSV" -SwitchName "InfraSwitch" -confirm:$false
Remove-VMNetworkAdapter -ManagementOS -Name "REPLHV" -SwitchName "InfraSwitch" -confirm:$false

Remove-VMSwitch -Name VM-SWITCH -confirm:$false
Remove-VMSwitch -Name InfraSwitch -confirm:$false


