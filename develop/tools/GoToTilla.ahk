/*
#####################
GoToTilla v0.22 by hoppfrosch - Added parsing of properties (AHK > 1.1.16.*)
http://www.autohotkey.com/board/topic/95536-gototilla-a-combination-of-goto-and-tillagoto/
GoToTilla v0.21 by budRich
http://www.autohotkey.com/board/topic/95536-gototilla-a-combination-of-goto-and-tillagoto/
A combination of: GoTo by Avi Aryan
http://www.autohotkey.com/board/topic/95009-goto-hotkeys-hotstrings-functions-and-labels-in-any-editor/
and TillaGoto by TheGood
http://www.autohotkey.com/forum/viewtopic.php?t=41575
TheGood was inspired by Rajats Active GoTo
http://www.autohotkey.com/board/topic/10936-active-goto-v4/
#####################
 
Go To functions, labels, hotkeys and hotstrings in any editor.
The only requirement is that the Editor shows file full path in Title Bar and has a Goto (Ctrl+G) option.
Examples of such editors - Notepad++, Sublime Text, PSPad, ConTEXT
 
Ctrl+Space to show a list of all functions,hotkeys,hotstrings and labels.
Type to narrow list down, navigate with mouse or arrowkeys, select with doubleclick or Enter.
 
*/
 
;------- CONFIGURE -------------------
GoTo_AutoExecute()	;1 = Gui is movable, A_temp = Working Directory
+F7::Reload
 
#if GetActiveFile()	;If ahk window is active
^Space::
Activefileindex := fileiscached( GetActiveFile() )
if ( Activefile_old != Activefileindex )
	FreshList("-all", activefileindex)
 
GuiControl,, txtSearch,% ""
WinShow, GoToTilla
WinActivate, GoToTilla
ControlFocus,, ahk_id %htxtSearch%
 
Activefile_old := Activefileindex
return
#if
 
#IfWinActive, GoToTilla
^Space::WinHide, GoToTilla
Up::ControlSend,, {Up}, ahk_id %hlblList%
Down::ControlSend,, {Down}, ahk_id %hlblList%
Enter::Gosub, SelectItem
#IfWinActive
 
 
GoTo_AutoExecute(resizable=true, WorkingDir=""){
	global
	#SingleInstance force
	SetTitleMatchMode, 3
	SetWorkingDir,% ( WorkingDir == "" ) ? A_scriptdir : WorkingDir
	SetBatchLines, -1
	FileCreateDir, gotoCache
	FileDelete, gotoCache\*.gotolist
	SetTimer, filecheck, 200
	goto_cache := {}
	if resizable
		OnMessage(0x201, "DragGotoGui") ; WM_LBUTTONDOWN
	Gosub, NewGui
}
 
NewGui:
	Gui, +AlwaysOnTop -Caption +ToolWindow
	Gui, Margin, 3, 3
	Gui, Font, s11, Consolas
	Gui, Add, Edit, h20 w200 vtxtSearch hwndhtxtsearch gtxtSearch_Event
	Gui, Add, ListBox, sort w200 h275 vlblList glblList_Event hwndhlblList -HScroll +256 ;LBS_NOINTEGRALHEIGHT
	Gui, Show, Hide AutoSize, GoToTilla
return
 
 
GoTo_Readfile(File) {
	Critical, On
 
	static filecount , commentneedle := A_space ";|" A_tab	";"
	if ( filecount_N := fileiscached(File) )
		Filename := filecount_N
	else {
		Filename := filecount := filecount ? filecount+1 : 1
		FileAppend,% file "`n",gotoCache\filelist.gotolist
	}
	FileDelete, gotoCache\%Filename%-*
 
	loop, read, %file%
	{
		readline := Trim( A_LoopReadLine )
		if block_comments
			if Instr(readline, "*/") = 1
			{
				block_comments := 0
				continue
			}
			else continue
 
		if Instr(readline, ";") = 1
			continue
 
		if Instr(readline, "/*") = 1
		{
			block_comments := 1
			continue
		}
		readline := Trim( Substr(readline, 1, SuperInstr(readline, commentneedle, 1) ? SuperInstr(readline, commentneedle, 1)-1 : Strlen(readline)) )
 
		if ( readline_temp := Check4Hotkey(readline) )
			CreateCache(filename, "hotkey", readline_temp, A_index)
		else if ( Instr(readline, ":") = 1 ) and ( Instr(readline, "::", 0, 0) > 1 )
			CreateCache(filename, "hotstr", Substr(readline, 1, Instr(readline, "::", 0, 0)-1), A_index )
		else if !SuperInstr(readline, "``|`t| |,", 0) and Substr(readline,0) == ":"
			CreateCache(filename, "label", readline, A_index)
		else if Check4func(readline, A_index, file)
			CreateCache(filename, "func", Substr(readline, 1, Instr(readline, "(")) ")", A_index)
		else if Check4prop(readline, A_index, file)
			CreateCache(filename, "prop", Substr(readline, 1, Instr(readline, "[")) "]", A_index)
	}
}
 
