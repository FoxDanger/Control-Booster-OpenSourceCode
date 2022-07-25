;Tangent Wave Booster
;A software that will give to your Tangent Wave incredible powers
;Developer: André Rodrigues - Media Environment
;Contact: contato@souandrerodrigues.com.br
;Version: 2.0.9
;Please donate if you liked the project! - Por favor faça uma doação se você gostou deste projeto!
;For Dollar Donation: https://www.paypal.com/donate/?token=xMLCpr_JUxvMFomkrZ7jSLPPCCfz8oJAkBeXtPWAw2f3Hfym6otcNQ2gX-ilD3afonbWXF9E4kzKjZY0
;Para doações em Real: https://www.paypal.com/donate/?token=lHsnRH3-dwXqGdqFNYmguAh7Mh8zG0gQnLImvO5HSGqb0wSvaHWrfuzR_mbocCa_Er0nOv-uS8NP7xxd

;Updates of 2.0.9 version:
;Log Wheels Panel functions created and working

;Updates of 2.0.8 version:
;Primaries Bars Panel functions created and working
;In Color mode you can use Alternate + Inch Reverse Key to Reset All Node Grades and Alternate + Inch Forward Key to Reset Node Grade

;Updates of 2.0.7 version:
;Primaries Wheels Panel functions created and working
;Node navigation using Alternate + Fourth Jog Wheel
;Thumbnail navigation using Alternate + First Jog Wheel
;Mouse emulation now can be activated using F8 Key (for right trackball) and Alternate + F8 (for left trackball) Key on panel - The circle and dot buttons over the jog wheel are the left and right mouse buttons
;In any mode you can use F9 Key on panel to navigate fast through the modes.
;In any mode you can use Alternate + F9 Key to start/stop TWB, so you can go out Davinci Screen without the controller click or move the mouse when you don't want that
;In any mode you can use Alternate + Play Key to Redo and Alternate + Reverse Play Key to Undo
;In any mode you can use Alternate + Stop Key to save the project

;Updates of 2.0.6 version:
;Implementation of auto change page/panel when using any tool
;The windows_status.ini can be used to save the latest panels status too, like for example HDR Zone Panel
;Save the latest page used and the latest state of the HDR Zone Panel on windows_status.ini
;HDR Panel functions created and working

;Updates of 2.0.5 version:
;Added stop/restart software button function so you can stop the script when you need pressing F8
;Inspector functions created and working
;Correction on windows_status.ini: There's no more "buttonName" variable, instead we have now only 2 variables: Var and Status. Var stores the name of the button pressed and status is if it is opened or closed

;Updates of 2.0.4 version:
;Reorganized the edit panel on Tagent Mapper with new functions and better UX organization
;Save the latest status of each window on edit page on windows_status.ini
;Edit Panel control functions created and working
;Open/Close windows function added

;Updates of 2.0.3 version:
;OSC comunication implemented

;Updates of 2.0.2 version:
;Add a button so the user can add as much new resolutions he wants. Click on the button, write the name of the new resolution and hit ok. All the positions of the new resolution will be based on the last resolution selected and can be changed after be created.

;Updates of 2.0.1 version:
;New position variables and resolution method. Now we have a external file with all the positions and there's no need to have the variables in the code.

;Updates of 2.0 version:
;Software all redesigned from start
;New OSC controls by Tangent Mapper
;New GUI
;Revised all the shortcuts and some positions of the controllers on Tangent Wave Mapper
;Added support to be used with 2 or more screens setup

;TODO? Create a panel for motion effects

;Tips about Tangent Mapper
;1 - When setting a knob intensity, use for the OSC Value format the option Interger and the knob sensitivity at Coarse. For the Min and Max values, use 0 to 5 if you want not too fast repeating. 0 to 6 for a little more. 0 to 10 and 0 to 50 will give you a fast response with a more sensible knob so only use this for things that doesn't matter repeat the same command more than one time. Example: For select all clips, you can repeat the command because doesn't matter, will select all and that's it. So you can use 0 to 50 because will give you a sensible and fast response. Although for delete you don't wanna the delete being pressed a lot of times in a row, so use 0 to 5.

;------------------------------------------------------------------------------------------ Software Code Start -------------------------------------------------------------------------------------------------------

; \/ AHK Setup \/

; #Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Gui +LastFound
hWnd := WinExist()
CoordMode, Mouse, Screen

#MaxHotkeysPerInterval, 200

; /\ End of AHK Setup /\

; \/ OSC2AHK Communication \/

; OSC datatypes. Just for better readability,
; you also just could use the numbers
global oscTypeNone := 1
global oscTypeInt := 2
global oscTypeFloat := 4
global oscTypeString := 8

;Start OSC2AHK opening the port 7002 and adding all the event listeners
_startOSC2AHK()

; /\ OSC2AHK Communication /\

; \/ GLOBAL VARIABLES \/

;Create a variable for the resolution and scale combo box and set the actual PC Resolution and DPIScale - String - Can be: "FHD100", "FHD125", "FHD150", "FHD200", "4K100", "4K125", "4K150", "4K200" or "USER":
global comboboxResolutionScale
global newResolutionItem
global _comboboxItems
global _resolutionAndScale := "USER"

;Define if app is runnig or in stand by
global _appRunning := true

;Global timers and speeds
global _releaseTime := -300
global _releaseTimeForWheels := -500

;Set the active controllers, pages and panels
global _globalMousePosX := 0
global _globalMousePosY := 0

;Save ImageSearch Pixel
global _imageSearchX := 0
global _imageSearchY := 0

;Define what position variable will be changed
global _variableToSet := ""

;Tels the software that you are seting a new position for some element on the screen, so the software will wait for you to press ENTER to set the new position
global _isSetingVariable := "false"

;Save the last button that was used to set a position. So you can turn on that button again clicking on "Enable Last Button" button
global _lastButtonUsed

; == Array for the position variables - Set the position of each element on the Davinci Resolve workarea (if your resolution and/or scale doesn't work with any of the presets, you need setup each position manualy using TWB tool) ==
global _positionsArray1 := []
global _positionsArray2 := []

;Array with all edit tools windows status
global _editPageWindowsStatus := [] 

;Set the actual page. Can be: "EDIT", "COLOR", 
global _actualPage := "NONE"

;Set the actual mode. Can be: "CAMERA RAW", "COLOR CHECKER", "COLOR WHEELS", "HDR WHEELS", "RGB MIXER", "MOTION BLUR", "CURVES", "WARPER", "QUALIFIER", "POWER WINDOWS", "TRACKING", "MAGIC MASK", "BSM", "KEY", "SIZING", "3D"
global _actualMode := "NONE"

;Set the actual panel. Can be: "NONE" (when u are in edit page), "HDR", "PRIMARIES", "BARS", "LOG", "CURVES", "HUEXHUE", "HUEXSAT", "HUEXLUM"
global _actualColorPanel := "NONE"

;Save what controller are in use. If is "off" no controller are in use
global _activeController := "off"

; /\ END OF GLOBAL VARIABLES /\

; \/ READ AND LOAD EXTERNAL VARIABLES \/

;Read the resolution and scale ini file to set the latest resolution and scale used on the variable _resolutionAndScale and the combobox resolution options
Loop, read, %A_ScriptDir%\resolution.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        if (InStr(A_Loopfield, "lastResScale") != 0){
            startingPos := InStr(A_Loopfield, "=")

            _resolutionAndScale := SubStr(A_Loopfield, startingPos + 1)
        }Else if (InStr(A_Loopfield, "comboboxItems") != 0){
            startingPos := InStr(A_Loopfield, "=")
            
            _comboboxItems := SubStr(A_Loopfield, startingPos + 1)
        }
    }
}

_loadWindowsStatus()

; /\ END OF READ AND LOAD EXTERNAL VARIABLES /\

; \/ START GUI INTERFACE \/

Gui Font, s9, Segoe UI
Gui Add, Picture, x8 y8 w150 h150, %A_ScriptDir%\images\Logo.png
Gui Add, Text, x1216 y8 w120 h23 +0x200, How to use:
Gui Add, Text, x1216 y31 w700 h23, 1 - Click on the button of the tool that you want change the position
Gui Add, Text, x1216 y54 w700 h23, 2 - Go to your software screen and position the mouse on top of the tool
Gui Add, Text, x1216 y77 w700 h23, 3 - Hit "ENTER" key
Gui Add, Text, x1216 y100 w700 h23, 4 - If you think you made a mistake, you can hit Enable Last Button and do that position again
Gui Add, Text, x1216 y123 w700 h23, 5 - Repeat the process for each tool and hit "Save Positions" button at the end
Gui Add, Text, x1216 y146 w700 h23, * Please wait 5 to 10 seconds to do anything else on the software after hit "Save Positions" button
Gui Add, Button, g_start_stop_bt x192 y8 w150 h50, Stop TWB
Gui Add, Button, g_save_positions_bt x192 y64 w150 h50, Save Positions
Gui Add, Button, g_enableLastButton x192 y120 w150 h50, Enable Last Button
;Gui Add, Button, g_checkRes x360 y72 w150 h50, Check Res Test Button
Gui Add, Button, g_addComboboxItemsInputBox x768 y8 w150 h50, Add New Resolution Config
Gui Add, Text, x360 y8 w250 h23, Set Resolution / DPI Scale (in percentage):
Gui Add, ComboBox, vcomboboxResolutionScale g_changeResolutionAndScale x360 y32 w400, %_comboboxItems%

Gui Add, Tab3, x8 y176 w1905 h900 Choose1, Edit Page Buttons|Inspector Transform|Color Page Buttons|Wheels/Jogs|Primaries YRGB|Primaries Tools|Log Wheels|Log Tools|HDR Controllers|HDR Tools|HDR Zone|RGB Mixer|Curves Dots/Options|Custom Curves|Hue Curves|Qualifier|Qualifier Matte Finess|Power Windows|BSM|Key|Motion Blur|Other

Gui Tab, 1
Gui Add, Picture, x480 y608 w950 h40, %A_ScriptDir%\images\Edit Page Top Buttons.png
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_left_expand x352 y604 w120 h50, Left Expand Button
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_media_pool x544 y544 w120 h50, Media Pool
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_effects_library x680 y664 w120 h50, Effects Library
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_edit_index x808 y544 w120 h50, Edit Index
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_sound_library x928 y664 w120 h50, Sound Library
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_mixer x1040 y544 w120 h50, Mixer
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_metadata x1144 y664 w120 h50, Metadata
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_inspector x1256 y544 w120 h50, Inspector
Gui Add, Button, gsetVariableButton vpos_edit_top_bts_right_expand x1440 y604 w120 h50, Right Expand Button

Gui Tab, 2
Gui Add, Picture, x200 y432 w570 h400,  %A_ScriptDir%\images\Inspector Transform Panel.png
Gui Add, Button, gsetVariableButton vpos_inspector_video x200 y368 w150 h50, Video
Gui Add, Button, gsetVariableButton vpos_inspector_transform_on_off x40 y432 w150 h50, Transform On/Off
Gui Add, Button, gsetVariableButton vpos_inspector_horizontal_flip x40 y712 w150 h50, Horizontal Flip
Gui Add, Button, gsetVariableButton vpos_inspector_vertical_flip x40 y784 w150 h50, Vertical Flip
Gui Add, Button, gsetVariableButton vpos_inspector_zoom_x x208 y848 w150 h50, Zoom X
Gui Add, Button, gsetVariableButton vpos_inspector_zoom_y x368 y848 w150 h50, Zoom Y
Gui Add, Button, gsetVariableButton vpos_inspector_position_x x208 y912 w150 h50, Position X
Gui Add, Button, gsetVariableButton vpos_inspector_position_y x368 y912 w150 h50, Position Y
Gui Add, Button, gsetVariableButton vpos_inspector_rotation_angle x456 y976 w150 h50, Rotation Angle
Gui Add, Button, gsetVariableButton vpos_inspector_anchor_point_x x536 y848 w150 h50, Anchor Point X
Gui Add, Button, gsetVariableButton vpos_inspector_anchor_point_y x696 y848 w150 h50, Anchor Point Y
Gui Add, Button, gsetVariableButton vpos_inspector_pitch x536 y912 w150 h50, Pitch
Gui Add, Button, gsetVariableButton vpos_inspector_yaw x696 y912 w150 h50, Yaw
Gui Add, Button, gsetVariableButton vpos_inspector_zoom_link x464 y368 w150 h50, Transform Zoom Link
Gui Add, Button, gsetVariableButton vpos_inspector_transform_reset x624 y368 w150 h50, Transform Reset
Gui Add, Button, gsetVariableButton vpos_inspector_zoom_reset x784 y400 w150 h50, Zoom Reset
Gui Add, Button, gsetVariableButton vpos_inspector_position_reset x784 y464 w150 h50, Position Reset
Gui Add, Button, gsetVariableButton vpos_inspector_rotation_angle_reset x784 y528 w150 h50, Rotation Angle Reset
Gui Add, Button, gsetVariableButton vpos_inspector_anchor_point_reset x784 y592 w150 h50, Anchor Point Reset
Gui Add, Button, gsetVariableButton vpos_inspector_pitch_reset x784 y656 w150 h50, Pitch Reset
Gui Add, Button, gsetVariableButton vpos_inspector_yaw_reset x784 y720 w150 h50, Yaw Reset
Gui Add, Button, gsetVariableButton vpos_inspector_flip_reset x784 y784 w150 h50, Flip Reset
Gui Add, Button, gsetVariableButton vpos_inspector_key_frame_transform x1064 y784 w150 h50, Key Frame - Transform
Gui Add, Button, gsetVariableButton vpos_inspector_key_frame_zoom x904 y848 w150 h50, Key Frame - Zoom
Gui Add, Button, gsetVariableButton vpos_inspector_key_frame_anchor_point x904 y912 w150 h50, Key Frame - Anchor Point
Gui Add, Button, gsetVariableButton vpos_inspector_key_frame_position x1064 y848 w150 h50, Key Frame - Position
Gui Add, Button, gsetVariableButton vpos_inspector_key_frame_pitch x1064 y912 w150 h50, Key Frame - Pitch
Gui Add, Button, gsetVariableButton vpos_inspector_key_frame_rotation_angle x1224 y848 w150 h50, Key Frame - Rotation Angle
Gui Add, Button, gsetVariableButton vpos_inspector_key_frame_yaw x1224 y912 w150 h50, Key Frame - Yaw
Gui Add, Picture, x1152 y432 w570 h170,  %A_ScriptDir%\images\Inspector Audio Panel.png
Gui Add, Button, gsetVariableButton vpos_inspector_audio x1152 y368 w150 h50, Audio
Gui Add, Button, gsetVariableButton vpos_inspector_volume_on_off x992 y504 w150 h50, Volume On/Off
Gui Add, Button, gsetVariableButton vpos_inspector_audio_reset x1576 y368 w150 h50, Audio Reset
Gui Add, Button, gsetVariableButton vpos_inspector_volume_reset x1736 y552 w150 h50, Volume Reset
Gui Add, Button, gsetVariableButton vpos_inspector_volume x1512 y616 w150 h50, Volume
Gui Add, Button, gsetVariableButton vpos_inspector_volume_keyframe x1512 y680 w150 h50, Volume Key Frame

Gui Tab, 3
Gui Add, Picture, x480 y424 w950 h40, %A_ScriptDir%\images\Color Page Top Buttons.png
Gui Add, Button, gsetVariableButton vpos_color_top_bts_gallery x480 y360 w120 h50, Gallery
Gui Add, Button, gsetVariableButton vpos_color_top_bts_luts x576 y480 w120 h50, LUTs
Gui Add, Button, gsetVariableButton vpos_color_top_bts_media_pool x704 y360 w120 h50, Media Pool
Gui Add, Button, gsetVariableButton vpos_color_top_bts_timeline x848 y480 w120 h50, Timeline
Gui Add, Button, gsetVariableButton vpos_color_top_bts_clips x968 y360 w120 h50, Clips
Gui Add, Button, gsetVariableButton vpos_color_top_bts_nodes x1088 y480 w120 h50, Nodes
Gui Add, Button, gsetVariableButton vpos_color_top_bts_open_fx x1192 y360 w120 h50, Open FX
Gui Add, Button, gsetVariableButton vpos_color_top_bts_lightbox x1312 y480 w120 h50, Lightbox
Gui Add, Picture, x480 y752 w950 h130, %A_ScriptDir%\images\Color Panels Buttons.png
Gui Add, Button, gsetVariableButton vpos_color_page_bts_curves x320 y688 w120 h50, Curves
Gui Add, Button, gsetVariableButton vpos_color_page_bts_warper x448 y688 w120 h50, Warper
Gui Add, Button, gsetVariableButton vpos_color_page_bts_qualifier x576 y688 w120 h50, Qualifier
Gui Add, Button, gsetVariableButton vpos_color_page_bts_power_windows x704 y688 w120 h50, Power Windows
Gui Add, Button, gsetVariableButton vpos_color_page_bts_tracking x832 y688 w120 h50, Tracking
Gui Add, Button, gsetVariableButton vpos_color_page_bts_magic_mask x960 y688 w120 h50, Magic Mask
Gui Add, Button, gsetVariableButton vpos_color_page_bts_bsm x1088 y688 w120 h50, BSM
Gui Add, Button, gsetVariableButton vpos_color_page_bts_key x1216 y688 w120 h50, Key
Gui Add, Button, gsetVariableButton vpos_color_page_bts_sizing x1344 y688 w120 h50, Sizing
Gui Add, Button, gsetVariableButton vpos_color_page_bts_3d x1472 y688 w120 h50, 3D
Gui Add, Button, gsetVariableButton vpos_color_page_bts_camera_raw x320 y896 w120 h50, Camera RAW
Gui Add, Button, gsetVariableButton vpos_color_page_bts_color_checker x448 y896 w120 h50, Color Checker
Gui Add, Button, gsetVariableButton vpos_color_page_bts_color_wheels x576 y896 w120 h50, Color Wheels
Gui Add, Button, gsetVariableButton vpos_color_page_bts_hdr_wheels x704 y896 w120 h50, HDR Wheels
Gui Add, Button, gsetVariableButton vpos_color_page_bts_rgb_mixer x832 y896 w120 h50, RGB Mixer
Gui Add, Button, gsetVariableButton vpos_color_page_bts_motion_effects x960 y896 w120 h50, Motion Effects
Gui Add, Button, gsetVariableButton vpos_color_page_bts_key_frame_animation x1216 y896 w120 h50, Key Frame Animation
Gui Add, Button, gsetVariableButton vpos_color_page_bts_scopes x1344 y896 w120 h50, Scopes
Gui Add, Button, gsetVariableButton vpos_color_page_bts_information x1472 y896 w120 h50, Information
Gui Add, Button, gsetVariableButton vpos_color_page_bts_key_frame_expander x1088 y896 w120 h50, Key Frame Expander

Gui Tab, 4
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Wheels Panel.png
Gui Add, Button, gsetVariableButton vpos_primaries_wheels_dot x696 y368 w150 h50, Primaries Wheels Dot
Gui Add, Button, gsetVariableButton vpos_primaries_bars_dot x856 y368 w150 h50, Primaries Bars Dot
Gui Add, Button, gsetVariableButton vpos_primaries_log_dot x1016 y368 w150 h50, Primaries Log Dot
Gui Add, Button, gsetVariableButton vpos_first_wheel_reset x528 y848 w150 h50, First Wheel Reset
Gui Add, Button, gsetVariableButton vpos_first_wheel x528 y912 w150 h50, First Wheel
Gui Add, Button, gsetVariableButton vpos_first_jog x528 y976 w150 h50, First Jog
Gui Add, Button, gsetVariableButton vpos_second_wheel_reset x768 y848 w150 h50, Second Wheel Reset
Gui Add, Button, gsetVariableButton vpos_second_wheel x768 y912 w150 h50, Second Wheel
Gui Add, Button, gsetVariableButton vpos_second_jog x768 y976 w150 h50, Second Jog
Gui Add, Button, gsetVariableButton vpos_third_wheel_reset x1000 y848 w150 h50, Third Wheel Reset
Gui Add, Button, gsetVariableButton vpos_third_wheel x1000 y912 w150 h50, Third Wheel
Gui Add, Button, gsetVariableButton vpos_third_jog x1000 y976 w150 h50, Third Jog
Gui Add, Button, gsetVariableButton vpos_fourth_wheel_reset x1240 y848 w150 h50, Fourth Wheel Reset
Gui Add, Button, gsetVariableButton vpos_fourth_wheel x1240 y912 w150 h50, Fourth Wheel
Gui Add, Button, gsetVariableButton vpos_fourth_jog x1240 y976 w150 h50, Fourth Jog

