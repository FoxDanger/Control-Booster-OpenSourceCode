#Persistent
#SingleInstance, force
SetTitleMatchMode, 2
SendMode Input              	; Recommended for new scripts due to its superior speed and reliability.
#InstallKeybdHook
#MaxHotkeysPerInterval 15000
#InstallMouseHook
Process, Priority,, High
SetWorkingDir %A_ScriptDir% 	; Ensures a consistent starting directory.
SoundBeep, 1600
DetectHiddenWindows, On
#INCLUDE %A_ScriptDir%\Anchor.ahk
#INCLUDE %A_ScriptDir%\Acc.ahk



#IfWinActive ahk_exe Resolve.exe


; ===============
  version = MIDI_ColorPanel ; Change this title to suit you,  will generate .ini file with port selection
; ===============
readini()					; load midi port from .ini file
gosub, MidiPortRefresh        ; used to refresh the input and output port lists - see label below
port_test(numports)   		; test the ports - check for valid ports?
gosub, midiin_go              ; opens the midi input port listening routine
gosub, midiMon           	; see below - a midi monitor gui - for learning mostly - comment this line eventually.



;*************************************************
;*      MIDI INPUT DETECTION
;              PARSE FUNCTION
;*************************************************
MidiMsgDetect(hInput, midiMsg, wMsg)


;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓ XTouch MINI ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

