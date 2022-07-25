;Tangent Wave Booster
;A software that will give to your Tangent Wave incredible powers
;Developer: André Rodrigues - Media Environment
;Contact: contato@souandrerodrigues.com.br
;Version: 2.0.4
;Please donate if you liked the project! - Por favor faça uma doação se você gostou deste projeto!
;For Dollar Donation: https://www.paypal.com/donate/?token=xMLCpr_JUxvMFomkrZ7jSLPPCCfz8oJAkBeXtPWAw2f3Hfym6otcNQ2gX-ilD3afonbWXF9E4kzKjZY0
;Para doações em Real: https://www.paypal.com/donate/?token=lHsnRH3-dwXqGdqFNYmguAh7Mh8zG0gQnLImvO5HSGqb0wSvaHWrfuzR_mbocCa_Er0nOv-uS8NP7xxd

;Updates of 2.0.5 version:
;Inspector functions created and working

;Updates of 2.0.4 version:
;Reorganized the edit panel on Tagent Mapper with new functions and better UX organization
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

;TODO: Create a panel for motion effects
;TODO? Added auto-release feature (release shortcut still exist at F1 but is not assigned anymore)
;TODO? Added auto-toggle pages 1/2 for the basic controllers (you don't need anymore toggle between pages on the panel, use any basic control will change for the correct page automatically - The toggle shortcust still existing but is not assigned anymore)
;TODO: Make all the tools change panels automatically (this will free up some shortcuts)
;TODO: If we have some spare shortcuts, its possible to use them to transfer Curves VS from buttons to knobs (output on knob left/right and input on alternative knob left/right)

;Tips about Tangent Mapper
;1 - When setting a knob intensity, use for the OSC Value format the option Interger and the knob sensitivity at Coarse. For the Min and Max values, use 0 to 5 if you want not too fast repeating. 0 to 6 for a little more. 0 to 10 and 0 to 50 will give you a fast response with a more sensible knob so only use this for things that doesn't matter repeat the same command more than one time. Example: For select all clips, you can repeat the command because doesn't matter, will select all and that's it. So you can use 0 to 50 because will give you a sensible and fast response. Although for delete you don't wanna the delete being pressed a lot of times in a row, so use 0 to 5.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Gui +LastFound
hWnd := WinExist()
CoordMode, Mouse, Screen

#MaxHotkeysPerInterval, 200

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
global _appRunning := false

;Global timers and speeds
global _releaseTime := -200

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
global _actualPage := "EDIT"

;Set the actual mode. Can be: "CAMERA RAW", "COLOR CHECKER", "COLOR WHEELS", "HDR WHEELS", "RGB MIXER", "MOTION BLUR", "CURVES", "WARPER", "QUALIFIER", "POWER WINDOWS", "TRACKING", "MAGIC MASK", "BSM", "KEY", "SIZING", "3D"
global _actualMode := "HDR WHEELS"

;Set the actual panel. Can be: "INSPECTOR", "PRIMARIES", "BARS", "LOG", "CURVES", "HUEXHUE", "HUEXSAT", "HUEXLUM"
global _actualPanel := "INSPECTOR"

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
Gui Add, Button, g_start_stop_bt x192 y8 w150 h50, Start TWB
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
Gui Add, Button, gsetVariableButton vpos_color_top_bts_gallery gsetVariableButton x480 y360 w120 h50, Gallery
Gui Add, Button, gsetVariableButton vpos_color_top_bts_luts gsetVariableButton x576 y480 w120 h50, LUTs
Gui Add, Button, gsetVariableButton vpos_color_top_bts_media_pool gsetVariableButton x704 y360 w120 h50, Media Pool
Gui Add, Button, gsetVariableButton vpos_color_top_bts_timeline gsetVariableButton x848 y480 w120 h50, Timeline
Gui Add, Button, gsetVariableButton vpos_color_top_bts_clips gsetVariableButton x968 y360 w120 h50, Clips
Gui Add, Button, gsetVariableButton vpos_color_top_bts_nodes gsetVariableButton x1088 y480 w120 h50, Nodes
Gui Add, Button, gsetVariableButton vpos_color_top_bts_open_fx gsetVariableButton x1192 y360 w120 h50, Open FX
Gui Add, Button, gsetVariableButton vpos_color_top_bts_lightbox gsetVariableButton x1312 y480 w120 h50, Lightbox
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
Gui Add, Button, gsetVariableButton vpos_hdr_reset x1440 y632 w150 h50, HDR Reset
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_hl x320 y512 w150 h50, First Wheel High Light
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_hl x320 y576 w150 h50, Second Wheel High Light
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_hl x320 y640 w150 h50, Third Wheel High Light
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_exp x496 y848 w100 h50, Exp First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_sat x608 y848 w100 h50, Sat First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_exp x736 y848 w100 h50, Exp Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_sat x848 y848 w100 h50, Sat Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_exp x968 y848 w100 h50, Exp Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_sat x1080 y848 w100 h50, Sat Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_exp x1200 y848 w100 h50, Exp Fourth Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_sat x1312 y848 w100 h50, Sat Fourth Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_x x496 y912 w100 h50, X First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_first_wheel_y x608 y912 w100 h50, Y First Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_x x736 y912 w100 h50, X Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_second_wheel_y x848 y912 w100 h50, Y Second Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_x x968 y912 w100 h50, X Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_third_wheel_y x1080 y912 w100 h50, Y Third Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_x x1200 y912 w100 h50, X Fourth Wheel
Gui Add, Button, gsetVariableButton vpos_hdr_fourth_wheel_y x1312 y912 w100 h50, Y Fourth Wheel

Gui Tab, 10
Gui Add, Picture, x480 y432 w950 h400 +0x400000, %A_ScriptDir%\images\HDR Panel.png
Gui Add, Button, gsetVariableButton vpos_hdr_hue x760 y848 w120 h50, Hue
Gui Add, Button, gsetVariableButton vpos_hdr_temperature x488 y848 w120 h50, Temperature
Gui Add, Button, gsetVariableButton vpos_hdr_tint x624 y848 w120 h50, Tint
Gui Add, Button, gsetVariableButton vpos_hdr_contrast x896 y848 w120 h50, Contrast
Gui Add, Button, gsetVariableButton vpos_hdr_pivot x1032 y848 w120 h50, Pivot
Gui Add, Button, gsetVariableButton vpos_hdr_md x1168 y848 w120 h50, MD
Gui Add, Button, gsetVariableButton vpos_hdr_black_offset x1304 y848 w120 h50, Black Offset

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
Gui Add, Picture, x40 y472 w950 h51, %A_ScriptDir%\images\Timeline Time Bar.png
Gui Add, Picture, x40 y752 w695 h278, %A_ScriptDir%\images\Timeline Position.png
Gui Add, Picture, x1336 y784 w554 h262, %A_ScriptDir%\images\Preview Window.png
Gui Add, Picture, x1360 y472 w529 h185, %A_ScriptDir%\images\First Clip Media Pool.png
Gui Add, Button, gsetVariableButton vpos_timeline_time_bar x40 y408 w150 h50, Timeline Time Bar
Gui Add, Button, gsetVariableButton vpos_timeline x40 y688 w150 h50, Timeline Position
Gui Add, Button, gsetVariableButton vpos_first_media_pool_clip x1360 y408 w150 h50, First Media Pool Clip
Gui Add, Button, gsetVariableButton vpos_preview_window x1336 y720 w150 h50, Preview Window

Gui Tab

Gui Show, w1920 h1080, TWB 2.0.4

; \/ APP START \/

;Start load all positions and populate _positionsArray1 and _positionsArray2 (this function NEED to be called inside the GUI construction at the end of it)
_loadPositions()

; /\ END APP START /\

Return

GuiClose:
    ExitApp

; /\ END OF GUI INTERFACE /\

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
    
    ;OSC2AHK Listerners
    
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

    DllCall("OSC2AHK.dll\addListener", AStr, "/undoRedo", UInt, 0x1011, UInt, oscTypeInt)
    OnMessage(0x1011, "_undoRedo")
    
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

    DllCall("OSC2AHK.dll\addListener", AStr, "/enterPrimaries", UInt, 0x1055, UInt, oscTypeInt)
    OnMessage(0x1055, "_enterPrimaries")
    
    DllCall("OSC2AHK.dll\addListener", AStr, "/enterEditMode", UInt, 0x1050, UInt, oscTypeInt)
    OnMessage(0x1050, "_enterEditMode")

    DllCall("OSC2AHK.dll\addListener", AStr, "/enterColorMode", UInt, 0x1051, UInt, oscTypeInt)
    OnMessage(0x1051, "_enterColorMode")
    
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
                        
                        _editPageWindowsStatus[arrayPos].buttonName := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 3:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _editPageWindowsStatus[arrayPos].status := SubStr(A_Loopfield, startingPos + 1)
                        
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

;Move mouse and click on object
_moveMouseAndClick(object){
    object := _returnObject(object)
    
    MouseClick Left, object["x"], object["y"], 1, 0
}

;Move mouse and start grabing object
_moveMouseAndGrab(activeController, posX, posY){
    ;Release the mouse of any other controller before start
    _releaseAllControls()
    
    ;Setup the variable with the controller being used
    _activeController := activeController
    
    ;Move mouse to the controller position
    MouseMove posX, posY, 0
        
    ;Start grabing and set a timer to auto release
    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
        Send, {LButton Down}
        _startAutoReleaseTimer()
    }
}

