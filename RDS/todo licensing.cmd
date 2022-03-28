#implement local licensing per user on terminal

http://woshub.com/licensing-mode-rds-host-not-configured/

$obj = gwmi -namespace "Root/CIMV2/TerminalServices" Win32_TerminalServiceSetting
$obj.GetSpecifiedLicenseServerList()
$obj.SetSpecifiedLicenseServerList("$Computername")

ni šlo:
HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\Licensing Core\LicensingMode

You need to change the DWORD to 2 for Per Device or 4 for Per User.
