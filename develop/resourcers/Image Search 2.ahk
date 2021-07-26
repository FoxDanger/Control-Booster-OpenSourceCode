
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxHotkeysPerInterval, 200

; == START GUI INTERFACE ==

Gui Font, s9, Segoe UI
Gui Add, Button, x50 y8 w150 h50, Start TWB

Gui Show, w300 h300, TWB 2.0.1 Beta

Return

GuiClose:
    ExitApp

F12::
_searchTool()
return

;Search for a tool (base on a image)
_searchTool(){
    CoordMode Pixel  ; Interprets the coordinates below as relative to the screen rather than the active window.
    PixelSearch, Px, Py, 1450, 1500, 2860, 1980, 0xD9D4D4, 3, Fast
        if ErrorLevel
            MsgBox, That color was not found in the specified region.
        else
            MsgBox, A color within 3 shades of variation was found at X%Px% Y%Py%.
            MouseMove Px, Py
}