;Release the mouse grab
_releaseMouseGrabing(){
    GetKeyState, LbuttonState, LButton, P
	if !(LbuttonState = "U"){
   	    Send, {LButton Up}
        Sleep 20
    }
}

_setGlobalMousePos(){
    MouseGetPos, mousePosX, mousePosY
    
    _globalMousePosX := mousePosX
    _globalMousePosY := mousePosY
}

;===== End of Mouse Functions =====

;===== DLLCall Functions =====



;----- Edit mode functions -----
;Change between windows on Edit Page - Can be Timeline or Preview.
_changeEditActiveWindow(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return

    if (data == 0){
        return
    }Else if (data < 0){
        _moveMouseAndClick("pos_preview_window")
        return
    }Else if (data > 0){
        _moveMouseAndClick("pos_timeline")
        return
    }
}

;Open or close Right Expander
_openCloseRightExpander(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_right_expand")
}

;Open or close Inspector window
_openCloseInspector(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_inspector")
}

;Open or close Metadata window
_openCloseMetadata(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_metadata")
}

;Open or close Mixer window
_openCloseMixer(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_mixer")
}

;Open or close Sound Library window
_openCloseSoundLibrary(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_sound_library")
}

;Open or close Edit Index window
_openCloseEditIndex(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_edit_index")
}

