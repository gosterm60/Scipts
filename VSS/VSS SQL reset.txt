https://forums.veeam.com/microsoft-hyper-v-f25/the-infamous-vss-ws-failed-at-prepare-snapshot-problem-t45123.html




net stop VSS /Y
TIMEOUT /T 10
net stop iphlpsvc /Y
TIMEOUT /T 10
net stop SQLWriter /Y
TIMEOUT /T 10
net stop CcmExec /Y
TIMEOUT /T 10
net stop Winmgmt /Y
TIMEOUT /T 30
net stop Winmgmt /Y
TIMEOUT /T 30
net stop SQLWriter /Y
net start VSS
net start Winmgmt
net start SQLWriter


--------------------
net stop MSExchangeIS
net start MSExchangeIS

