' *****************************
' * List All Groups in the Domain and
' * List All Members of each Group
' * 
' * SEARCH_FOR either user (list all users) or group (default behaviour)
' * 
' * Output to a text file on the user's desktop in the format:
' * group name <tab> type <tab> member name <tab> type
' * Prompt for text file name.
' * Written by James Anderson, July 2009
' *****************************
' Variable
'Const MY_DOMAIN = "dc=triglif,dc=si"
'Const SEARCH_FOR = "user"
'Const SEARCH_FOR = "group"
' *****************************
'for a prompt MY_DOMAIN needs to be empty
MY_DOMAIN = "dc=****,dc=local"
' Start Main
On Error Resume Next
Const ADS_SCOPE_SUBTREE = 2
Const ADS_GROUP_TYPE_GLOBAL_GROUP = &h2
Const ADS_GROUP_TYPE_LOCAL_GROUP = &h4
Const ADS_GROUP_TYPE_UNIVERSAL_GROUP = &h8
Const ADS_GROUP_TYPE_SECURITY_ENABLED = &h80000000
Const E_ADS_PROPERTY_NOT_FOUND = &h8000500D
Const MYPROMPT = "Enter the Output filename (i.e. Groups.txt) that will be saved on your desktop:"
Const GRPROMPT = "enter 'user' to search only users, else it will search groups."
Const DPROMPT = "Enter domain to search, use format 'dc=triglif,dc=si'"
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Setup the output file
If UCase( Right( WScript.FullName, 12 ) ) = "\CSCRIPT.EXE" Then
  WScript.StdOut.Write MYPROMPT & " "
  strMyFileName = WScript.StdIn.ReadLine
  WScript.StdOut.Write GRPROMPT & " "
  'didn't hold to convenction with lower case...
  SEARCH_FOR = WScript.StdIn.ReadLine
  if MY_DOMAIN = "" then
    WScript.StdOut.Write DPROMPT & " "
    MY_DOMAIN = WScript.StdIn.ReadLine
  end if
Else
  strMyFileName = InputBox( MYPROMPT )
  SEARCH_FOR = InputBox( GRPROMPT  )
  if MY_DOMAIN = "" then
    MY_DOMAIN = InputBox ( DPROMPT )
  end if
End If
if strMyFileName = "" then
  wscript.quit
end if
Set WshShell = CreateObject("WScript.Shell")
Set WshSysEnv = WshShell.Environment("PROCESS")
strMyFileName = WshSysEnv("USERPROFILE") & "\Desktop\" & strMyFileName
Set WshSysEnv = nothing
Set WshShell = nothing
if objFSO.FileExists(strMyFileName) then
  'objFSO.DeleteFile(strMyFileName)
  wscript.echo "That filename already exists"
  wscript.quit
end if

' Get a recordset of groups in AD
Set objMyOutput = objFSO.OpenTextFile(strMyFileName, ForWriting, True)
Set objConnection = CreateObject("ADODB.Connection")
Set objCommand =   CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider"
Set objCommand.ActiveConnection = objConnection
objCommand.Properties("Page Size") = 1000
objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE 
'objCommand.CommandText = _
'    "SELECT ADsPath, Name FROM 'LDAP://" & MY_DOMAIN & "' WHERE objectCategory='" & SEARCH_FOR & "'" 
'Set objRecordSet = objCommand.Execute
'objRecordSet.MoveFirst
if SEARCH_FOR = "user" then
	' do user magic and exit
	objCommand.CommandText = _
    "SELECT sAMAccountName, userAccountControl, Name FROM 'LDAP://" & MY_DOMAIN & "' WHERE objectCategory='user'" 
	Set objRecordSet = objCommand.Execute
	objRecordSet.MoveFirst
	'objMyOutput.WriteLine( "user")
	Do Until objRecordSet.EOF
		strUserName = objRecordSet.Fields("name").Value
		memStatus = " unknown "
		aEnabled = objRecordSet.Fields("userAccountControl").Value
		sAMAccountName = objRecordSet.Fields("sAMAccountName").Value
		memStatus = MemberStatus(aEnabled)
		'objMyOutput.WriteLine( aEnabled)
		objMyOutput.WriteLine( strUserName & vbtab & sAMAccountName & vbtab & memStatus)
		objRecordSet.MoveNext
	Loop
