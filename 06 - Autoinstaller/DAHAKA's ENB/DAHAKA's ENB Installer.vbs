' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'     | DAHAKA's ENB - Autoinstaller Script |
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'             coded by SkyrimTuner
'

'Option Explicit

dim filesys, fullpath, instpath, filename, pathfile, myArray(), strdatei, result, overwrite, ShellWSH, objFile, objSubFolder 
dim VRAMamount, SYSRAMamount, windowsversion, cardname, text, filetoadd, usage, x, i, rFile, wFile, suchstring, ausgabe

Set ShellWSH = WScript.CreateObject("WScript.Shell")
Set filesys = WScript.CreateObject("Scripting.FileSystemObject")
fullpath = filesys.GetParentFolderName(WScript.ScriptFullName)
result=6

' --------------------------------------------------------------------------------------------------------------------------------------------
If filesys.FileExists("instpath.txt") Then
	dim org_zeile
	strdatei="instpath.txt"
	x = 0
	Const ForReading = 1
	Set pathfile = filesys.OpenTextFile(strdatei, ForReading) 
	Do While pathfile.AtEndOfStream <> True
	  x = x+1
	  ReDim Preserve myArray(x) 
	  org_zeile = pathfile.Readline 
		myArray(x) = org_zeile 
	Loop
	pathfile.Close
	instpath=myArray(x)	
	if instpath="..\..\" then instpath=left(fullpath, len(fullpath) - 25)
Else
	instpath=left(fullpath, len(fullpath) - 25)
End if

Set pathfile = filesys.CreateTextFile("instpath.txt", TRUE) 
pathfile.WriteLine (instpath)
pathfile.Close

If filesys.FileExists(instpath & "DAHAKA_install.log") Then 
	overwrite = MsgBox("Found DAHAKA_install.log from previous installation in " & instpath & vbCrlf & vbCrlf & "Do you want to overwrite?" & vbCrlf & "(Not recommended, better make a clean uninstall first)",3,"DAHAKA's ENB")	
	If overwrite <> 6 then WScript.Quit    
Else