{
	global statusbyte, chan, note, cc, data1, data2, stb ; !!!! Make these vars global to be used in other functions
	; Extract Vars by extracting from midi message
	statusbyte  	:=  midiMsg & 0xFF          ; Extract statusbyte = what type of midi message and what midi channel
	chan        	:= (statusbyte & 0x0f) + 1  ; WHAT MIDI CHANNEL IS THE MESSAGE ON? EXTRACT FROM STATUSBYTE
	data1         	:= (midiMsg >> 8) & 0xFF    ; THIS IS DATA1 VALUE = NOTE NUMBER OR CC NUMBER
	data2         	:= (midiMsg >> 16) & 0xFF   ; DATA2 VALUE IS NOTE VELEOCITY OR CC VALUE
	pitchb        	:= (data2 << 7) | data1     ; (midiMsg >> 8) & 0x7F7F  masking to extract the pitchbends

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
	if statusbyte between 176 and 191   ; Is message a CC
		stb := "CC"                     ; if so then set stb to CC - only used with the midi monitor

	if (chan=11 and data1=9 and data2=1)
		{
		SoundSet, 0
		}
	if (chan=11 and data1=9 and data2=7)
		{
		SoundSet, 5
		}
	if (chan=11 and data1=9 and data2=13)
		{
		SoundSet, 10
		}
	if (chan=11 and data1=9 and data2=20)
		{
		SoundSet, 15
		}
	if (chan=11 and data1=9 and data2=26)
		{
		SoundSet, 20
		}
	if (chan=11 and data1=9 and data2=32)
		{
		SoundSet, 25
		}
	if (chan=11 and data1=9 and data2=38)
		{
		SoundSet, 30
		}
	if (chan=11 and data1=9 and data2=45)
		{
		SoundSet, 35
		}
	if (chan=11 and data1=9 and data2=50)
		{
		SoundSet, 40
		}
	if (chan=11 and data1=9 and data2=57)
		{
		SoundSet, 45
		}
	if (chan=11 and data1=9 and data2=64)
		{
		SoundSet, 50
		}
	if (chan=11 and data1=9 and data2=70)
		{
		SoundSet, 55
		}
	if (chan=11 and data1=9 and data2=77)
		{
		SoundSet, 60
		}
	if (chan=11 and data1=9 and data2=83)
		{
		SoundSet, 65
		}
	if (chan=11 and data1=9 and data2=89)
		{
		SoundSet, 70
		}
	if (chan=11 and data1=9 and data2=95)
		{
		SoundSet, 75
		}
	if (chan=11 and data1=9 and data2=102)
		{
		SoundSet, 80
		}
	if (chan=11 and data1=9 and data2=108)
		{
		SoundSet, 85
		}
	if (chan=11 and data1=9 and data2=114)
		{
		SoundSet, 90
		}
	if (chan=11 and data1=9 and data2=120)
		{
		SoundSet, 95
		}
	if (chan=11 and data1=9 and data2=127)
		{
		SoundSet, 100
		}








if (chan=11 and data1=10 and data2=0)
		{
		SoundSet, 0
		}
	if (chan=11 and data1=10 and data2=3)
		{
		SoundSet, 2.5
		}
	if (chan=11 and data1=10 and data2=6)
		{
		SoundSet, 5
		}
	if (chan=11 and data1=10 and data2=9)
		{
		SoundSet, 7.5
		}
	if (chan=11 and data1=10 and data2=12)
		{
		SoundSet, 10
		}
	if (chan=11 and data1=10 and data2=15)
		{
		SoundSet, 12.5
		}
	if (chan=11 and data1=10 and data2=19)
		{
		SoundSet, 15
		}
	if (chan=11 and data1=10 and data2=22)
		{
		SoundSet, 17.5
		}
	if (chan=11 and data1=10 and data2=25)
		{
		SoundSet, 20
		}
	if (chan=11 and data1=10 and data2=28)
		{
		SoundSet, 22.5
		}
	if (chan=11 and data1=10 and data2=32)
		{
		SoundSet, 25
		}
	if (chan=11 and data1=10 and data2=35)
		{
		SoundSet, 27.5
		}
	if (chan=11 and data1=10 and data2=38)
		{
		SoundSet, 30
		}
	if (chan=11 and data1=10 and data2=41)
		{
		SoundSet, 32.5
		}
	if (chan=11 and data1=10 and data2=44)
		{
		SoundSet, 35
		}
	if (chan=11 and data1=10 and data2=47)
		{
		SoundSet, 37.5
		}
	if (chan=11 and data1=10 and data2=50)
		{
		SoundSet, 40
		}
	if (chan=11 and data1=10 and data2=54)
		{
		SoundSet, 42.5
		}
	if (chan=11 and data1=10 and data2=57)
		{
		SoundSet, 45
		}
	if (chan=11 and data1=10 and data2=60)
		{
		SoundSet, 47.5
		}
	if (chan=11 and data1=10 and data2=64)
		{
		SoundSet, 50
		}
	if (chan=11 and data1=10 and data2=67)
		{
		SoundSet, 52.5
		}
	if (chan=11 and data1=10 and data2=70)
		{
		SoundSet, 55
		}
	if (chan=11 and data1=10 and data2=73)
		{
		SoundSet, 57.5
		}
	if (chan=11 and data1=10 and data2=76)
		{
		SoundSet, 60
		}
	if (chan=11 and data1=10 and data2=79)
		{
		SoundSet, 62.5
		}
	if (chan=11 and data1=10 and data2=83)
		{
		SoundSet, 65
		}
	if (chan=11 and data1=10 and data2=86)
		{
		SoundSet, 67.5
		}
	if (chan=11 and data1=10 and data2=89)
		{
		SoundSet, 70
		}
	if (chan=11 and data1=10 and data2=92)
		{
		SoundSet, 72.5
		}
	if (chan=11 and data1=10 and data2=95)
		{
		SoundSet, 75
		}
	if (chan=11 and data1=10 and data2=98)
		{
		SoundSet, 77.5
		}
	if (chan=11 and data1=10 and data2=102)
		{
		SoundSet, 80
		}
	if (chan=11 and data1=10 and data2=105)
		{
		SoundSet, 82.5
		}
	if (chan=11 and data1=10 and data2=108)
		{
		SoundSet, 85
		}
	if (chan=11 and data1=10 and data2=111)
		{
		SoundSet, 87.5
		}
	if (chan=11 and data1=10 and data2=114)
		{
		SoundSet, 90
		}
	if (chan=11 and data1=10 and data2=118)
		{
		SoundSet, 92.5
		}
	if (chan=11 and data1=10 and data2=120)
		{
		SoundSet, 95
		}
	if (chan=11 and data1=10 and data2=123)
		{
		SoundSet, 97.5
		}
	if (chan=11 and data1=10 and data2=127)
		{
		SoundSet, 100
		}


;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓LAYER A ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

    if (data1=11 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

        }

	if (data1=11 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=12 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}


	if (data1=12 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=13 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=13 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=14 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=14 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}


    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=15 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=15 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=24 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
        {

		}

	if (data1=24 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
        {

		}


    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=25 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=25 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=26 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=26 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓ LAYER B ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=1 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=1 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=2 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=2 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=3 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{
		#Persistent
		If !play20
		MouseGetPos, x, y
		SendEvent, {LButton down}
		play20 := True
		MouseMove, 10, 0,, R
		SetTimer, Stop20, -00
		Sleep, 50
		Return

		Stop20:
		play20 := False
		SendEvent, {LButton up}
		MouseMove, x, y
		Return
		}

	if (data1=3 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{
		#Persistent
		If !play21
		MouseGetPos, x, y
		SendEvent, {LButton down}
		play21 := True
		MouseMove, -10, 0,, R
		SetTimer, Stop21, -500
		Sleep, 50
		Return

		Stop21:
		play21 := False
		SendEvent, {LButton up}
		MouseMove, x, y
		Return
		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=4 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{
		#Persistent
		If !play22
		MouseGetPos, x, y
		SendEvent, {LButton down}
		play22 := True
		MouseMove, 0, 10,, R
		SetTimer, Stop22, -500
		Return

		Stop22:
		play22 := False
		SendEvent, {LButton Up}
		MouseMove, x, y
		Return
		}

	if (data1=4 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{
		#Persistent
		If !play23
		MouseGetPos, x, y
		SendEvent, {LButton down}
		play23 := True
		MouseMove, 0, -10,, R
		SetTimer, Stop23, -500
		Return

		Stop23:
		play23 := False
		SendEvent, {LButton up}
		MouseMove, x, y
		Return
		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=5 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=5 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=6 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=6 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=7 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=7 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=8 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) )
		{

		}

	if (data1=8 and (data2=56 or data2=57 or data2=58 or data2=59 or data2=60 or data2=61 or data2=62 or data2=63) )
		{

		}

;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓



;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓  MC MODE ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=16 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=16 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=17 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=17 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=18 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=18 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=19 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=19 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=20 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=20 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=21 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=21 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=22 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=22 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}

    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (data1=23 and (data2=1 or data2=2 or data2=3 or data2=4 or data2=5 or data2=6 or data2=7 or data2=8) ) ;CW
		{

		}


    if (data1=23 and (data2=65 or data2=66 or data2=67 or data2=68 or data2=69 or data2=70 or data2=71 or data2=72) ) ;CCW
		{

		}



    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
	if statusbyte between 144 and 159  ; Is message a Note On,  if yes do below

		stb := "NoteOn"               ; Set gui var !!! no edit this line

	if (chan=1 and data1=0 and data2=127 ) ;Temperature
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.1.1.2.1.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		SystemCursor(False)
		MouseMove, % vCurX, % vCurY
		SystemCursor(True)
		return
		}

	if (chan=1 and data1=1 and data2=127 ) ; Tint
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.1.1.2.2.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=2 and data2=127 ) ;Contrast
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.1.1.2.3.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=3 and data2=127 ) ;Pivot
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.1.1.2.4.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=4 and data2=127 ) ; LIFT
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.2.1.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=5 and data2=127 ) ;Gamma
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.2.2.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=6 and data2=127 ) ;Gain
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.2.3.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=7 and data2=127 ) ; OFFSET
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.2.4.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=8 and data2=127 ) ; Lift Master wheel
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.2.1.3.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=9 and data2=127 ) ; Gamma Master Wheel
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.2.2.3.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=10 and data2=127 ) ; Gain Master Wheel
		{
		WinGet, hWnd, ID, A
		oAcc := Acc_Get("Object", "4.2.2.1.1.2.3.2.1.1.1.1.1.1.1.2.1.1.2.3.3.2", 0, "ahk_id " hWnd)
		oRect := Acc_Location(oAcc)
		CoordMode, Mouse, Screen
		vCurX := oRect.x + oRect.w/2
		vCurY := oRect.y + oRect.h/2
		oAcc := oRect := ""
		MouseMove, % vCurX, % vCurY, 2
		return
		}

	if (chan=1 and data1=11 and data2=127 )
		{

		}

	if (chan=1 and data1=12 and data2=127 )
		{

		}

	if (chan=1 and data1=13 and data2=127 )
		{

		}

	if (chan=1 and data1=14 and data2=127 )
		{

		}

	if (chan=1 and data1=15 and data2=127 )
		{

		}

	if (chan=1 and data1=16 and data2=127 )
		{

		}

	if (chan=1 and data1=17 and data2=127 )
		{

		}





	if (chan=11 and data1=24 )
		{

		}

	if (chan=11 and data1=25)     ;and data2=127) Add if velocity is specific
		{

		}

	if (chan=11 and data1=26)     ;and data2=127) Add if velocity is specific
		{

		}

    if (chan=11 and data1=27)     ;and data2=127) Add if velocity is specific
        {
        }

    if (chan=11 and data1=28)     ;and data2=127) Add if velocity is specific
        {
        }

    if (chan=11 and data1=29)     ;and data2=127) Add if velocity is specific
        {
        }

    if (chan=11 and data1=30)     ;and data2=127) Add if velocity is specific
        {

        }

    if (chan=11 and data1=31)     ;and data2=127) Add if velocity is specific
        {

        }


