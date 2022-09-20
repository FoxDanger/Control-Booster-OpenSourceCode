;TWB Auto Position Generator
;A software to generator object_positions.ini for TWB 2
;Developer: André Rodrigues - Media Environment
;Website: https://souandrerodrigues.com.br/twb
;Contact: twb@souandrerodrigues.com.br
;Version: 0.1

;CAPTURAR
;HDR 3 dots MENU

;------------------------------------------------------------------------------------------ Software Code Start -------------------------------------------------------------------------------------------------------

; \/ AHK Setup \/

; #Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Gui +LastFound
hWnd := WinExist()
CoordMode, Mouse, Screen
#MaxMem 256

;Includes FindText class. This is a Third Party class that is used to find the dots on custom curves
;#Include <FindText>

#MaxHotkeysPerInterval, 200

; /\ End of AHK Setup /\

; \/ GLOBAL VARIABLES \/

;Set the type of Davinci Layout according the PC resolution - String - Can be: "NORMAL_LAYOUT" or "CONDENSED_LAYOUT"
Global _davinciLayout := "NORMAL_LAYOUT"

;Define if app is runnig or in stand by
Global _appRunning := true

;Set the active controllers, pages and panels
Global _globalMousePosX := 0
Global _globalMousePosY := 0

;Save ImageSearch Pixel
Global _imageSearchX := 0
Global _imageSearchY := 0

; Array with the positions X and Y of all elements on the Davinci Resolve UI
Global _positionsArray := []

;Set a counter for the Array Position
Global _arrayPos := 1

;Set a counter to know what tool is being seted
Global _actualTool := 1

;Set the string of the actual object position to configure
Global _actualObject := ""

;If is setting some variable became true so when you hit ENTER key will set the variable. If false, ENTER key will work normally
Global _isSetingVariable := False

;Disable ENTER Key when necessary
Global _disableEnterKey := False

; /\ END OF GLOBAL VARIABLES /\

; \/ START GUI INTERFACE \/

Menu, Tray, Icon, %A_ScriptDir%\images\TB Ready.ico

Gui Font, s9, Segoe UI
Gui Add, Picture, x8 y8 w150 h150, %A_ScriptDir%\images\Logo.png

Gui Show, w720 h640, TWB Auto Position Generator 0.1

; \/ SETUP DAVINCI TO START THE PROCCESS \/

; /\ END OF SETUP DAVINCI TO START THE PROCCESS /\

; \/ APP START \/


; /\ END APP START /\

Return

GuiClose:
    ExitApp

; /\ END OF GUI INTERFACE /\

;TEST KEY - Use this for test anything in the code
F9::
    ;MsgBox Test key pressed
Return

#If (_appRunning) ;Turn on and off all the other functions of the app, making it stop if you need. Shortcut to turn on/off is F8

; \/ FUNCTIONS \/

;===== LOAD AND SET FUNCTIONS =====


;===== END OF LOAD AND SET FUNCTIONS =====

;===== GENERAL FUNCTIONS =====

;Get the position X/Y of a accObject
_getAccPositions(address, windowID := "0x590632", child := "0"){
    coordmode,mouse,screen
    WinGet, hWnd, ID, A
    oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
    oRect := Acc_Location(oAcc, 0)

    object := []
    
    object.posX := oRect.x + Round((oRect.w/2))
    object.posY := oRect.y + Round((oRect.h/2))
    
    return object
}

;Get the position X/Y of the top left of an accObject
_getAccPositionsTopLeft(address, windowID := "0x590632", child := "0", sumX := 0, sumY := 0){
    coordmode,mouse,screen
    WinGet, hWnd, ID, A
    oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
    oRect := Acc_Location(oAcc, 0)

    object := []
    
    object.posX := oRect.x + sumX
    object.posY := oRect.y + sumY
    
    return object
}

_getAccPositionsBottomRight(address, windowID := "0x590632", child := "0", sumX := 0, sumY := 0){
    coordmode,mouse,screen
    WinGet, hWnd, ID, A
    oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
    oRect := Acc_Location(oAcc, 0)

    object := []
    
    object.posX := oRect.x + (oRect.w) + sumX
    object.posY := oRect.y + (oRect.h) + sumY
    
    return object
}

