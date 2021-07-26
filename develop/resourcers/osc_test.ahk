#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
Gui +LastFound
hWnd := WinExist()

; OSC datatypes. Just for better readability,
; you also just could use the numbers
global oscTypeNone := 1
global oscTypeInt := 2
global oscTypeFloat := 4
global oscTypeString := 8

DllCall("LoadLibrary", "Str", "x64\Debug\OSC2AHK.dll", "Ptr")
;DllCall("OSC2AHK.dll\open", UInt, hWnd, UInt, 7002)

success := DllCall("OSC2AHK.dll\open", UInt, hWnd, UInt, 7002)
if (success != 0){
    msgbox, Failed to open port for OSC2AHK!    
}Else{
    msgbox, OSC2AHK port open!
}

DllCall("OSC2AHK.dll\addListener", AStr, "/test1", UInt, 0x1001, UInt, oscTypeInt)
OnMessage(0x1001, "msghandlerTest1")

DllCall("OSC2AHK.dll\addListener", AStr, "/test2", UInt, 0x1002, UInt, oscTypeString)
OnMessage(0x1002, "msghandlerTest2")

DllCall("OSC2AHK.dll\addListener", AStr, "/test3", UInt, 0x1003, UInt, oscTypeFloat)
OnMessage(0x1003, "msghandlerTest3")

global teste := 0

msghandlerTest1(oscType, data, msgID, hwnd){
    if(oscType == oscTypeInt){
        msgbox int
        msgbox %data%
        
        ;teste := teste+1
    }
}

msghandlerTest2(oscType, data, msgID, hwnd){
    if(oscType == oscTypeString){
        ;msgbox string
        ;msgbox %data%
        msgbox %teste%
    }
}

msghandlerTest3(oscType, data, msgID, hwnd){
    if(oscType == oscTypeFloat){
        msgbox Float
        msgbox %data%
    }
}

+Esc::
ExitApp