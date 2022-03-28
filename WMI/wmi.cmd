
https://support.microsoft.com/en-us/help/2554336/how-to-manually-rebuild-performance-counters-for-windows-server-2008-6

Rebuilding the counters:
     cd c:\windows\system32
     lodctr /R
     cd c:\windows\sysWOW64
     lodctr /R

Resyncing the counters with Windows Management Instrumentation (WMI):
     WINMGMT.EXE /RESYNCPERF

Stop and restart the Performance Logs and Alerts service. 
Stop and restart the Windows Management Instrumentation service.


Diski:
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfDisk\Performance]
"Disable Performance Counters"=dword:00000000

diskperf -Y
+ restart WMI in telegraf