CreateCache(hostfile, type, data, linenum){
	if type = func
		if ( Substr( data, 1, SuperInstr(data, " |`t|,|(", 1)-1 ) == "while" )
			return
	;Exceptions are listed above
 
	FileAppend,% data ">" linenum "`n",% "Gotocache\" hostfile "-all.gotolist"
}
 
Check4Hotkey(line) {
	;The function assumes line is trimmed using Trim() and then checked for ; comment
	if ( Instr(line, "::") = 1 ) and ( Instr(line, ":", false, 0) = 3 )	;hotstring
		return ""
	hK := Substr( line, 1, ( Instr(line, ":::") ? Instr(line, ":::")+2 : ( Instr(line, "::") ? Instr(line, "::")+1 : Strlen(line)+2 ) ) - Strlen(line) - 2)
	if hK =
		return
 
	if !SuperInstr(hK, " | ", 0)
		if !SuperInstr(hK, "^|!|+|#", 0) And RegExMatch(hK, "[a-z]+[,(]")
			return
		else
			return hK
	else
		if Instr(hK, " & ") or ( Substr(hK, -1) == "UP" )
			return hK
}
 
Check4func(readline, linenum, file){
	if RegExmatch(readline, "i)[A-Z0-9#_@\$\?\[\]]+\(.*\)") != 1
		return
	if ( Substr(readline, 0) == "{" )
		return 1
 
	loop, {
		FileReadLine, cl, %file%,% linenum+A_index
		if Errorlevel = 1
			return
		cl := Trim( Substr(cl, 1, Instr(cl, ";") ? Instr(cl, ";")-1 : Strlen(cl)) )
		if cl =
			continue
 
		if block_comments
			if Instr(readline, "*/") = 1 {
				block_comments := 0
				continue
			}
		else continue
		if Instr(readline, "/*") = 1 {
			block_comments := 1
			continue
		}
 
		return Instr(cl, "{") = 1 ? 1 : 0
	}
}

Check4prop(readline, linenum, file){
    if A_AhkVersion < "1.1.16.0"
    	return
	if RegExmatch(readline, "i)[A-Z0-9#_@\$\?]+\[.*\]") != 1
		return
	if ( Substr(readline, 0) == "{" )
		return 1
 
	loop, {
		FileReadLine, cl, %file%,% linenum+A_index
		if Errorlevel = 1
			return
		cl := Trim( Substr(cl, 1, Instr(cl, ";") ? Instr(cl, ";")-1 : Strlen(cl)) )
		if cl =
			continue
 
		if block_comments
			if Instr(readline, "*/") = 1 {
				block_comments := 0
				continue
			}
		else continue
		if Instr(readline, "/*") = 1 {
			block_comments := 1
			continue
		}
 
		return Instr(cl, "{") = 1 ? 1 : 0
	}
}
 
filecheck:
	FileGetTime, Timeforfile,% goto_tempfile := GetActiveFile(), M
	if ( goto_cache[goto_tempfile] != Timeforfile )
		goto_cache[goto_tempfile] := Timeforfile , Goto_Readfile(goto_tempfile)
return
 
fileiscached(file){
	loop, read, gotoCache\filelist.gotolist
	if ( file == A_LoopReadLine )
		return A_index
}
  
GUIEscape:
	WinHide, GoToTilla