;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if (chan=11 and data1=32)			; THIS is the item to edit,  put your note number here,  in place of 42
		{

		}


	if (chan=11 and data1=33)
		{

		}


	if (chan=11 and data1=34)
		{

		}


	if (chan=11 and data1=35)
		{

		}


	if (chan=11 and data1=36)
		{

		}

	if (chan=11 and data1=37)     ;and data2=127) Add if velocity is specific
        {

        }

   if (chan=11 and data1=38 and data2=127)     ;and data2=127) Add if velocity is specific
        {


        }

	if (chan=11 and data1=39)     ;and data2=127) Add if velocity is specific
		{

		}


    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


	if (chan=11 and data1=40 and data2=127)
		{

		}


	if (chan=11 and data1=41 and data2=127)
		{

		}

	if (chan=11 and data1=42 and data2=127)
		{

		}



	if (chan=11 and data1=43 and data2=127)
		{

		}


	if (chan=11 and data1=44 and data2=127)
		{

		}

	if (chan=11 and data1=45 and data2=127)
		{

		}

	if (chan=11 and data1=46 and data2=127)
		{

		}



	if (chan=11 and data1=47)
		{
		; USED AS MODE SWITCHER IN BOME MIDI PRO
		}


    ;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if statusbyte between 128 and 143  ; Is message a Note Off?
		stb := "NoteOff"                           ; set gui to NoteOff

	if (chan=11 and data1=40 and data2=0)
		{

		}

		if (chan=2 and data1=41 and data2=0)
		{

		}

		if (chan=2 and data1=42 and data2=0)
		{

		}

		if (chan=1 and data1=43 and data2=0)
		{

		}

		if (chan=2 and data1=44 and data2=0)
		{

		}

		if (chan=2 and data1=45 and data2=0)
		{

		}

		if (chan=2 and data1=46 and data2=0)
		{

		}

		if (chan=2 and data1=47 and data2=0)
		{

		}


