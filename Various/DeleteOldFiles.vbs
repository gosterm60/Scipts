Dim BackupPath ' As String
Dim OhraniDatotek ' As Integer
Dim DBName ' As String
Dim MapaZaBrisanje ' As String

Const adVarChar = 200 '(&HC8)
Const adDate = 7

set args = WScript.Arguments
OhraniDatotek=args.item(0)
DBName=args.item(1)
BackupPath=args.item(2)
MapaZaBrisanje= BackupPath

Set oFso=CreateObject("Scripting.FileSystemObject")
Set oFolder = oFso.GetFolder(MapaZaBrisanje)
Dim oFolderForDelete
Dim oRsFiles
Set oRsFiles=CreateObject("ADODB.Recordset")
oRsFiles.Fields.Append "FileName", adVarChar, 255
oRsFiles.Fields.Append "Datum", adDate
oRsFiles.Open
For Each oFile in oFolder.Files
	sPath=oFile.Path
	oRsFiles.AddNew Array("FileName", "Datum"), Array(sPath, oFile.DateCreated)
Next
oRsFiles.Sort="Datum DESC"
oRsFiles.MoveFirst
i = 1
Do
	sPath=oRsFiles.Fields("FileName").Value
	If i > cint(OhraniDatotek) Then
	oFso.DeleteFile sPath,True
	End If
	i = i + 1
	oRsFiles.MoveNext
Loop Until oRsFiles.EOF
oRsFiles.Close
Set oRsFiles=Nothing