;Open or close Effects Library window
_openCloseEffectsLibrary(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_effects_library")
}

;Open or close Media Pool window
_openCloseMediaPool(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_media_pool")
}

;Open or close Left Expander
_openCloseLeftExpander(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return

    _openCloseWindow("pos_edit_top_bts_left_expand")
}

;Add a clip to the end of timeline - Davinci Resolve default shortcut -> Shift + F12
_addClipToTheEnd(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send +{F12}
}

;Fit to Fill Clip on timeline - Davinci Resolve default shortcut -> Shift + F11
_fitToFillClip(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send +{F11}
}

;Ripple Overwrite Clip on timeline - Davinci Resolve default shortcut -> Shift + F10
_rippleOverwriteClip(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send +{F10}
}

;Replace Clip on timeline - Davinci Resolve default shortcut -> F11
_replaceClip(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send {F11}
}

;Overwrite Clip on timeline - Davinci Resolve default shortcut -> F10
_overwriteClip(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send {F10}
}

;Insert Clip on timeline - Davinci Resolve default shortcut -> F9
_insertClip(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send {F9}
}

;Select Blade tool - Davinci Resolve default shortcut -> B
_bladeTool(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send {b}
}

;Select Trim tool or Dynamic Trim tool - Davinci Resolve default shortcut -> T / W
_trimMode(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send {w}
        return
    }Else if (data > 0){
        Send {t}
        return
    }
}

;Select Selection tool - Davinci Resolve default shortcut -> A
_selectionTool(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    send {a}
}

