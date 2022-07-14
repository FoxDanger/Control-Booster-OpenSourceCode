;TWB Auto Setup
;A software to generate a new resolution/scale setup for Tangent Booster
;Developer: André Rodrigues - Media Environment
;Website: https://souandrerodrigues.com.br/tb
;Contact: tangentbooster@souandrerodrigues.com.br
;Version: 0.4 Beta

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

;Set the type of Davinci Layout according the PC resolution - Can be: "NORMAL", "CONDENSED" or "WIDE"
Global _davinciLayoutUI := "NORMAL"

;Itens of actual ComboBox Resolutions and Scales
Global _comboboxItems := []

;Define if app is runnig or in stand by
Global _appRunning := true

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

Menu, Tray, Icon, %A_ScriptDir%\images\TWB Ready.ico

Gui, -dpiscale

Gui Show, w1024 h768, TWB Auto Setup 0.3 Beta

; \/ SETUP DAVINCI TO START THE PROCCESS \/

;Check if Davinci Resolve is Running
IfWinNotExist, DaVinci Resolve
{
	MsgBox "Please Run Davinci Resolve and then run TWB Auto Setup again following the instructions."
    ExitApp
}

; /\ END OF SETUP DAVINCI TO START THE PROCCESS /\

; \/ APP START \/

;Read the resolution and scale ini file to set the combobox resolution options
Loop, read, %A_ScriptDir%\resolution.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        if (InStr(A_Loopfield, "comboboxItems") != 0){
            startingPos := InStr(A_Loopfield, "=")
            
            _comboboxItems := SubStr(A_Loopfield, startingPos + 1)
        }
    }
}

;Step by Step messages to setup Davinci Resolve for TWB Positions Generator
FirstSetup()

; /\ END APP START /\

Return

GuiClose:
    ExitApp

; /\ END OF GUI INTERFACE /\

#If (_appRunning) ;Turn on and off all the other functions of the app, making it stop if you need. Shortcut to turn on/off is F8

; \/ FUNCTIONS \/

;===== LOAD AND SET FUNCTIONS =====

;Setup things for TWB Positions Generator work correctly
FirstSetup(){
    MsgBox "Before start we need to do 3 steps:"
    MsgBox "1 - Open a new project on Davinci Resolve"
    MsgBox "2 - Create a timeline and put a clip with audio on it"
    MsgBox "3 - Go to color page, select the clip and add this clip to a group."
    
    CallNormalLayout()
}

CallNormalLayout(){
    Gui, Destroy
    
    Gui Font, s9, Segoe UI
    Gui Add, Text, x0 y0 w1024 h768
    Gui Add, Text, x0 y100 w1280 h3 +0x10
    Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center , How's your Davinci UI looks like on color page?
    Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center , Pay attention to the buttons bar on the color page and the Matte Finess on Qualifier
    Gui Add, Picture, x0 y120 w1024 h518, %A_ScriptDir%\images\step-by-step\davinci_normal_interface.png
    Gui Add, Button, g_set_variable_button x412 y650 w200 h50, Normal Layout
    Gui Add, Button, g_set_variable_button x800 y700 w200 h50, Show Condensed Layout

    Gui Show, w1024 h768, Window
}

CallCondensedLayout(){
    Gui, Destroy
    
    Gui Font, s9, Segoe UI
    Gui Add, Text, x0 y0 w1024 h768
    Gui Add, Text, x0 y100 w1280 h3 +0x10
    Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center , How's your Davinci UI looks like on color page?
    Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center , Pay attention to the buttons bar on the color page and the Matte Finess on Qualifier
    Gui Add, Picture, x0 y120 w1024 h518, %A_ScriptDir%\images\step-by-step\davinci_condensed_interface.png
    Gui Add, Button, g_set_variable_button x412 y650 w200 h50, Condensed Layout
    Gui Add, Button, g_set_variable_button x24 y700 w200 h50, Show Normal Layout
    Gui Add, Button, g_set_variable_button x800 y700 w200 h50, Show Wide Layout

    Gui Show, w1024 h768, Window
}

