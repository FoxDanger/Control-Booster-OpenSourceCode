; This example sends OSC messages on key presses and works together with the simple_example.ahk
; and string_example.ahk. The messages are sent back to this PC by using the loopback IP adress
; 127.0.0.1, but of course normal IP addresses can be used too.

#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%  ; Until here, this is the default script template
; Get handle to this running script instance
Gui +LastFound
hWnd := WinExist()

; Load DLL
DllCall("LoadLibrary", "Str", "OSC2AHK.dll", "Ptr")

; Send OSC message with integer payload with Shift+a
+a::
ip := "127.0.0.1" ; Note that this is the "loopback" IP, so this gets sent back to our PC
port := 7001
addr := "/test1"
data := 42
DllCall("OSC2AHK.dll\sendOscMessageInt", AStr, ip, UInt, port, AStr, addr, Int, data)
return

; Send OSC message with float payload with Shift+s
+s::
ip := "127.0.0.1" ; Note that this is the "loopback" IP, so this gets sent back to our PC
port := 7001
addr := "/test1"
data := 42.3
DllCall("OSC2AHK.dll\sendOscMessageFloat", AStr, ip, UInt, port, AStr, addr, Float, data)
return

; Send OSC message with string payload with Shift+d
+d::
ip := "127.0.0.1" ; Note that this is the "loopback" IP, so this gets sent back to our PC
port := 7001
addr := "/test1"
data := "Some string..."
DllCall("OSC2AHK.dll\sendOscMessageString", AStr, ip, UInt, port, AStr, addr, AStr, data)
return

; Shutdown the script with Shift+ESC
+Esc::
ExitApp