;Move clips through tracks up and down - Davinci Resolve default shortcut -> Alt + Up Arrow / Alt + Down Arrow
_altUpDown(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send !{up}
        return
    }Else if (data > 0){
        Send !{down}
        return
    }
}

;Left and right arrow on knob turn and hit the knob to enter - Davinci Resolve default shortcut -> Left Arrow / Right Arrow / Enter Key
_leftRightEnter(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        Send {enter}
        return
    }Else if (data < 0){
        Send {left}
        return
    }Else if (data > 0){
        Send {right}
        return
    }
}

;Up and down arrow on knob turn and hit the knob to enter - Davinci Resolve default shortcut -> Up Arrow / Down Arrow / Enter Key
_upDownEnter(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        Send {enter}
        return
    }Else if (data < 0){
        Send {up}
        return
    }Else if (data > 0){
        Send {down}
        return
    }
}

;Select all clips of the active track backward and forward - Davinci Resolve default shortcut -> Y / Ctrl + Y
_selectFwBwActiveTrack(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send ^{y}
        return
    }Else if (data > 0){
        Send {y}
        return
    }
}

;Go to timeline begin or end - Davinci Resolve default shortcut -> Home / End
_homeEnd(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send {home}
        return
    }Else if (data > 0){
        Send {end}
        return
    }
}

;Cut, copy and paste - Davinci Resolve default shortcut -> Ctrl + C / Ctrl + X / Ctrl + V
_cutCopyPaste(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        Send ^{v}
        return
    }Else if (data < 0){
        Send ^{x}
        return
    }Else if (data > 0){
        Send ^{c}
        return
    }
}

;Add audio transition, video transition or both - Davinci Resolve default shortcut -> Shift + T / Alt + T / Ctrl + T
_addAVTransitions(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        Send ^{t}
        return
    }Else if (data < 0){
        Send +{t}
        return
    }Else if (data > 0){
        Send !{t}
        return
    }
}

;Delete what is selected (without move timeline) - Davinci Resolve default shortcut -> Backspace
_deleteSelection(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send {del}
        return
    }Else if (data > 0){
        Send {backspace}
        return
    }
}

;Open Change Clip Speed window or put clip on retime mode - Davinci Resolve default shortcut -> Ctrl + R / R
_retimeClipSpeed(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send ^{r}
        return
    }Else if (data > 0){
        Send {r}
        return
    }
}

;Swap clip towards right and left - Davinci Resolve default shortcut -> Ctrl + Shift + , / Ctrl + Shift + .
_swapClips(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send ^+{,}
        return
    }Else if (data > 0){
        Send ^+{.}
        return
    }
}

;Select and deselect all clips - Davinci Resolve default shortcut -> Ctrl + A / Ctrl + Shift + A
_selectDeselectAll(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send ^+{a}
        return
    }Else if (data > 0){
        Send ^{a}
        return
    }
}

;Select all clips backward and forward - Davinci Resolve default shortcut -> Alt + Y / Ctrl + Alt + Y
_selectForwardBackward(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        return
    }Else if (data < 0){
        Send ^!{y}
        return
    }Else if (data > 0){
        Send !{y}
        return
    }
}

;Add a mark, remove a mark and setup a mark - Davinci Resolve default shortcut -> M / Alt + M / Ctrl + M
_addRemoveSetMark(oscType, data, msgID, hwnd){
    if (_actualPage != "EDIT")
    return
    
    if (data == 0){
        Send ^{m}
        return
    }Else if (data < 0){
        Send !{m}
        return
    }Else if (data > 0){
        Send {m}
        return
    }
}

;Save project - Davinci Resolve default shortcut -> Ctrl + S
_saveProject(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send ^{s}
}

;Enter/Exit on fullscreen mode - Davinci Resolve default shortcut -> Ctrl + F
_toggleFullscreen(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send ^{f}
}

;Paste attributes from other clip - Davinci Resolve default shortcut -> Alt + V
_pasteAttributes(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send !{v}
}

;Link/Unlink clips on timeline - Davinci Resolve default shortcut -> Ctrl + Alt + L
_linkUnlinkClips(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send ^!{l}
}

