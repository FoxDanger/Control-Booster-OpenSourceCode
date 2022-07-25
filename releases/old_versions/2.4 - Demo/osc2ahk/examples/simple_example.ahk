#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%  ; Until here, this is the default script template
; Get handle to this running script instance
Gui +LastFound
hWnd := WinExist()

; just for convenience, you also could use the "magic numbers" directly
global oscTypeNone := 1
global oscTypeInt := 2
global oscTypeFloat := 4
global oscTypeString := 8
global oscTypeAll := 0xffffffff

; Load DLL and open network port for OSC (7001)
DllCall("LoadLibrary", "Str", "OSC2AHK.dll", "Ptr")
DllCall("OSC2AHK.dll\open", UInt, hWnd, UInt, 7001)

; Tell the DLL to post a system message with ID 0x1001 when a OSC message with address "/test1" and type Integer or Float is received.
DllCall("OSC2AHK.dll\addListener", AStr, "/test1", UInt, 0x1001, UInt, oscTypeInt+oscTypeFloat)
; Tell AHK to invoke the function msghandlerTest1 when a windows message with ID 0x1001 is received
OnMessage(0x1001, "msghandlerTest1")

; This function effectively is called for each OSC message as specified above
msghandlerTest1(oscType, data, msgID, hwnd) 
{
    ; Check which datatype we received (above we accepted Float and Int)
    if (oscType = oscTypeInt) 
    {
        ; Integers can be used "as is"
        msgbox,Got Integer: %data%
    }
    if (oscType = oscTypeFloat) 
    {
        ; Floats have to be "reinterpreted"
        VarSetCapacity(buf, 4, 0)
        NumPut(data, buf)
        theFloat := NumGet(buf, "Float")

        msgbox,Got Float: %theFloat%
    }
}

; Shutdown the script with Shift+ESC
+Esc::
ExitApp