return
 
 
FreshList(mode, fileindex){
	global aLst,lblList
	aLst := Object()
	lblList := ""
	GuiControl,, lblList,|
	if !fileindex
		return
 
	loop, read, gotoCache\%fileIndex%%Mode%.gotolist
	{
		StringSplit, toadd, A_LoopReadLine, >
		aLst.Insert(toadd1, toadd2)
		lblList .= "|" toadd1
	}
	GuiControl, -Redraw, lblList
	Guicontrol, ,lblList,% !lblList ? "|" : lblList
	GuiControl, +Redraw, lblList
}
 
 
GetActiveFile(){
	WinGetActiveTitle, Title
	if !( Instr(title, ".ahk") and Instr(title, ":\") )
		return ""
	return Trim( Substr( Title, temp := Instr(Title, ":\")-1, Instr(Title, ".ahk", 0, 0)-temp+4 ) )
}
 
 
DragGotoGui(){	;Thanks Pulover
	PostMessage, 0xA1, 2,,, A
}
 
/*
SuperInstr()
Returns min/max position for a | separated values of Needle(s)
return_min = true ; return minimum position
return_min = false ; return maximum position
 
*/
SuperInstr(Hay, Needles, return_min=true, Case=false, Startpoint=1, Occurrence=1){
	pos := return_min*Strlen(Hay)
	if return_min
	{
		loop, parse, Needles,|
		if ( pos > (var := Instr(Hay, A_LoopField, Case, startpoint, Occurrence)) )
			pos := var ? var : pos
		if ( pos == Strlen(Hay) )
			return 0
	}
	else
	{
		loop, parse, Needles,|
		if ( (var := Instr(Hay, A_LoopField, Case, startpoint, Occurrence)) > pos )
			pos := var
	}
	return pos
}
 
lblList_Event:
If (A_GuiEvent <> "DoubleClick")
Return
SelectItem:	
;Get selected item index. LB_GETCURSEL
SendMessage, 0x188, 0, 0,, ahk_id %hlblList%
 
;Check for error. LB_ERR
If (ErrorLevel = 0xFFFFFFFF)
Return
 
;Get the associated item data
i := GetListBoxItem(hlblList, ErrorLevel)
 
BlockInput, On
WinHide, GoToTilla
SendInput, ^g
sleep, 100
SendInput,% aLst[i] "{Enter}"
BlockInput, Off
Return
 
 
GetListBoxItem(hLB, i) {
	;Get length of item. LB_GETTEXTLEN
	SendMessage 394, %i%, 0,, ahk_id %hLB%
	;Check for error
	If (ErrorLevel = 0xFFFFFFFF)
		Return ""
	;Prepare variable
	VarSetCapacity(sText, ErrorLevel * (1 + !!A_IsUnicode), 0)
	;Retrieve item. LB_GETTEXT
	SendMessage 393, %i%, &sText,, ahk_id %hLB%
	;Check for error
	If (ErrorLevel = 0xFFFFFFFF)
		Return ""
	 
	Return sText
}
 
;Incremental searching
txtSearch_Event:
	GuiControlGet, s,, txtSearch
	CreateList(s)
Return
 
CreateList(filter = "") {
	Global hlblList, bShowing, aLst, activefileindex
	Static sLastfilter := "`n" ;Initialize on an impossible filter
 
	;Trim the right side
	While (SubStr(filter, 0) = A_Space)
		StringTrimRight, filter, filter, 1
	 
	;Trim right side if it ends in " !" since it changes nothing
	If (StrLen(filter) > 2) And (SubStr(filter, -1) = " !") And (SubStr(filter, -2, 1) <> A_Space)
		StringTrimRight, filter, filter, 2
	 
	;Check if the filter is different
	If (filter = sLastfilter) ;And bShowing
		Return
	 
	sLastfilter := filter
	 
	GuiControl, -Redraw, lblList
	GuiControl,, lblList,|
	lblList := ""
	 
	If (filter = "")
		FreshList("-all", activefileindex)
	Else {
		For k, v in aLst
			If (InStr(k, filter) = 1)
				lblList .= "|" k
	 
		Guicontrol, ,lblList,% !lblList ? "|" : lblList
	}
	;Select the first item. LB_SETCURSEL
	SendMessage 390, 0, 0,, ahk_id %hlblList%
	 
	;Redraw
	GuiControl, +Redraw, lblList
}