;Select the closest edit point - Davinci Resolve default shortcut -> V
_closestEditPoint(oscType, data, msgID, hwnd){

    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send {v}
}

;Select the closest clip or gap - Davinci Resolve default shortcut -> Shift + V
_closestClipGap(oscType, data, msgID, hwnd){

    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send +{v}
}

;Delete all the content from the end of the clip until the playhead - Davinci Resolve default shortcut -> Ctrl + Shift + ]
_delEndToPlayhead(oscType, data, msgID, hwnd){

    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send ^+{]}
}

;Delete all the content from the begin of the clip until the playhead - Davinci Resolve default shortcut -> Ctrl + Shift + [
_delStartToPlayhead(oscType, data, msgID, hwnd){

    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send ^+{[}
}

;Cut all selected clips or all tracks if none is selected - Davinci Resolve default shortcut -> Ctrl + B
_cutAllTimelines(oscType, data, msgID, hwnd){

    if (data == 0)
    return
    
    if (_actualPage != "EDIT")
    return
    
    Send ^{b}
}

;----- End of Edit Mode Functions -----

;----- Other DLL Call Functions -----

;Set mode to EDIT and open the inspector
_enterEditMode(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    _changePage("EDIT")
}

;Set mode to COLOR, open color page and set the panel to Primaries Wheels with custom curves (default davinci mode)
_enterColorMode(oscType, data, msgID, hwnd){
    if (data == 0)
    return
    
    _changePage("COLOR")
}

;----- All Modes Functions -----

;Undo and Redo - Davinci Resolve default shortcut -> Ctrl + Z / Ctrl + Shift + Z
_undoRedo(oscType, data, msgID, hwnd){
    if (data == 0){
        return
    }Else if (data < 0){
        Send ^{z}
        return
    }Else if (data > 0){
        Send ^+{z}
        return
    }
}

;----- End of All Modes Functions -----

;----- Color mode functions -----

;***** Primaries Wheels mode functions *****

_enterPrimaries(oscType, data, msgID, hwnd){
    if (data == 0)
    return

    if (_actualPage != "COLOR"){
        _changePage("COLOR")
        return
    }
    
    if (_actualMode != "COLOR WHEELS"){
        _changeMode("COLOR WHEELS")
        return
    }
    
    if (_actualPanel != "PRIMARIES"){
        _changePanel("PRIMARIES")
    }
}

;***** End of primaries Wheels mode functions *****



;===== End of DLLCall functions =====

;===== Useful functions =====

;Run the _positionsArray1 and _positionsArray2 to find a expecific object and return it
_returnObject(objectName){
    For index, object in _positionsArray1
    if (object.var == objectName) {
        return object
    }
    
    For index, object in _positionsArray2
    if (object.var == objectName) {
        return object
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
    _setGlobalMousePos()
}

;Auto release the controller being used
_autoReleaseControls(){
    MouseGetPos, MousePosX, MousePosY
    
    if (_globalMousePosX == MousePosX and _globalMousePosY == MousePosY){
        if !(LbuttonState = "U"){
            _releaseAllControls()
        }
    }Else{
        _startAutoReleaseTimer()
    }
}

;Change the page from EDIT to COLOR
_changePage(page, from := "NONE"){
    Switch (page){
        Case "EDIT":
            if (_actualPage == "EDIT")
            return
            
            _actualPage := "EDIT"
            
            ;Davinci Resolve Shortctu Shift+4 - Open Edit Page
            Send +4
            
            sleep 20
            
            if (from != "CHANGE PANEL"){
                _changePanel("INSPECTOR")    
            }
        return
        Case "COLOR":
            if (_actualPage == "COLOR")
            return
            
            _actualPage := "COLOR"
            
            ;Davinci Resolve Shortctu Shift+6 - Open Color Page
            ;Davinci bug makes you have to press shift+6 2 times to go to color page
            Send +6
            Send +6
            
            Sleep 50
            
            _changeMode("COLOR WHEELS", "CHANGE PAGE")
        return
    }
}

;Change between different color modes (Camera RAW / Color Checker / Color Wheels / HDR Wheels / RGB Mixer / Motion Blur / Curves / Warper / Qualifier / Power Windows / Tracking / Magic Mask / BSM / Key / Sizing / 3D)
;From parameter is to know where this function was called. If was from _changePage it will call the _changePanel too
_changeMode(mode, from := "NONE"){
    Switch (mode){
        Case "CAMERA RAW":
            if (_actualMode == "CAMERA RAW")
            return
            
            _actualMode := "CAMERA RAW"
        return
        Case "COLOR CHECKER":
            if (_actualMode == "COLOR CHECKER")
            return
            
            _actualMode := "COLOR CHECKER"
        return
        Case "COLOR WHEELS":
            if (_actualMode == "COLOR WHEELS")
            return
            
            _actualMode := "COLOR WHEELS"
            
            _moveMouseAndClick("pos_color_page_bts_color_wheels")
            
            Sleep 20

            if (from == "CHANGE PAGE"){
                _changePanel("PRIMARIES")
            }
        return
        Case "HDR WHEELS":
            if (_actualMode == "HDR WHEELS")
            return
            
            _actualMode := "HDR WHEELS"
        return
    }
}

_changePanel(panel, from := "NONE"){
    Switch (panel){
        Case "INSPECTOR":
            if (_actualPage != "EDIT"){
                _changePage("EDIT", "CHANGE PANEL")
                return
            }
            
            if (_actualPanel == "INSPECTOR")
            return
            
            _actualPanel := "INSPECTOR"
            
            ;Check if inspector is closed, if is closed it send command to open
            if (_inspectorStatus == false){
                _openCloseInspector(oscTypeInt, 1, 0, hWnd)                
            }
        return
        Case "PRIMARIES":
            if (_actualPage != "COLOR"){
                _changePage("COLOR")
                return
            }

            if (_actualMode != "COLOR WHEELS"){
                _changeMode("COLOR WHEELS")                
            }
            
            if (_actualPanel == "PRIMARIES")
            return
            
            _actualPanel := "PRIMARIES"
            
            _moveMouseAndClick("pos_primaries_wheels_dot")
        return
    }
}

_getWindow(windowName){
    For index, object in _editPageWindowsStatus
    if (object.buttonName == windowName) {
        return object
    }
}

_setWindowStatus(window, status){
    For index, object in _editPageWindowsStatus
    if (window == object.var) {
        object.status := status
        return
    }
}

_openCloseWindow(buttonName){
    object := _getWindow(buttonName)
    
    if (object.status == 0){
        _moveMouseAndClick(object.buttonName)

        Sleep 10
        
        ;For media pool specficaly we move the mouse and click on the first clip of the library so you can start naviagation on it
        if (object.buttonName == "pos_edit_top_bts_media_pool"){
            _moveMouseAndClick("pos_first_media_pool_clip") 
        }
    
        _setWindowStatus(object.var, 1)
        
        _saveWindowsStatus()
    }Else{
        _moveMouseAndClick(object.buttonName)
        
        _setWindowStatus(object.var, 0)
    
        _saveWindowsStatus()
    }
}

;Save all the windows status on the windows_status.ini
_saveWindowsStatus() {
    For arrayNum, array in _editPageWindowsStatus
        For index, varbuttonNamestatus in ["var", "buttonName", "status"]
        IniWrite, % array[varbuttonNamestatus], %A_ScriptDir%\windows_status.ini, EDIT WINDOWS STATUS, %arrayNum%%varbuttonNamestatus%
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
return

_start_stop_bt:
    if (tog := !tog){
        GuiControl,,Start TWB,Stop TWB
        _appRunning := true
    }Else{
        GuiControl,,Stop TWB,Start TWB
        _appRunning := false
    }
Return

; /\ END OF BUTTONS FUNCTIONS /\

; /\ KEY BIDINGS \/

;TEST KEY - Use this for test anything in the code
F9::
    ;MsgBox Test key pressed
    For arrayNum, array in _editPageWindowsStatus{
        teste := array.status
        
        msgbox %teste%
    }
    
return


Enter::
    if (_isSetingVariable == "false"){
        Send, {Enter}
    }Else{
        _changePositionVariable()
    }
return

; /\ END OF KEY BIDINGS /\