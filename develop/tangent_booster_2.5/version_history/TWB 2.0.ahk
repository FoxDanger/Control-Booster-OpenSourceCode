;Tangent Wave Booster
;A software that will give to your Tangent Wave incredible powers
;Developer: André Rodrigues - Media Environment
;Contact: contato@souandrerodrigues.com.br
;Version: 2.0 Beta
;Please donate if you liked the project! - Por favor faça uma doação se você gostou deste projeto!
;For Dollar Donation: https://www.paypal.com/donate/?token=xMLCpr_JUxvMFomkrZ7jSLPPCCfz8oJAkBeXtPWAw2f3Hfym6otcNQ2gX-ilD3afonbWXF9E4kzKjZY0
;Para doações em Real: https://www.paypal.com/donate/?token=lHsnRH3-dwXqGdqFNYmguAh7Mh8zG0gQnLImvO5HSGqb0wSvaHWrfuzR_mbocCa_Er0nOv-uS8NP7xxd

;Updates of this version:
;Software all redesigned from start
;New OSC controls by Tangent Mapper
;New GUI
;Revised all the shortcuts and some positions of the controllers on Tangent Wave Mapper

;TODO? Added auto-release feature (release shortcut still exist at F1 but is not assigned anymore)
;TODO? Added auto-toggle pages 1/2 for the basic controllers (you don't need anymore toggle between pages on the panel, use any basic control will change for the correct page automatically - The toggle shortcust still existing but is not assigned anymore)
;TODO: Make all the tools change panels automatically (this will free up some shortcuts)
;TODO: If we have some spare shortcuts, its possible to use them to transfer Curves VS from buttons to knobs (output on knob left/right and input on alternative knob left/right)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxHotkeysPerInterval, 200

; == GLOBAL VARIABLES ==

;Create a variable for the resolution and scale combo box and set the actual PC Resolution and DPIScale - String - Can be: "FHD100", "FHD125", "FHD150", "FHD200", "4K100", "4K125", "4K150", "4K200" or "USER":
global comboboxResolutionScale
global _resolutionAndScale := "USER"

;Define if app was started by the start button
global _appStarted := "false"

;Global timers and speeds
global _releaseTimeWheels := -700
global _releaseTimeKnobs := -200

;Set the active controllers, pages and panels
global _globalMousePosX := 0
global _globalMousePosY := 0

;Save ImageSearch Pixel
global _imageSearchX := 0
global _imageSearchY := 0

;Define what position variable will be changed
global _variableToSet := ""

;Tells the software that you are seting a new position for some element on the screen, so the software will wait for you to press ENTER to set the new position
global _isSetingVariable := "false"

; == Array for the position variables - Set the position of each element on the Davinci Resolve workarea (if your resolution and/or scale doesn't work with any of the presets, you need setup each position manualy using TWB tool) ==
global _positionsArray1 := []
global _positionsArray2 := []

; == END OF GLOBAL VARIABLES ==

; == GUI INTERFACE ==

Gui Font, s9, Segoe UI
Gui Add, Picture, x8 y8 w150 h150, %A_ScriptDir%\images\Logo.png
Gui Add, Text, x1216 y8 w120 h23 +0x200 , How to use:
Gui Add, Text, x1216 y40 w700 h23, 1 - Click on the button of the tool that you want change the position
Gui Add, Text, x1216 y72 w700 h23, 2 - Go to your software screen and position the mouse on top of the tool
Gui Add, Text, x1216 y104 w700 h23, 3 - Hit "ENTER" key
Gui Add, Text, x1216 y136 w700 h23, 4 - Repeat the process for each tool and hit "Save Positions" button at the end
Gui Add, Button, g_start_stop_bt x192 y8 w150 h50, Start TWB
Gui Add, Button, g_save_positions_bt x192 y64 w150 h50, Save Positions
Gui Add, Button, g_CheckRes x600 y100 w150 h50, Check Res Test Button
Gui Add, Text, x360 y8 w250 h23, Set Resolution / DPI Scale (in percentage):
Gui Add, ComboBox, vcomboboxResolutionScale g_changeResolutionAndScale x360 y32 w400, FHD100|FHD125|FHD150|FHD200|4K100|4K125|4K150|4K200|USER

Gui Add, Tab3, x8 y176 w1905 h900 Choose1, Edit Page Buttons|Inspector Transform|Color Page Buttons|Wheels/Jogs|Primaries YRGB|Primaries Tools|Log Wheels|Log Tools|HDR Controllers|HDR Tools|HDR Zone|RGB Mixer|Curves Dots/Options|Custom Curves|Hue Curves|Qualifier|Qualifier Matte Finess|Power Windows|BSM|Key

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
Gui Add, Button, gsetVariableButton vpos_inspector_transform_reset x624 y368 w150 h50, Transform Reset
Gui Add, Button, gsetVariableButton vpos_inspector_zoom_reset x784 y400 w150 h50, Zoom Reset
Gui Add, Button, gsetVariableButton vpos_inspector_position_reset x784 y464 w150 h50, Position Reset
Gui Add, Button, gsetVariableButton vpos_inspector_rotation_angle_reset x784 y528 w150 h50, Rotation Angle Reset
Gui Add, Button, gsetVariableButton vpos_inspector_anchor_point_reset x784 y592 w150 h50, Anchor Point Reset
Gui Add, Button, gsetVariableButton vpos_inspector_pitch_reset x784 y656 w150 h50, Pitch Reset
Gui Add, Button, gsetVariableButton vpos_inspector_flip_reset x784 y720 w150 h50, Flip Reset
Gui Add, Picture, x1152 y432 w570 h170,  %A_ScriptDir%\images\Inspector Audio Panel.png
Gui Add, Button, gsetVariableButton vpos_inspector_audio x1152 y368 w150 h50, Audio
Gui Add, Button, gsetVariableButton vpos_inspector_volume_on_off x992 y504 w150 h50, Volume On/Off
Gui Add, Button, gsetVariableButton vpos_inspector_audio_reset x1576 y368 w150 h50, Audio Reset
Gui Add, Button, gsetVariableButton vpos_inspector_volume_reset x1736 y552 w150 h50, Volume Reset
Gui Add, Button, gsetVariableButton vpos_inspector_volume x1512 y616 w150 h50, Volume
Gui Add, Button, gsetVariableButton vpos_inspector_volume_keyframe x1512 y680 w150 h50, Volume Key Frame

Gui Tab, 3
Gui Add, Picture, x480 y608 w950 h40, %A_ScriptDir%\images\Color Page Top Buttons.png
Gui Add, Button, gsetVariableButton vpos_color_top_bts_gallery x480 y544 w120 h50, Gallery
Gui Add, Button, gsetVariableButton vpos_color_top_bts_luts x576 y664 w120 h50, LUTs
Gui Add, Button, gsetVariableButton vpos_color_top_bts_media_pool x704 y544 w120 h50, Media Pool
Gui Add, Button, gsetVariableButton vpos_color_top_bts_timeline x848 y664 w120 h50, Timeline
Gui Add, Button, gsetVariableButton vpos_color_top_bts_clips x968 y544 w120 h50, Clips
Gui Add, Button, gsetVariableButton vpos_color_top_bts_nodes x1088 y664 w120 h50, Nodes
Gui Add, Button, gsetVariableButton vpos_color_top_bts_open_fx x1192 y544 w120 h50, Open FX
Gui Add, Button, gsetVariableButton vpos_color_top_bts_lightbox x1312 y664 w120 h50, Lightbox

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

Gui Tab

Gui Show, w1920 h1080, TWB 2.0 Beta

; == SETUP AND START THE SOFTAWRE ==

; == Load external variables (resolution / dpi scale) ==

;Read the resolution and scale file to load and set the latest resolution and scale used on the variable _resolutionAndScale
Loop, read, %A_ScriptDir%\last_res.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        if(InStr(A_Loopfield, "lastResScale") != 0){
            startingPos := InStr(A_Loopfield, "=")

            _resolutionAndScale := SubStr(A_Loopfield, startingPos + 1)
        }
    }
}

