; #Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Gui +LastFound
hWnd := WinExist()
CoordMode, Mouse, Screen
#Maxmem 256 ;Set the max use of memory by the software

#MaxHotkeysPerInterval, 200

F1::
    SetTitleMatchMode, 1
    WinActivate, Adventure
    Sleep 100
    Send {Down}
    Sleep 100
    Send {Down}
    Sleep 100
    Send ^{v}
    Sleep 100
    SetTitleMatchMode, 1
    WinActivate, DaVinci Resolve
Return