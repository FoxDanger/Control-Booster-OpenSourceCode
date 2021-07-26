#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxHotkeysPerInterval, 200

; == Start/Draw GUI == 

;Add the start controller button
Gui Show, w1130 h1020, Test
return
GuiEscape:
GuiClose:
    ExitApp
    
F12::

DoSearch()

return

; == Functions ==
DoSearch(){

    WinTitle := "DaVinci Resolve by Blackmagic Design - 17.2.1"

    WinActivate, % WinTitle
    
    Dots := ImageSearchAll("dot.png", 0, 0, "Screen", "Screen", 6)

    SortResults(Dots)

    for Each, Dot in Dots {
        WinActivate, % WinTitle
        MouseMove, Dot.x + 1, Dot.y + 8
        MsgBox,, Result %A_Index%, Cursor is pointing at dot #%A_Index%.`n`nClick 'OK' or press 'Enter' for next dot.
    }
}

SortResults(coords) {
	loop {
		swapped := 0
		loop, % coords.MaxIndex() - 1
			if (coords[A_Index].x > coords[A_Index + 1].x) {
				coords.InsertAt(A_Index, coords[A_Index + 1])
				coords.RemoveAt(A_Index + 2)
				swapped := 1
			}
	} until !swapped
}

ImageSearchAll(imageFile, x1 := 0, y1 := 0, x2 := "Screen", y2 := "Screen", var := 0) {
	; found coordinates are returned as a simple array of coordinate pairs
	; each coordinate pair is an associative array with keys "x" and "y"


	x2 := x2 = "Screen" ? A_ScreenWidth : x2
	y2 := y2 = "Screen" ? A_ScreenHeight : y2
	found := []
	y := y1
	loop {
		x := x1
		loop {
 			ImageSearch, foundX, foundY, x, y, x2, y2, % "*" var " " imageFile
			if (ErrorLevel = 2)
				return -1
			if !ErrorLevel {
                msgbox found
				found.Push({x: foundX, y: foundY})
				x := foundX + 1
				lastFoundY := foundY
			}
		} until ErrorLevel
		Y := lastFoundY + 1
	} until (x = x1) && ErrorLevel
	return found
}