Else
	objCommand.CommandText = _
    "SELECT ADsPath, Name FROM 'LDAP://" & MY_DOMAIN & "' WHERE objectCategory='group'" 
	Set objRecordSet = objCommand.Execute
	objRecordSet.MoveFirst
	'objMyOutput.WriteLine( "Group")
	' For each Group, Get group properties
	Do Until objRecordSet.EOF
	  Set objGroup = GetObject(objRecordSet.Fields("ADsPath").Value)
	  strGroupName = objRecordSet.Fields("Name").Value
	  If objGroup.GroupType AND ADS_GROUP_TYPE_LOCAL_GROUP Then
		strGroupDesc = "Domain local "
	  ElseIf objGroup.GroupType AND ADS_GROUP_TYPE_GLOBAL_GROUP Then
		strGroupDesc = "Global "
	  ElseIf objGroup.GroupType AND ADS_GROUP_TYPE_UNIVERSAL_GROUP Then
	   strGroupDesc = "Universal "
	  ElseIF objGroup.GroupType Then
	   strGroupDesc = "Unknow Group xxx"
	  Else
		strGroupDesc = "Unknown "
	  End If
	  If objGroup.GroupType AND ADS_GROUP_TYPE_SECURITY_ENABLED Then
		strGroupDesc = strGroupDesc & "Security group"
	  Else
		strGroupDesc = strGroupDesc & "Distribution group"
	 End If

	  ' Check if there are members
	  err.clear
		
	  arrMemberOf = objGroup.GetEx("Member")
	  If Err.Number = E_ADS_PROPERTY_NOT_FOUND then
		' Write a line to the outputfile with group properties and no members
		objMyOutput.WriteLine(strGroupName & vbtab & strGroupDesc & vbtab & "<null> 1" & vbtab & "<null> 2" & vbtab & "<null> 3" & "<null> 4")
	  Else
		' For each group member, get member properties
		For Each strMemberOf in arrMemberOf
		  Set objMember = GetObject("LDAP://" & strMemberOf)
		  memStatus = " unknown "
		  aEnabled = objMember.Get("userAccountControl")
		  memStatus = MemberStatus(aEnabled)
		  strMemberName = right(objMember.Name,len(objMember.Name)-3)
          strsAMAccountName = objMember.sAMAccountName
		  ' Write a line to the outputfile with group and member properties
		  objMyOutput.WriteLine(strGroupName & vbtab & strGroupDesc & vbtab & strMemberName & vbtab & strsAMAccountName & vbtab & objMember.Class & vbtab & memStatus)
		  set objMember = nothing
		Next
	  End If
	  objRecordSet.MoveNext
	  Set objGroup = nothing
	Loop
End if
objMyOutput.close
wscript.echo "Done!"

function MemberStatus (aEnabled )
  select case aEnabled
	case 1
	  MemberStatus = " SCRIPT "
	case 2
	  MemberStatus = " ACCOUNTDISABLE "
	case 8
	  MemberStatus = " HOMEDIR_REQUIRED "
	case 16
	  MemberStatus = " LOCKOUT "
	case 32
	  MemberStatus = " PASSWD_NOTREQD "
	case 64
	  MemberStatus = " PASSWD_CANT_CHANGE "
	case 128
	  MemberStatus = " ENCRYPTED_TEXT_PWD_ALLOWED "
	case 256
	  MemberStatus = " TEMP_DUPLICATE_ACCOUNT "
	case 512
	  MemberStatus = " Enabled NORMAL_ACCOUNT "
	case 514
	  MemberStatus = " Disabled Account "
	case 544
	  MemberStatus = " Enabled, Password Not Required "
	case 546
	  MemberStatus = " Disabled, Password Not Required "
	case 2048
	  MemberStatus = " INTERDOMAIN_TRUST_ACCOUNT "
	case 4096
	  MemberStatus = " WORKSTATION_TRUST_ACCOUNT "
	case 8192
	  MemberStatus = " SERVER_TRUST_ACCOUNT "
	case 65536
	  MemberStatus = " DONT_EXPIRE_PASSWORD "
	case 66048
	  MemberStatus = " Enabled, Password Doesn’t Expire "
	case 66050
	  MemberStatus = " Disabled, Password Doesn’t Expire "
	case 66080
	  MemberStatus = " Enabled , Password Doesn’t Expire, Password Not Required "
	case 66082
	  MemberStatus = " Disabled, Password Doesn’t Expire & Not Required "
	case 131072
	  MemberStatus = " MNS_LOGON_ACCOUNT "
	case 262144
	  MemberStatus = " SMARTCARD_REQUIRED "
	case 262656
	  MemberStatus = " Enabled, Smartcard Required "
	case 262658
	  MemberStatus = " Disabled, Smartcard Required "
	case 262690
	  MemberStatus = " Disabled, Smartcard Required, Password Not Required "
	case 328194
	  MemberStatus = " Disabled, Smartcard Required, Password Doesn’t Expire "
	case 328226
	  MemberStatus = " Disabled, Smartcard Required, Password Doesn’t Expire & Not Required "
	case 524288
	  MemberStatus = " TRUSTED_FOR_DELEGATION "
	case 532480
	  MemberStatus = " Domain controller "
	case 1048576
	  MemberStatus = " NOT_DELEGATED "
	case 2097152
	  MemberStatus = " USE_DES_KEY_ONLY "
	case 4194304
	  MemberStatus = " DONT_REQ_PREAUTH "
	case 8388608
	  MemberStatus = " PASSWORD_EXPIRED "
	case 16777216
	  MemberStatus = " TRUSTED_TO_AUTH_FOR_DELEGATION "
	case 67108864
	  MemberStatus = " PARTIAL_SECRETS_ACCOUNT "
	case else 
	  MemberStatus = " " & aEnabled & " unk "
    End select
 end function