CallWideLayout(){
    Gui, Destroy
    
    Gui Font, s9, Segoe UI
    Gui Add, Text, x0 y0 w1024 h768
    Gui Add, Text, x0 y100 w1280 h3 +0x10
    Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center , How's your Davinci UI looks like on color page?
    Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center , Pay attention to the buttons bar on the color page and the Matte Finess on Qualifier
    Gui Add, Picture, x0 y120 w1024 h342, %A_ScriptDir%\images\step-by-step\davinci_wide_interface.png
    Gui Add, Button, g_set_variable_button x412 y480 w200 h50, Wide Layout
    Gui Add, Button, g_set_variable_button x24 y700 w200 h50, Show Condensed Layout

    Gui Show, w1024 h768, Window
}

;Start the load positions proccess
StartAutoPositions(){
    ;Set if the actual item is a Address
    isAddress := False

    ;Save the actual object name being loaded
    actualObjectName := ""
    
    ;Define if the next item should be clicked or just move the mouse
    nextClick := False

    ;Use this to add some paths without need use all the paths
    ;filePath := "temp_address.ini"
    
    Switch (_davinciLayoutUI){
        Case "NORMAL":
            filePath := "addresses_normal.ini"
        Case "CONDENSED":
            filePath := "addresses_condensed.ini"
        Case "WIDE":
            filePath := "addresses_wide.ini"
    }

    ;Loop through addresses_normal.ini file to find each object and populate the arrays _positionsArray(x) with all the Davinci Resolve UI elements positions
    ;Each variable will have an address that is formed by a 0 or 1 before a "\" character. 0 is when that object doesn't need catch the ID of a new window opened, like a menu or dropdown combobox and etc.
    ;1 is for objects that need the ID of that window. And after the "\" character comes the address of that item on that window.
    ;Example: address=0\4.2.2.1.1.2.3.2.2.1.1.1.1.1.1.2.1.2.1.1.2 - Means that is on the main screen, so 0 because we don't need the ID of that screen
    ;Example: address=1\4.1.1 - Means that is on a submenu or dropdown menu, which will be the last window opened on the screen, the 1 before the "\" means the software need get the ID of that window so
    ;the address will be correct for that window.
    ;Loop, read, %A_ScriptDir%\project_files\addresses_debug.ini
    Loop, read, %A_ScriptDir%\%filePath%
    {
        Loop, parse, A_LoopReadLine, %A_Tab%
        {
            if (InStr(A_Loopfield, "--") >= 1){
                nextClick := True
                
                if (InStr(A_Loopfield, "EDIT PANEL") >= 1){
                    nextClick := False
                    
                    ;Davinci Resolve Default Shortctut Shift+4 - Open Edit Page
                    Send +4
                    
                    Sleep 500
                }
                
                if (InStr(A_Loopfield, "COLOR PANEL") >= 1){
                    nextClick := False
                    
                    ;Davinci Resolve Default Shortctut Shift+6 - Open Color Page
                    ;Davinci bug makes you have to press shift+6 2 times to go to color page
                    Send +6
                    Send +6
                    
                    Sleep 500
                }
                
                continue
            }

            if !(isAddress){
                startingPos := InStr(A_Loopfield, "=")

                actualObjectName := SubStr(A_Loopfield, startingPos + 1)

                isAddress := True
            }Else{
                ;If true it will click on a empty space of the preview window to close any sub menu
                clickOnEmptySpaceAfter := False
            
                tempString := SubStr(A_Loopfield, 1, InStr(A_Loopfield,"\",0,0)-1)
                
                startingPos := InStr(A_Loopfield, "=")
                
                needID := SubStr(tempString, startingPos + 1)
                
                startingPos := InStr(A_Loopfield, "\")

                address := SubStr(A_Loopfield, startingPos + 1)
                
                ;Define some special cases
                Switch (actualObjectName){
                    Case "pos_hdr_first_wheel_hl":
                        accObject := GetAccPositionsTopLeft(address, needID, 0, 10, 10)
                    Case "pos_hdr_second_wheel_hl":
                        accObject := GetAccPositionsTopLeft(address, needID, 0, 10, 10)
                    Case "pos_hdr_third_wheel_hl":
                        accObject := GetAccPositionsTopLeft(address, needID, 0, 10, 10)
                    Case "pos_hdr_fourth_wheel_hl":
                        accObject := GetAccPositionsTopLeft(address, needID, 0, 10, 10)
                    Case "pos_timeline_view_options_audio_waveforms":
                        accObject := GetAccPositionsCenter(address, needID)
                        clickOnEmptySpaceAfter := True
                    Default:
                        accObject := GetAccPositionsCenter(address, needID)
                }

                if (nextClick){
                    MouseClick Left, accObject.posX, accObject.posY, 1, 0
                    
                    nextClick := False
                    
                    Sleep 200
                }Else{
                    MouseMove accObject.posX, accObject.posY
                }
                
                object := []

                _positionsArray.Push(object)

                _positionsArray[_arrayPos].var := actualObjectName
                _positionsArray[_arrayPos].x := accObject.posX
                _positionsArray[_arrayPos].y := accObject.posY
                
                _arrayPos++
                
                isAddress := False
                
                if (clickOnEmptySpaceAfter){
                    object := GetObjectOnPositionsArray("pos_preview_window")
                    MouseClick Left, object.x, object.y, 1, 0
                    Sleep 1000
                }
            }
        }
    }
    
    ;Remove the coment to display all the content of the arrays
    ;DisplayPositionsArray("Positions Array", _positionsArray)
    ;vartemp := _positionsArray[420].var
    ;MsgBox %vartemp%
    
    startUserPositions()
}

startUserPositions(){
    _isSetingVariable := True
    
    Gui, Destroy
    
    Gui Font, s9, Segoe UI
    Gui Add, Text, x0 y0 w1024 h768
    Gui Add, Text, x0 y100 w1280 h3 +0x10
    
    ;Remove the comment to skip the user position configuration
    ;_actualTool := 100
    
    Switch (_actualTool){
        Case 1:
            _actualObject := "pos_media_pool_empty_space"

            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over an empty space on Media Pool
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, and hit ENTER key
            Gui Add, Picture, x157 y224 w710 h319, %A_ScriptDir%\images\step-by-step\pos_media_pool_empty_space.png
        Case 2:
            _actualObject := "pos_timeline_time_bar"

            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the timeline time bar
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, and hit ENTER key
            Gui Add, Picture, x157 y254 w710 h259, %A_ScriptDir%\images\step-by-step\pos_timeline_time_bar.png
        Case 3:
            _actualObject := "pos_color_interface_tools_node_mode_menu"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the nodes groups menu
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, and hit ENTER key
            Gui Add, Picture, x345 y261 w334 h246, %A_ScriptDir%\images\step-by-step\pos_color_interface_tools_node_mode_menu.png
        Case 4:
            _actualObject := "pos_color_interface_tools_node_mode_1"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, On color page create a group for some clip and select that clip, put your
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, mouse over the option "Group Pre-clip" on nodes menu and hit ENTER key
            Gui Add, Picture, x345 y261 w334 h246, %A_ScriptDir%\images\step-by-step\pos_color_interface_tools_node_mode_1.png
        Case 5:
            _actualObject := "pos_color_interface_tools_node_mode_2"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "clip"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on nodes menu and hit ENTER key
            Gui Add, Picture, x345 y261 w334 h246, %A_ScriptDir%\images\step-by-step\pos_color_interface_tools_node_mode_2.png
        Case 6:
            _actualObject := "pos_color_interface_tools_node_mode_3"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "Group Post-clip"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on nodes menu and hit ENTER key
            Gui Add, Picture, x345 y261 w334 h246, %A_ScriptDir%\images\step-by-step\pos_color_interface_tools_node_mode_3.png
        Case 7:
            _actualObject := "pos_color_interface_tools_node_mode_4"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "timeline"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on nodes menu and hit ENTER key
            Gui Add, Picture, x345 y261 w334 h246, %A_ScriptDir%\images\step-by-step\pos_color_interface_tools_node_mode_4.png
        Case 8:
            _actualObject := "pos_zone_on_off_black"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the on/off button of black zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_on_off_black.png
        Case 9:
            _actualObject := "pos_zone_on_off_dark"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the on/off button of dark zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_on_off_dark.png
        Case 10:
            _actualObject := "pos_zone_on_off_shadow"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the on/off button of shadow zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_on_off_shadow.png
        Case 11:
            _actualObject := "pos_zone_on_off_light"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the on/off button of light zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_on_off_light.png
        Case 12:
            _actualObject := "pos_zone_on_off_highlight"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the on/off button of highlight zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_on_off_highlight.png
        Case 13:
            _actualObject := "pos_zone_on_off_specular"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the on/off button of specular zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_on_off_specular.png
        Case 14:
            _actualObject := "pos_zone_show_hide_black"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the show/hide button of black zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_show_hide_black.png
        Case 15:
            _actualObject := "pos_zone_show_hide_dark"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the show/hide button of dark zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_show_hide_dark.png
        Case 16:
            _actualObject := "pos_zone_show_hide_shadow"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the show/hide button of shadow zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_show_hide_shadow.png
        Case 17:
            _actualObject := "pos_zone_show_hide_light"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the show/hide button of light zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_show_hide_light.png
        Case 18:
            _actualObject := "pos_zone_show_hide_highlight"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the show/hide button of highlight zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_show_hide_highlight.png
        Case 19:
            _actualObject := "pos_zone_show_hide_specular"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the show/hide button of specular zone
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, at the zone panel and hit ENTER key
            Gui Add, Picture, x282 y165 w460 h437, %A_ScriptDir%\images\step-by-step\pos_zone_show_hide_specular.png
        Case 20:
            _actualObject := "pos_scopes_parade"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "parade"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on scopes menu and hit ENTER key
            Gui Add, Picture, x326 y326 w372 h312, %A_ScriptDir%\images\step-by-step\pos_scopes_parade.png
        Case 21:
            _actualObject := "pos_scopes_waveform"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "waveform"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on scopes menu and hit ENTER key
            Gui Add, Picture, x326 y326 w372 h312, %A_ScriptDir%\images\step-by-step\pos_scopes_waveform.png
        Case 22:
            _actualObject := "pos_scopes_vectorscope"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "vectorscope"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on scopes menu and hit ENTER key
            Gui Add, Picture, x326 y326 w372 h312, %A_ScriptDir%\images\step-by-step\pos_scopes_vectorscope.png
        Case 23:
            _actualObject := "pos_scopes_histogram"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "histogram"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on scopes menu and hit ENTER key
            Gui Add, Picture, x326 y326 w372 h312, %A_ScriptDir%\images\step-by-step\pos_scopes_histogram.png
        Case 24:
            _actualObject := "pos_scopes_cie"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "cie"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on scopes menu and hit ENTER key
            Gui Add, Picture, x326 y326 w372 h312, %A_ScriptDir%\images\step-by-step\pos_scopes_cie.png
        Case 25:
            _actualObject := "pos_scopes_display_focus"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "display focus"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on scopes three dots menu and hit ENTER key
            Gui Add, Picture, x304 y235 w415 h298, %A_ScriptDir%\images\step-by-step\pos_scopes_display_focus.png
        Case 26:
            _actualObject := "pos_scopes_low_pass_filter"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse over the option "low pass filter"
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, on scopes three dots menu and hit ENTER key
            Gui Add, Picture, x304 y235 w415 h298, %A_ScriptDir%\images\step-by-step\pos_scopes_low_pass_filter.png
        Case 27:
            _actualObject := "pos_custom_top_left"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse on top/left corner of the custom curves graphic
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, slightly before the top and left begins and hit ENTER key
            Gui Add, Picture, x157 y158 w710 h452, %A_ScriptDir%\images\step-by-step\pos_custom_top_left.png
        Case 28:
            _actualObject := "pos_custom_bottom_right"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse on top/left corner of the huevshue curves graphic
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, slightly before the top and left begins and hit ENTER key
            Gui Add, Picture, x157 y158 w710 h452, %A_ScriptDir%\images\step-by-step\pos_custom_bottom_right.png
        Case 29:
            _actualObject := "pos_hue_curves_top_left"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse on bottom/right corner of the custom curves graphic
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, slightly after the bottom and right ends and hit ENTER key
            Gui Add, Picture, x157 y250 w710 h267, %A_ScriptDir%\images\step-by-step\pos_hue_curves_top_left.png

        Case 30:
            _actualObject := "pos_hue_curves_bottom_right"
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Put your mouse on bottom/right corner of the huevshue curves graphic
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, slightly after the bottom and right ends and hit ENTER key
            Gui Add, Picture, x157 y250 w710 h267, %A_ScriptDir%\images\step-by-step\pos_hue_curves_bottom_right.png
        Default:
            _disableEnterKey := True
            
            NameResolutionAndScale()
            
            Gui Add, Text, x0 y0 w1024 h50 +0x200 +Center, Wait! TWB is saving the positions on your INI file...
            Gui Add, Text, x0 y50 w1024 h50 +0x200 +Center, When it's done, TWB will automaticaly close this window.
            
            setTimer, FinishTWB, 3000
    }

    Gui Show, w1024 h768, TWB Set Position Window
    
    _actualTool++
    Return
}

;===== END OF LOAD AND SET FUNCTIONS =====

;===== GENERAL FUNCTIONS =====

;Get the position X/Y of the center of an accObject
GetAccPositionsCenter(address, needID, child := "0", sumX := 0, sumY := 0){
    coordmode,mouse,screen
    
    Switch (needID){
        Case 1:
            WinGet, windowID, ID, Resolve
            oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
        Case 2:
            WinGet, windowID, ID, A
            oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
        Default:
            WinGet, hWnd, ID, A
            oAcc := Acc_Get("Object", address, child, "ahk_id " hWnd)
    }
    
    oRect := Acc_Location(oAcc, 0)

    object := []
    
    object.posX := oRect.x + Round((oRect.w/2)) + sumX
    object.posY := oRect.y + Round((oRect.h/2)) + sumY
    
    return object
}

;Get the position X/Y of the top left of an accObject
GetAccPositionsTopLeft(address, needID, child := "0", sumX := 0, sumY := 0){
    coordmode,mouse,screen
    
    Switch (needID){
        Case 1:
            WinGet, windowID, ID, Resolve
            oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
        Case 2:
            WinGet, windowID, ID, A
            oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
        Default:
            WinGet, hWnd, ID, A
            oAcc := Acc_Get("Object", address, child, "ahk_id " hWnd)
    }
    
    oRect := Acc_Location(oAcc, 0)

    object := []
    
    object.posX := oRect.x + sumX
    object.posY := oRect.y + sumY
    
    return object
}

;Get the position X/Y of the bottom right of an accObject
GetAccPositionsBottomRight(address, needID, child := "0", sumX := 0, sumY := 0){
    coordmode,mouse,screen

    ;0 is default and doesn't need ID because is the main window.
    ;1 is when you need get the ID of the last window named as Resolve
    ;2 is when you need get the ID of the last window active (some windows like timeline preferences doesn't has name but you can get it by last active)
    Switch (needID){
        Case 1:
            WinGet, windowID, ID, Resolve
            oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
        Case 2:
            WinGet, windowID, ID, A
            oAcc := Acc_Get("Object", address, child, "ahk_id " windowID)
        Default:
            WinGet, hWnd, ID, A
            oAcc := Acc_Get("Object", address, child, "ahk_id " hWnd)
    }

    oRect := Acc_Location(oAcc, 0)

    object := []
    
    object.posX := oRect.x + (oRect.w) + sumX
    object.posY := oRect.y + (oRect.h) + sumY
    
    object.posX := SubStr(object.posX, 1, InStr(object.posX, ".") - 1)
    object.posY := SubStr(object.posY, 1, InStr(object.posY, ".") - 1)
    
    return object
}

_set_variable_button:
    buttonPressed := A_GuiControl
    
    Switch (buttonPressed){
        Case "Normal Layout":
            _davinciLayoutUI := "NORMAL"
            
            StartSetup()
        Case "Condensed Layout":
            _davinciLayoutUI := "CONDENSED"
            
            StartSetup()
        Case "Wide Layout":
            _davinciLayoutUI := "WIDE"
            
            StartSetup()
        Case "Show Condensed Layout":
            CallCondensedLayout()
        Case "Show Wide Layout":
            CallWideLayout()
        Case "Show Normal Layout":
            CallNormalLayout()
    }
Return

StartSetup(){
    MsgBox "Now let your mouse free and press enter to start!"
    
    ;Minimize TWB 2 and go to Davinci Resolve Window
    SetTitleMatchMode, 1
    WinMinimize, TWB

    SetTitleMatchMode, 1
    WinActivate, DaVinci Resolve
    
    ;Reset Davinci Resolve for the default state UI and Fullscreen Mode
    ResetDefaultState()

    Sleep 1000

    ;Start load all positions and populate _positionsArray
    StartAutoPositions()
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
    coordmode,mouse,screen
    MouseGetPos, mousePosX, mousePosY

    object := []

    _positionsArray.Push(object)

    _positionsArray[_arrayPos].var := _actualObject
    _positionsArray[_arrayPos].x := mousePosX
    _positionsArray[_arrayPos].y := mousePosY

    _arrayPos++
        
    _isSetingVariable := False
}

;Run the _positionsArray to find a expecific object and return it
GetObjectOnPositionsArray(objectName){
    For index, object in _positionsArray
    if (object.var == objectName) {
        Return object
    }
}

NameResolutionAndScale(){
    InputBox, newResolutionItem, Please name your new resolution config. ONLY NUMBERS AND LETTERS ARE ACCEPTED so please do not use special characters or space., , 400, 180
    if (ErrorLevel){
        ;MsgBox Cancel button was pressed
        Return
    }Else {
        ;Add the new item to the variable that stores all the combobox items
        _comboboxItems := _comboboxItems . "|" . newResolutionItem
        
        WriteIniFiles(newResolutionItem)
        Return
    }
}

;Write in the INI file all the positions stored on the _positionsArray under the respective resolution
WriteIniFiles(resolutionScale) {
    For arrayNum, array in _positionsArray
        For index, varxy in ["var", "x", "y"]
        IniWrite, % array[varxy], %A_ScriptDir%\res_dpi_scale.ini, %resolutionScale%, %resolutionScale% - %arrayNum%%varxy%
        
    ;Write the new item on the ini file for future load
    IniWrite, %_comboboxItems%, %A_ScriptDir%\resolution.ini, RESOLUTION, comboboxItems
}

;Exit the app
FinishTWB(){
    ExitApp
}

;Shows the results of all position arrays
;DisplayPositionsArray(header, array) {
	;out := header "`n`n"
    ;
	;for index, var in array
		;out .= "x: " var.x "`ty: " var.y "`tvar: " var.var "`n"
	;MsgBox, % out
;}

;===== END OF GENERAL FUNCTIONS =====

;===== KEYS FUNCTIONS =====

Enter::
    if (_disableEnterKey)
    Return
    
    if !(_isSetingVariable){
        Send {Enter}
        Return
    }Else{
        ChangePositionVariable()
        
        startUserPositions()
        
        Return
    }
Return

ESC::
    ExitApp
Return

;ARRAY DEBUG KEYS
;F5::
    ;Put a name of a object to show the position saved on the array
    ;object := GetObjectOnPositionsArray("pos_media_pool_empty_space")
    ;objectName := object.var
    ;positionX := object.x
    ;positionY := object.y
    ;
    ;MsgBox %objectName% " - " %positionX% " - " %positionY%
;Return

;F6::
    ;Put a name of a object to show the position saved on the array
    ;object := GetObjectOnPositionsArray("pos_timeline_time_bar")
    ;objectName := object.var
    ;positionX := object.x
    ;positionY := object.y
    ;
    ;MsgBox %objectName% " - " %positionX% " - " %positionY%
;Return

;F7::
    ;Put a name of a object to show the position saved on the array
    ;object := GetObjectOnPositionsArray("pos_timeline_time_bar")
    ;objectName := object.var
    ;positionX := object.x
    ;positionY := object.y
    ;
    ;MsgBox %objectName% " - " %positionX% " - " %positionY%
;Return

;F8::
    ;Put a name of a object to show the position saved on the array
    ;object := GetObjectOnPositionsArray("pos_timeline_time_bar")
    ;objectName := object.var
    ;positionX := object.x
    ;positionY := object.y
    ;
    ;MsgBox %objectName% " - " %positionX% " - " %positionY%
;Return

;===== END OF KEYS FUNCTIONS =====

; /\ END OF FUNCTIONS /\