;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	if statusbyte between 192 and 208  ;Program Change
		stb := "PC"


	if statusbyte between 224 and 254  ; Is message a Pitch Bend

		return


	MidiInDisplay(stb, statusbyte, chan, data1, data2) ; midi display function called when message received

} ; end of MidiMsgDetect funciton

Return

;~ -------------------------------------------------------------------------------------------------
;~ ---------------------------------------       End        ----------------------------------------
;~ --------------------------------------- autoexec section ----------------------------------------
;~ -------------------------------------------------------------------------------------------------


;*************************************************
;*    SHOW MIDI INPUT ON GUI MONITOR !!! nothing to edit
;*************************************************

MidiInDisplay(stb, statusbyte, chan, data1, data2) ; update the midimonitor gui
{
Gui,3:default
Gui,3:ListView, In1 					; see the first listview midi in monitor
  LV_Add("",stb,statusbyte,chan,data1,data2)
  LV_ModifyCol(1,"center")
  LV_ModifyCol(2,"center")
  LV_ModifyCol(3,"center")
  LV_ModifyCol(4,"center")
  LV_ModifyCol(5,"center")
  If (LV_GetCount() > 10)
    {
      LV_Delete(1)
    }
}
return


;*************************************************
;*      MIDI MONITOR GUI CODE - creates the monitor window !!!! nothing to edit
;*************************************************

midiMon: ; midi monitor gui with listviews
gui,3:destroy
gui,3:default
Gui,3:Add, ListView, x5 r11 w220 Backgroundblack cyellow Count10 vIn1,  EventType|StatB|Ch|data1|data2|
gui,3:Show, autosize xcenter y5, MidiMonitor
Gui, Minimize
Return


