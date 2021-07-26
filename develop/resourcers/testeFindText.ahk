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

global _dotsArray := []
global _customCurvesDotCounter := 1

;Start Global Mouse Position Variable
;_setGlobalMousePos()

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

#Include <FindText>


F9::
    _searchAllCurveDots("Y")
return

F10::
    _searchAllCurveDots("R")
return

F11::
    _searchAllCurveDots("G")
return

F12::
    _searchAllCurveDots("B")
return

F7::
    _getNextDot()
Return



; == Functions ==
;Do a search looking for all dots on Custom Curves Panel
_searchAllCurveDots(){
    t1:=A_TickCount, X:=Y:=""

    if (_actualCustomCurvesMode == "ALL" or _actualCustomCurvesMode == "Y"){
        allDots := "|<>0xD9D4D4@1.00$18.0000000z03zk7zs7zsDzwDzwDzwDzwDzwDzw7zs7zs3zk0z0000000U"
    }Else if(_actualCustomCurvesMode == "R"){
        allDots := "|<>0xD0021B@1.00$16.0007s1zsDzkzz7zyTztzzbzyTztzzXzwDzkTy0TU002"
    }Else if(_actualCustomCurvesMode == "G"){
        allDots := "|<>0x0EC218@1.00$16.0007s1zsDzkzz7zyTztzzbzyTztzzXzwDzkTy0TU002"
    }Else if(_actualCustomCurvesMode == "B"){
        allDots := "|<>0x003CFF@1.00$16.0007s1zsDzkzz7zyTztzzbzyTztzzXzwDzkTy0TU002"
    }
    
    _customCurvesDotsArray := FindText(1450, 1500, 2400, 2050, 0, 0, allDots)
    
    selectedDot := "|<>0x28282E@1.00$12.007sDwTyTyTyTyTyTyDw7s00U"
    
    tempArray := FindText(1450, 1500, 2400, 2050, 0, 0, selectedDot)
    
    if (tempArray.Length() != 0){
        _customCurvesDotsArray.push(tempArray[1])
    }
    
    _customCurvesDotCounter := 1

    for i,v in _customCurvesDotsArray
    FindText.MouseTip(_customCurvesDotsArray[i].x, _customCurvesDotsArray[i].y)
}

;Get the next dot on Custom Curves Panel
_getNextDot(){
    lenght := _customCurvesDotsArray.Length()
    
    MouseClick Left, _customCurvesDotsArray[_customCurvesDotCounter].x, _customCurvesDotsArray[_customCurvesDotCounter].y, 1, 0
    
    if (_customCurvesDotCounter < lenght){
        _customCurvesDotCounter++
    }Else{
        _customCurvesDotCounter := 1
    }
}

;Remove the actual selected dot on Custom Curves
_removeSelectedDot(){
    MouseGetPos mousePosX, mousePosY
    MouseClick Right, mousePoX, mousePosY, 1, 0
}