Gui Tab, 5
Gui Add, Picture, x480 y232 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Wheels Panel.png
Gui Add, Button, gsetVariableButton vpos_primaries_lift_y x528 y648 w150 h50, Lift Y
Gui Add, Button, gsetVariableButton vpos_primaries_lift_r x528 y712 w150 h50, Lift R
Gui Add, Button, gsetVariableButton vpos_primaries_lift_g x528 y776 w150 h50, Lift G
Gui Add, Button, gsetVariableButton vpos_primaries_lift_b x528 y840 w150 h50, Lift B
Gui Add, Button, gsetVariableButton vpos_primaries_gamma_y x776 y648 w150 h50, Gamma Y
Gui Add, Button, gsetVariableButton vpos_primaries_gamma_r x776 y712 w150 h50, Gamma R
Gui Add, Button, gsetVariableButton vpos_primaries_gamma_g x776 y776 w150 h50, Gamma G
Gui Add, Button, gsetVariableButton vpos_primaries_gamma_b x776 y840 w150 h50, Gamma B
Gui Add, Button, gsetVariableButton vpos_primaries_gain_y x1008 y648 w150 h50, Gain Y
Gui Add, Button, gsetVariableButton vpos_primaries_gain_r x1008 y712 w150 h50, Gain R
Gui Add, Button, gsetVariableButton vpos_primaries_gain_g x1008 y776 w150 h50, Gain G
Gui Add, Button, gsetVariableButton vpos_primaries_gain_b x1008 y840 w150 h50, Gain B
Gui Add, Button, gsetVariableButton vpos_offset_r x1240 y648 w150 h50, Offset R
Gui Add, Button, gsetVariableButton vpos_offset_g x1240 y712 w150 h50, Offset G
Gui Add, Button, gsetVariableButton vpos_offset_b x1240 y776 w150 h50, Offset B

Gui Tab, 6
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Wheels Panel.png
Gui Add, Button, gsetVariableButton vpos_primaries_reset x1448 y432 w150 h50, Primaries Reset
Gui Add, Button, gsetVariableButton vpos_auto_balance x328 y432 w150 h50, Auto Balance
Gui Add, Button, gsetVariableButton vpos_awb_picker x328 y488 w150 h50, AWB Picker
Gui Add, Button, gsetVariableButton vpos_primaries_temp x624 y368 w150 h50, Temperature
Gui Add, Button, gsetVariableButton vpos_primaries_tint x784 y368 w150 h50, Tint
Gui Add, Button, gsetVariableButton vpos_primaries_contrast x944 y368 w150 h50, Contrast
Gui Add, Button, gsetVariableButton vpos_primaries_pivot x1104 y368 w150 h50, Pivot
Gui Add, Button, gsetVariableButton vpos_primaries_middetail x1264 y368 w150 h50, Mid/Detail
Gui Add, Button, gsetVariableButton vpos_primaries_black_point_selector x328 y544 w150 h50, Black Point Selector
Gui Add, Button, gsetVariableButton vpos_primaries_white_point_selector x1448 y488 w150 h50, White Point Selector
Gui Add, Button, gsetVariableButton vpos_primaries_cool_boost x488 y848 w150 h50, Cool Boost
Gui Add, Button, gsetVariableButton vpos_primaries_shadow x648 y848 w150 h50, Shadow
Gui Add, Button, gsetVariableButton vpos_primaries_high_light x808 y848 w150 h50, High Light
Gui Add, Button, gsetVariableButton vpos_primaries_saturarion x968 y848 w150 h50, Saturatiom
Gui Add, Button, gsetVariableButton vpos_primaries_hue x1128 y848 w150 h50, Hue
Gui Add, Button, gsetVariableButton vpos_primaries_lum_mix x1288 y848 w150 h50, Lum Mix

Gui Tab, 7
Gui Add, Picture, x480 y232 w956 h406 +0x400000 , %A_ScriptDir%\images\Log Panel.png
Gui Add, Button, gsetVariableButton vpos_log_shadow_r x528 y648 w150 h50, Shadow R
Gui Add, Button, gsetVariableButton vpos_log_shadow_g x528 y712 w150 h50, Shadow G
Gui Add, Button, gsetVariableButton vpos_log_shadow_b x528 y776 w150 h50, Shadow B
Gui Add, Button, gsetVariableButton vpos_log_midtone_r x776 y648 w150 h50, Midtone R
Gui Add, Button, gsetVariableButton vpos_log_midtone_g x776 y712 w150 h50, Midtone G
Gui Add, Button, gsetVariableButton vpos_log_midtone_b x776 y776 w150 h50, Midtone B
Gui Add, Button, gsetVariableButton vpos_log_highlights_r x1008 y648 w150 h50, Highlights R
Gui Add, Button, gsetVariableButton vpos_log_highlights_g x1008 y712 w150 h50, Highlights G
Gui Add, Button, gsetVariableButton vpos_log_highlights_b x1008 y776 w150 h50, Highlights B

Gui Tab, 8
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Log Panel.png
Gui Add, Button, gsetVariableButton vpos_log_temperature x480 y368 w150 h50, Temperature
Gui Add, Button, gsetVariableButton vpos_log_tint x640 y368 w150 h50, Tint
Gui Add, Button, gsetVariableButton vpos_log_contrast x800 y368 w150 h50, Contrast
Gui Add, Button, gsetVariableButton vpos_log_pivot x960 y368 w150 h50, Pivot
Gui Add, Button, gsetVariableButton vpos_log_low_range x1120 y368 w150 h50, Low Range
Gui Add, Button, gsetVariableButton vpos_log_high_range x1280 y368 w150 h50, High Range
Gui Add, Button, gsetVariableButton vpos_log_middetail x480 y848 w150 h50, Mid/Det
Gui Add, Button, gsetVariableButton vpos_log_cool_boost x640 y848 w150 h50, Cool Boost
Gui Add, Button, gsetVariableButton vpos_log_shadow x800 y848 w150 h50, Shadow
Gui Add, Button, gsetVariableButton vpos_log_high_light x960 y848 w150 h50, High Light
Gui Add, Button, gsetVariableButton vpos_log_saturation x1120 y848 w150 h50, Saturation
Gui Add, Button, gsetVariableButton vpos_log_hue x1280 y848 w150 h50, Hue

Gui Tab, 9
Gui Add, Picture, x480 y432 w950 h400 +0x400000, %A_ScriptDir%\images\HDR Panel.png
Gui Add, Button, gsetVariableButton vpos_hdr_wheels_left_arrow x776 y368 w150 h50, HDR Wheels Left
Gui Add, Button, gsetVariableButton vpos_hdr_wheels_right_arrow x984 y368 w150 h50, HDR Wheels Right
Gui Add, Button, gsetVariableButton vpos_hdr_open_zone x1440 y440 w150 h50, Open Zone Panel
Gui Add, Button, gsetVariableButton vpos_hdr_wheels x1440 y504 w150 h50, HDR Wheels Toggle
Gui Add, Button, gsetVariableButton vpos_hdr_zone_toggle x1440 y568 w150 h50, HDR Zone Toggle
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_hl x320 y512 w150 h50, First Wheel High Light
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_exp x496 y848 w100 h50, Exp First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_sat x608 y848 w100 h50, Sat First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_x x496 y912 w100 h50, X First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_y x608 y912 w100 h50, Y First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_falloff x496 y976 w100 h50, Falloff First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_hl x320 y576 w150 h50, Second Wheel High Light
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_exp x736 y848 w100 h50, Exp Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_sat x848 y848 w100 h50, Sat Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_x x736 y912 w100 h50, X Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_y x848 y912 w100 h50, Y Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_falloff x736 y976 w100 h50, Falloff Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_hl x320 y640 w150 h50, Third Wheel High Light
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_exp x968 y848 w100 h50, Exp Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_sat x1080 y848 w100 h50, Sat Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_x x968 y912 w100 h50, X Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_y x1080 y912 w100 h50, Y Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_falloff x968 y976 w100 h50, Falloff Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_exp x1200 y848 w100 h50, Exp Fourth Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_sat x1312 y848 w100 h50, Sat Fourth Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_x x1200 y912 w100 h50, X Fourth Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_y x1312 y912 w100 h50, Y Fourth Wheel


Gui Tab, 10
Gui Add, Picture, x200 y432 w950 h400 +0x400000, %A_ScriptDir%\images\HDR Panel.png
Gui Add, Picture, x1160 y432 w600 h100 +0x400000, %A_ScriptDir%\images\HDR Reset Menu.png
Gui Add, Button, gsetVariableButton vpos_hdr_dots_menu x1000 y298 w150 h50, 3 Dots Menu
Gui Add, Button, gsetVariableButton vpos_hdr_dots_menu_zone x1000 y368 w150 h50, 3 Dots Menu - Zone Open
Gui Add, Button, gsetVariableButton vpos_hdr_dots_menu_reset x1160 y298 w150 h50, 3 Dots Menu - Reset Option
Gui Add, Button, gsetVariableButton vpos_hdr_dots_menu_reset_zone x1160 y368 w150 h50, 3 Dots Menu - Reset Option - Zone Open
Gui Add, Button, gsetVariableButton vpos_hdr_reset_all x1480 y298 w150 h50, HDR Reset All
Gui Add, Button, gsetVariableButton vpos_hdr_reset_all_zone x1480 y368 w150 h50, HDR Reset All - Zone Open
Gui Add, Button, gsetVariableButton vpos_hdr_reset_color x1480 y550 w150 h50, HDR Reset Color
Gui Add, Button, gsetVariableButton vpos_hdr_reset_color_zone x1640 y550 w150 h50, HDR Reset Color - Zone Open
Gui Add, Button, gsetVariableButton vpos_hdr_reset_zone x1480 y620 w150 h50, HDR Reset Zone
Gui Add, Button, gsetVariableButton vpos_hdr_reset_zone_zone x1640 y620 w150 h50, HDR Reset Zone - Zone Open
Gui Add, Button, gsetVariableButton vpos_hdr_temperature x208 y848 w120 h50, Temperature
Gui Add, Button, gsetVariableButton vpos_hdr_tint x344 y848 w120 h50, Tint
Gui Add, Button, gsetVariableButton vpos_hdr_hue x480 y848 w120 h50, Hue
Gui Add, Button, gsetVariableButton vpos_hdr_contrast x616 y848 w120 h50, Contrast
Gui Add, Button, gsetVariableButton vpos_hdr_pivot x752 y848 w120 h50, Pivot
Gui Add, Button, gsetVariableButton vpos_hdr_md x888 y848 w120 h50, MD
Gui Add, Button, gsetVariableButton vpos_hdr_black_offset x1024 y848 w120 h50, Black Offset

Gui Tab, 11
Gui Add, Picture, x480 y432 w950 h400 +0x400000, %A_ScriptDir%\images\Zones Panel.png
Gui Add, Button, gsetVariableButton vpos_zone_close_zone x1440 y440 w150 h50, Close Zone Panel
Gui Add, Button, gsetVariableButton vpos_zone_reset x1440 y504 w150 h50, HDR Reset (Zone Panel)
Gui Add, Button, gsetVariableButton vpos_zone_max_range x952 y848 w150 h50, Max Range
Gui Add, Button, gsetVariableButton vpos_zone_falloff x1128 y848 w150 h50, Falloff
Gui Add, Button, gsetVariableButton vpos_zone_create_new_zone x560 y848 w150 h50, Create New Zone
Gui Add, Button, gsetVariableButton vpos_zone_show_hide_black x224 y456 w120 h50, Black Show/Hide
Gui Add, Button, gsetVariableButton vpos_zone_on_off_black x96 y456 w120 h50, Black On/Off
Gui Add, Button, gsetVariableButton vpos_zone_black x352 y456 w120 h50, Black
Gui Add, Button, gsetVariableButton vpos_zone_show_hide_dark x224 y520 w120 h50, Dark Show/Hide
Gui Add, Button, gsetVariableButton vpos_zone_on_off_dark x96 y520 w120 h50, Dark On/Off
Gui Add, Button, gsetVariableButton vpos_zone_dark x352 y520 w120 h50, Dark
Gui Add, Button, gsetVariableButton vpos_zone_show_hide_shadow x224 y584 w120 h50, Shadow Show/Hide
Gui Add, Button, gsetVariableButton vpos_zone_on_off_shadow x96 y584 w120 h50, Shadow On/Off
Gui Add, Button, gsetVariableButton vpos_zone_shadow x352 y584 w120 h50, Shadow
Gui Add, Button, gsetVariableButton vpos_zone_show_hide_light x224 y648 w120 h50, Light Show/Hide
Gui Add, Button, gsetVariableButton vpos_zone_on_off_light x96 y648 w120 h50, Light On/Off
Gui Add, Button, gsetVariableButton vpos_zone_light x352 y648 w120 h50, Light
Gui Add, Button, gsetVariableButton vpos_zone_show_hide_highlight x224 y712 w120 h50, Highlight Show/Hide
Gui Add, Button, gsetVariableButton vpos_zone_on_off_highlight x96 y712 w120 h50, Highlight On/Off
Gui Add, Button, gsetVariableButton vpos_zone_highlight x352 y712 w120 h50, Highlight
Gui Add, Button, gsetVariableButton vpos_zone_show_hide_specular x224 y776 w120 h50, Specular Show/Hide
Gui Add, Button, gsetVariableButton vpos_zone_on_off_specular x96 y776 w120 h50, Specular On/Off
Gui Add, Button, gsetVariableButton vpos_zone_specular x352 y776 w120 h50, Specular

Gui Tab, 12
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\RGB Mixer Panel.png
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_red_output_reset x568 y368 w150 h50, Red Output Reset
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_green_output_reset x880 y368 w150 h50, Green Output Reset
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_blue_output_reset x1200 y368 w150 h50, Blue Output Reset
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_reset x1440 y432 w150 h50, RGB Mixer Reset
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_monochrome x1440 y720 w150 h50, Monochrome
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_preserve_luminance x1440 y784 w150 h50, Preserve Luminance
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_red_to_green x320 y656 w150 h50, Red to Green
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_green_to_blue x320 y720 w150 h50, Green to Blue
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_blue_to_red x320 y784 w150 h50, Blue to Red
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_red_output_red x560 y848 w150 h50, Red Output - Red
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_red_output_green x560 y912 w150 h50, Red Output - Green
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_red_output_blue x560 y976 w150 h50, Red Output - Blue
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_green_output_red x880 y848 w150 h50, Green Output - Red
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_green_output_green x880 y912 w150 h50, Green Output - Green
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_green_output_blue x880 y976 w150 h50, Green Output - Blue
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_blue_output_red x1200 y848 w150 h50, Blue Output - Red
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_blue_output_green x1200 y912 w150 h50, Blue Output - Green
Gui Add, Button, gsetVariableButton vpos_rgb_mixer_blue_output_blue x1200 y976 w150 h50, Blue Output - Blue

Gui Tab, 13
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Curves Panel.png
Gui Add, Button, gsetVariableButton vpos_curves_buttons_custom_dot x480 y368 w120 h50, Custom Dot
Gui Add, Button, gsetVariableButton vpos_curves_buttons_huexhue_dot x616 y368 w120 h50, Hue x Hue Dot
Gui Add, Button, gsetVariableButton vpos_curves_buttons_huexsat_dot x752 y368 w120 h50, Hue x Sat Dot
Gui Add, Button, gsetVariableButton vpos_curves_buttons_huexlum_dot x888 y368 w120 h50, Hue x Lum Dot
Gui Add, Button, gsetVariableButton vpos_curves_buttons_satxlum_dot x1296 y368 w120 h50, Sat x Lum Dot
Gui Add, Button, gsetVariableButton vpos_curves_buttons_lumxsat_dot x1024 y368 w120 h50, Lum x Sat Dot
Gui Add, Button, gsetVariableButton vpos_curves_buttons_satxsat_dot x1160 y368 w120 h50, Sat x Sat Dot
Gui Add, Button, gsetVariableButton vpos_curves_buttons_reset x1440 y432 w150 h50, Reset

Gui Tab, 14
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Curves Panel.png
Gui Add, Button, gsetVariableButton vpos_custom_edit_link_on_off x480 y368 w150 h50, Edit Link On/Off
Gui Add, Button, gsetVariableButton vpos_custom_edit_y_on_off x640 y368 w150 h50, Edit Y On/Off
Gui Add, Button, gsetVariableButton vpos_custom_edit_r_on_off x800 y368 w150 h50, Edit R On/Off
Gui Add, Button, gsetVariableButton vpos_custom_edit_g_on_off x960 y368 w150 h50, Edit G On/Off
Gui Add, Button, gsetVariableButton vpos_custom_intensity_lum x1440 y464 w150 h50, Intensity Lum
Gui Add, Button, gsetVariableButton vpos_custom_edit_b_on_off x1120 y368 w150 h50, Edit B On/Off
Gui Add, Button, gsetVariableButton vpos_custom_edit_reset x1280 y368 w150 h50, Edit Reset
Gui Add, Button, gsetVariableButton vpos_custom_intensity_red x1440 y528 w150 h50, Intensity Red
Gui Add, Button, gsetVariableButton vpos_custom_intensity_green x1440 y592 w150 h50, Intensity Green
Gui Add, Button, gsetVariableButton vpos_custom_intensity_blue x1440 y656 w150 h50, Intensity Blue
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_link x640 y848 w150 h50, Soft Clip Link
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_r x800 y848 w150 h50, Soft Clip R
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_g x960 y848 w150 h50, Soft Clip G
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_b x1120 y848 w150 h50, Soft Clip B
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_reset x1280 y848 w150 h50, Soft Clip Reset
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_low x1120 y912 w150 h50, Soft Clip Low
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_low_smooth x1120 y976 w150 h50, Soft Clip Low Smooth
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_high x1280 y912 w150 h50, Soft Clip High
Gui Add, Button, gsetVariableButton vpos_custom_soft_clip_high_smooth x1280 y976 w150 h50, Soft Clip High Smooth
Gui Add, Button, gsetVariableButton vpos_custom_intensity_lum_reset x1600 y464 w150 h50, Intensity Lum Reset
Gui Add, Button, gsetVariableButton vpos_custom_intensity_red_reset x1600 y528 w150 h50, Intensity Red Reset
Gui Add, Button, gsetVariableButton vpos_custom_intensity_green_reset x1600 y592 w150 h50, Intensity Green Reset
Gui Add, Button, gsetVariableButton vpos_custom_intensity_blue_reset x1600 y656 w150 h50, Intensity Blue Reset

Gui Tab, 15
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Hue Curves Panel.png
Gui Add, Button, gsetVariableButton vpos_hue_curves_spline x320 y784 w150 h50, Spline
Gui Add, Button, gsetVariableButton vpos_hue_curves_red x480 y848 w150 h50, Red
Gui Add, Button, gsetVariableButton vpos_hue_curves_yellow x640 y848 w150 h50, Yellow
Gui Add, Button, gsetVariableButton vpos_hue_curves_green x800 y848 w150 h50, Green
Gui Add, Button, gsetVariableButton vpos_hue_curves_cyan x960 y848 w150 h50, Cyan
Gui Add, Button, gsetVariableButton vpos_hue_curves_blue x1120 y848 w150 h50, Blue
Gui Add, Button, gsetVariableButton vpos_hue_curves_magenta x1280 y848 w150 h50, Magenta
Gui Add, Button, gsetVariableButton vpos_hue_curves_input_hue x1440 y720 w150 h50, Input Hue
Gui Add, Button, gsetVariableButton vpos_hue_curves_output x1440 y784 w150 h50, Output Hue Rotate/Sat/Lum

