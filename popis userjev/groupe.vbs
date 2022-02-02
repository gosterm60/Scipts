' *****************************
' * List All Groups in the Domain and
' * List All Members of each Group
' * 
' * Output to a text file on the user's desktop in the format:
' * group name <tab> type <tab> member name <tab> type
' * Prompt for text file name.
' * Written by James Anderson, July 2009
' *****************************
' Variables
Const MY_DOMAIN = "dc=****,dc=si"
' *****************************
' Start Main
On Error Resume Next
Const ADS_SCOPE_SUBTREE = 2
Const ADS_GROUP_TYPE_GLOBAL_GROUP = &h2
Const ADS_GROUP_TYPE_LOCAL_GROUP = &h4
Const ADS_GROUP_TYPE_UNIVERSAL_GROUP = &h8
Const ADS_GROUP_TYPE_SECURITY_ENABLED = &h80000000
Const E_ADS_PROPERTY_NOT_FOUND = &h8000500D
Const MYPROMPT = "Enter the Output filename (i.e. Groups.txt) that will be saved on your desktop:"
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Setup the output file
If UCase( Right( WScript.FullName, 12 ) ) = "\CSCRIPT.EXE" Then
  WScript.StdOut.Write MYPROMPT & " "
  strMyFileName = WScript.StdIn.ReadLine
Else
  strMyFileName = InputBox( MYPROMPT )
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
objCommand.CommandText = _
    "SELECT ADsPath, Name FROM 'LDAP://" & MY_DOMAIN & "' WHERE objectCategory='group'" 
Set objRecordSet = objCommand.Execute
objRecordSet.MoveFirst

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
    objMyOutput.WriteLine(strGroupName & vbtab & strGroupDesc & vbtab & "<null>" & vbtab & "<null>")
  Else
    ' For each group member, get member properties
    For Each strMemberOf in arrMemberOf
      Set objMember = GetObject("LDAP://" & strMemberOf)
      strMemberName = right(objMember.Name,len(objMember.Name)-3)
      ' Write a line to the outputfile with group and member properties
      objMyOutput.WriteLine(strGroupName & vbtab & strGroupDesc & vbtab & strMemberName & vbtab & objMember.Class)
      set objMember = nothing
    Next
  End If
  objRecordSet.MoveNext
  Set objGroup = nothing
Loop
objMyOutput.close
wscript.echo "Done!"