MidiPortRefresh: 				; get the list of ports !!!! nothing to edit here

MIlist := MidiInsList(NumPorts)
Loop Parse, MIlist, |
{
}
TheChoice := MidiInDevice + 1
return

;-----------------------------------------------------------------

ReadIni() ; also set up the tray Menu !!!! Nothing to edit here
{
	Menu, tray, add, MidiSet            ; set midi ports tray item
	Menu, tray, add, ResetAll           ; Delete the ini file for testing --------------------------------

	global MidiInDevice, version ; version var is set at the beginning.
	IfExist, %version%.ini
	{
		IniRead, MidiInDevice, %version%.ini, Settings, MidiInDevice , %MidiInDevice%     ; read the midi In port from ini file
	}
	Else ; no ini exists and this is either the first run or reset settings.
	{
		MsgBox, 1, No ini file found, Select midi ports?
		IfMsgBox, Cancel
			ExitApp
		IfMsgBox, yes
			gosub, midiset
	}
}

;CALLED TO UPDATE INI WHENEVER SAVED PARAMETERS CHANGE - !!!! nothing to edit here
WriteIni()
{
	global MidiInDevice, version 		; global vars needed

	IfNotExist, %version%.ini 		; does .ini file exist?
		FileAppend,, %version%.ini 	; make one with name of the .ahk file and the following entries.
	IniWrite, %MidiInDevice%, %version%.ini, Settings, MidiInDevice
}

;------------ port testing to make sure selected midi port is valid --------------------------------

port_test(numports) ; confirm selected ports exist - !!!!! nothing to edit here