Gui Tab, 16
Gui Add, Picture, x480 y432 w950 h400,  %A_ScriptDir%\images\Qualifier Panel.png
Gui Add, Button, gsetVariableButton vpos_qualifier_reset x1280 y368 w150 h50, Qualifier Reset
Gui Add, Button, gsetVariableButton vpos_qualifier_invert x1440 y504 w150 h50, Qualifier Invert
Gui Add, Button, gsetVariableButton vpos_qualifier_hue_on_off x320 y464 w150 h50, Hue On/Off
Gui Add, Button, gsetVariableButton vpos_qualifier_hue_center x480 y848 w150 h50, Hue Center
Gui Add, Button, gsetVariableButton vpos_qualifier_hue_width x640 y848 w150 h50, Hue Width
Gui Add, Button, gsetVariableButton vpos_qualifier_hue_soft x800 y848 w150 h50, Hue Soft
Gui Add, Button, gsetVariableButton vpos_qualifier_hue_sym x960 y848 w150 h50, Hue Sym
Gui Add, Button, gsetVariableButton vpos_qualifier_hue_reset x1120 y848 w150 h50, Hue Reset
Gui Add, Button, gsetVariableButton vpos_qualifier_saturation_on_off x320 y592 w150 h50, Saturation On/Off
Gui Add, Button, gsetVariableButton vpos_qualifier_saturation_low x480 y912 w150 h50, Saturation Low
Gui Add, Button, gsetVariableButton vpos_qualifier_saturation_high x640 y912 w150 h50, Saturation High
Gui Add, Button, gsetVariableButton vpos_qualifier_saturation_low_soft x800 y912 w150 h50, Saturation Low Soft
Gui Add, Button, gsetVariableButton vpos_qualifier_saturation_high_soft x960 y912 w150 h50, Saturation High Soft
Gui Add, Button, gsetVariableButton vpos_qualifier_saturation_reset x1120 y912 w150 h50, Saturation Reset
Gui Add, Button, gsetVariableButton vpos_qualifier_luminance_on_off x320 y712 w150 h50, Luminance On/Off
Gui Add, Button, gsetVariableButton vpos_qualifier_luminance_low x480 y976 w150 h50, Luminance Low
Gui Add, Button, gsetVariableButton vpos_qualifier_luminance_high x640 y976 w150 h50, Luminance High
Gui Add, Button, gsetVariableButton vpos_qualifier_luminance_low_soft x800 y976 w150 h50, Luminance Low Soft
Gui Add, Button, gsetVariableButton vpos_qualifier_luminance_high_soft x960 y976 w150 h50, Luminance High Soft
Gui Add, Button, gsetVariableButton vpos_qualifier_luminance_reset x1120 y976 w150 h50, Luminance Reset

Gui Tab, 17
Gui Add, Picture, x672 y320 w570 h400, %A_ScriptDir%\images\Qualifier Matte Finesse Panel.png
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1 x672 y256 w150 h50, Matte Finesse 1
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2 x1088 y256 w150 h50, Matte Finesse 2
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_denoise_reset x512 y376 w150 h50, Denoise Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_clean_black_reset x512 y440 w150 h50, Clean Black Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_clean_white_reset x512 y504 w150 h50, Clean White Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_blur_radius_reset x512 y568 w150 h50, Blur Radius Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_in_out_ratio_reset x512 y632 w150 h50, In/Out Ratio Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_mode_reset x1256 y328 w150 h50, Mode Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_shape_reset x1256 y392 w150 h50, Shape Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_radius_reset x1256 y456 w150 h50, Radius Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_iterations_reset x1256 y520 w150 h50, Iterations Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_black_clip_reset x1256 y584 w150 h50, Black Clip Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_white_clip_reset x1256 y648 w150 h50, White Clip Reset
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_denoise x672 y736 w150 h50, Denoise
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_clean_black x672 y800 w150 h50, Clean Black
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_clean_white x672 y864 w150 h50, Clean White
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_blur_radius x672 y928 w150 h50, Bluer Radius
Gui Add, Button, gsetVariableButton vpos_matte_finesse_1_in_out_ratio x672 y992 w150 h50, In/Out Ratio
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_mode_menu x976 y736 w150 h50, Mode Menu
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_shrink x976 y800 w150 h50, Shrink
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_grow x976 y864 w150 h50, Grow
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_opening x976 y928 w150 h50, Opening
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_closing x976 y992 w150 h50, Closing
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_shape_menu x1136 y736 w150 h50, Shape menu
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_square x1136 y800 w150 h50, Square
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_circle x1136 y864 w150 h50, Circle
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_diamond x1136 y928 w150 h50, Diamond
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_radius x1136 y992 w150 h50, Radius
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_iterations x1296 y736 w150 h50, Iterations
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_black_clip x1296 y800 w150 h50, Black Clip
Gui Add, Button, gsetVariableButton vpos_matte_finesse_2_white_clip x1296 y864 w150 h50, White clip

Gui Tab, 18
Gui Add, Picture, x480 y320 w950 h400, %A_ScriptDir%\images\Power Windows Panel.png
Gui Add, Button, gsetVariableButton vpos_power_window_add_linear x480 y256 w150 h50, Add Linear
Gui Add, Button, gsetVariableButton vpos_power_window_add_circle x640 y256 w150 h50, Add Circle
Gui Add, Button, gsetVariableButton vpos_power_window_add_polygon x800 y256 w150 h50, Add Polygon
Gui Add, Button, gsetVariableButton vpos_power_window_add_curve x960 y256 w150 h50, Add Curve
Gui Add, Button, gsetVariableButton vpos_power_window_add_gradient x1120 y256 w150 h50, Add Gradient
Gui Add, Button, gsetVariableButton vpos_power_window_delete_power_window x1280 y256 w150 h50, Delete Power Window
Gui Add, Button, gsetVariableButton vpos_power_window_reset x1440 y320 w150 h50, Power Window Reset
Gui Add, Button, gsetVariableButton vpos_power_window_size x784 y736 w150 h50, Size
Gui Add, Button, gsetVariableButton vpos_power_window_aspect x944 y736 w150 h50, Aspect
Gui Add, Button, gsetVariableButton vpos_power_window_pan x784 y800 w150 h50, Pan
Gui Add, Button, gsetVariableButton vpos_power_window_tilt x944 y800 w150 h50, Tilt
Gui Add, Button, gsetVariableButton vpos_power_window_rotate x784 y864 w150 h50, Rotate
Gui Add, Button, gsetVariableButton vpos_power_window_opacity x944 y864 w150 h50, Opacity
Gui Add, Button, gsetVariableButton vpos_power_window_soft_1 x1120 y736 w150 h50, Soft 1
Gui Add, Button, gsetVariableButton vpos_power_window_soft_2 x1280 y736 w150 h50, Soft 2
Gui Add, Button, gsetVariableButton vpos_power_window_soft_3 x1120 y800 w150 h50, Soft 3
Gui Add, Button, gsetVariableButton vpos_power_window_soft_4 x1280 y800 w150 h50, Soft 4
Gui Add, Button, gsetVariableButton vpos_power_window_inside x1120 y864 w150 h50, Inside
Gui Add, Button, gsetVariableButton vpos_power_window_outside x1280 y864 w150 h50, Outside

Gui Tab, 19
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\BSM Panel.png
Gui Add, Button, gsetVariableButton vpos_bsm_radius_reset x640 y368 w150 h50, Radius Reset
Gui Add, Button, gsetVariableButton vpos_bsm_reset x1440 y432 w150 h50, Blur/Sharpen/Mist Reset
Gui Add, Button, gsetVariableButton vpos_bsm_scaling_r x1200 y848 w150 h50, Scaling R
Gui Add, Button, gsetVariableButton vpos_bsm_coring_softness x320 y656 w150 h50, Coring Softness
Gui Add, Button, gsetVariableButton vpos_bsm_radius_b x568 y976 w150 h50, Radius B
Gui Add, Button, gsetVariableButton vpos_bsm_radius_link x480 y368 w150 h50, Radius Link
Gui Add, Button, gsetVariableButton vpos_bsm_ratio_reset x960 y368 w150 h50, Ratio Reset
Gui Add, Button, gsetVariableButton vpos_bsm_scaling_g x1200 y912 w150 h50, Scaling G
Gui Add, Button, gsetVariableButton vpos_bsm_scaling_link x1120 y368 w150 h50, Scaling Link
Gui Add, Button, gsetVariableButton vpos_bsm_ratio_g x880 y912 w150 h50, Ratio G
Gui Add, Button, gsetVariableButton vpos_bsm_radius_r x568 y848 w150 h50, Radius R
Gui Add, Button, gsetVariableButton vpos_bsm_scaling_reset x1280 y368 w150 h50, Scaling Reset
Gui Add, Button, gsetVariableButton vpos_bsm_level x320 y720 w150 h50, Level
Gui Add, Button, gsetVariableButton vpos_bsm_mix x320 y784 w150 h50, Mix
Gui Add, Button, gsetVariableButton vpos_bsm_ratio_b x880 y976 w150 h50, Ratio B
Gui Add, Button, gsetVariableButton vpos_bsm_scaling_b x1200 y976 w150 h50, Scaling B
Gui Add, Button, gsetVariableButton vpos_bsm_ratio_link x800 y368 w150 h50, Ratio Link
Gui Add, Button, gsetVariableButton vpos_bsm_radius_g x568 y912 w150 h50, Radius G
Gui Add, Button, gsetVariableButton vpos_bsm_ratio_r x880 y848 w150 h50, Ratio R
Gui Add, Button, gsetVariableButton vpos_bsm_blur_dot x720 y304 w150 h50, Blur Dot
Gui Add, Button, gsetVariableButton vpos_bsm_sharpen_dot x880 y304 w150 h50, Sharpen Dot
Gui Add, Button, gsetVariableButton vpos_bsm_mist_dot x1040 y304 w150 h50, Mist Dot

Gui Tab, 20
Gui Add, Picture, x480 y320 w950 h400, %A_ScriptDir%\images\Key Panel.png
Gui Add, Button, gsetVariableButton vpos_key_reset x1280 y256 w150 h50, Reset Key
Gui Add, Button, gsetVariableButton vpos_key_input_invert_matte_mask x1440 y320 w150 h50, Input Invert Matte/Mask
Gui Add, Button, gsetVariableButton vpos_key_input_invert_key x1440 y384 w150 h50, Input Invert Key
Gui Add, Button, gsetVariableButton vpos_key_output_invert_matte_mask x1440 y496 w150 h50, Output Invert Matte/Mask
Gui Add, Button, gsetVariableButton vpos_key_qualifier_invert_matte_mask x1440 y584 w150 h50, Qualifier Invert Matte/Mask
Gui Add, Button, gsetVariableButton vpos_key_qualifier_invert_key x1440 y648 w150 h50, Qualifier Invert Key
Gui Add, Button, gsetVariableButton vpos_key_input_gain x1040 y736 w150 h50, Input Gain
Gui Add, Button, gsetVariableButton vpos_key_input_offset x1256 y736 w150 h50, Input Offset
Gui Add, Button, gsetVariableButton vpos_key_input_blur_r x1040 y800 w150 h50, Input Blur R.
Gui Add, Button, gsetVariableButton vpos_key_input_blur_h_v x1256 y800 w150 h50, Input Blur H/V
Gui Add, Button, gsetVariableButton vpos_key_output_gain x1040 y864 w150 h50, Output Gain
Gui Add, Button, gsetVariableButton vpos_key_output_offset x1256 y864 w150 h50, Output Offset
Gui Add, Button, gsetVariableButton vpos_key_qualifier_gain x1040 y928 w150 h50, Qualifier Gain
Gui Add, Button, gsetVariableButton vpos_key_qualifier_offset x1256 y928 w150 h50, Qualifier Offset

Gui Tab, 21
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Motion Effects Panel.png
Gui Add, Button, gsetVariableButton vpos_motion_effects_reset x1312 y368 w120 h50, Reset Motion Effects
Gui Add, Button, gsetVariableButton vpos_motion_effects_frames x96 y432 w120 h50, Frames
Gui Add, Button, gsetVariableButton vpos_motion_effects_frames_0 x96 y496 w120 h50, Frames - 0
Gui Add, Button, gsetVariableButton vpos_motion_effects_frames_1 x96 y560 w120 h50, Frames - 1
Gui Add, Button, gsetVariableButton vpos_motion_effects_frames_2 x96 y624 w120 h50, Frames - 2
Gui Add, Button, gsetVariableButton vpos_motion_effects_frames_3 x96 y688 w120 h50, Frames - 3
Gui Add, Button, gsetVariableButton vpos_motion_effects_frames_4 x96 y752 w120 h50, Frames - 4
Gui Add, Button, gsetVariableButton vpos_motion_effects_frames_5 x96 y816 w120 h50, Frames - 5
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_mo_est_type x224 y432 w120 h50, Temporal Mo. Est. Type
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_mo_est_type_faster x224 y496 w120 h50, Temporal Mo. Type - Faster
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_mo_est_type_better x224 y560 w120 h50, Temporal Mo. Type - Better
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_mo_est_type_none x224 y624 w120 h50, Temporal Mo. Type - None
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_motion_range x352 y432 w120 h50, Temporal Motion Range
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_motion_range_large x352 y496 w120 h50, Temp. Range - Large
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_motion_range_medium x352 y560 w120 h50, Temp. Range - Medium
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_motion_range_small x352 y624 w120 h50, Temporal Range - Small
Gui Add, Button, gsetVariableButton vpos_motion_effects_reset_temporal_nr x352 y688 w120 h50, Reset Temporal NR
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_luma x480 y840 w120 h50, Temporal - Luma
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_chroma x480 y904 w120 h50, Temporal - Chroma
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_motion x480 y968 w120 h50, Temporal - Motion
Gui Add, Button, gsetVariableButton vpos_motion_effects_temporal_blend x672 y904 w120 h50, Temporal - Blend
Gui Add, Button, gsetVariableButton vpos_motion_effects_reset_temporal_threshold x672 y840 w120 h50, Reset Temporal Threshold
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_mode x616 y304 w120 h50, Mode
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_mode_faster x744 y304 w120 h50, Mode - Faster
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_mode_better x872 y304 w120 h50, Mode - Better
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_mode_enhanced x1000 y304 w120 h50, Mode - Enhanced
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_radius x616 y368 w120 h50, Radius
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_radius_small x744 y368 w120 h50, Radius - Small
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_radius_medium x872 y368 w120 h50, Radius - Medium
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_radius_large x1000 y368 w120 h50, Radius - Large
Gui Add, Button, gsetVariableButton vpos_motion_effects_reset_spatial_nr x1128 y368 w120 h50, Reset Spatial NR
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_luma x824 y840 w120 h50, Spatial - Luma
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_chroma x824 y904 w120 h50, Spatial - Chroma
Gui Add, Button, gsetVariableButton vpos_motion_effects_spatial_blend x992 y904 w120 h50, Spatial - Blend
Gui Add, Button, gsetVariableButton vpos_motion_effects_reset_spatial_threshold x992 y840 w120 h50, Reset Spatial Threshold
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_mo_est_type x1440 y464 w120 h50, Blur Mo. Est. Type
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_mo_est_type_faster x1440 y520 w120 h50, Blur - Type - Faster
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_mo_est_type_better x1440 y592 w120 h50, Blur - Type - Better
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_mo_est_type_none x1440 y656 w120 h50, Blur - Type - None
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_motion_range x1568 y464 w120 h50, Blur - Motion Range
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_motion_range_large x1568 y528 w120 h50, Blur - Range - Large
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_motion_range_medium x1568 y592 w120 h50, Blur - Range - Medium
Gui Add, Button, gsetVariableButton vpos_motion_effects_blur_motion_range_small x1568 y656 w120 h50, Blur - Range - Small
Gui Add, Button, gsetVariableButton vpos_motion_effects_motion_blur x1696 y528 w120 h50, Motion Blur
Gui Add, Button, gsetVariableButton vpos_motion_effects_reset_motion_blur x1696 y464 w120 h50, Reset Motion Blur

Gui Tab, 22
Gui Add, Picture, x40 y312 w950 h51, %A_ScriptDir%\images\Timeline Time Bar.png
Gui Add, Picture, x40 y768 w695 h278, %A_ScriptDir%\images\Timeline Position.png
Gui Add, Picture, x608 y472 w554 h262, %A_ScriptDir%\images\Preview Window.png
Gui Add, Picture, x40 y472 w529 h185, %A_ScriptDir%\images\First Clip Media Pool.png
Gui Add, Picture, x1352 y312 w529 h185, %A_ScriptDir%\images\Color Page Thumbnails.png
Gui Add, Button, gsetVariableButton vpos_timeline_time_bar x40 y250 w150 h50, Timeline Time Bar
Gui Add, Button, gsetVariableButton vpos_timeline x40 y704 w150 h50, Timeline Position
Gui Add, Button, gsetVariableButton vpos_first_media_pool_clip x40 y408 w150 h50, First Media Pool Clip
Gui Add, Button, gsetVariableButton vpos_preview_window x608 y408 w150 h50, Preview Window
Gui Add, Button, gsetVariableButton vpos_color_page_thumbnails x1352 y248 w150 h50, Color Page Thumbnails

Gui Tab

Gui Show, w1920 h1080, TWB 2.0.9

; \/ APP START \/

;Start load all positions and populate _positionsArray1 and _positionsArray2 (this function NEED to be called inside the GUI construction at the end of it)
_loadPositions()

; /\ END APP START /\

Return

GuiClose:
    ExitApp

; /\ END OF GUI INTERFACE /\

;Turn on and off all the app
F8::
    Suspend, Toggle
    _start_stop_bt()
Return

;TEST KEY - Use this for test anything in the code
F9::
    ;MsgBox Test key pressed
Return

#If (_appRunning) ;Turn on and off all the other functions of the app, making it stop if you need. Shortcut to turn on/off is F8

; \/ FUNCTIONS \/

;Start the OSC2AHK
_startOSC2AHK(){
    ;Load OSC2AHK DLL
    DllCall("LoadLibrary", "Str", "OSC2AHK.dll", "Ptr")

    ;Open OSC2AHK Port
    hWnd := WinExist()
    success := DllCall("OSC2AHK.dll\open", UInt, hWnd, UInt, 7002)
    if (success != 0){
        msgbox, Failed to open port for OSC2AHK! Please check your firewall and/or antivirus and free the port 7002
    }Else{
        msgbox, TWB is ready to be used!
    }
    
    ;Call function to add OSC2AHK Listeners
    _osc2ahkAddOrRemoveListeners()
}

