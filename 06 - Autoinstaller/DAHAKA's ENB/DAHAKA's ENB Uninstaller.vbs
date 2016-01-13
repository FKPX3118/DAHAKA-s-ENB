' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'      | DAHAKA ENB - AutoUninstaller Script |
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'             coded by SkyrimTuner
' 

dim filesys
dim erasepath
dim ipath
dim strdatei
dim myArray()
dim fullpath
dim pathfile

Set ShellWSH = WScript.CreateObject("WScript.Shell")
Set filesys = WScript.CreateObject("Scripting.FileSystemObject")
fullpath = filesys.GetParentFolderName(WScript.ScriptFullName)
erasepath = "..\..\"
answer=6

' ------------------------------------------------------------------------------------------------------------------------------------------
If filesys.FileExists("instpath.txt") Then
	strdatei="instpath.txt"
	x = 0
	Const ForReading = 1
	Set f = filesys.OpenTextFile(strdatei, ForReading) 
	Do While f.AtEndOfStream <> True
	  x = x+1
	  ReDim Preserve myArray(x) 
	  org_zeile = f.Readline 
		myArray(x) = org_zeile 
	Loop
	f.Close
	erasepath=myArray(x)
	if erasepath="..\..\" then erasepath=left(fullpath, len(fullpath) - 25)
Else
	instpath=left(fullpath, len(fullpath) - 25)
End if	

' ------------------------------------------------------------------------------------------------------------------------------------------
If filesys.FileExists(erasepath & "DAHAKA_uninstall.log") Then
  answer=MsgBox("DAHAKA_uninstall.log present in " & erasepath & vbCrlf & vbCrlf & "Do you still want to uninstall?",3,"DAHAKA's ENB")
end if

if answer = 6 AND filesys.FileExists(erasepath & "TESV.exe") then
  fileerase(erasepath)
  If filesys.FileExists(erasepath & "DAHAKA_uninstall.log") Then
    MsgBox "Uninstall successful!" & vbCrlf & vbCrlf & "All DAHAKA's ENB files got erased," & vbCrlf & "now you can disable DAHAKA's ENB in your Mod Manager.",0,"DAHAKA's ENB"    	
  Else
    MsgBox "Oh no, there is something wrong!" & vbCrlf & "try to uninstall manually please.",16,"DAHAKA's ENB"
  End if	
Else
  WScript.Quit
End if

' ------------------------------------------------------------------------------------------------------------------------------------------

' --- fileerase ---
Sub fileerase(ipath)

  if filesys.FileExists(ipath & "log.log")		Then filesys.DeleteFile ipath & "log.log"
  if filesys.FileExists(ipath & "enblocal.ini") 	Then filesys.DeleteFile ipath & "enblocal.ini"
  if filesys.FileExists(ipath & "enbseries.ini") 	Then filesys.DeleteFile ipath & "enbseries.ini"
  if filesys.FileExists(ipath & "DAHAKA_install.log") 	Then filesys.DeleteFile ipath & "DAHAKA_install.log"
  if filesys.FileExists(ipath & "d3d9.dll") 		Then filesys.DeleteFile ipath & "d3d9.dll"
  if filesys.FileExists(ipath & "enbhost.exe") 		Then filesys.DeleteFile ipath & "enbhost.exe"

  If filesys.FolderExists(ipath & "enbseries") Then 
	permchange(filesys.GetFolder(ipath & "enbseries"))
	filesys.DeleteFolder(ipath & "enbseries")
  End if
  Set pathfile = filesys.CreateTextFile(ipath & "DAHAKA_uninstall.log", TRUE) 
	pathfile.WriteLine ("DAHAKA's ENB files erased successfully.")
  pathfile.Close
  'WScript.Sleep 1200
End Sub

' -------------------------------------------------------------------------------------------------------

' --- change permission ---

Sub permchange(objFolder)
  For Each objFile In objFolder.Files
    If filesys.GetFile(objFile).Attributes And 1 Then 
	filesys.GetFile(objFile).Attributes = filesys.GetFile(objFile).Attributes - 1  
    End If
  Next
  For Each objSubFolder In objFolder.SubFolders
    	On Error Resume Next
    	permchange(objSubFolder)
    	On Error Goto 0
  Next
End Sub