;Click on a accObject
_accClick(address, child := "0")
{
    coordmode,mouse,screen
    WinGet, hWnd, ID, A
    oAcc := Acc_Get("Object", address, child, "ahk_id " hWnd)
    oRect := Acc_Location(oAcc, 0)

    MouseClick Left, oRect.x + (oRect.w/2) , oRect.y + (oRect.h/2), 1, 0
}

;Reset Davinci UI Layout, reset all variables to default states and put Davinci on Full Screen Mode (IMPORTANT: You have to manually put Custom Curves Edit on LINKED mode after use this function) - Davinci Resolve NON-Default Shortcut: Ctrl + F1 (Reset UI Layout) and Ctrl + F2 (Full Screen Window)
ResetDefaultState(){
    FileCopy %A_ScriptDir%\default_ini_files\windows_status.ini, %A_ScriptDir%, 1

    Send ^{F1}
    Sleep 1000
    Send ^{F2}
    Sleep 1000
}

ChangePositionVariable(){
    MouseGetPos, mousePosX, mousePosY

    object := []

    _positionsArray.Push(object)

    _positionsArray[_arrayPos].var := _actualObject
    _positionsArray[_arrayPos].x := mousePosX
    _positionsArray[_arrayPos].y := mousePosY

    _arrayPos++
        
    _isSetingVariable := "false"
}

;Run the _positionsArray to find a expecific object and return it
GetObjectOnPositionsArray(objectName){
    For index, object in _positionsArray
    if (object.var == objectName) {
        Return object
    }
}

;Write in the INI file all the positions stored on the _positionsArray under the respective resolution
UpdateIniResScaleFile(resolutionScale) {
    For arrayNum, array in _positionsArray
        For index, varxy in ["var", "x", "y"]
        IniWrite, % array[varxy], %A_ScriptDir%\test.ini, %resolutionScale%, %resolutionScale% - %arrayNum%%varxy%
}

;Exit the app
FinishTWB(){
    ExitApp
}

;Shows the results of all position arrays
DisplayPositionsArray(header, array) {
	out := header "`n`n"
    
	for index, var in array
		out .= "x: " var.x "`ty: " var.y "`tvar: " var.var "`n"
	MsgBox, % out
}

MoveMouseToPosition(x,y){
    MouseMove, x, y, 1
}

;Move mouse and click on object
MouseClick(x,y){
    MouseClick Left, x, y, 1, 0
}

;===== END OF GENERAL FUNCTIONS =====

;===== KEYS FUNCTIONS =====

_getAccPositionsLastWindow(address, child := "0"){
    coordmode,mouse,screen
    WinGet, hWnd, ID, A
    oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
    oRect := Acc_Location(oAcc, 0)

    object := []
    
    object.posX := oRect.x + Round((oRect.w/2))
    object.posY := oRect.y + Round((oRect.h/2))
    
    return object
}

;ARRAY DEBUG KEYS
F5::
    accObject := _getAccPositions("4.2.2.1.1.2.1.1.1.1.1.2.4")
    varPosX := accObject.posX
    varPosY := accObject.posY
    
    ;TrayTip, "Position of the object is X: " %varPosX% " and Y: " %varPosY%, 10
    
    ;MoveMouseToPosition(varPosX,varPosY)
    MouseClick(varPosX,varPosY)

    Sleep 200
    
    accObject2 := _getAccPositions("4.3", "0x490910")
    
    var2PosX := accObject2.posX
    var2PosY := accObject2.posY
    
    MoveMouseToPosition(var2PosX,var2PosY)

    ;TrayTip, "Position of the object is X: " %var2PosX% " and Y: " %var2PosY%, 10
Return

F6::
    string := "0x100C32\4.1.1.1.1.2.2.2.2"

    ;LastDotPos := InStr(string,"\",0,0)  ; get position of last occurrence of "."
    result := SubStr(string,1,InStr(string,"\",0,0)-1)  ; get substring from start to last dot

    MsgBox %result%  ; display result
    
Return

F7::
    WinGet, active_id, ID, Resolve
;    WinMaximize, ahk_id %active_id%
    TrayTip, Tray, The active window's ID is "%active_id%".
Return

F8::
       
    WinGet, active_id, ID, A
   
    MsgBox %active_id%
   
    Sleep 100
Return

;===== END OF KEYS FUNCTIONS =====

; /\ END OF FUNCTIONS /\