;Add or remove OSC2AHK Listeners - OSC2AHK Listerners (Latest Listener used: 0x1249)
_osc2ahkAddOrRemoveListeners(addOrRemove := "add"){
    if (addOrRemove == "add"){
        ;All Panels Listeners
        DllCall("OSC2AHK.dll\addListener", AStr, "/undo", UInt, 0x1500, UInt, oscTypeInt)
        OnMessage(0x1500, "_undo")

        DllCall("OSC2AHK.dll\addListener", AStr, "/redo", UInt, 0x1501, UInt, oscTypeInt)
        OnMessage(0x1501, "_redo")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/colorPageScrollThumbnails", UInt, 0x1502, UInt, oscTypeInt)
        OnMessage(0x1502, "_colorPageScrollThumbnails")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/navigateNodes", UInt, 0x1503, UInt, oscTypeInt)
        OnMessage(0x1503, "_navigateNodes")
        
        ;Log Panel Listeners
        DllCall("OSC2AHK.dll\addListener", AStr, "/logHue", UInt, 0x1249, UInt, oscTypeInt)
        OnMessage(0x1249, "_logHue")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logHighlight", UInt, 0x1248, UInt, oscTypeInt)
        OnMessage(0x1248, "_logHighlight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logShadow", UInt, 0x1247, UInt, oscTypeInt)
        OnMessage(0x1247, "_logShadow")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logMidDetail", UInt, 0x1246, UInt, oscTypeInt)
        OnMessage(0x1246, "_logMidDetail")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logTint", UInt, 0x1245, UInt, oscTypeInt)
        OnMessage(0x1245, "_logTint")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logTemperature", UInt, 0x1244, UInt, oscTypeInt)
        OnMessage(0x1244, "_logTemperature")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logSaturation", UInt, 0x1243, UInt, oscTypeInt)
        OnMessage(0x1243, "_logSaturation")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logCoolBoost", UInt, 0x1242, UInt, oscTypeInt)
        OnMessage(0x1242, "_logCoolBoost")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logContrast", UInt, 0x1241, UInt, oscTypeInt)
        OnMessage(0x1241, "_logContrast")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logHighRange", UInt, 0x1240, UInt, oscTypeInt)
        OnMessage(0x1240, "_logHighRange")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logLowRange", UInt, 0x1239, UInt, oscTypeInt)
        OnMessage(0x1239, "_logLowRange")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logPivot", UInt, 0x1238, UInt, oscTypeInt)
        OnMessage(0x1238, "_logPivot")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logColorPicker", UInt, 0x1237, UInt, oscTypeInt)
        OnMessage(0x1237, "_logColorPicker")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logAWB", UInt, 0x1236, UInt, oscTypeInt)
        OnMessage(0x1236, "_logAWB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logResetAll", UInt, 0x1235, UInt, oscTypeInt)
        OnMessage(0x1235, "_logResetAll")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logOffsetReset", UInt, 0x1234, UInt, oscTypeInt)
        OnMessage(0x1234, "_logOffsetReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logHighlightsReset", UInt, 0x1233, UInt, oscTypeInt)
        OnMessage(0x1233, "_logHighlightsReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logMidtoneReset", UInt, 0x1232, UInt, oscTypeInt)
        OnMessage(0x1232, "_logMidtoneReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logShadowReset", UInt, 0x1231, UInt, oscTypeInt)
        OnMessage(0x1231, "_logShadowReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logOffsetB", UInt, 0x1230, UInt, oscTypeInt)
        OnMessage(0x1230, "_logOffsetB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logOffsetG", UInt, 0x1229, UInt, oscTypeInt)
        OnMessage(0x1229, "_logOffsetG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logOffsetR", UInt, 0x1228, UInt, oscTypeInt)
        OnMessage(0x1228, "_logOffsetR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logHighlightsB", UInt, 0x1227, UInt, oscTypeInt)
        OnMessage(0x1227, "_logHighlightsB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logHighlightsG", UInt, 0x1226, UInt, oscTypeInt)
        OnMessage(0x1226, "_logHighlightsG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logHighlightsR", UInt, 0x1225, UInt, oscTypeInt)
        OnMessage(0x1225, "_logHighlightsR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logMidtoneB", UInt, 0x1224, UInt, oscTypeInt)
        OnMessage(0x1224, "_logMidtoneB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logMidtoneG", UInt, 0x1223, UInt, oscTypeInt)
        OnMessage(0x1223, "_logMidtoneG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logMidtoneR", UInt, 0x1222, UInt, oscTypeInt)
        OnMessage(0x1222, "_logMidtoneR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logShadowB", UInt, 0x1221, UInt, oscTypeInt)
        OnMessage(0x1221, "_logShadowB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logShadowG", UInt, 0x1220, UInt, oscTypeInt)
        OnMessage(0x1220, "_logShadowG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logShadowR", UInt, 0x1219, UInt, oscTypeInt)
        OnMessage(0x1219, "_logShadowR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logFourthJog", UInt, 0x1218, UInt, oscTypeInt)
        OnMessage(0x1218, "_logFourthJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logThirdJog", UInt, 0x1217, UInt, oscTypeInt)
        OnMessage(0x1217, "_logThirdJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logSecondJog", UInt, 0x1216, UInt, oscTypeInt)
        OnMessage(0x1216, "_logSecondJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logFirstJog", UInt, 0x1215, UInt, oscTypeInt)
        OnMessage(0x1215, "_logFirstJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logFourthWheelY", UInt, 0x1214, UInt, oscTypeInt)
        OnMessage(0x1214, "_logFourthWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logFourthWheelX", UInt, 0x1213, UInt, oscTypeInt)
        OnMessage(0x1213, "_logFourthWheelX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logThirdWheelY", UInt, 0x1212, UInt, oscTypeInt)
        OnMessage(0x1212, "_logThirdWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logThirdWheelX", UInt, 0x1211, UInt, oscTypeInt)
        OnMessage(0x1211, "_logThirdWheelX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logSecondWheelY", UInt, 0x1210, UInt, oscTypeInt)
        OnMessage(0x1210, "_logSecondWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logSecondWheelX", UInt, 0x1209, UInt, oscTypeInt)
        OnMessage(0x1209, "_logSecondWheelX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logFirstWheelY", UInt, 0x1208, UInt, oscTypeInt)
        OnMessage(0x1208, "_logFirstWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/logFirstWheelX", UInt, 0x1207, UInt, oscTypeInt)
        OnMessage(0x1207, "_logFirstWheelX")

        ;Bars Panel Listeners
        DllCall("OSC2AHK.dll\addListener", AStr, "/barsOffsetB", UInt, 0x1206, UInt, oscTypeInt)
        OnMessage(0x1206, "_barsOffsetB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsOffsetG", UInt, 0x1205, UInt, oscTypeInt)
        OnMessage(0x1205, "_barsOffsetG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsOffsetR", UInt, 0x1204, UInt, oscTypeInt)
        OnMessage(0x1204, "_barsOffsetR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGainY", UInt, 0x1203, UInt, oscTypeInt)
        OnMessage(0x1203, "_barsGainY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGainB", UInt, 0x1202, UInt, oscTypeInt)
        OnMessage(0x1202, "_barsGainB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGainG", UInt, 0x1201, UInt, oscTypeInt)
        OnMessage(0x1201, "_barsGainG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGainR", UInt, 0x1200, UInt, oscTypeInt)
        OnMessage(0x1200, "_barsGainR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGammaB", UInt, 0x1199, UInt, oscTypeInt)
        OnMessage(0x1199, "_barsGammaB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGammaG", UInt, 0x1198, UInt, oscTypeInt)
        OnMessage(0x1198, "_barsGammaG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGammaR", UInt, 0x1197, UInt, oscTypeInt)
        OnMessage(0x1197, "_barsGammaR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsGammaY", UInt, 0x1196, UInt, oscTypeInt)
        OnMessage(0x1196, "_barsGammaY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsLiftY", UInt, 0x1195, UInt, oscTypeInt)
        OnMessage(0x1195, "_barsLiftY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsLiftB", UInt, 0x1194, UInt, oscTypeInt)
        OnMessage(0x1194, "_barsLiftB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsLiftG", UInt, 0x1193, UInt, oscTypeInt)
        OnMessage(0x1193, "_barsLiftG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsLiftR", UInt, 0x1192, UInt, oscTypeInt)
        OnMessage(0x1192, "_barsLiftR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsWhitePointPicker", UInt, 0x1191, UInt, oscTypeInt)
        OnMessage(0x1191, "_barsWhitePointPicker")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsBlackPointPicker", UInt, 0x1190, UInt, oscTypeInt)
        OnMessage(0x1190, "_barsBlackPointPicker")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsColorPicker", UInt, 0x1189, UInt, oscTypeInt)
        OnMessage(0x1189, "_barsColorPicker")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsAWB", UInt, 0x1188, UInt, oscTypeInt)
        OnMessage(0x1188, "_barsAWB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsResetAll", UInt, 0x1187, UInt, oscTypeInt)
        OnMessage(0x1187, "_barsResetAll")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsResetOffset", UInt, 0x1186, UInt, oscTypeInt)
        OnMessage(0x1186, "_barsResetOffset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsResetGain", UInt, 0x1185, UInt, oscTypeInt)
        OnMessage(0x1185, "_barsResetGain")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsResetGamma", UInt, 0x1184, UInt, oscTypeInt)
        OnMessage(0x1184, "_barsResetGamma")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsResetLift", UInt, 0x1183, UInt, oscTypeInt)
        OnMessage(0x1183, "_barsResetLift")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsLumMix", UInt, 0x1182, UInt, oscTypeInt)
        OnMessage(0x1182, "_barsLumMix")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsMidDetail", UInt, 0x1181, UInt, oscTypeInt)
        OnMessage(0x1181, "_barsMidDetail")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsHue", UInt, 0x1180, UInt, oscTypeInt)
        OnMessage(0x1180, "_barsHue")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsSaturation", UInt, 0x1179, UInt, oscTypeInt)
        OnMessage(0x1179, "_barsSaturation")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsHighlight", UInt, 0x1178, UInt, oscTypeInt)
        OnMessage(0x1178, "_barsHighlight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsShadow", UInt, 0x1177, UInt, oscTypeInt)
        OnMessage(0x1177, "_barsShadow")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsCoolBoost", UInt, 0x1176, UInt, oscTypeInt)
        OnMessage(0x1176, "_barsCoolBoost")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsPivot", UInt, 0x1175, UInt, oscTypeInt)
        OnMessage(0x1175, "_barsPivot")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsContrast", UInt, 0x1174, UInt, oscTypeInt)
        OnMessage(0x1174, "_barsContrast")

        DllCall("OSC2AHK.dll\addListener", AStr, "/barsTint", UInt, 0x1173, UInt, oscTypeInt)
        OnMessage(0x1173, "_barsTint")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/barsTemperature", UInt, 0x1172, UInt, oscTypeInt)
        OnMessage(0x1172, "_barsTemperature")
        
        ;Primaries Panel Listeners
        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesOffsetB", UInt, 0x1171, UInt, oscTypeInt)
        OnMessage(0x1171, "_primariesOffsetB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesOffsetG", UInt, 0x1170, UInt, oscTypeInt)
        OnMessage(0x1170, "_primariesOffsetG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesOffsetR", UInt, 0x1169, UInt, oscTypeInt)
        OnMessage(0x1169, "_primariesOffsetR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGainY", UInt, 0x1168, UInt, oscTypeInt)
        OnMessage(0x1168, "_primariesGainY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGainB", UInt, 0x1167, UInt, oscTypeInt)
        OnMessage(0x1167, "_primariesGainB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGainG", UInt, 0x1166, UInt, oscTypeInt)
        OnMessage(0x1166, "_primariesGainG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGainR", UInt, 0x1165, UInt, oscTypeInt)
        OnMessage(0x1165, "_primariesGainR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGammaB", UInt, 0x1164, UInt, oscTypeInt)
        OnMessage(0x1164, "_primariesGammaB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGammaG", UInt, 0x1163, UInt, oscTypeInt)
        OnMessage(0x1163, "_primariesGammaG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGammaR", UInt, 0x1162, UInt, oscTypeInt)
        OnMessage(0x1162, "_primariesGammaR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesGammaY", UInt, 0x1161, UInt, oscTypeInt)
        OnMessage(0x1161, "_primariesGammaY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesLiftY", UInt, 0x1160, UInt, oscTypeInt)
        OnMessage(0x1160, "_primariesLiftY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesLiftB", UInt, 0x1159, UInt, oscTypeInt)
        OnMessage(0x1159, "_primariesLiftB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesLiftG", UInt, 0x1158, UInt, oscTypeInt)
        OnMessage(0x1158, "_primariesLiftG")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesLiftR", UInt, 0x1157, UInt, oscTypeInt)
        OnMessage(0x1157, "_primariesLiftR")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesWhitePointPicker", UInt, 0x1156, UInt, oscTypeInt)
        OnMessage(0x1156, "_primariesWhitePointPicker")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesBlackPointPicker", UInt, 0x1155, UInt, oscTypeInt)
        OnMessage(0x1155, "_primariesBlackPointPicker")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesColorPicker", UInt, 0x1154, UInt, oscTypeInt)
        OnMessage(0x1154, "_primariesColorPicker")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesAWB", UInt, 0x1153, UInt, oscTypeInt)
        OnMessage(0x1153, "_primariesAWB")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesResetAll", UInt, 0x1152, UInt, oscTypeInt)
        OnMessage(0x1152, "_primariesResetAll")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesResetOffset", UInt, 0x1151, UInt, oscTypeInt)
        OnMessage(0x1151, "_primariesResetOffset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesResetGain", UInt, 0x1150, UInt, oscTypeInt)
        OnMessage(0x1150, "_primariesResetGain")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesResetGamma", UInt, 0x1149, UInt, oscTypeInt)
        OnMessage(0x1149, "_primariesResetGamma")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesResetLift", UInt, 0x1148, UInt, oscTypeInt)
        OnMessage(0x1148, "_primariesResetLift")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesLumMix", UInt, 0x1147, UInt, oscTypeInt)
        OnMessage(0x1147, "_primariesLumMix")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesMidDetail", UInt, 0x1146, UInt, oscTypeInt)
        OnMessage(0x1146, "_primariesMidDetail")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesHue", UInt, 0x1145, UInt, oscTypeInt)
        OnMessage(0x1145, "_primariesHue")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesSaturation", UInt, 0x1144, UInt, oscTypeInt)
        OnMessage(0x1144, "_primariesSaturation")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesHighlight", UInt, 0x1143, UInt, oscTypeInt)
        OnMessage(0x1143, "_primariesHighlight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesShadow", UInt, 0x1142, UInt, oscTypeInt)
        OnMessage(0x1142, "_primariesShadow")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesCoolBoost", UInt, 0x1141, UInt, oscTypeInt)
        OnMessage(0x1141, "_primariesCoolBoost")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesPivot", UInt, 0x1140, UInt, oscTypeInt)
        OnMessage(0x1140, "_primariesPivot")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesContrast", UInt, 0x1139, UInt, oscTypeInt)
        OnMessage(0x1139, "_primariesContrast")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesTint", UInt, 0x1138, UInt, oscTypeInt)
        OnMessage(0x1138, "_primariesTint")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesTemperature", UInt, 0x1137, UInt, oscTypeInt)
        OnMessage(0x1137, "_primariesTemperature")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesFourthJog", UInt, 0x1136, UInt, oscTypeInt)
        OnMessage(0x1136, "_primariesFourthJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesThirdJog", UInt, 0x1135, UInt, oscTypeInt)
        OnMessage(0x1135, "_primariesThirdJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesSecondJog", UInt, 0x1134, UInt, oscTypeInt)
        OnMessage(0x1134, "_primariesSecondJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesFirstJog", UInt, 0x1133, UInt, oscTypeInt)
        OnMessage(0x1133, "_primariesFirstJog")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesFourthWheelY", UInt, 0x1132, UInt, oscTypeInt)
        OnMessage(0x1132, "_primariesFourthWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesFourthWheelX", UInt, 0x1131, UInt, oscTypeInt)
        OnMessage(0x1131, "_primariesFourthWheelX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesThirdWheelY", UInt, 0x1130, UInt, oscTypeInt)
        OnMessage(0x1130, "_primariesThirdWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesThirdWheelX", UInt, 0x1129, UInt, oscTypeInt)
        OnMessage(0x1129, "_primariesThirdWheelX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesSecondWheelY", UInt, 0x1128, UInt, oscTypeInt)
        OnMessage(0x1128, "_primariesSecondWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesSecondWheelX", UInt, 0x1127, UInt, oscTypeInt)
        OnMessage(0x1127, "_primariesSecondWheelX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesFirstWheelY", UInt, 0x1126, UInt, oscTypeInt)
        OnMessage(0x1126, "_primariesFirstWheelY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/primariesFirstWheelX", UInt, 0x1125, UInt, oscTypeInt)
        OnMessage(0x1125, "_primariesFirstWheelX")

        ;HDR Panel Listeners
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneFalloff", UInt, 0x1124, UInt, oscTypeInt)
        OnMessage(0x1124, "_hdrZoneFalloff")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneMaxRange", UInt, 0x1123, UInt, oscTypeInt)
        OnMessage(0x1123, "_hdrZoneMaxRange")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrShowHideSpecular", UInt, 0x1122, UInt, oscTypeInt)
        OnMessage(0x1122, "_hdrShowHideSpecular")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrShowHideHighlight", UInt, 0x1121, UInt, oscTypeInt)
        OnMessage(0x1121, "_hdrShowHideHighlight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrShowHideLight", UInt, 0x1120, UInt, oscTypeInt)
        OnMessage(0x1120, "_hdrShowHideLight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrShowHideShadow", UInt, 0x1119, UInt, oscTypeInt)
        OnMessage(0x1119, "_hdrShowHideShadow")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrShowHideDark", UInt, 0x1118, UInt, oscTypeInt)
        OnMessage(0x1118, "_hdrShowHideDark")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrShowHideBlack", UInt, 0x1117, UInt, oscTypeInt)
        OnMessage(0x1117, "_hdrShowHideBlack")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTurnOnOffSpecular", UInt, 0x1116, UInt, oscTypeInt)
        OnMessage(0x1116, "_hdrTurnOnOffSpecular")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTurnOnOffHighlight", UInt, 0x1115, UInt, oscTypeInt)
        OnMessage(0x1115, "_hdrTurnOnOffHighlight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTurnOnOffLight", UInt, 0x1114, UInt, oscTypeInt)
        OnMessage(0x1114, "_hdrTurnOnOffLight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTurnOnOffShadow", UInt, 0x1113, UInt, oscTypeInt)
        OnMessage(0x1113, "_hdrTurnOnOffShadow")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTurnOnOffDark", UInt, 0x1112, UInt, oscTypeInt)
        OnMessage(0x1112, "_hdrTurnOnOffDark")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTurnOnOffBlack", UInt, 0x1111, UInt, oscTypeInt)
        OnMessage(0x1111, "_hdrTurnOnOffBlack")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFourthWheelReset", UInt, 0x1110, UInt, oscTypeInt)
        OnMessage(0x1110, "_hdrFourthWheelReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrThirdWheelReset", UInt, 0x1109, UInt, oscTypeInt)
        OnMessage(0x1109, "_hdrThirdWheelReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrSecondWheelReset", UInt, 0x1108, UInt, oscTypeInt)
        OnMessage(0x1108, "_hdrSecondWheelReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFirstWheelReset", UInt, 0x1107, UInt, oscTypeInt)
        OnMessage(0x1107, "_hdrFirstWheelReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrThirdWheelHL", UInt, 0x1106, UInt, oscTypeInt)
        OnMessage(0x1106, "_hdrThirdWheelHL")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrSecondWheelHL", UInt, 0x1105, UInt, oscTypeInt)
        OnMessage(0x1105, "_hdrSecondWheelHL")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFirstWheelHL", UInt, 0x1104, UInt, oscTypeInt)
        OnMessage(0x1104, "_hdrFirstWheelHL")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrResetZone", UInt, 0x1103, UInt, oscTypeInt)
        OnMessage(0x1103, "_hdrResetZone")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrResetColor", UInt, 0x1102, UInt, oscTypeInt)
        OnMessage(0x1102, "_hdrResetColor")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrResetAll", UInt, 0x1101, UInt, oscTypeInt)
        OnMessage(0x1101, "_hdrResetAll")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrWheelsRight", UInt, 0x1100, UInt, oscTypeInt)
        OnMessage(0x1100, "_hdrWheelsRight")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrWheelsLeft", UInt, 0x1099, UInt, oscTypeInt)
        OnMessage(0x1099, "_hdrWheelsLeft")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneSpecular", UInt, 0x1097, UInt, oscTypeInt)
        OnMessage(0x1097, "_hdrZoneSpecular")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneHighlight", UInt, 0x1096, UInt, oscTypeInt)
        OnMessage(0x1096, "_hdrZoneHighlight")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneLight", UInt, 0x1095, UInt, oscTypeInt)
        OnMessage(0x1095, "_hdrZoneLight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneShadow", UInt, 0x1094, UInt, oscTypeInt)
        OnMessage(0x1094, "_hdrZoneShadow")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneDark", UInt, 0x1093, UInt, oscTypeInt)
        OnMessage(0x1093, "_hdrZoneDark")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneBlack", UInt, 0x1092, UInt, oscTypeInt)
        OnMessage(0x1092, "_hdrZoneBlack")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrZoneOpenClose", UInt, 0x1091, UInt, oscTypeInt)
        OnMessage(0x1091, "_hdrZoneOpenClose")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrBlackOffset", UInt, 0x1090, UInt, oscTypeInt)
        OnMessage(0x1090, "_hdrBlackOffset")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrMD", UInt, 0x1089, UInt, oscTypeInt)
        OnMessage(0x1089, "_hdrMD")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrPivot", UInt, 0x1088, UInt, oscTypeInt)
        OnMessage(0x1088, "_hdrPivot")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrContrast", UInt, 0x1087, UInt, oscTypeInt)
        OnMessage(0x1087, "_hdrContrast")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrHue", UInt, 0x1086, UInt, oscTypeInt)
        OnMessage(0x1086, "_hdrHue")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTint", UInt, 0x1085, UInt, oscTypeInt)
        OnMessage(0x1085, "_hdrTint")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrTemperature", UInt, 0x1084, UInt, oscTypeInt)
        OnMessage(0x1084, "_hdrTemperature")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFourthWheelSaturation", UInt, 0x1083, UInt, oscTypeInt)
        OnMessage(0x1083, "_hdrFourthWheelSaturation")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFourthWheelExposure", UInt, 0x1082, UInt, oscTypeInt)
        OnMessage(0x1082, "_hdrFourthWheelExposure")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrThirdWheelSaturation", UInt, 0x1081, UInt, oscTypeInt)
        OnMessage(0x1081, "_hdrThirdWheelSaturation")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrThirdWheelExposure", UInt, 0x1080, UInt, oscTypeInt)
        OnMessage(0x1080, "_hdrThirdWheelExposure")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrSecondWheelSaturation", UInt, 0x1079, UInt, oscTypeInt)
        OnMessage(0x1079, "_hdrSecondWheelSaturation")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrSecondWheelExposure", UInt, 0x1078, UInt, oscTypeInt)
        OnMessage(0x1078, "_hdrSecondWheelExposure")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFirstWheelSaturation", UInt, 0x1077, UInt, oscTypeInt)
        OnMessage(0x1077, "_hdrFirstWheelSaturation")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFirstWheelExposure", UInt, 0x1076, UInt, oscTypeInt)
        OnMessage(0x1076, "_hdrFirstWheelExposure")

        ;DllCall("OSC2AHK.dll\addListener", AStr, "/jogHDRFourthWheel", UInt, 0x1075, UInt, oscTypeInt)
        ;OnMessage(0x1075, "_jogHDRFourthWheel") ;Inactive for now, remove comment to activate and don't forget to remove the comment on the function

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFalloffThirdWheel", UInt, 0x1074, UInt, oscTypeInt)
        OnMessage(0x1074, "_hdrFalloffThirdWheel")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFalloffSecondWheel", UInt, 0x1073, UInt, oscTypeInt)
        OnMessage(0x1073, "_hdrFalloffSecondWheel")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFalloffFirstWheel", UInt, 0x1072, UInt, oscTypeInt)
        OnMessage(0x1072, "_hdrFalloffFirstWheel")

        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFourthWheelY", UInt, 0x1071, UInt, oscTypeInt)
        OnMessage(0x1071, "_hdrFourthWheelY")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFourthWheelX", UInt, 0x1070, UInt, oscTypeInt)
        OnMessage(0x1070, "_hdrFourthWheelX")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrThirdWheelY", UInt, 0x1069, UInt, oscTypeInt)
        OnMessage(0x1069, "_hdrThirdWheelY")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrThirdWheelX", UInt, 0x1068, UInt, oscTypeInt)
        OnMessage(0x1068, "_hdrThirdWheelX")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrSecondWheelY", UInt, 0x1067, UInt, oscTypeInt)
        OnMessage(0x1067, "_hdrSecondWheelY")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrSecondWheelX", UInt, 0x1066, UInt, oscTypeInt)
        OnMessage(0x1066, "_hdrSecondWheelX")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFirstWheelY", UInt, 0x1065, UInt, oscTypeInt)
        OnMessage(0x1065, "_hdrFirstWheelY")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/hdrFirstWheelX", UInt, 0x1064, UInt, oscTypeInt)
        OnMessage(0x1064, "_hdrFirstWheelX")

        ;Inspector Panel Listeners
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorLinkUnlinkZoom", UInt, 0x1060, UInt, oscTypeInt)
        OnMessage(0x1060, "_inspectorLinkUnlinkZoom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorAudioReset", UInt, 0x1059, UInt, oscTypeInt)
        OnMessage(0x1059, "_inspectorAudioReset")

        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorTransformReset", UInt, 0x1058, UInt, oscTypeInt)
        OnMessage(0x1058, "_inspectorTransformReset")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorAudioVolume", UInt, 0x1057, UInt, oscTypeInt)
        OnMessage(0x1057, "_inspectorAudioVolume")

        DllCall("OSC2AHK.dll\addListener", AStr, "/openInspectorAudio", UInt, 0x1056, UInt, oscTypeInt)
        OnMessage(0x1056, "_openInspectorAudio")

        DllCall("OSC2AHK.dll\addListener", AStr, "/openInspectorVideo", UInt, 0x1055, UInt, oscTypeInt)
        OnMessage(0x1055, "_openInspectorVideo")

        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorFlip", UInt, 0x1054, UInt, oscTypeInt)
        OnMessage(0x1054, "_inspectorFlip")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorYaw", UInt, 0x1053, UInt, oscTypeInt)
        OnMessage(0x1053, "_inspectorYaw")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorAnchorPointY", UInt, 0x1052, UInt, oscTypeInt)
        OnMessage(0x1052, "_inspectorAnchorPointY")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorAnchorPointX", UInt, 0x1051, UInt, oscTypeInt)
        OnMessage(0x1051, "_inspectorAnchorPointX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorPitch", UInt, 0x1050, UInt, oscTypeInt)
        OnMessage(0x1050, "_inspectorPitch")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorPositionY", UInt, 0x1049, UInt, oscTypeInt)
        OnMessage(0x1049, "_inspectorPositionY")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorPositionX", UInt, 0x1048, UInt, oscTypeInt)
        OnMessage(0x1048, "_inspectorPositionX")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorRotationAngle", UInt, 0x1047, UInt, oscTypeInt)
        OnMessage(0x1047, "_inspectorRotationAngle")

        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorZoomY", UInt, 0x1046, UInt, oscTypeInt)
        OnMessage(0x1046, "_inspectorZoomY")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/inspectorZoomX", UInt, 0x1045, UInt, oscTypeInt)
        OnMessage(0x1045, "_inspectorZoomX")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/goToInspectorWindow", UInt, 0x1044, UInt, oscTypeInt)
        OnMessage(0x1044, "_goToInspectorWindow")
        
        ;Edit Panel Listeners
        DllCall("OSC2AHK.dll\addListener", AStr, "/inOut", UInt, 0x1098, UInt, oscTypeInt)
        OnMessage(0x1098, "_inOut")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/clipEditPointFrameStep", UInt, 0x1063, UInt, oscTypeInt)
        OnMessage(0x1063, "_clipEditPointFrameStep")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/moveTimeline", UInt, 0x1062, UInt, oscTypeInt)
        OnMessage(0x1062, "_moveTimeline")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/timelineZoom", UInt, 0x1061, UInt, oscTypeInt)
        OnMessage(0x1061, "_timelineZoom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/enterEditMode", UInt, 0x1043, UInt, oscTypeInt)
        OnMessage(0x1043, "_enterEditMode")

        DllCall("OSC2AHK.dll\addListener", AStr, "/changeEditActiveWindow", UInt, 0x1042, UInt, oscTypeInt)
        OnMessage(0x1042, "_changeEditActiveWindow")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseRightExpander", UInt, 0x1041, UInt, oscTypeInt)
        OnMessage(0x1041, "_openCloseRightExpander")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseInspector", UInt, 0x1040, UInt, oscTypeInt)
        OnMessage(0x1040, "_openCloseInspector")

        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseMetadata", UInt, 0x1039, UInt, oscTypeInt)
        OnMessage(0x1039, "_openCloseMetadata")

        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseMixer", UInt, 0x1038, UInt, oscTypeInt)
        OnMessage(0x1038, "_openCloseMixer")

        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseSoundLibrary", UInt, 0x1037, UInt, oscTypeInt)
        OnMessage(0x1037, "_openCloseSoundLibrary")

        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseEditIndex", UInt, 0x1036, UInt, oscTypeInt)
        OnMessage(0x1036, "_openCloseEditIndex")

        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseEffectsLibrary", UInt, 0x1035, UInt, oscTypeInt)
        OnMessage(0x1035, "_openCloseEffectsLibrary")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseMediaPool", UInt, 0x1034, UInt, oscTypeInt)
        OnMessage(0x1034, "_openCloseMediaPool")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/openCloseLeftExpander", UInt, 0x1033, UInt, oscTypeInt)
        OnMessage(0x1033, "_openCloseLeftExpander")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/addClipToTheEnd", UInt, 0x1032, UInt, oscTypeInt)
        OnMessage(0x1032, "_addClipToTheEnd")

        DllCall("OSC2AHK.dll\addListener", AStr, "/fitToFillClip", UInt, 0x1031, UInt, oscTypeInt)
        OnMessage(0x1031, "_fitToFillClip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/rippleOverwriteClip", UInt, 0x1030, UInt, oscTypeInt)
        OnMessage(0x1030, "_rippleOverwriteClip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/replaceClip", UInt, 0x1029, UInt, oscTypeInt)
        OnMessage(0x1029, "_replaceClip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/overwriteClip", UInt, 0x1028, UInt, oscTypeInt)
        OnMessage(0x1028, "_overwriteClip")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/insertClip", UInt, 0x1027, UInt, oscTypeInt)
        OnMessage(0x1027, "_insertClip")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/bladeTool", UInt, 0x1026, UInt, oscTypeInt)
        OnMessage(0x1026, "_bladeTool")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/trimMode", UInt, 0x1025, UInt, oscTypeInt)
        OnMessage(0x1025, "_trimMode")

        DllCall("OSC2AHK.dll\addListener", AStr, "/selectionTool", UInt, 0x1024, UInt, oscTypeInt)
        OnMessage(0x1024, "_selectionTool")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/altUpDown", UInt, 0x1023, UInt, oscTypeInt)
        OnMessage(0x1023, "_altUpDown")

        DllCall("OSC2AHK.dll\addListener", AStr, "/leftRightEnter", UInt, 0x1022, UInt, oscTypeInt)
        OnMessage(0x1022, "_leftRightEnter")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/upDownEnter", UInt, 0x1021, UInt, oscTypeInt)
        OnMessage(0x1021, "_upDownEnter")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/selectFwBwActiveTrack", UInt, 0x1020, UInt, oscTypeInt)
        OnMessage(0x1020, "_selectFwBwActiveTrack")

        DllCall("OSC2AHK.dll\addListener", AStr, "/homeEnd", UInt, 0x1019, UInt, oscTypeInt)
        OnMessage(0x1019, "_homeEnd")

        DllCall("OSC2AHK.dll\addListener", AStr, "/cutCopyPaste", UInt, 0x1018, UInt, oscTypeInt)
        OnMessage(0x1018, "_cutCopyPaste")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/addAVTransitions", UInt, 0x1017, UInt, oscTypeInt)
        OnMessage(0x1017, "_addAVTransitions")

        DllCall("OSC2AHK.dll\addListener", AStr, "/retimeClipSpeed", UInt, 0x1016, UInt, oscTypeInt)
        OnMessage(0x1016, "_retimeClipSpeed")

        DllCall("OSC2AHK.dll\addListener", AStr, "/swapClips", UInt, 0x1015, UInt, oscTypeInt)
        OnMessage(0x1015, "_swapClips")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/selectDeselectAll", UInt, 0x1014, UInt, oscTypeInt)
        OnMessage(0x1014, "_selectDeselectAll")

        DllCall("OSC2AHK.dll\addListener", AStr, "/selectForwardBackward", UInt, 0x1013, UInt, oscTypeInt)
        OnMessage(0x1013, "_selectForwardBackward")

        DllCall("OSC2AHK.dll\addListener", AStr, "/addRemoveSetMark", UInt, 0x1012, UInt, oscTypeInt)
        OnMessage(0x1012, "_addRemoveSetMark")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/saveProject", UInt, 0x1010, UInt, oscTypeInt)
        OnMessage(0x1010, "_saveProject")

        DllCall("OSC2AHK.dll\addListener", AStr, "/toggleFullscreen", UInt, 0x1009, UInt, oscTypeInt)
        OnMessage(0x1009, "_toggleFullscreen")

        DllCall("OSC2AHK.dll\addListener", AStr, "/pasteAttributes", UInt, 0x1008, UInt, oscTypeInt)
        OnMessage(0x1008, "_pasteAttributes")

        DllCall("OSC2AHK.dll\addListener", AStr, "/linkUnlinkClips", UInt, 0x1007, UInt, oscTypeInt)
        OnMessage(0x1007, "_linkUnlinkClips")

        DllCall("OSC2AHK.dll\addListener", AStr, "/deleteSelection", UInt, 0x1006, UInt, oscTypeInt)
        OnMessage(0x1006, "_deleteSelection")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/closestEditPoint", UInt, 0x1005, UInt, oscTypeInt)
        OnMessage(0x1005, "_closestEditPoint")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/closestClipGap", UInt, 0x1004, UInt, oscTypeInt)
        OnMessage(0x1004, "_closestClipGap")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/delEndToPlayhead", UInt, 0x1003, UInt, oscTypeInt)
        OnMessage(0x1003, "_delEndToPlayhead")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/delStartToPlayhead", UInt, 0x1002, UInt, oscTypeInt)
        OnMessage(0x1002, "_delStartToPlayhead")
        
        DllCall("OSC2AHK.dll\addListener", AStr, "/cutAllTimelines", UInt, 0x1001, UInt, oscTypeInt)
        OnMessage(0x1001, "_cutAllTimelines")
    }Else{
        DllCall("OSC2AHK.dll\removeListener", AStr, "/undoRedo", UInt, 0x1011, UInt, oscTypeInt)
        OnMessage(0x1011, "_undoRedo")

        
        ;Inspector Panel Listeners
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorAudioReset", UInt, 0x1059, UInt, oscTypeInt)
        OnMessage(0x1059, "_inspectorAudioReset")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorTransformReset", UInt, 0x1058, UInt, oscTypeInt)
        OnMessage(0x1058, "_inspectorTransformReset")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorAudioVolume", UInt, 0x1057, UInt, oscTypeInt)
        OnMessage(0x1057, "_inspectorAudioVolume")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/openInspectorAudio", UInt, 0x1056, UInt, oscTypeInt)
        OnMessage(0x1056, "_openInspectorAudio")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/openInspectorVideo", UInt, 0x1055, UInt, oscTypeInt)
        OnMessage(0x1055, "_openInspectorVideo")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorFlip", UInt, 0x1054, UInt, oscTypeInt)
        OnMessage(0x1054, "_inspectorFlip")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorYaw", UInt, 0x1053, UInt, oscTypeInt)
        OnMessage(0x1053, "_inspectorYaw")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorAnchorPointY", UInt, 0x1052, UInt, oscTypeInt)
        OnMessage(0x1052, "_inspectorAnchorPointY")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorAnchorPointX", UInt, 0x1051, UInt, oscTypeInt)
        OnMessage(0x1051, "_inspectorAnchorPointX")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorPitch", UInt, 0x1050, UInt, oscTypeInt)
        OnMessage(0x1050, "_inspectorPitch")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorPositionY", UInt, 0x1049, UInt, oscTypeInt)
        OnMessage(0x1049, "_inspectorPositionY")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorPositionX", UInt, 0x1048, UInt, oscTypeInt)
        OnMessage(0x1048, "_inspectorPositionX")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorRotationAngle", UInt, 0x1047, UInt, oscTypeInt)
        OnMessage(0x1047, "_inspectorRotationAngle")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorZoomY", UInt, 0x1046, UInt, oscTypeInt)
        OnMessage(0x1046, "_inspectorZoomY")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/inspectorZoomX", UInt, 0x1045, UInt, oscTypeInt)
        OnMessage(0x1045, "_inspectorZoomX")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/goToInspectorWindow", UInt, 0x1044, UInt, oscTypeInt)
        OnMessage(0x1044, "_goToInspectorWindow")
        
        ;Edit Panel Listeners
        DllCall("OSC2AHK.dll\removeListener", AStr, "/enterEditMode", UInt, 0x1043, UInt, oscTypeInt)
        OnMessage(0x1043, "_enterEditMode")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/changeEditActiveWindow", UInt, 0x1042, UInt, oscTypeInt)
        OnMessage(0x1042, "_changeEditActiveWindow")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseRightExpander", UInt, 0x1041, UInt, oscTypeInt)
        OnMessage(0x1041, "_openCloseRightExpander")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseInspector", UInt, 0x1040, UInt, oscTypeInt)
        OnMessage(0x1040, "_openCloseInspector")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseMetadata", UInt, 0x1039, UInt, oscTypeInt)
        OnMessage(0x1039, "_openCloseMetadata")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseMixer", UInt, 0x1038, UInt, oscTypeInt)
        OnMessage(0x1038, "_openCloseMixer")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseSoundLibrary", UInt, 0x1037, UInt, oscTypeInt)
        OnMessage(0x1037, "_openCloseSoundLibrary")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseEditIndex", UInt, 0x1036, UInt, oscTypeInt)
        OnMessage(0x1036, "_openCloseEditIndex")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseEffectsLibrary", UInt, 0x1035, UInt, oscTypeInt)
        OnMessage(0x1035, "_openCloseEffectsLibrary")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseMediaPool", UInt, 0x1034, UInt, oscTypeInt)
        OnMessage(0x1034, "_openCloseMediaPool")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/openCloseLeftExpander", UInt, 0x1033, UInt, oscTypeInt)
        OnMessage(0x1033, "_openCloseLeftExpander")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/addClipToTheEnd", UInt, 0x1032, UInt, oscTypeInt)
        OnMessage(0x1032, "_addClipToTheEnd")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/fitToFillClip", UInt, 0x1031, UInt, oscTypeInt)
        OnMessage(0x1031, "_fitToFillClip")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/rippleOverwriteClip", UInt, 0x1030, UInt, oscTypeInt)
        OnMessage(0x1030, "_rippleOverwriteClip")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/replaceClip", UInt, 0x1029, UInt, oscTypeInt)
        OnMessage(0x1029, "_replaceClip")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/overwriteClip", UInt, 0x1028, UInt, oscTypeInt)
        OnMessage(0x1028, "_overwriteClip")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/insertClip", UInt, 0x1027, UInt, oscTypeInt)
        OnMessage(0x1027, "_insertClip")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/bladeTool", UInt, 0x1026, UInt, oscTypeInt)
        OnMessage(0x1026, "_bladeTool")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/trimMode", UInt, 0x1025, UInt, oscTypeInt)
        OnMessage(0x1025, "_trimMode")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/selectionTool", UInt, 0x1024, UInt, oscTypeInt)
        OnMessage(0x1024, "_selectionTool")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/altUpDown", UInt, 0x1023, UInt, oscTypeInt)
        OnMessage(0x1023, "_altUpDown")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/leftRightEnter", UInt, 0x1022, UInt, oscTypeInt)
        OnMessage(0x1022, "_leftRightEnter")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/upDownEnter", UInt, 0x1021, UInt, oscTypeInt)
        OnMessage(0x1021, "_upDownEnter")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/selectFwBwActiveTrack", UInt, 0x1020, UInt, oscTypeInt)
        OnMessage(0x1020, "_selectFwBwActiveTrack")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/homeEnd", UInt, 0x1019, UInt, oscTypeInt)
        OnMessage(0x1019, "_homeEnd")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/cutCopyPaste", UInt, 0x1018, UInt, oscTypeInt)
        OnMessage(0x1018, "_cutCopyPaste")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/addAVTransitions", UInt, 0x1017, UInt, oscTypeInt)
        OnMessage(0x1017, "_addAVTransitions")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/retimeClipSpeed", UInt, 0x1016, UInt, oscTypeInt)
        OnMessage(0x1016, "_retimeClipSpeed")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/swapClips", UInt, 0x1015, UInt, oscTypeInt)
        OnMessage(0x1015, "_swapClips")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/selectDeselectAll", UInt, 0x1014, UInt, oscTypeInt)
        OnMessage(0x1014, "_selectDeselectAll")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/selectForwardBackward", UInt, 0x1013, UInt, oscTypeInt)
        OnMessage(0x1013, "_selectForwardBackward")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/addRemoveSetMark", UInt, 0x1012, UInt, oscTypeInt)
        OnMessage(0x1012, "_addRemoveSetMark")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/saveProject", UInt, 0x1010, UInt, oscTypeInt)
        OnMessage(0x1010, "_saveProject")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/toggleFullscreen", UInt, 0x1009, UInt, oscTypeInt)
        OnMessage(0x1009, "_toggleFullscreen")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/pasteAttributes", UInt, 0x1008, UInt, oscTypeInt)
        OnMessage(0x1008, "_pasteAttributes")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/linkUnlinkClips", UInt, 0x1007, UInt, oscTypeInt)
        OnMessage(0x1007, "_linkUnlinkClips")

        DllCall("OSC2AHK.dll\removeListener", AStr, "/deleteSelection", UInt, 0x1006, UInt, oscTypeInt)
        OnMessage(0x1006, "_deleteSelection")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/closestEditPoint", UInt, 0x1005, UInt, oscTypeInt)
        OnMessage(0x1005, "_closestEditPoint")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/closestClipGap", UInt, 0x1004, UInt, oscTypeInt)
        OnMessage(0x1004, "_closestClipGap")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/delEndToPlayhead", UInt, 0x1003, UInt, oscTypeInt)
        OnMessage(0x1003, "_delEndToPlayhead")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/delStartToPlayhead", UInt, 0x1002, UInt, oscTypeInt)
        OnMessage(0x1002, "_delStartToPlayhead")
        
        DllCall("OSC2AHK.dll\removeListener", AStr, "/cutAllTimelines", UInt, 0x1001, UInt, oscTypeInt)
        OnMessage(0x1001, "_cutAllTimelines")

        ;DllCall("OSC2AHK.dll\removeListener", AStr, "/enterPrimaries", UInt, 0x1100, UInt, oscTypeInt)
        ;OnMessage(0x1100, "_enterPrimaries")
       ;
        ;DllCall("OSC2AHK.dll\removeListener", AStr, "/enterColorMode", UInt, 0x1101, UInt, oscTypeInt)
        ;OnMessage(0x1101, "_enterColorMode")
    }
}

