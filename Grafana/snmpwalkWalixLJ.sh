countIP=`snmpwalk -v2c -c ***PASSS*** **FQDN******.****.****.si TCP-MIB::tcpConnState | grep -E 'established' | grep -E '10.***.***|10.***|10.***.***'  | grep -v '.5.445' | wc -l`

echo $countIP