' --------------------------------------------------------------------------------------------------------------------------------------------
  If not LCase(Left(right(fullpath,49),28)) = LCase("SteamApps\common\skyrim\Data") Then
   On Error Resume Next 
   filename = "tesv.exe"
   count=0
   
   Do While count<1
   driveok=0
    Do While driveok<1
     drive = UCase(InputBox("DAHAKA's ENB_ENB_files folder is not in Steam\SteamApps\common\Skyrim\Data" & vbCrlf & vbCrlf & "Please enter the driveletter of the drive where TESV.exe is located:","DAHAKA's ENB"))
     If drive="" then WScript.Quit
     If instr(drive,":") > 0  then drive=left(drive,instr(drive,":")-1)
     For Each objDrive In filesys.Drives	
	if objDrive.DriveType = 2 and UCase(objDrive.DriveLetter) = drive then
		driveok=driveok+1
				
		If not filesys.FileExists(drive & ":\Program Files (x86)\Steam\SteamApps\common\Skyrim\TESV.exe") Then		
		If not filesys.FileExists(drive & ":\Steam\SteamApps\common\Skyrim\TESV.exe") Then
	
		Set ie4 = CreateObject("InternetExplorer.Application")   
		ie4.navigate ("about:blank")
		With ie4 
		  .AddressBar = False 
		  .MenuBar = False 
		  .StatusBar = False 
		  .Toolbar = False  
		  .Height = 200
		  .Width = 400
		  .Top = 300 
		  .Left = 300
		End With  
		ie4.Visible = True
		ie4.document.body.innerHTML = "<center><b><br>searching for TESV.exe<br>on drive " & UCase(drive) & "<br><br>please wait...</b></center>" 
		ie4.document.Title = "please wait"
		'ShellWSH.AppActivate "please wait - Internet Explorer"		
		ProcFolders(filesys.GetFolder(drive&":\"))
		ie4.Quit
		Set ie4 = Nothing
			
		Else
			instpath=drive & ":\Steam\SteamApps\common\Skyrim\"
			count=1
		End if
		Else
			instpath=drive & ":\Program Files (x86)\Steam\SteamApps\common\Skyrim\"
			count=1
		End if
	end if		
     Next
    Loop

    if count = 0 then
	MsgBox "TESV.exe not found on drive " & drive,48,"DAHAKA's ENB"
    else
	result = MsgBox ("TESV.exe found in " & instpath & vbCrlf & vbCrlf & "Start installation?",3,"DAHAKA's ENB")
	Set pathfile = filesys.CreateTextFile("instpath.txt", TRUE) 
	pathfile.WriteLine (instpath)
	pathfile.Close
    End if
   Loop
  End if
End If
' --------------------------------------------------------------------------------------------------------------------------------------------    
  if result = 6 then 
    ENBoost	
    copycheck
  else 
    WScript.Quit
  end if




' -------------------------------------------------------------------------------------------------------

' --- filecopy ---

Sub filecopy(ipath)
  If filesys.FolderExists(ipath & "enbseries") Then 
	permchange(filesys.GetFolder(ipath & "enbseries"))
	filesys.DeleteFolder(ipath & "enbseries")
  End if
  filesys.CreateFolder(ipath & "enbseries")
  filesys.GetFolder(".\enbseries").Copy ipath & "enbseries"
  If filesys.FileExists(ipath & "DAHAKA_uninstall.log") Then filesys.DeleteFile ipath & "DAHAKA_uninstall.log"
  Set pathfile = filesys.CreateTextFile(ipath & "DAHAKA_install.log", TRUE) 
	pathfile.WriteLine ("DAHAKA's ENB files copied successfully.")
  pathfile.Close
  For Each objFile In filesys.GetFolder(".\").Files
    If filesys.GetFile(objFile).Name <> "DAHAKA's ENB Installer.vbs" AND filesys.GetFile(objFile).Name <> "DAHAKA's ENB Uninstaller.vbs" AND filesys.GetFile(objFile).Name <> "instpath.txt" Then
	filesys.CopyFile objFile, ipath, True
    End if
  Next
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

' -------------------------------------------------------------------------------------------------------

' --- filesearch ---

Sub ProcFolders(objFolder)
  For Each objFile In objFolder.Files
    If LCase(filename) = LCase(objFile.Name) Then
	count=count+1
	Position=InStrRev(LCase(objFile.Path),filename)
	instpath=Left(objFile.Path,Position-1)
    End If
  Next
  if count<1 then
    For Each objSubFolder In objFolder.SubFolders
    	On Error Resume Next
    	ProcFolders(objSubFolder)
    	On Error Goto 0
    Next
  else
    Exit Sub
  end if
End Sub

' -------------------------------------------------------------------------------------------------------

' --- copy & check ---

Sub copycheck
  filecopy(instpath)
  If not filesys.FileExists(instpath & "DAHAKA_install.log") Then
	MsgBox "Oh no, there is something wrong!" & vbCrlf & vbCrlf & "Please copy all files except DAHAKA's ENB Installer.vbs, DAHAKA's ENB Uninstaller.vbs, instpath.txt" & vbCrlf & "to Skyrim-mainfolder where TESV.exe is located, manually.",16,"DAHAKA's ENB"	
  Else
	MsgBox "Installation successful!" & vbCrlf & vbCrlf & "Thanks for using DAHAKA's ENB ",0,"DAHAKA's ENB"
	If not filesys.FileExists(instpath & "d3d9.dll") AND not filesys.FileExists(instpath & "enbseries.dll") Then
		WScript.Sleep 300
		MsgBox "d3d9.dll (wrapper) or enbseries.dll (injector) missing in Skyrim mainfolder!" & vbCrlf & vbCrlf & "Get the newest ENBSERIES BINARY FILES(dll and enbhost) from enbdev:" & vbCrlf & vbCrlf &"http://enbdev.com/download_mod_tesskyrim.htm",48,"DAHAKA's ENB"
		dim Wsh 
		Set Wsh=WScript.CreateObject("WScript.Shell") 
		On error Resume Next 
		Wsh.Run "http://enbdev.com/download_mod_tesskyrim.htm"
  End if
  End if
End Sub

' -------------------------------------------------------------------------------------------------------

' --- ENBoost settings ---
Sub ENBoost
	dim strComputer, objWMIService, colItems
	strComputer = "."
	cardname="not found"
	VRAMamount=-1

'Windowsversion---
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem",,48)
	Dim objItem 'as Win32_OperatingSystem
	For Each objItem in colItems
		windowsversion=objItem.OSArchitecture
	Next

'Videoadapter---
	Set colItems = objWMIService.ExecQuery _
    	("Select * from Win32_VideoController")

	For Each objItem in colItems
		'msgbox objItem.VideoMemoryType
		
		if instr(objItem.Name, "Intel") = 0 then
		  cardname=objItem.Name
		  'VRAMamount=INT(objItem.AdapterRAM/1024/1024)
		end if

	Next
'RAM---
	Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" _ 
	& strComputer & "\root\cimv2") 
	Set colItems = objWMIService.ExecQuery _
	("Select * from Win32_ComputerSystem") 

	For Each objItem in colItems 
		SYSRAMamount=INT(objItem.TotalPhysicalMemory/1024/1024)
	Next

'VRAM--- 
	do while VRAMamount <> 0 and VRAMamount <> 128 and VRAMamount <> 256 and VRAMamount <> 512 and VRAMamount <> 768 and VRAMamount <> 1024 and VRAMamount <> 2048 and VRAMamount <> 3072 and VRAMamount <> 4096 and VRAMamount <> 6144 and VRAMamount <> 8192

		On Error Resume Next
		VRAMamount = InputBox("Please enter video RAM amount (VRAM) of your graphics card in MB (Megabytes)" & vBCrlf & vBCrlf & "To abort, or to use default settings," & vBCrlf & "enter '0' or click 'Cancel'" & vBCrlf & vBCrlf & "Possible values:" & vBCrlf & "128|256|512|768|1024|2048|3072|4096|6144|8192" & vBCrlf & vBCrlf & "If you are using Crossfire or SLI," & vBCrlf & "ONLY insert VRAM of 1 single card!","ENBOOST CONFIGURATOR")
	loop

if VRAMamount > 0 then

	if SYSRAMamount >= 64000 then
		SYSRAMamount=65536
	else
	if SYSRAMamount >= 32000 then
		SYSRAMamount=32768
	else
	if SYSRAMamount >= 16000 then
		SYSRAMamount=16384
	else
	if SYSRAMamount >= 12000 then
		SYSRAMamount=12288
	else
	if SYSRAMamount >= 8000 then
		SYSRAMamount=8192
	else
	if SYSRAMamount >= 6000 then
		SYSRAMamount=6144
	else
	if SYSRAMamount >= 4000 then
		SYSRAMamount=4096
	else
	if SYSRAMamount >= 2000 then
		SYSRAMamount=2048
	else
	if SYSRAMamount >= 1000 then
		SYSRAMamount=1024
	end if
	end if
	end if
	end if
	end if
	end if
	end if
	end if
	end if

	'Windows: " & windowsversion & " Karte: " & cardname & " VRAM: " & VRAMamount & " RAM: " & SYSRAMamount 

	' ---ExpandSystemMemoryX64---
	if instr(windowsversion,"32") > 0 then 
		addstring "false", "ExpandSystemMemoryX64"
	end if
	
	' ---VideoMemorySizeMb---
	addstring VRAMamount+SYSRAMamount-2048, "VideoMemorySizeMb"

	' ---ReservedMemorySizeMb---
	if VRAMamount >= 3072 then
	  addstring 512, "ReservedMemorySizeMb"
	else
	  if VRAMamount >= 2048 then
	    addstring 256, "ReservedMemorySizeMb"
	  else
	    addstring "true", "EnableCompression"
	    if VRAMamount >= 1024 then 
    		addstring 128, "ReservedMemorySizeMb"
	    else	
		addstring 64, "ReservedMemorySizeMb"
	    end if
	  end if
	end if

Set rFile = filesys.OpenTextFile(".\enblocal.ini", ForReading)
	x = 0
	i = 0

	Do While rFile.AtEndOfStream <> True
	  x = x+1
	  ReDim Preserve myArray(x) 
	  myArray(x) = rFile.Readline 		 
	  if instr(UCase(myArray(x)),UCase("[MEMORY]")) <> 0 then 
		i=1 
	  end if
	  if i>0 and i<=10 then
	      ausgabe=ausgabe & myArray(x) & vbCrlf
	      i=i+1
	  end if	  
	Loop
rFile.close
msgbox "Your enblocal.ini has been created:" & vBCrlf & vBCrlf & ausgabe,0, "ENBoost settings"

end if
End Sub

Sub addstring(text, suchstring)
	Set rFile = filesys.OpenTextFile(".\enblocal.ini", ForReading)
	x = 0
	Do While rFile.AtEndOfStream <> True
	  x = x+1
	  ReDim Preserve myArray(x) 
	  myArray(x) = rFile.Readline 		 
	  if instr(UCase(myArray(x)),UCase(suchstring)) <> 0 then
		myArray(x)=suchstring & "=" & text
	  end if
	Loop
	rFile.close
	Set wFile = filesys.CreateTextFile(".\enblocal.ini", True)
	for i = 1 to x
		wFile.WriteLine myArray(i)
	next
	wFile.close
End Sub
