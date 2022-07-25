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
global oscTypeAll := 0xffffffff

stdout := FileOpen("tmp.log", "w")
stdout.WriteLine("START")
OnExit("exithandler")

DllCall("LoadLibrary", "Str", "x64\Debug\OSC2AHK.dll", "Ptr")
; ret := DllCall("OSC2AHK.dll\testMsg", UInt,hWnd, UInt,0x1000, int)

OnMessage(0x1002, "msghandlerFloat")

success := DllCall("OSC2AHK.dll\open", UInt, hWnd, UInt, 7002)
    if (success != 0){
        msgbox, Failed to open port for OSC2AHK!    
    }Else{
        msgbox, OSC2AHK port open!
    }

DllCall("OSC2AHK.dll\addListener", AStr, "/test1", UInt, 0x1001, UInt, oscTypeInt)
OnMessage(0x1001, "msghandlerInt")

DllCall("OSC2AHK.dll\addListener", AStr, "/test2", UInt, 0x1002, UInt, oscTypeFloat)
OnMessage(0x1002, "msghandlerFloat")

DllCall("OSC2AHK.dll\addListener", AStr, "/test3", UInt, 0x1003, UInt, oscTypeInt+oscTypeFloat)
OnMessage(0x1003, "msghandlerTest3")

DllCall("OSC2AHK.dll\addListener", AStr, "/test4", UInt, 0x1004, UInt, oscTypeString)
OnMessage(0x1004, "msghandlerString")

stdout.Close()
return

msghandlerString(wParam, lParam, msg, hwnd) {
    stdout := FileOpen("tmp.log", "a")
    if (wParam = oscTypeInt) 
    {
        stdout.WriteLine("No String!")
        return
    }
    stdout.Write("msghandlerString: ")

    VarSetCapacity(theStr, 20)
    theStr := DllCall("OSC2AHK.dll\getStringData", str, theStr, UInt, 20, UInt, lParam, AStr)

    stdout.WriteLine(theStr)
    stdout.Close()
}

msghandlerTest3(wParam, lParam, msg, hwnd) {
    stdout := FileOpen("tmp.log", "a")
    stdout.Write("Got /test3 with ")
    if (wParam = oscTypeInt) 
    {
        stdout.Write("Int")
        stdout.Write(" ")
        stdout.WriteLine(lParam)
    }
    if (wParam = oscTypeFloat) 
    {
        stdout.Write("Float")
        stdout.Write(" ")
        ; Retrieve float from the lParam
        VarSetCapacity(buf, 8, 0)
        NumPut(lParam, buf)
        theFloat := NumGet(buf, "Float")
        stdout.WriteLine(theFloat)
    }
    stdout.Close()
}

msghandlerInt(wParam, lParam, msg, hwnd) {
    ; Check if we actually got a Integer
    if (wParam != 2)
        return

    ; Log to the logfile
    stdout := FileOpen("tmp.log", "a")
    stdout.Write("Got Int: ")
    stdout.Write(msg)
    stdout.Write(" ")
    stdout.WriteLine(lParam)
    stdout.Close()
}

msghandlerFloat(wParam, lParam, msg, hwnd) {
    ; Check if we actually got a float
    if (wParam != 4)
        return

    ; Retrieve float from the lParam
    VarSetCapacity(buf, 8, 0)
    NumPut(lParam, buf)
    theFloat := NumGet(buf, "Float")

    ; Log to the logfile
    stdout := FileOpen("tmp.log", "a")
    stdout.Write("Got Float: ")
    stdout.Write(msg)
    stdout.Write(" ")
    stdout.WriteLine(theFloat)
    stdout.Close()
}

exithandler() {
    stdout := FileOpen("tmp.log", "a")
    stdout.WriteLine("The End")
    stdout.Close()
}

do_exit:
    ExitApp
    return

Esc::
ExitApp

^a::
VarSetCapacity(theStr, 10)
theStr := DllCall("OSC2AHK.dll\getStringData", AStr, theStr, UInt, 10, UInt, 0, "Cdecl AStr")
msgbox,%theStr%
; DllCall("OSC2AHK.dll\close", UInt, 0)
;msgbox,esc
; DllCall("OSC2AHK.dll\open", UInt, hWnd, UInt, 7001)