{
	global midiInDevice, midiok ;midiOutDevice

	; ----- In port selection test based on numports
	If MidiInDevice not Between 0 and %numports%
		{
			MidiIn := 0 ; this var is just to show if there is an error - set if the ports are valid = 1, invalid = 0
			;MsgBox, 0, , midi in port Error ; (this is left only for testing)
			If (MidiInDevice = "")              ; if there is no midi in device
				MidiInerr = Midi In Port EMPTY. ; set this var = error message
			;MsgBox, 0, , midi in port EMPTY
			If (midiInDevice > %numports%)          ; if greater than the number of ports on the system.
				MidiInnerr = Midi In Port Invalid.  ; set this error message
			;MsgBox, 0, , midi in port out of range
		}
	Else
		{
			MidiIn := 1 ; setting var to non-error state or valid
		}

	If (%MidiIn% = 0)
	{
		MsgBox, 49, Midi Port Error!,%MidiInerr%`nLaunch Midi Port Selection!
		IfMsgBox, Cancel
			ExitApp
		midiok = 0 ; Not sure if this is really needed now....
		Gosub, MidiSet ;Gui, show Midi Port Selection
	}
	Else
	{
		midiok = 1
		Return ; DO NOTHING - PERHAPS DO THE NOT TEST INSTEAD ABOVE.
	}
}
Return

; ------------------ end of port testing ---------------------------

MidiSet: ; midi port selection gui

; ------------- MIDI INPUT SELECTION -----------------------

Gui, 1: +LastFound +AlwaysOnTop   +Caption +ToolWindow ;-SysMenu
Gui, 1: Font, s12
Gui, 1: add, text, x10 y8 w200 cmaroon, Select Midi Input ; Text title
Gui, 1: Font, s9
Gui, 1: font, s9
Gui, 1: Add, ListBox, x10 w175 h100  Choose%TheChoice% vMidiInPort gDoneInChange AltSubmit, %MiList% ; --- midi in listing of ports

Gui, 1: add, Button, x10 w80 gSet_Done, Done - Reload
Gui, 1: add, Button, xp+80 w80 gCancel, Cancel
Gui, 1: show , , %version% Midi Input ; main window title and command to show it.

Return

;~ ------------------------------- methods to save midi port selection -----------------------------

DoneInChange:
Gui, 1: Submit, NoHide
Gui, 1: Flash
If %MidiInPort%
	UDPort:= MidiInPort - 1, MidiInDevice:= UDPort ; probably a much better way do this, I took this from JimF's qwmidi without out editing much.... it does work same with doneoutchange below.
GuiControl, 1:, UDPort, %MidiIndevice%
WriteIni()		; Write .ini file in same folder as ahk file
Return

Set_Done: 		; aka reload program, called from midi selection gui
Gui, 1: Destroy
sleep, 100
Reload
Return

Cancel:
Gui, Destroy
Gui, 2: Destroy
Return

ResetAll: 		; for development only, leaving this in for a program reset if needed by user
MsgBox, 33, %version% - Reset All?, This will delete ALL settings`, and restart this program!
IfMsgBox, OK
{
	FileDelete, %version%.ini   ; delete the ini file to reset ports, probably a better way to do this ...
	Reload                      ; restart the app.
}
IfMsgBox, Cancel
	Return

GuiClose: 		; on x exit app
Suspend, Permit 	; allow Exit to work Paused. I just added this yesterday 3.16.09 Can now quit when Paused.

MsgBox, 4, Exit %version%, Exit %version% %ver%? ;
IfMsgBox No
	Return
Else IfMsgBox Yes
Gui, 6: Destroy
Gui, 2: Destroy
Gui, 3: Destroy
Sleep 100

ExitApp


;~ -------------------------------------------------------------------------------------------------
;~ -----------------------        Original work by lots of ahk gurus        ------------------------
;~ ----------------------- DO NOT EDIT - unless you know what you are doing ------------------------
;~ -----------------------                                                  ------------------------
;~ -------------------------------------------------------------------------------------------------

;############################################## MIDI LIB from orbik and lazslo#############
;-------- orbiks midi input code --------------
; Set up midi input and callback_window based on the ini file above.
; This code copied from ahk forum Orbik's post on midi input

; nothing below here to edit. !!!!!!!!!!!!
; =============== midi in =====================

Midiin_go:
DeviceID := MidiInDevice      ; midiindevice from IniRead above assigned to deviceid
CALLBACK_WINDOW := 0x10000    ; from orbiks code for midi input

Gui, +LastFound 	; set up the window for midi data to arrive.
hWnd := WinExist()	;MsgBox, 32, , line 176 - mcu-input  is := %MidiInDevice% , 3 ; this is just a test to show midi device selection

hMidiIn =
VarSetCapacity(hMidiIn, 4, 0)
result := DllCall("winmm.dll\midiInOpen", UInt,&hMidiIn, UInt,DeviceID, UInt,hWnd, UInt,0, UInt,CALLBACK_WINDOW, "UInt")
If result
	{
		MsgBox, Error, midiInOpen Returned %result%`n
		;GoSub, sub_exit
	}

hMidiIn := NumGet(hMidiIn) ; because midiInOpen writes the value in 32 bit binary Number, AHK stores it as a string
result := DllCall("winmm.dll\midiInStart", UInt,hMidiIn)
If result
	{
		MsgBox, Error, midiInStart Returned %result%`nRight Click on the Tray Icon - Left click on MidiSet to select valid midi_in port.
		;GoSub, sub_exit
	}

OpenCloseMidiAPI()

; ----- the OnMessage listeners ----

; #define MM_MIM_OPEN 0x3C1 /* MIDI input */
; #define MM_MIM_CLOSE 0x3C2
; #define MM_MIM_DATA 0x3C3
; #define MM_MIM_LONGDATA 0x3C4
; #define MM_MIM_ERROR 0x3C5
; #define MM_MIM_LONGERROR 0x3C6

OnMessage(0x3C1, "MidiMsgDetect")  ; calling the function MidiMsgDetect in get_midi_in.ahk
OnMessage(0x3C2, "MidiMsgDetect")
OnMessage(0x3C3, "MidiMsgDetect")
;OnMessage(0x3C4, "MidiMsgDetect")
;OnMessage(0x3C5, "MidiMsgDetect")
;OnMessage(0x3C6, "MidiMsgDetect")

Return

;*************************************************
;*          MIDI IN PORT HANDLING
;*************************************************

MidiInsList(ByRef NumPorts)                                             ; should work for unicode now...
  { ; Returns a "|"-separated list of midi output devices
	local List, MidiInCaps, PortName, result, midisize
	(A_IsUnicode)? offsetWordStr := 64: offsetWordStr := 32
	midisize := offsetWordStr + 18
	VarSetCapacity(MidiInCaps, midisize, 0)
	VarSetCapacity(PortName, offsetWordStr)                       ; PortNameSize 32

	NumPorts := DllCall("winmm.dll\midiInGetNumDevs") ; #midi output devices on system, First device ID = 0

	Loop %NumPorts%
      {
        result := DllCall("winmm.dll\midiInGetDevCaps", "UInt",A_Index-1, "Ptr",&MidiInCaps, "UInt",midisize)

        If (result OR ErrorLevel) {
            List .= "|-Error-"
            Continue
          }
    PortName := StrGet(&MidiInCaps + 8, offsetWordStr)
        List .= "|" PortName
      }
    Return SubStr(List,2)
  }

MidiInGetNumDevs() { ; Get number of midi output devices on system, first device has an ID of 0
    Return DllCall("winmm.dll\midiInGetNumDevs")
  }
MidiInNameGet(uDeviceID = 0) {                  ; Get name of a midiOut device for a given ID

;MIDIOUTCAPS struct
;    WORD      wMid;
;    WORD      wPid;
;    MMVERSION vDriverVersion;
;    CHAR      szPname[MAXPNAMELEN];
;    WORD      wTechnology;
;    WORD      wVoices;
;    WORD      wNotes;
;    WORD      wChannelMask;
;    DWORD     dwSupport;

    VarSetCapacity(MidiInCaps, 50, 0)               ; allows for szPname to be 32 bytes
    OffsettoPortName := 8, PortNameSize := 32
    result := DllCall("winmm.dll\midiInGetDevCapsA", UInt,uDeviceID, UInt,&MidiInCaps, UInt,50, UInt)

    If (result OR ErrorLevel) {
        MsgBox Error %result% (ErrorLevel = %ErrorLevel%) in retrieving the name of midi Input %uDeviceID%
        Return -1
      }

    VarSetCapacity(PortName, PortNameSize)
    DllCall("RtlMoveMemory", Str,PortName, Uint,&MidiInCaps+OffsettoPortName, Uint,PortNameSize)
    Return PortName
  }

MidiInsEnumerate() { ; Returns number of midi output devices, creates global array MidiOutPortName with their names
    local NumPorts, PortID
    MidiInPortName =
    NumPorts := MidiInGetNumDevs()

    Loop %NumPorts% {
        PortID := A_Index -1
        MidiInPortName%PortID% := MidiInNameGet(PortID)
      }
    Return NumPorts
  }


OpenCloseMidiAPI() {  ; at the beginning to load, at the end to unload winmm.dll
	static hModule
	If hModule
		DllCall("FreeLibrary", UInt,hModule), hModule := ""
	If (0 = hModule := DllCall("LoadLibrary",Str,"winmm.dll")) {
		MsgBox Cannot load libray winmm.dll
		Exit
	}
}


;▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

SystemCursor(OnOff := 1) {  ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
 ; https://www.autohotkey.com/boards/viewtopic.php?t=6167
 Static AndMask, XorMask, $, h_cursor
  , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; Blank cursors
  , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; Handles of default cursors
  , c := StrSplit("32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650", ",")
 If (OnOff = "Init" || OnOff = "I" || $ = "") {  ; Init when requested or at first call
  $ = h                                          ; Active default cursors
  VarSetCapacity(h_cursor,4444, 1), VarSetCapacity(AndMask, 32*4, 0xFF), VarSetCapacity(XorMask, 32*4, 0)
  For each, cursor in c {
   h_cursor := DllCall("LoadCursor", "Ptr",0, "Ptr", cursor)
   h%each%  := DllCall("CopyImage", "Ptr", h_cursor, "UInt", 2, "Int", 0, "Int", 0, "UInt", 0)
   b%each%  := DllCall("CreateCursor", "Ptr", 0, "Int", 0, "Int", 0
                     , "Int", 32, "Int", 32, "Ptr", &AndMask, "Ptr", &XorMask)
  }
 }
 $ := OnOff = 0 || OnOff = "Off" || $ = "h" && (OnOff < 0 || OnOff = "Toggle" || OnOff = "T") ? "b" : "h"
 For each, cursor in c {
  h_cursor := DllCall("CopyImage", "Ptr", %$%%each%, "UInt", 2, "Int", 0, "Int", 0, "UInt", 0)
  DllCall("SetSystemCursor", "Ptr", h_cursor, "UInt", cursor)
 }
}

#IfWinActive