;===== Load and position functions =====

;Load the positions of each element on the screen from a external file (depends of what resolution / dpi scale is seted)
_loadPositions(){
    ;Set the Combo Box Resolution/Scale for the latest Resolution/Scale used
    GuiControl, Text, comboboxResolutionScale, %_resolutionAndScale%
    
    ;Reset _positionsArray1 and _positionsArray2 (comment this two next lines if you're using the variables inside the code)
    _positionsArray1 := []
    _positionsArray2 := []

    ;Set a counter from 1 to 3 so loop knows if it is Var (1), X(2), Y(3)
    counter := 1

    ;Set a counter for the Array Position
    arrayPos := 1
    
    ;set a flag to know when changing from one array to another and reset the arrayPos and counter variables
    firstTimeHere := "true"

    ;Loop through resolution/dps scale ini file to populate the arrays (_positionsArray1 and _positionsArray2)
    Loop, read, %A_ScriptDir%\res_dpi_scale.ini
    {
        Loop, parse, A_LoopReadLine, %A_Tab%
        {
            if (InStr(A_Loopfield, _resolutionAndScale) == 0){
                continue
            }
            
            if (InStr(A_Loopfield, "Array1") != 0){
                switch (counter){
                    Case 1:
                        object := []
                        _positionsArray1.Push(object)
                        
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _positionsArray1[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 2:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _positionsArray1[arrayPos].x := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 3:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _positionsArray1[arrayPos].y := SubStr(A_Loopfield, startingPos + 1)
                        
                        counter := 1
                        arrayPos++
                    continue
                }
            }Else if (InStr(A_Loopfield, "Array2") != 0){
                ;If to reset the variables so array 2 can start from the begin
                if(firstTimeHere == "true"){
                    arrayPos := 1
                    counter := 1
                    firstTimeHere := "false"
                }
                
                switch (counter){
                    Case 1:
                        object := []
                        _positionsArray2.Push(object)
                        
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _positionsArray2[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)
                        
                        counter++
                    continue
                    Case 2:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _positionsArray2[arrayPos].x := SubStr(A_Loopfield, startingPos + 1)
                        
                        counter++
                    continue
                    Case 3:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _positionsArray2[arrayPos].y := SubStr(A_Loopfield, startingPos + 1)

                        counter := 1
                        arrayPos++
                    continue
                }
            }Else{
                ;msgbox "Resolution Information: " %A_Loopfield%
            }
        }
    }
}

;Load the Edit Windows status of the last session from windows_status.ini
_loadWindowsStatus(){
    ;Set a counter from 1 to 3 so loop knows if it is Var (1), X(2), Y(3)
    counter := 1
    
    ;Set a counter for the Array Position
    arrayPos := 1
    
    ;set a flag to know when changing from one array to another and reset the arrayPos and counter variables
    firstTimeHere := "true"

    ;Loop through resolution/dps scale ini file to populate the arrays (_positionsArray1 and _positionsArray2)
    Loop, read, %A_ScriptDir%\windows_status.ini
    {
        Loop, parse, A_LoopReadLine, %A_Tab%
        {
            if (InStr(A_Loopfield, "WINDOW") != 0){
                continue
            }Else{
                switch (counter){
                    Case 1:
                        object := []
                        _editPageWindowsStatus.Push(object)
                        
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _editPageWindowsStatus[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 2:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _editPageWindowsStatus[arrayPos].status := SubStr(A_Loopfield, startingPos + 1)
                        
                        ;Check if the variable is the last page used and if yes, set the _actualPage as the variable
                        if (_editPageWindowsStatus[arrayPos].status == "EDIT" OR _editPageWindowsStatus[arrayPos].status == "COLOR"){
                            _actualPage := _editPageWindowsStatus[arrayPos].status
                        }
                        
                        counter := 1
                        arrayPos++
                    continue
                }
            }
        }
    }
}

;Save all the actual seted positions on the position INI file
_save_positions_bt(){
   _updateIniResScaleFile(_resolutionAndScale)
}

;Enable the last button used to save a position so you can set it again
_enableLastButton(){
    GuiControl, Enable, %_lastButtonUsed%
}

;Get the mouse actual position and store the X and Y on the respective object variable inside the _positionsArray1 or _positionsArray2
_changePositionVariable(){
    MouseGetPos, mousePosX, mousePosY

    variableFound := "false"

    For index, object in _positionsArray1
    if (object.var == _variableToSet) {
        object.x := mousePosX
        object.y := mousePosY
        
        variableFound := "true"
    }
    
    if (variableFound == "false"){
        For index, object in _positionsArray2
        if (object.var == _variableToSet) {
            object.x := mousePosX
            object.y := mousePosY
            
            variableFound := "true"
        }
    }
    
    _isSetingVariable := "false"
    _variableToSet := ""
}

;Write in the INI file all the positions stored on the _positionsArray1 and _positionsArray2 under the respective resolution
_updateIniResScaleFile(resolutionScale) {
    For arrayNum, array in _positionsArray1
        For index, varxy in ["var", "x", "y"]
        IniWrite, % array[varxy], %A_ScriptDir%\res_dpi_scale.ini, %resolutionScale%, Array1 - %_resolutionAndScale% - %arrayNum%%varxy%
        
    For arrayNum, array in _positionsArray2
        For index, varxy in ["var", "x", "y"]
        IniWrite, % array[varxy], %A_ScriptDir%\res_dpi_scale.ini, %resolutionScale%, Array2 - %_resolutionAndScale% - %arrayNum%%varxy%
}

;Change the combobox for the latest resolution/scale saved in the _resolutionAndScale variable and write it on the INI file. After that, load all the positions inside the _positionsArray1 and _positionsArray2
_changeResolutionAndScale(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
    GuiControlGet, comboboxResolutionScale
    _resolutionAndScale := comboboxResolutionScale
    
    IniWrite, %_resolutionAndScale%, %A_ScriptDir%\resolution.ini, RESOLUTION, lastResScale
    
    _loadPositions()
}

;Call the input Box where user will type the new resolution/scale bank name
_addComboboxItemsInputBox(){
    InputBox, newResolutionItem, Add a new resolution config, Please enter the name of the resolution config. ONLY NUMBERS AND LETTERS ARE ACCEPTED so please do not use special characters or space., , 400, 180
    if (ErrorLevel){
        ;MsgBox Cancel button was pressed
    }Else {
        _addcomboboxItems(newResolutionItem)
    }
}

;Add a new resolution configuration to the combobox
_addcomboboxItems(item) {
    ;Add the new item to the combobox
    GuiControl,, comboboxResolutionScale, %item%
    
    ;Add the new item to the variable that stores all the combobox items
    _comboboxItems := _comboboxItems . "|" . item
    
    ;Write the new item on the ini file for future load
    IniWrite, %_comboboxItems%, %A_ScriptDir%\resolution.ini, RESOLUTION, comboboxItems
    
    ;Change the resolution and scale variable to the new item
    _resolutionAndScale := item
    
    ;Change the combobox for the new item
    GuiControl, Text, comboboxResolutionScale, %_resolutionAndScale%
    
    ;Reset and populate the _positionsArray1 and _positionsArray2 with the new positions and write the new positions on the INI file too
    _updateIniResScaleFile(_resolutionAndScale)
}

;Save all the windows status on the windows_status.ini
_saveWindowsStatus() {
    For arrayNum, array in _editPageWindowsStatus
        For index, varstatus in ["var", "status"]
        IniWrite, % array[varstatus], %A_ScriptDir%\windows_status.ini, EDIT WINDOWS STATUS, %arrayNum%%varstatus%
}

;DEBUG FUNCTION JUST FOR CHECK IF THE RESOLUTION VARIABLE AND POSITION ARRAYS ARE CORRECT
;_checkRes(){
    ;msgbox %_resolutionAndScale%
    ;
    ;var1 := _positionsArray1[1].var
    ;x1 := _positionsArray1[1].x
    ;y1 := _positionsArray1[1].y
    ;msgbox "Var1: " %var1% "X1: " %x1% "Y1: " %y1%
    ;
    ;var219 := _positionsArray1[219].var
    ;x219 := _positionsArray1[219].x
    ;y219 := _positionsArray1[219].y
    ;msgbox "Var219: " %var219% "X219: " %x219% "Y219: " %y219%
    ;
    ;var1 := _positionsArray2[1].var
    ;x1 := _positionsArray2[1].x
    ;y1 := _positionsArray2[1].y
    ;msgbox "Var1: " %var1% "X1: " %x1% "Y1: " %y1%
    ;
    ;var187 := _positionsArray2[187].var
    ;x187 := _positionsArray2[187].x
    ;y187 := _positionsArray2[187].y
    ;msgbox "Var187: " %var187% "X187: " %x187% "Y187: " %y187%
;}

;===== End of Load and Position Functions =====

;===== Mouse Functions =====

;Move mouse on determined axis, incrementing or reducing the determined value - Axis can be "X" or "Y" - Action can be "plus" or "minus" - Value can be any positive value
_moveMouseOnAxis(axis, action, value){
    MouseGetPos MousePosX, MousePosY

    Switch axis{
        Case "X":
            if (action == "plus"){
                MouseMove MousePosX+Value, MousePosY
            }Else{
                MouseMove MousePosX-Value, MousePosY
            }
        Case "Y":
            if (action == "plus"){
                MouseMove MousePosX, MousePosY+Value
            }Else{
                MouseMove MousePosX, MousePosY-Value
            }
    }
}

;Move mouse to object position
_moveMouseToPosition(object){
    object := _returnObject(object)
    
    MouseMove, object["x"], object["y"], 0
}

;Move mouse and click on object
_moveMouseAndClick(object){
    object := _returnObject(object)
    
    MouseClick Left, object["x"], object["y"], 1, 0
}

;Move mouse and double click on object
_moveMouseAndDoubleClick(object){
    object := _returnObject(object)

    MouseClick Left, object["x"], object["y"], 2, 10
}

;Move mouse and start grabing object
_moveMouseAndDrag(objectName, data, axis){
    if (_activeController != objectName){
        ;Release the mouse of any other controller before start
        _releaseAllControls()

        object := _returnObject(objectName)
        
        ;Setup the variable with the controller being used
        _activeController := objectName

        ;Move mouse to the controller position
        MouseMove object.x, object.y, 0
            
        ;Start grabing and set a timer to auto release
        GetKeyState, LbuttonState, LButton, P
        if (LbuttonState = "U"){
            Send, {LButton Down}
            
            _startAutoReleaseTimer()
        }
    }
    
    if (axis == "x"){
        setTimer, _autoReleaseControls, Off
        _startAutoReleaseTimer()
        
        MouseGetPos, mousePosX, mousePosY
        MouseMove mousePosX + data, mousePosY, 0
    }Else {
        setTimer, _autoReleaseControls, Off
        _startAutoReleaseTimer()
        
        MouseGetPos, mousePosX, mousePosY
        MouseMove mousePosX, mousePosY - data, 0
    }
}

;Make mouse scroll with or without a alternate key pressed
_mouseScroll(direction, alternateKey := "NONE"){
    Switch (alternateKey){
        Case "NONE":
            if (direction == "UP"){
                MouseClick WheelUp
            }Else{
                MouseClick WheelDown
            }
        Return
        Case "CTRL":
            if (direction == "UP"){
                Send, {Ctrl Down}
                MouseClick WheelUp
                Send, {Ctrl Up}
            }Else{
                Send, {Ctrl Down}
                MouseClick WheelDown
                Send, {Ctrl Up}
            }
        Return
        Case "SHIFT":
            if (direction == "UP"){
                Send, {Shift Down}
                MouseClick WheelUp
                Send, {Shift Up}
            }Else{
                Send, {Shift Down}
                MouseClick WheelDown
                Send, {Shift Up}
            }
        Return
        Case "ALT":
            if (direction == "UP"){
                Send, {Alt Down}
                MouseClick WheelUp
                Send, {Alt Up}
            }Else{
                Send, {Alt Down}
                MouseClick WheelDown
                Send, {Alt Up}
            }
        Return
        Case "WIN":
            if (direction == "UP"){
                Send, {LWin Down}
                MouseClick WheelUp
                Send, {LWin Up}
            }Else{
                Send, {LWin Down}
                MouseClick WheelDown
                Send, {LWin Up}
            }
        Return
    }
}

_moveMouseAndKeep(objectName){
    object := _returnObject(objectName)
    
    ;Move mouse to the controller position
    MouseMove object.x, object.y, 0
        
    ;Start grabing and set a timer to auto release
    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
        Send, {LButton Down}
    }
}

;Release the mouse grab
_releaseMouseGrabing(){
    GetKeyState, LbuttonState, LButton, P
	if !(LbuttonState = "U"){
   	    Send, {LButton Up}
    }
}

;Save on global variables the actual global mouse position
_setGlobalMousePos(){
    MouseGetPos, mousePosX, mousePosY
    
    _globalMousePosX := mousePosX
    _globalMousePosY := mousePosY
}

;===== End of Mouse Functions =====

;===== DLLCall Functions =====

;----- Color mode functions -----

;***** LOG Wheels mode functions *****

;Knob - Increment, decrement or reset Hue value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logHue(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_hue", 50)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_hue", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Highlight value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logHighlight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_high_light", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_high_light", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Shadow value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logShadow(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_shadow", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_shadow", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Mid Detail value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logMidDetail(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_middetail", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_middetail", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Tint value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logTint(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_tint", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_tint", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Temperature value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logTemperature(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_temperature", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_temperature", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Saturation value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logSaturation(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_saturation", 50)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_saturation", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Cool Boost value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logCoolBoost(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_cool_boost", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_cool_boost", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Contrast value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logContrast(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_contrast", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_contrast", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset High Range value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logHighRange(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_high_range", 0.550)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_high_range", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Low Range value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logLowRange(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_low_range", 0.333)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_low_range", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Pivot value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logPivot(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_pivot", 0.435)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_pivot", data, "x")
        Return
    }
}

;Button - Select Color Picker on Log Panel
_logColorPicker(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return

    _moveMouseAndClick("pos_awb_picker")
}

;Button - Auto Balance Colors on Log Panel
_logAWB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return

    _moveMouseAndClick("pos_auto_balance")
}

;Button - Reset All Log Panel
_logResetAll(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return

    _moveMouseAndClick("pos_primaries_reset")
}

;Button - Reset Offset Wheel on Log Panel
_logOffsetReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return

    _moveMouseAndClick("pos_fourth_wheel_reset")
}

;Button - Reset Highlights Wheel on Log Panel
_logHighlightsReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return

    _moveMouseAndClick("pos_third_wheel_reset")
}

;Button - Reset Midtone Wheel on Log Panel
_logMidtoneReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return

    _moveMouseAndClick("pos_second_wheel_reset")
}

;Button - Reset Shadow Wheel on Log Panel
_logShadowReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return

    _moveMouseAndClick("pos_first_wheel_reset")
}

;Knob - Increment, decrement or reset Offset R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logOffsetB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_b", 25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Offset R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logOffsetG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_g", 25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Offset R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logOffsetR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_r", 25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Highlights R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logHighlightsB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_highlights_b", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_highlights_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Highlights R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logHighlightsG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_highlights_g", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_highlights_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Highlights R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logHighlightsR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_highlights_r", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_highlights_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Midtone R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logMidtoneB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_midtone_b", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_midtone_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Midtone R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logMidtoneG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_midtone_g", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_midtone_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Midtone R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logMidtoneR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_midtone_r", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_midtone_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Shadow B valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logShadowB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_shadow_b", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_shadow_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Shadow G valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logShadowG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_shadow_g", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_shadow_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Shadow R valeu in LOG - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logShadowR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_log_shadow_r", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_log_shadow_r", data, "x")
        Return
    }
}

;Jog - Increment (right) or decrement (left) the LOG Offset Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFourthJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return
    
    _moveMouseAndDrag("pos_fourth_jog", data, "x")
}

;Jog - Increment (right) or decrement (left) the LOG Highlights Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logThirdJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return
    
    _moveMouseAndDrag("pos_third_jog", data, "x")
}

;Jog - Increment (right) or decrement (left) the LOG Midtones Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logSecondJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return
    
    _moveMouseAndDrag("pos_second_jog", data, "x")
}

