;Davinci Resolve Tangent Wave Booster
;A software that will give to your Tangent Wave incredible powers with Davinci Resolve
;Developer: André Rodrigues - Media Environment
;Contact: contato@mediaenvironment.com.br
;Version: 2.0 Beta
;Updates of this version:
;All new code from the scratch
;TODO: Make all the tools change panels automatically (this will free up some shortcuts)
;TODO: If we have some spare shortcuts, its possible to use them to transfer Curves VS from buttons to knobs (output on know left/right and input on alternative know left/right)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxHotkeysPerInterval, 200

; == Global Variables - The seted values are the default ones and shouldn't be changed ==

;Define if app was started by the start button
global _appStarted := "false"

;Global timers and speeds ==
global _releaseTimeWheels := -700
global _releaseTimeKnobs := -200

;Set the active controllers, pages and panels ==
global _globalMousePosX := 0
global _globalMousePosY := 0

;Save ImageSearch Pixel ==
global _imageSearchX := 0
global _imageSearchY := 0

;Start Global Mouse Position Variable
_setGlobalMousePos()

; == Start/Draw GUI == 

;Add the start controller button
Gui Add, Button, x10 y10 w1110 h30 gStartButton, Start DR Tangent Wave Booster

Gui Show, w1130 h1020, Tangent Wave Booster Ver. 1.3 Beta
return
GuiEscape:
GuiClose:
    ExitApp
    
F8::
StartButton:
    if (tog := !tog){
        GuiControl,,Start DR Tangent Wave Booster,Stop DR Tangent Wave Booster
        _appStarted := "true"
    }Else{
        GuiControl,,Stop DR Tangent Wave Booster,Start DR Tangent Wave Booster
        _appStarted := "false"
    }
return

#If (_appStarted == "true") ;Turn on and off the app

F12::
;array := ImageSearchAll(1450, 1550, 2400, 2050)

_searchTool()

;For index, object in array{
    ;objectX := array[index].x
    ;objectY := array[index].y
    ;
    ;MsgBox A coordenada do objeto %index% é: X = %objectX% - Y = %objectY%
;}
return

; == Functions ==

;Set Global Mouse Pos
_setGlobalMousePos(){
    MouseGetPos, mousePosX, mousePosY
    _globalMousePosX := mousePosX
    _globalMousePosY := mousePosY
}

;Search for a tool (base on a image)
_searchTool(){
;    CoordMode Pixel  ; Interprets the coordinates below as relative to the screen rather than the active window.
    ImageSearch, _imageSearchX, _imageSearchY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\images\teste.png
    if (ErrorLevel = 2)
        MsgBox Could not conduct the search.
    else if (ErrorLevel = 1)
        MsgBox Icon could not be found on the screen.
    else
;        MsgBox The icon was found at %_imageSearchX%x%_imageSearchY%.
        MouseMove _imageSearchX + 30, _imageSearchY + 30
}

_searchPixel(){
    PixelSearch, posX, posY, 1465, 1530, 2360, 2030, 000000
    if (ErrorLevel = 2)
        MsgBox Could not conduct the search.
    else if (ErrorLevel = 1)
        MsgBox Icon could not be found on the screen.
    else
;        MsgBox The icon was found at %_imageSearchX%x%_imageSearchY%.
        MouseMove posX + 5, posY + 5
}

ImageSearchAll(x1 := 0, y1 := 0, x2 := "Screen", y2 := "Screen")
{
	; found coordinates are returned as a simple array of coordinate pairs
	; each coordinate pair is an associative array with keys "x" and "y"

	x2 := x2 = "Screen" ? A_ScreenWidth : x2
	y2 := y2 = "Screen" ? A_ScreenHeight : y2
	found := []
	y := y1
	loop {
		x := x1
		loop {
			ImageSearch, foundX, foundY, x, y, x2, y2, %A_ScriptDir%\images\Curves Dot.png
			if (ErrorLevel = 2)
				return -1
                msgbox errorAqui
			if !ErrorLevel {
				found.Push({x: foundX, y: foundY})
				x := foundX + 1
				lastFoundY := foundY
			}
		} until ErrorLevel
		Y := lastFoundY + 1
	} until (x = x1) && ErrorLevel
	return found
}