;_resolutionAndScale := "USER"

_loadPositions()
; == End of Load external variables (resolution / dpi scale) ==

; == END SETUP THE SOFTAWRE ==


Return

GuiEscape:
GuiClose:
    ExitApp

; == END OF GUI INTERFACE ==

; == FUNCTIONS ==

;Load the positions of each element on the screen from a external file (depends of what resolution / dpi scale is seted)
_loadPositions(){
    ;Set the Combo Box Resolution/Scale for the latest Resolution/Scale used
    GuiControl, Text, comboboxResolutionScale, %_resolutionAndScale%
    
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
            if(InStr(A_Loopfield, _resolutionAndScale) == 0){
                continue
            }
            
            if(InStr(A_Loopfield, "Array1") != 0){
                switch (counter){
                    Case 1:
                        object := []
                        _positionsArray1.Push(object)
                        
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _positionsArray1[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)

                        ;teste := _positionsArray1[arrayPos].var
                        ;MsgBox "ultima var do array1 " %teste%

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
            }Else if(InStr(A_Loopfield, "Array2") != 0){
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

;Save all the actual seted positions on the position files
_save_positions_bt(){
    Switch _resolutionAndScale{
        Case "USER":
            _updateIniResScaleFile("USER")
        return
        Case "FHD100":
            _updateIniResScaleFile("FHD100")
        return
        Case "FHD125":
            _updateIniResScaleFile("FHD125")
        return
        Case "FHD150":
            _updateIniResScaleFile("FHD150")
        return
        Case "QHD100":
            _updateIniResScaleFile("QHD100")
        return
        Case "QHD125":
            _updateIniResScaleFile("QHD125")
        return
        Case "QHD150":
            _updateIniResScaleFile("QHD150")
        return
        Case "4K100":
            _updateIniResScaleFile("4K100")
        return
        Case "4K125":
            _updateIniResScaleFile("4K125")
        return
        Case "4K150":
            _updateIniResScaleFile("4K150")
        return
        Case "4K175":
            _updateIniResScaleFile("4K175")
        return
        Case "4K200":
            _updateIniResScaleFile("4K200")
        return
    }
}

_changePositionVariable(){
    CoordMode, Mouse, Screen
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

_updateIniResScaleFile(resolutionScale) {
    For arrayNum, array in _positionsArray1
        For index, varxy in ["var", "x", "y"]
        IniWrite, % array[varxy], %A_ScriptDir%\res_dpi_scale.ini, %resolutionScale%, Array1 - %_resolutionAndScale% - %arrayNum%%varxy%
        
    For arrayNum, array in _positionsArray2
        For index, varxy in ["var", "x", "y"]
        IniWrite, % array[varxy], %A_ScriptDir%\res_dpi_scale.ini, %resolutionScale%, Array2 - %_resolutionAndScale% - %arrayNum%%varxy%
}

_changeResolutionAndScale(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
    GuiControlGet, comboboxResolutionScale
    _resolutionAndScale := comboboxResolutionScale
    
    IniWrite, %_resolutionAndScale%, %A_ScriptDir%\lastResolutionScale.ini, RESOLUTIONSCALE, lastResScale
    
    _loadPositions()
}

_CheckRes(){
    msgbox %_resolutionAndScale%
    
    var1 := _positionsArray1[1].var
    x1 := _positionsArray1[1].x
    y1 := _positionsArray1[1].y
    msgbox "Var1: " %var1% "X1: " %x1% "Y1: " %y1%
    
    var243 := _positionsArray1[243].var
    x243 := _positionsArray1[243].x
    y243 := _positionsArray1[243].y
    msgbox "Var243: " %var243% "X243: " %x243% "Y243: " %y243%
    
    var1 := _positionsArray2[1].var
    x1 := _positionsArray2[1].x
    y1 := _positionsArray2[1].y
    msgbox "Var1: " %var1% "X1: " %x1% "Y1: " %y1%
    
    var86 := _positionsArray2[86].var
    x86 := _positionsArray2[86].x
    y86 := _positionsArray2[86].y
    msgbox "Var86: " %var86% "X86: " %x86% "Y86: " %y86%
}

; == END OF FUNCTIONS ==

; == BUTTONS FUNCTIONS ==

;Set the name of the variable that will have a new position seted
;Start the seting variable mode (makes the software wait for the ENTER key be pressed to save the mouse position)
;Disable the button so you can't set the same position 2 times == TODO: Maybe is not a good deal disable the button, check if there's another way to show that variable was seted on the session)
setVariableButton:
    _variableToSet := A_GuiControl
    _isSetingVariable := "true"
    
;    GuiControl, Disable, %_variableToSet%
return

_start_stop_bt:
Return

; == END OF BUTTONS FUNCTIONS ==

; == KEY BIDINGS ==

Enter::
    if (_isSetingVariable == "false"){
        Send, {Enter}
    }Else{
        _changePositionVariable()
    }
return

; == END OF KEY BIDINGS ==