;Jog - Increment (right) or decrement (left) the LOG Shadow Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "LOG") == 0)
    Return
    
    _moveMouseAndDrag("pos_first_jog", data, "x")
}

;Trackball - Move up/down the trackball to move the Y axis at the LOG Offset - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFourthWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_fourth_wheel", data, "y")
        Return
    }
}

;Trackball - Move up/down the trackball to move the X axis at the LOG Offset - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFourthWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_fourth_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the LOG Highlights - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logThirdWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_third_wheel", data, "y")
        Return
    }
}

;Trackball - Move up/down the trackball to move the X axis at the LOG Highlights - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logThirdWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_third_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the LOG Midtones - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logSecondWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_second_wheel", data, "y")
        Return
    }
}

;Trackball - Move up/down the trackball to move the X axis at the LOG Midtones - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logSecondWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_second_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the LOG Shadow - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_first_wheel", data, "y")
        Return
    }
}

;Trackball - Move up/down the trackball to move the X axis at the LOG Shadow - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("LOG") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_first_wheel", data, "x")
        Return
    }
}

;***** End Of Log Wheels mode functions *****

;***** Primaries Bars mode functions *****

;Knob - Increment, decrement or reset Offset Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsOffsetB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_b", 25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Offset Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsOffsetG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_g", 25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Offset Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsOffsetR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_r",25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGainY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_y", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGainB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_b", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGainG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_g", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGainR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_r", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGammaB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_b", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGammaG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_g", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGammaR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_r", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsGammaY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_y", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_y", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_b", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_g", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_r", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_r", data, "x")
        Return
    }
}

;Button - Select White Point Picker on Primaries Panel
_barsWhitePointPicker(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_primaries_white_point_picker")
}

;Button - Select Black Point Picker on Primaries Panel
_barsBlackPointPicker(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_primaries_black_point_picker")
}

;Button - Select Color Picker on Primaries Panel
_barsColorPicker(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_awb_picker")
}

;Button - Auto Balance Colors on Primaries Panel
_barsAWB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_auto_balance")
}

;Button - Reset All Bars Panel
_barsResetAll(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_primaries_reset")
}

;Button - Reset Offset Wheel on Primaries Panel
_barsResetOffset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_fourth_wheel_reset")
}

;Button - Reset Gain Wheel on Primaries Panel
_barsResetGain(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_third_wheel_reset")
}

;Button - Reset Gamma Wheel on Primaries Panel
_barsResetGamma(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_second_wheel_reset")
}

;Button - Reset Lift Wheel on Primaries Panel
_barsResetLift(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "BARS") == 0)
    Return

    _moveMouseAndClick("pos_first_wheel_reset")
}

