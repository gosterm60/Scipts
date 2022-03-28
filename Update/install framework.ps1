\\corp.iges.si\dfs\IT_SW\MS OpSys\MS>> Windows 10 ENT - mount
 
HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
Na 0 UseWUServer

RESTART WINDOWS UPDATE SERVICE 

dism /online /enable-feature /featurename:NetFX3 /Source:e:\sources\sxs /all 

net stop wuauserv
net start wuauserv