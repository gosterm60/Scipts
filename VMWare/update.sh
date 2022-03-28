10.119.119.119
esxcli software vib update -d "/vmfs/volumes/5a3d0851c-3d262eb4-f206-40f2993713a/update/ESXi600-201711001.zip"

10.119.119.101
esxcli software vib update -d "/vmfs/volumes/5a3d051c-3d262eb4-f206-40f2e993713a/update/ESXi600-201711001.zip"

10.119.119.43
esxcli software vib update -d "/vmfs/volumes/588b7121-6421a3f4-1e87-40f2e993617a/ISO/ESXi600-201711001.zip"

10.119.119.200
esxcli software vib update -d "/vmfs/volumes/558937d6-269d2400-3acf-901b0e5484c3/update/SVS-VMware-ESXi60-CIM-Provider-8.20.08.zip"

[root@geningesxi08:~] esxcli software sources profile list -d "/vmfs/volumes/558937d6-269d2400-3acf-901b0e5484c3/ISO/VMware-ESXi-6.0.update03-5050593-Fujitsu-v380-1-offline-bundle.zip"
[root@geningesxi08:~] esxcli software profile update -p Fujitsu-VMvisor-Installer-6.0.update03-5050593-v380-1 -d "/vmfs/volumes/558937d6-269d2400-3acf-901b0e5484c3/ISO/VMware-ESXi-6.0.update03-5050593-Fujitsu-v380-1-offline-bundle.zip"
Update Result


10.119.119.192
esxcli software vib update -d "/vmfs/volumes/51e44838-dc5cc687-759b-78e7d1645e9c/update/ESXi600-201808001.zip"

10.119.119.193
esxcli software vib update -d /vmfs/volumes/53e8717b-79f321c7-4ff0-0017a47724a4/ISO/VMware-ESXi-7.0.2-17867351-HPE-702.0.0.10.7.0.52-May2021-depot.zip

10.119.119.197
esxcli software vib update -d /vmfs/volumes/5d0b79c9-b861209c-55ca-fc15b4171d18/ISO/VMware-ESXi-7.0.2-17867351-HPE-702.0.0.10.7.0.52-May2021-depot.zip


https://docs.vmware.com/en/VMware-vSphere/6.7/rn/esxi670-202201001.html
esxcli software profile update -p ESXi-6.7.0-202201001-standard -d /vmfs/volumes/56b0b905-3ff23c28-4cb0-901b0e6d09e9/ISO/ESXi670-202201001.zip