;Knob - Increment, decrement or reset Lum Mix value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsLumMix(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lum_mix", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lum_mix", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Mid Detail value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsMidDetail(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_middetail", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_middetail", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Hue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsHue(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_hue", 50)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_hue", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Saturation value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsSaturation(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_saturation", 50)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_saturation", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Highlight value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsHighlight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_high_light", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_high_light", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Shadow value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsShadow(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_shadow", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_shadow", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Cool Boost value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsCoolBoost(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_cool_boost", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_cool_boost", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Pivot value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsPivot(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_pivot", 0.435)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_pivot", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Contrast value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsContrast(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_contrast", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_contrast", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Tint value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsTint(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_tint", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_tint", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Temperature value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_barsTemperature(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("BARS") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_temp", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_temp", data, "x")
        Return
    }
}

;***** End of Primaries Bars mode functions *****

;***** Primaries Wheels mode functions *****

;Knob - Increment, decrement or reset Offset Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesOffsetB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_b", 25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Offset Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesOffsetG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_g", 25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Offset Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesOffsetR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_offset_r",25)
        Return
    }Else{
        _moveMouseAndDrag("pos_offset_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_y", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_b", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_g", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gain_r", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gain_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGammaB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_b", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGammaG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_g", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGammaR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_r", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_r", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Gamma Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGammaY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_gamma_y", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_gamma_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesLiftY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_y", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesLiftB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_b", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_b", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesLiftG(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_g", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_g", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesLiftR(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lift_r", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lift_r", data, "x")
        Return
    }
}

;Button - Select White Point Picker on Primaries Panel
_primariesWhitePointPicker(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_primaries_white_point_picker")
}

;Button - Select Black Point Picker on Primaries Panel
_primariesBlackPointPicker(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_primaries_black_point_picker")
}

;Button - Select Color Picker on Primaries Panel
_primariesColorPicker(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_awb_picker")
}

;Button - Auto Balance Colors on Primaries Panel
_primariesAWB(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_auto_balance")
}

;Button - Reset All Primaries Panel
_primariesResetAll(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_primaries_reset")
}

;Button - Reset Offset Wheel on Primaries Panel
_primariesResetOffset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_fourth_wheel_reset")
}

;Button - Reset Gain Wheel on Primaries Panel
_primariesResetGain(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_third_wheel_reset")
}

;Button - Reset Gamma Wheel on Primaries Panel
_primariesResetGamma(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_second_wheel_reset")
}

;Button - Reset Lift Wheel on Primaries Panel
_primariesResetLift(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return

    _moveMouseAndClick("pos_first_wheel_reset")
}

;Knob - Increment, decrement or reset Lum Mix value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesLumMix(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_lum_mix", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_lum_mix", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Mid Detail value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesMidDetail(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_middetail", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_middetail", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Hue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesHue(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_hue", 50)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_hue", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Saturation value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesSaturation(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_saturation", 50)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_saturation", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Highlight value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesHighlight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_high_light", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_high_light", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Shadow value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesShadow(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_shadow", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_shadow", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Cool Boost value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesCoolBoost(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_cool_boost", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_cool_boost", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Pivot value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesPivot(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_pivot", 0.435)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_pivot", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Contrast value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesContrast(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_contrast", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_contrast", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Tint value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesTint(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_tint", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_tint", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Temperature value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesTemperature(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_primaries_temp", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_primaries_temp", data, "x")
        Return
    }
}

;Jog - Increment (right) or decrement (left) the Primaries Offset Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFourthJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return
    
    _moveMouseAndDrag("pos_fourth_jog", data, "x")
}

;Jog - Increment (right) or decrement (left) the Primaries Gain Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesThirdJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return
    
    _moveMouseAndDrag("pos_third_jog", data, "x")
}

;Jog - Increment (right) or decrement (left) the Primaries Gamma Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesSecondJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return
    
    _moveMouseAndDrag("pos_second_jog", data, "x")
}

;Jog - Increment (right) or decrement (left) the Primaries Lift Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFirstJog(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "PRIMARIES") == 0)
    Return
    
    _moveMouseAndDrag("pos_first_jog", data, "x")
}

;Trackball - Move up/down the trackball to move the Y axis at the Primaries Offset - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFourthWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_fourth_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the Primaries Offset - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFourthWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_fourth_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the Primaries Gain - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesThirdWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_third_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the Primaries Gain - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesThirdWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_third_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the Primaries Gamma - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesSecondWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_second_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the Primaries Gamma - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesSecondWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_second_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the Primaries Lift - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFirstWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_first_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the Primaries Lift - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFirstWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("PRIMARIES") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_first_wheel", data, "x")
        Return
    }
}

;***** End of Primaries Wheels mode functions *****

;***** HDR Panel Functions *****

;Jog - Increment (right) or decrement (left) Max Range Value on HDR Zones - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_hdrZoneFalloff(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndDrag("pos_zone_falloff", data, "x")
}

;Jog - Increment (right) or decrement (left) Max Range Value on HDR Zones - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_hdrZoneMaxRange(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndDrag("pos_zone_max_range", data, "x")
}

;Button - Turn on/off Specular zone on HDR Panel
_hdrShowHideSpecular(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_show_hide_specular")
}

;Button - Turn on/off Highlight zone on HDR Panel
_hdrShowHideHighlight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_show_hide_highlight")
}

;Button - Turn on/off Light zone on HDR Panel
_hdrShowHideLight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_show_hide_light")
}

;Button - Turn on/off Shadow zone on HDR Panel
_hdrShowHideShadow(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_show_hide_shadow")
}

;Button - Turn on/off Dark zone on HDR Panel
_hdrShowHideDark(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_show_hide_dark")
}

;Button - Turn on/off Black zone on HDR Panel
_hdrShowHideBlack(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_show_hide_black")
}

;Button - Turn on/off Specular zone on HDR Panel
_hdrTurnOnOffSpecular(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_on_off_specular")
}

;Button - Turn on/off Highlight zone on HDR Panel
_hdrTurnOnOffHighlight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_on_off_highlight")
}

;Button - Turn on/off Light zone on HDR Panel
_hdrTurnOnOffLight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_on_off_light")
}

;Button - Turn on/off Shadow zone on HDR Panel
_hdrTurnOnOffShadow(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_on_off_shadow")
}

;Button - Turn on/off Dark zone on HDR Panel
_hdrTurnOnOffDark(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_on_off_dark")
}

;Button - Turn on/off Black zone on HDR Panel
_hdrTurnOnOffBlack(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return

    _moveMouseAndClick("pos_zone_on_off_black")
}

;Button - Reset only the Fourth Wheel on HDR Wheels
_hdrFourthWheelReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _moveMouseAndClick("pos_fourth_wheel_reset")
}

;Button - Reset only the Third Wheel on HDR Wheels
_hdrThirdWheelReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _moveMouseAndClick("pos_third_wheel_reset")
}

;Button - Reset only the Second Wheel on HDR Wheels
_hdrSecondWheelReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _moveMouseAndClick("pos_second_wheel_reset")
}

;Button - Reset only the First Wheel on HDR Wheels
_hdrFirstWheelReset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _moveMouseAndClick("pos_first_wheel_reset")
}

;Button - Keep pressed to show HDR Third Wheel Highlight and release to turn off
_hdrThirdWheelHL(oscType, data, msgID, hwnd){
    _checkForHDRHighlight(data, "HDR", "THIRD")
}

;Button - Keep pressed to show HDR Second Wheel Highlight and release to turn off
_hdrSecondWheelHL(oscType, data, msgID, hwnd){
    _checkForHDRHighlight(data, "HDR", "SECOND")
}

;Button - Keep pressed to show HDR First Wheel Highlight and release to turn off
_hdrFirstWheelHL(oscType, data, msgID, hwnd){
    _checkForHDRHighlight(data, "HDR", "FIRST")
}

;Button - Reset only HDR Zone modifications
_hdrResetZone(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _resetHDRPanels("ZONE")
}

;Button - Reset only HDR Color modifications
_hdrResetColor(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _resetHDRPanels("COLOR")
}

;Button - Reset all HDR modifications
_hdrResetAll(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _resetHDRPanels("ALL")
}

;Button - Move HDR Wheels panels to the right
_hdrWheelsRight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _moveMouseAndClick("pos_hdr_wheels_right_arrow")
}

;Button - Move HDR Wheels panels to the left
_hdrWheelsLeft(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return

    _moveMouseAndClick("pos_hdr_wheels_left_arrow")
}

;Button - select Light zone on HDR Zone Panel
_hdrZoneSpecular(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndClick("pos_zone_specular")
}

;Button - select Light zone on HDR Zone Panel
_hdrZoneHighlight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndClick("pos_zone_highlight")
}

;Button - select Light zone on HDR Zone Panel
_hdrZoneLight(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndClick("pos_zone_light")
}

;Button - select Shadow zone on HDR Zone Panel
_hdrZoneShadow(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndClick("pos_zone_shadow")
}

;Button - select Dark zone on HDR Zone Panel
_hdrZoneDark(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndClick("pos_zone_dark")
}

;Button - select Black zone on HDR Zone Panel
_hdrZoneBlack(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR", true) == 0)
    Return
    
    _moveMouseAndClick("pos_zone_black")
}

;Button - Open or Close the HDR Zone Panel (Toggle). The status of the panel is saved on windows_status.ini and is 0 to closed and 1 to open
_hdrZoneOpenClose(oscType, data, msgID, hwnd){
    if (_checkIfColorPanelData0(data, "HDR") == 0)
    Return
    
    _openCloseHDRZone()
}

;Knob - Increment, decrement or reset MD value on HDR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrBlackOffset(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_hdr_black_offset", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_black_offset", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset MD value on HDR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrMD(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_hdr_md", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_md", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Pivot value on HDR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrPivot(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_hdr_pivot", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_pivot", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Contrast value on HDR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrContrast(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_hdr_contrast", 1)
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_contrast", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Hue value on HDR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrHue(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_hdr_hue", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_hue", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Tint value on HDR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrTint(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_hdr_tint", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_tint", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Temperature value on HDR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrTemperature(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _resetForSpecificValue("pos_hdr_temperature", 0)
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_temperature", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset saturation value on HDR Fourth Wheel - Default Knob Sensitivity: Min: 0 - Max: 5000 - Step: 1 - Coarse
_hdrFourthWheelSaturation(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_fourth_wheel_sat")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_fourth_wheel_sat", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset exposure value on HDR Fourth Wheel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrFourthWheelExposure(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_fourth_wheel_exp")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_fourth_wheel_exp", data, "x")
        Return
    }
}

;Knob - Turn left/right to increment or decrement falloff value on the third HDR Wheel - Default Knob Sensitivity: Min: 0 - Max: 5000 - Step: 1 - Coarse
_hdrFalloffThirdWheel(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_third_wheel_falloff", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset saturation value on HDR Third Wheel - Default Knob Sensitivity: Min: 0 - Max: 5000 - Step: 1 - Coarse
_hdrThirdWheelSaturation(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_third_wheel_sat")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_third_wheel_sat", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset exposure value on HDR Third Wheel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrThirdWheelExposure(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_third_wheel_exp")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_third_wheel_exp", data, "x")
        Return
    }
}

;Knob - Turn left/right to increment or decrement falloff value on the second HDR Wheel - Default Knob Sensitivity: Min: 0 - Max: 5000 - Step: 1 - Coarse
_hdrFalloffSecondWheel(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_second_wheel_falloff", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset saturation value on HDR Second Wheel - Default Knob Sensitivity: Min: 0 - Max: 5000 - Step: 1 - Coarse
_hdrSecondWheelSaturation(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_second_wheel_sat")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_second_wheel_sat", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset exposure value on HDR Second Wheel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrSecondWheelExposure(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_second_wheel_exp")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_second_wheel_exp", data, "x")
        Return
    }
}

;Knob - Turn left/right to increment or decrement falloff value on the first HDR Wheel - Default Knob Sensitivity: Min: 0 - Max: 5000 - Step: 1 - Coarse
_hdrFalloffFirstWheel(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_first_wheel_falloff", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset saturation value on HDR First Wheel - Default Knob Sensitivity: Min: 0 - Max: 5000 - Step: 1 - Coarse
_hdrFirstWheelSaturation(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_first_wheel_sat")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_first_wheel_sat", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset exposure value on HDR First Wheel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrFirstWheelExposure(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return

    if (data == 0){
        _moveMouseAndDoubleClick("pos_hdr_first_wheel_exp")
        Return
    }Else{
        _moveMouseAndDrag("pos_hdr_first_wheel_exp", data, "x")
        Return
    }
}

;Jog - Fourth HDR Wheel (Inactive, remove comment to activate and don't forget to remove the comment on listeners)- Default Jog Sensitivity: Min:  - Max: - Step:  - 
;_jogHDRFourthWheel(oscType, data, msgID, hwnd){

;}

;Trackball - Move up/down the trackball to move the Y axis at the fourth HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrFourthWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_fourth_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the fourth HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrFourthWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_fourth_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the third HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrThirdWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_third_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the third HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrThirdWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_third_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the second HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrSecondWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_second_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the second HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrSecondWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_second_wheel", data, "x")
        Return
    }
}

;Trackball - Move up/down the trackball to move the Y axis at the first HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrFirstWheelY(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_first_wheel", data, "y")
        Return
    }
}

;Trackball - Move left/right the trackball to move the X axis at the first HDR Wheel - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrFirstWheelX(oscType, data, msgID, hwnd){
    if (_checkIfColorPanel("HDR") == false)
    Return
    
    if (data == 0){
        Return
    }Else{
        _moveMouseAndDrag("pos_first_wheel", data, "x")
        Return
    }
}

;***** End of HDR Panel Functions *****

;----- End of Color Mode Functions -----

;----- Edit Mode Functions -----

;***** Inspector Functions *****

;Jog - Turn left/right to step frames with clip/edit point - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_clipEditPointFrameStep(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        Return
    }Else if(data < 0){
        Send, {,}
        Return
    }Else if(data > 0){
        Send, {.}
        Return
    }
}

;Jog - Turn left to go backward on timeline and right to go forward - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_moveTimeline(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        Return
    }Else if(data < 0){
        _moveMouseToPosition("pos_timeline_time_bar")
        _mouseScroll("UP", "CTRL")
        Return
    }Else if(data > 0){
        _moveMouseToPosition("pos_timeline_time_bar")
        _mouseScroll("DOWN", "CTRL")
        Return
    }
}

;Jog - Turn left to zoom out and right to zoom in - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_timelineZoom(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        Return
    }Else if(data < 0){
        Send, ^{-}
        Return
    }Else if(data > 0){
        Send, ^{=}
        Return
    }
}

;Button - Open or close Right Expander
_inspectorLinkUnlinkZoom(oscType, data, msgID, hwnd){
    if (data == 0 OR _checkIfEditInspector() == false)
    Return
    
    _moveMouseAndClick("pos_inspector_zoom_link")
}

;Button - Reset all audio inspector
_inspectorAudioReset(oscType, data, msgID, hwnd){
    if (data == 0 OR _checkIfEditInspector(0) == false)
    Return
    
    _moveMouseAndClick("pos_inspector_audio_reset")
}

;Button - Reset all transform inspector
_inspectorTransformReset(oscType, data, msgID, hwnd){
    if (data == 0 OR _checkIfEditInspector() == false)
    Return
    
    _moveMouseAndClick("pos_inspector_transform_reset")
}

;Knob - Increment, decrement or reset Inspector Volume - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorAudioVolume(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector(0) == false)
    Return

    if (data == 0){
        _moveMouseAndClick("pos_inspector_volume_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_volume", data, "x")
        Return
    }
}

;Button - Open the Vide Inspector Window (NOT IN USE - DELETE THIS COMMENT IF USING IT)
_openInspectorAudio(oscType, data, msgID, hwnd){
    if (data == 0 OR _checkIfEditInspector() == false)
    Return
    
    _moveMouseAndClick("pos_inspector_video")
}

;Button - Open the Audio Inspector Window (NOT IN USE - DELETE THIS COMMENT IF USING IT)
_openInspectorVideo(oscType, data, msgID, hwnd){
    if (data == 0 OR _checkIfEditInspector(0) == false)
    Return
    
    _moveMouseAndClick("pos_inspector_audio")
}

;Knob - Turn left to flip the clip horizontally and right to flip vertically (toggle), and press the knob to reset - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_inspectorFlip(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_flip_reset")
        Return
    }Else if(data < 0){
        _moveMouseAndClick("pos_inspector_horizontal_flip")
        Return
    }Else if(data > 0){
        _moveMouseAndClick("pos_inspector_vertical_flip")        
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Yaw - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorYaw(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_yaw_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_yaw", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Anchor Point Y - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorAnchorPointY(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_anchor_point_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_anchor_point_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Anchor Point X - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorAnchorPointX(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_anchor_point_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_anchor_point_x", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Pitch - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorPitch(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_pitch_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_pitch", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Position Y - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorPositionY(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_position_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_position_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Position X - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorPositionX(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_position_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_position_x", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Rotation Angle - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorRotationAngle(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_rotation_angle_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_rotation_angle", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Zoom Y - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorZoomY(oscType, data, msgID, hwnd){
    if (_checkIfEditInspector() == false)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_zoom_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_zoom_y", data, "x")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Zoom X - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorZoomX(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT" OR _getWindow("pos_edit_top_bts_inspector").status == 0 OR _getWindow("pos_inspector_video").status != 1)
    Return
    
    if (data == 0){
        _moveMouseAndClick("pos_inspector_zoom_reset")
        Return
    }Else{
        _moveMouseAndDrag("pos_inspector_zoom_x", data, "x")
        Return
    }
}

;***** End of Inspector Functions *****

;***** Edit Functions *****

;Knob - Change between windows on Edit Page - Can be Timeline (right) or Preview (left) - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_changeEditActiveWindow(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }

    if (data == 0){
        Return
    }Else if (data < 0){
        _moveMouseAndClick("pos_preview_window")
        Return
    }Else if (data > 0){
        _moveMouseAndClick("pos_timeline")
        Return
    }
}

;Button - Open or close Right Expander
_openCloseRightExpander(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    _openCloseWindow("pos_edit_top_bts_right_expand")
}

;Button - Open or close Inspector window
_openCloseInspector(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    _openCloseWindow("pos_edit_top_bts_inspector")
}

;Button - Open or close Metadata window
_openCloseMetadata(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    _openCloseWindow("pos_edit_top_bts_metadata")
}

;Button - Open or close Mixer window
_openCloseMixer(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    _openCloseWindow("pos_edit_top_bts_mixer")
}

;Button - Open or close Sound Library window
_openCloseSoundLibrary(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    _openCloseWindow("pos_edit_top_bts_sound_library")
}

;Button - Open or close Edit Index window
_openCloseEditIndex(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    _openCloseWindow("pos_edit_top_bts_edit_index")
}

;Button - Open or close Effects Library window
_openCloseEffectsLibrary(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    _openCloseWindow("pos_edit_top_bts_effects_library")
}

;Button - Open or close Media Pool window
_openCloseMediaPool(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    _openCloseWindow("pos_edit_top_bts_media_pool")
}

;Button - Open or close Left Expander
_openCloseLeftExpander(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    _openCloseWindow("pos_edit_top_bts_left_expand")
}

;Button to Shortcut - Add a clip to the end of timeline - Davinci Resolve default shortcut -> Shift + F12
_addClipToTheEnd(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    send +{F12}
}

;Button to Shortcut - Fit to Fill Clip on timeline - Davinci Resolve default shortcut -> Shift + F11
_fitToFillClip(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    send +{F11}
}

;Button to Shortcut - Ripple Overwrite Clip on timeline - Davinci Resolve default shortcut -> Shift + F10
_rippleOverwriteClip(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    send +{F10}
}

;Button to Shortcut - Replace Clip on timeline - Davinci Resolve default shortcut -> F11
_replaceClip(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    send {F11}
}

;Button to Shortcut - Overwrite Clip on timeline - Davinci Resolve default shortcut -> F10
_overwriteClip(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    send {F10}
}

;Button to Shortcut - Insert Clip on timeline - Davinci Resolve default shortcut -> F9
_insertClip(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    send {F9}
}

;Button to Shortcut - Select Blade tool - Davinci Resolve default shortcut -> B
_bladeTool(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    send {b}
}

;Knob to Shortcut - Select Trim tool or Dynamic Trim tool - Davinci Resolve default shortcut -> T / W - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_trimMode(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send {w}
        Return
    }Else if (data > 0){
        Send {t}
        Return
    }
}

;Button to Shortcut - Select Selection tool - Davinci Resolve default shortcut -> A
_selectionTool(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
        
    send {a}
}

;Knob to Shortcut - Move clips through tracks up and down - Davinci Resolve default shortcut -> Alt + Up Arrow / Alt + Down Arrow - Default Knob Sensitivity: Min: 0 - Max: 8 - Step: 1 - Coarse
_altUpDown(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send !{up}
        Return
    }Else if (data > 0){
        Send !{down}
        Return
    }
}

;Knob to Shortcut - Select all clips of the active track backward and forward - Davinci Resolve default shortcut -> Y / Ctrl + Y - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_selectFwBwActiveTrack(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^{y}
        Return
    }Else if (data > 0){
        Send {y}
        Return
    }
}

;Knob to Shortcut - Delete what is selected, left is delete and right is backspace - Davinci Resolve default shortcut -> Delete and Backspace - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_deleteSelection(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send {del}
        Return
    }Else if (data > 0){
        Send {backspace}
        Return
    }
}

;Knob to Shortcut - Add audio transition, video transition or both - Davinci Resolve default shortcut -> Shift + T / Alt + T / Ctrl + T - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_addAVTransitions(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Send ^{t}
        Return
    }Else if (data < 0){
        Send +{t}
        Return
    }Else if (data > 0){
        Send !{t}
        Return
    }
}

;Knob to Shortcut - Open Change Clip Speed window (left) or put clip on retime mode (right) - Davinci Resolve default shortcut -> Ctrl + R / R - Default Knob Sensitivity: Min: 0 - Max: 5 - Step: 1 - Coarse
_retimeClipSpeed(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^{r}
        Return
    }Else if (data > 0){
        Send {r}
        Return
    }
}

;Knob to Shortcut - Swap clip towards right and left - Davinci Resolve default shortcut -> Ctrl + Shift + , / Ctrl + Shift + . - Default Knob Sensitivity: Min: 0 - Max: 8 - Step: 1 - Coarse
_swapClips(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^+{,}
        Return
    }Else if (data > 0){
        Send ^+{.}
        Return
    }
}

