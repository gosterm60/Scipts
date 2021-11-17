del "C:\admin\logs\cobian\*.*" /F /Q

robocopy.exe "C:\Program Files\Cobian Backup 11\Logs" "C:\admin\logs\cobian" /MIR /FFT /S /E /COPY:DAT /R:1 /W:1 /np /NFL /NDL