;Knob to Shortcut - Add a mark, remove a mark and setup a mark - Davinci Resolve default shortcut -> M / Alt + M / Ctrl + M - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_addRemoveSetMark(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Send ^{m}
        Return
    }Else if (data < 0){
        Send !{m}
        Return
    }Else if (data > 0){
        Send {m}
        Return
    }
}

;Knob to Shortcut - Select (right) and deselect (left) all clips - Davinci Resolve default shortcut -> Ctrl + A / Ctrl + Shift + A - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_selectDeselectAll(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^+{a}
        Return
    }Else if (data > 0){
        Send ^{a}
        Return
    }
}

;Knob to Shortcut - Select all clips backward (left) and forward (right) - Davinci Resolve default shortcut -> Alt + Y / Ctrl + Alt + Y - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_selectForwardBackward(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^!{y}
        Return
    }Else if (data > 0){
        Send !{y}
        Return
    }
}

;Knob to Shortcut - In/Out (left/right) timeline or preview - Davinci Resolve default shortcut -> I / O / Alt + I / Alt + O - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_inOut(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        Return
    }
    
    if (data == 0){
        Send !{i}
        Sleep 10
        Send !{o}
        Return
    }Else if (data < 0){
        Send {i}
        Return
    }Else if (data > 0){
        Send {o}
        Return
    }
}

;Button to Shortcut - Paste attributes from other clip - Davinci Resolve default shortcut -> Alt + V
_pasteAttributes(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    Send !{v}
}

;Button to Shortcut - Link/Unlink clips on timeline - Davinci Resolve default shortcut -> Ctrl + Alt + L
_linkUnlinkClips(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    Send ^!{l}
}

;Button to Shortcut - Select the closest edit point - Davinci Resolve default shortcut -> V
_closestEditPoint(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    Send {v}
}

;Button to Shortcut - Select the closest clip or gap - Davinci Resolve default shortcut -> Shift + V
_closestClipGap(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    Send +{v}
}

;Button to Shortcut - Delete all the content from the end of the clip until the playhead - Davinci Resolve default shortcut -> Ctrl + Shift + ]
_delEndToPlayhead(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    Send ^+{]}
}

;Button to Shortcut - Delete all the content from the begin of the clip until the playhead - Davinci Resolve default shortcut -> Ctrl + Shift + [
_delStartToPlayhead(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    Send ^+{[}
}

;Button to Shortcut - Cut all selected clips or all tracks if none is selected - Davinci Resolve default shortcut -> Ctrl + B
_cutAllTimelines(oscType, data, msgID, hwnd){
    if (_checkIfEditOrData0(data) == false){
        Return
    }
    
    Send ^{b}
}

;***** End of Edit Mode Functions *****

;***** Other DLL Call Functions *****

;Button to Shortcut - Set mode to EDIT and open the inspector
_enterEditMode(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    _changePage("EDIT", "INSPECTOR")
}

;Set mode to EDIT and go to EDIT Page and open the inspector
_goToInspectorWindow(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    if (_actualPage != "EDIT"){
        _changePage("EDIT", "INSPECTOR")
    }Else{
        ;Check if inspector is closed, if is closed it send command to open
        if (_getWindow("pos_edit_top_bts_inspector").status == 0){
            _openCloseInspector(oscTypeInt, 1, 0, hWnd)
        }
    }
}


;Set mode to COLOR, open color page and set the panel to Primaries Wheels with custom curves (default davinci mode)
_enterColorMode(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    _changePage("COLOR")
}

;***** End of Other DLL Call Functions *****

;***** All Modes Functions *****

;Button - Undo - Davinci Resolve default shortcut -> Ctrl + Z
_undo(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{z}
}

;Button - Redo - Davinci Resolve default shortcut -> Ctrl + Shift + Z
_redo(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^+{z}
}

;Jog - Alternate Key + First Jog Wheel can be used to move the thumbnails to left and right in Color Page - Default Jog Sensitivity - Min. 0 - Max: 100 - Step: 1 - Coarse
_colorPageScrollThumbnails(oscType, data, msgID, hwnd){
    _changePage("COLOR")
    
    _moveMouseToPosition("pos_color_page_thumbnails")
    
    if (data <= 0){
        _mouseScroll("UP")
    }Else{
        _mouseScroll("DOWN")
    }
}

;Jog - Alternate Key + Fourth Jog Wheel can be used to navigate between nodes in Color Page - Default Jog Sensitivity - Min. 0 - Max: 10 - Step: 1 - Coarse (This use a not Davinci Default Shortcut - You need add the shortcuts Shift + Y for Next Node and Shift + U for Previous Node)
_navigateNodes(oscType, data, msgID, hwnd){
    _changePage("COLOR")

    if (data <= 0){
        Send +{Y}
    }Else{
        Send +{U}        
    }
}

;Enter/Exit on fullscreen mode - Davinci Resolve default shortcut -> Ctrl + F
_toggleFullscreen(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{f}
}

;Save project - Davinci Resolve default shortcut -> Ctrl + S
_saveProject(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{s}
}

;Home (left) or End (right) - Davinci Resolve default shortcut -> Home / End - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_homeEnd(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send {home}
        Return
    }Else if (data > 0){
        Send {end}
        Return
    }
}

;Cut (left), copy (right) and paste (press) - Davinci Resolve default shortcut -> Ctrl + C / Ctrl + X / Ctrl + V - Default Knob Sensitivity: Min: 0 - Max: 8 - Step: 1 - Coarse
_cutCopyPaste(oscType, data, msgID, hwnd){
    if (data == 0){
        Send ^{v}
        Return
    }Else if (data < 0){
        Send ^{x}
        Return
    }Else if (data > 0){
        Send ^{c}
        Return
    }
}

;Left and right arrow on knob turn and hit the knob to enter - Davinci Resolve default shortcut -> Left Arrow / Right Arrow / Enter Key - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_leftRightEnter(oscType, data, msgID, hwnd){
    if (data == 0){
        Send {enter}
        Return
    }Else if (data < 0){
        Send {left}
        Return
    }Else if (data > 0){
        Send {right}
        Return
    }
}

;Up and down arrow on knob turn and hit the knob to enter - Davinci Resolve default shortcut -> Up Arrow / Down Arrow / Enter Key - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_upDownEnter(oscType, data, msgID, hwnd){
    if (data == 0){
        Send {enter}
        Return
    }Else if (data < 0){
        Send {up}
        Return
    }Else if (data > 0){
        Send {down}
        Return
    }
}

;***** End of All Modes Functions *****

;----- End of Edit Mode Functions -----

;===== End of DLLCall functions =====

;===== Useful functions =====

;Run the _positionsArray1 and _positionsArray2 to find a expecific object and return it
_returnObject(objectName){
    For index, object in _positionsArray1
    if (object.var == objectName) {
        Return object
    }
    
    For index, object in _positionsArray2
    if (object.var == objectName) {
        Return object
    }
}

_releaseAllControls(){
    ;Saves latest position of a point if using it
   	;if (_activeController == "curves"){
        ;_savePointsPosition()
    ;}
    
    ;Reset necessary variables
    ;_activeBottomBlurControl := ""
    
    _releaseMouseGrabing()
    
    ;Turn of Active Controller
    _activeController := "off"
}

_startAutoReleaseTimer(){
    setTimer, _autoReleaseControls, %_releaseTime%
}

;Auto release the controller being used
_autoReleaseControls(isWheels := false){
    if !(LbuttonState = "U"){
        _releaseAllControls()
    }
    
    ;Testing by mouse position change (deprecated - now we just stop and start the timer again every time some tool is used)
    ;MouseGetPos, MousePosX, MousePosY
    ;
    ;if (_globalMousePosX == MousePosX and _globalMousePosY == MousePosY){
        ;if !(LbuttonState = "U"){
            ;_releaseAllControls()
        ;}
    ;}Else{
        ;_startAutoReleaseTimer()
    ;}
}

;Change the page and you can pass a from parameter so it can call specific functions after change the page
_changePage(page, from := "NONE"){
    Switch (page){
        Case "EDIT":
            if (_actualPage == "EDIT")
            Return
            
            _actualPage := "EDIT"
            
            _setPageToWindowsStatus("EDIT")
            
            _saveWindowsStatus()
            
            _actualMode := "NONE"
            
            _actualColorPanel := "NONE"
            
            ;Davinci Resolve Shortctu Shift+4 - Open Edit Page
            Send +4
            
            ;sleep 50
            ;
            ;if (from == "INSPECTOR"){
                ;Check if inspector is closed, if is closed it send command to open
                ;if (_getWindow("pos_edit_top_bts_inspector").status == 0){
                    ;_openCloseInspector(oscTypeInt, 1, 0, hWnd)
                ;}
            ;}
        Return
        Case "COLOR":
            if (_actualPage == "COLOR")
            Return
            
            _actualPage := "COLOR"
            
            _setPageToWindowsStatus("COLOR")
            
            _saveWindowsStatus()
            
            ;Davinci Resolve Shortctu Shift+6 - Open Color Page
            ;Davinci bug makes you have to press shift+6 2 times to go to color page
            Send +6
            Send +6
        Return
    }
}

;Change between different color modes (Camera RAW / Color Checker / Color Wheels / HDR / RGB Mixer / Motion Blur / Curves / Warper / Qualifier / Power Windows / Tracking / Magic Mask / BSM / Key / Sizing / 3D)
;From parameter is to know where this function was called. If was from _changePage it will call the _changePanel too
_changeMode(mode, from := "NONE"){
    Switch (mode){
        Case "CAMERA RAW":
            if (_actualMode == "CAMERA RAW")
            Return
            
            _actualMode := "CAMERA RAW"
        Return
        Case "COLOR CHECKER":
            if (_actualMode == "COLOR CHECKER")
            Return
            
            _actualMode := "COLOR CHECKER"
        Return
        Case "COLOR WHEELS":
            if (_actualMode == "COLOR WHEELS")
            Return
            
            _actualMode := "COLOR WHEELS"
            
            _moveMouseAndClick("pos_color_page_bts_color_wheels")
        Return
        Case "HDR":
            if (_actualMode == "HDR")
            Return
            
            _actualMode := "HDR"

            _moveMouseAndClick("pos_color_page_bts_hdr_wheels")
        Return
    }
}

;Change the panel that is being used
_changeColorPanel(panel, from := "NONE"){
    if (_actualColorPanel == panel)
    Return
    
    Switch (panel){
        Case "PRIMARIES":
            if (_actualMode != "COLOR WHEELS"){
                _changeMode("COLOR WHEELS")                
            }
            
            _actualColorPanel := "PRIMARIES"
            
            _moveMouseAndClick("pos_primaries_wheels_dot")
        Return
        Case "BARS":
            if (_actualMode != "COLOR WHEELS"){
                _changeMode("COLOR WHEELS")                
            }
            
            _actualColorPanel := "BARS"
            
            _moveMouseAndClick("pos_primaries_bars_dot")
        Return
        Case "LOG":
            if (_actualMode != "COLOR WHEELS"){
                _changeMode("COLOR WHEELS")                
            }
            
            _actualColorPanel := "LOG"
                
            _moveMouseAndClick("pos_primaries_log_dot")
        Return
        Case "HDR":
            if (_actualMode != "HDR"){
                _changeMode("HDR")                
            }
            
            _actualColorPanel := "HDR"
        Return
    }
}

;Return a object with the window name (var) and status(1 for opened and 0 for closed)
_getWindow(windowName){
    For index, object in _editPageWindowsStatus
    if (object.var == windowName) {
        Return object
    }
}

;Set on the respective object with the window name a new status(1 for opened and 0 for closed)
_setWindowStatus(window, status){
    For index, object in _editPageWindowsStatus
    if (window == object.var) {
        object.status := status
        Return
    }
}

;Set the variable on windows_status.ini with the latest page used
_setPageToWindowsStatus(page){
    For index, object in _editPageWindowsStatus
    if (object.var == "latest_page") {
        object.status := page
        Return
    }
}

;Open video or audio panel on inspector. 0 to audio and 1 to panel
_changeVideoAudioInspectorPanel(panel){
    if (panel == 0){
        _getWindow("pos_inspector_video").status := 0

        _moveMouseAndClick("pos_inspector_audio")
    }Else{
        _getWindow("pos_inspector_video").status := 1
        
        _moveMouseAndClick("pos_inspector_video")
    }
}

;Open or Close a window
_openCloseWindow(buttonName, ifInspectorVideoOrAudio := 1){
    object := _getWindow(buttonName)

    if (object.status == 0){
        _moveMouseAndClick(object.var)
        
        _setWindowStatus(object.var, 1)
        
        _saveWindowsStatus()

        Sleep 10
        
        ;For media pool specficaly we move the mouse and click on the first clip of the library so you can start naviagation on it
        if (object.var == "pos_edit_top_bts_media_pool"){
            _moveMouseAndClick("pos_first_media_pool_clip") 
        }
        
        ;For inspector it check if is using a Video (1) or Audio(0) tool
        if (object.var == "pos_edit_top_bts_inspector"){
            if (ifInspectorVideoOrAudio == 1){
                _changeVideoAudioInspectorPanel(1)
            }Else{
                _changeVideoAudioInspectorPanel(0)
            }
        }
    }Else{
        _moveMouseAndClick(object.var)
        
        _setWindowStatus(object.var, 0)
        
        _saveWindowsStatus()
    }
}

;Open or Close HDR Zone Window
_openCloseHDRZone(){
    if (_actualPage != "COLOR"){
        _changePage("COLOR")
        
        Return
    }

    object := _getWindow("pos_hdr_open_zone")
    
    if (object.status == 0)
    {   
        _moveMouseAndClick("pos_hdr_open_zone")
        
        _setWindowStatus(object.var, 1)
        
        _saveWindowsStatus()
    }Else{
        _moveMouseAndClick("pos_zone_close_zone")
        
        _setWindowStatus(object.var, 0)
        
        _saveWindowsStatus()
    }
}

;Check if _actualPage is Color, if is not, change to color page and return false. Otherwise keep pressed the mouse button on top of the highlight function of each HDR Color Wheel.
_checkForHDRHighlight(data, panel, wheel){
    if (_actualPage != "COLOR"){
        _changePage("COLOR")

        Return
    }
    
    _changeColorPanel(panel)
    
    Switch (wheel){
        CASE "FIRST":
            if (data == 0){
                _releaseMouseGrabing()
            }Else{
                _moveMouseAndKeep("pos_hdr_first_wheel_hl")
            }
        Return
        CASE "SECOND":
            if (data == 0){
                _releaseMouseGrabing()        
            }Else{
                _moveMouseAndKeep("pos_hdr_second_wheel_hl")                
            }
        Return
        CASE "THIRD":
            if (data == 0){
                _releaseMouseGrabing()        
            }Else{
                _moveMouseAndKeep("pos_hdr_third_wheel_hl")                
            }
        Return
    }
}

;Check if data is 0 and return false, if not 0 check if _actualPage is COLOR, if is not change to color page and return false. Otherwise change color panel and/or open HDR Zone panel if necessary.
_checkIfColorPanelData0(data, panel, openHDRZone := false){
    if (data == 0)
    Return false
    
    if (_actualPage != "COLOR"){
        _changePage("COLOR")

        Return False
    }
    
    _changeColorPanel(panel)
    
    if (openHDRZone == True){
        _checkIfHDRZone()
    }
    
    Return true
}

;Check if HDR Zone panel is opened (1) or closed (0) and if closed, open it
_checkIfHDRZone(){
    if (_getWindow("pos_hdr_open_zone").status == 0){
        _openCloseWindow("pos_hdr_open_zone", 1)
    }
    
    Return true
}

;Check if _actualPage is COLOR and if _actualColorPanel is the same, if it is return false if safety is active (so it changes the page to edit but doesn't execute the command) or return true instead (so change the page and execute the command), than open the inspector window if closed and open video or audio panel (based on videoOrAudio parameter)
_checkIfColorPanel(panel){
    if (_actualPage != "COLOR"){
        _changePage("COLOR")
        
        Return false
    }
    
    _changeColorPanel(panel)
    
    Return true
}

;Check if data is 0 and return false, if not 0 check if _actualPage is EDIT, if it is return false if safety is active (so it changes the page to edit but doesn't execute the command) or return true instead (so change the page and execute the command)
_checkIfEditOrData0(data){
    if (data == 0)
    Return false
    
    if (_actualPage != "EDIT"){
        _changePage("EDIT")
        
        Return False
    }Else{
        Return True
    }
}

;Check if _actualPage is EDIT, if it is return false if safety is active (so it changes the page to edit but doesn't execute the command - for some cases you don't wanna execute command imediately to prevent change things on the project, like a cut in some place that you don't wanna cut for example) or return true instead (so change the page and execute the command), than open the inspector window if closed and open video or audio panel (based on videoOrAudio parameter)
_checkIfEditInspector(videoOrAudio := 1){
    if (_actualPage != "EDIT"){
        _changePage("EDIT", "INSPECTOR")
        
        Return False
    }

    if (_getWindow("pos_edit_top_bts_inspector").status == 0){
        _openCloseWindow("pos_edit_top_bts_inspector", 1)
    }
    
    if (videoOrAudio == 1){
        if (_getWindow("pos_inspector_video").status == 0){
            _changeVideoAudioInspectorPanel(1)
        }
    }Else{
        if (_getWindow("pos_inspector_video").status == 1){
            _changeVideoAudioInspectorPanel(0)
        }
    }
    
    Return true
}

_resetForSpecificValue(object, value){
    _moveMouseAndClick(object)
    Sleep 10
    Send, %value%
    Sleep 10
    Send, {Enter}
}

_resetHDRPanels(reset){
    Switch (reset){
        Case "ALL":
            if (_getWindow("pos_hdr_open_zone").status == 0){
                _moveMouseAndClick("pos_hdr_dots_menu")
                Sleep 50
                _moveMouseAndClick("pos_hdr_dots_menu_reset")
                Sleep 50
                _moveMouseAndClick("pos_hdr_reset_all")
            }Else{
                _moveMouseAndClick("pos_hdr_dots_menu_zone")
                Sleep 50
                _moveMouseAndClick("pos_hdr_dots_menu_reset_zone")
                Sleep 50
                _moveMouseAndClick("pos_hdr_reset_all_zone")
            }
        Return
        Case "COLOR":
            if (_getWindow("pos_hdr_open_zone").status == 0){
                _moveMouseAndClick("pos_hdr_dots_menu")
                Sleep 50
                _moveMouseAndClick("pos_hdr_dots_menu_reset")
                Sleep 50
                _moveMouseAndClick("pos_hdr_reset_color")
            }Else{
                _moveMouseAndClick("pos_hdr_dots_menu_zone")
                Sleep 50
                _moveMouseAndClick("pos_hdr_dots_menu_reset_zone")
                Sleep 50
                _moveMouseAndClick("pos_hdr_reset_color_zone")
            }
        Return
        Case "ZONE":
            if (_getWindow("pos_hdr_open_zone").status == 0){
                _moveMouseAndClick("pos_hdr_dots_menu")
                Sleep 50
                _moveMouseAndClick("pos_hdr_dots_menu_reset")
                Sleep 50
                _moveMouseAndClick("pos_hdr_reset_zone")
            }Else{
                _moveMouseAndClick("pos_hdr_dots_menu_zone")
                Sleep 50
                _moveMouseAndClick("pos_hdr_dots_menu_reset_zone")
                Sleep 50
                _moveMouseAndClick("pos_hdr_reset_zone_zone")
            }
        Return
    }
}

_start_stop_bt(){
    if (_appRunning){
        GuiControl,,Stop TWB,Start TWB
        
        _appRunning := false
        
        _osc2ahkAddOrRemoveListeners("remove")
    }Else{
        GuiControl,,Start TWB,Stop TWB
        
        _appRunning := true
        
        _osc2ahkAddOrRemoveListeners()
    }
}

;===== End of Useful functions =====

; /\ END OF FUNCTIONS /\

; \/ BUTTONS FUNCTIONS \/

;Set the name of the variable that will have a new position seted
;Start the seting variable mode (makes the software wait for the ENTER key be pressed to save the mouse position)
setVariableButton:
    _lastButtonUsed := A_GuiControl
    _variableToSet := A_GuiControl
    _isSetingVariable := "true"
    
    GuiControl, Disable, %_variableToSet%
Return

; /\ END OF BUTTONS FUNCTIONS /\

; \/ KEY BIDINGS \/

Enter::
    if (_isSetingVariable == "false"){
        Send, {Enter}
    }Else{
        _changePositionVariable()
    }
Return

; /\ END OF KEY BIDINGS /\