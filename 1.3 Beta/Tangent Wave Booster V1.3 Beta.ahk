;Davinci Resolve Tangent Wave Booster
;A software that will give to your Tangent Wave incredible powers
;Developer: Media Environment - André Rodrigues
;Contact: contato@mediaenvironment.com.br
;Version: 1.3 Beta
;Updates of this version:
;Fixed some minor bugs
;Changed the name of the software to official Tangent Wave Booster

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxHotkeysPerInterval, 200

; == Global Variables - The seted values are the default ones and shouldn't be changed ==
global _appStarted := "false" ;Define if app was started by the start button

;Set the active controllers, pages and panelsglobal _globalMousePosX := 0
global _globalMousePosY := 0
global _activePage := "edit" ;Save the active page of the davinci. Can be: "media", "cut", "edit", "fusion", "color", "fairlight", "deliver"
global _activePageBasicControls := 1 ;Save what page of the basic color controls (controllers at the bottom of the primaries/log panels) you are. Can be 1 or 2
global _activeController := "off" ;Save what controller are in use. Can be contrast, pivot, saturation, hue, lum mix, temperature, tint, md, cool boost, shad, hl, lr, hr, liftShadows, gammaMidtones, gainHighlights, liftHorizontal, gammaHorizontal, gainHorizontal, offsetHorizontal, inputHueLumSat, hueRotateSatLum, yChannel, rChannel, gChannel, bChannel, softLow, softHigh, softLS, softHS, transformSize, transformAspect, transformPan, transformTilt, transformRotate, transformOpacity, softnessSoft1, softnessSoft2, softnessSoft3, softnessSoft4, softnessInside, softnessOutside
global _activeMasterPanel := "wheels" ;Save what "master panel" is active. Can be: "raw", "checker", "wheels", "rgbmixer", "motion"
global _activePrimariesLogPanel := "primaries" ;Save what panel of primaries/log are in use. Can be primaries, bars or log. If you change the panels without the Tangent, you need to click on "RESTORE PANELS" to fix the variables and not have problems with controls.
global _activePanel := "curves" ;Save the active panel. Can be: "curves", "qualifier", "windows", "tracking", "blur", "key", "sizing"
global _activeCurvesPanel := "curves" ;Save the active curves panel. Can be: "curves", "hueXhue", "hueXsat", "hueXlum", "lumXsat", "satXsat"
global _activeBlurPanel := "blur" ;Save the active blur panel: Can be: "blur", "sharpen", "mist"
global _activeBottomBlurControl := "" ;Save the active blur panel controller. Can be: "level", "coring", "mix". NEED TO BE RESETED ON _exitAnyControlFunction
global _inspectorState := "closed" ;Save the actual state of the Inspector Panel. Can be: "closed", "opened"
global _fullInspectorState := "closed" ;Save the actual state of the full inspector Panel. Can be: "closed", "opened"

; == All this variables need to be changed when changing the resolution or workspace area - BEGIN ==
global LIFT_SHAD_WHEEL_POS := {"var": "LIFT_SHAD_WHEEL_POS", "name": "Lift and Shadows Circle Center", "posX": 165, "posY": 1700}
global GAM_MID_WHEEL_POS := {"var": "GAM_MID_WHEEL_POS", "name": "Gamma and Midtones Circle Center", "posX": 540, "posY": 1700}
global GAIN_HIGH_WHEEL_POS := {"var": "GAIN_HIGH_WHEEL_POS", "name": "Gain and Highlights Circle Center", "posX": 900, "posY": 1700}
global OFFSET_WHEEL_POS := {"var": "OFFSET_WHEEL_POS", "name": "Offset Center of the Circle", "posX": 1265, "posY": 1700}
global LIFT_SHAD_HOR_WHEEL_POS := {"var": "LIFT_SHAD_HOR_WHEEL_POS", "name": "Lift and Shadows Horizontal Wheel Center", "posX": 160, "posY": 1860}
global GAM_MID_HOR_WHEEL_POS := {"var": "GAM_MID_HOR_WHEEL_POS", "name": "Gamma and Midtones Horizontal Wheel Center", "posX": 540, "posY": 1860}
global GAIN_HIGH_HOR_WHEEL_POS := {"var": "GAIN_HIGH_HOR_WHEEL_POS", "name": "Gain and Highlights Horizontal Wheel Center", "posX": 900, "posY": 1860}
global OFFSET_HOR_WHEEL_POS := {"var": "OFFSET_HOR_WHEEL_POS", "name": "Offset Horizontal Wheel Center", "posX": 1265, "posY": 1860}
global CONTRAST_POS_PRIMARIES := {"var": "CONTRAST_POS_PRIMARIES", "name": "Contrast on Primaries Wheels and Bars - Page 1", "posX": 600, "posY": 2030}
global PIVOT_POS_PRIMARIES := {"var": "PIVOT_POS_PRIMARIES", "name": "Pivot on Primaries Wheels and Bars - Page 1", "posX": 785, "posY": 2030}
global SAT_POS_PRIMARIES := {"var": "SAT_POS_PRIMARIES", "name": "Saturation on Primaries Wheels and Bars - Page 1", "posX": 950, "posY": 2030}
global HUE_POS_PRIMARIES := {"var": "HUE_POS_PRIMARIES", "name": "Hue on Primaries Wheels and Bars - Page 1", "posX": 1120, "posY": 2030}
global LUMMIX_POS_PRIMARIES := {"var": "LUMMIX_POS_PRIMARIES", "name": "Lumix on Primaries Wheels and Bars - Page 1", "posX": 1350, "posY": 2030}
global CONTRAST_POS_LOG := {"var": "CONTRAST_POS_LOG", "name": "Contrast on Log Wheels - Page 1", "posX": 510, "posY": 2030}
global PIVOT_POS_LOG := {"var": "PIVOT_POS_LOG", "name": "Pivot on Log Wheels - Page 1", "posX": 700, "posY": 2030}
global LR_POS_LOG := {"var": "LR_POS_LOG", "name": "LR on Log Wheels - Page 1", "posX": 855, "posY": 2030}
global HR_POS_LOG := {"var": "HR_POS_LOG", "name": "HR on Log Wheels - Page 1", "posX": 1015, "posY": 2030}
global SAT_POS_LOG := {"var": "SAT_POS_LOG", "name": "Saturation on Log Wheels - Page 1", "posX": 1180, "posY": 2030}
global HUE_POS_LOG := {"var": "HUE_POS_LOG", "name": "Hue on Log Wheels - Page 1", "posX": 1350, "posY": 2030}
global TEMP_POS := {"var": "TEMP_POS", "name": "Temperature - Page 2", "posX": 435, "posY": 2030}
global TINT_POS := {"var": "TINT_POS", "name": "Tint - Page 2", "posX": 600, "posY": 2030}
global MD_POS := {"var": "MD_POS", "name": "MD - Page 2", "posX": 770, "posY": 2030}
global COLBOOST_POS := {"var": "COLBOOST_POS", "name": "Cool Boost - Page 2", "posX": 1005, "posY": 2030}
global SHAD_POS := {"var": "SHAD_POS", "name": "Shadows - Page 2", "posX": 1190, "posY": 2030}
global HL_POS := {"var": "HL_POS", "name": "HL - Page 2", "posX": 1340, "posY": 2030}
global WB_SELECTOR := {"var": "WB_SELECTOR", "name": "Auto White Balance Button", "posX": 40, "posY": 2030}
global BASIC_COLOR_PAGE1 := {"var": "BASIC_COLOR_PAGE1", "name": "Basic Color Page 1 Button", "posX": 175, "posY": 2030}
global BASIC_COLOR_PAGE2 := {"var": "BASIC_COLOR_PAGE2", "name": "Basic Color Page 2 Button", "posX": 230, "posY": 2030}
global PRIMARIES_WHEELS_TAB := {"var": "PRIMARIES_WHEELS_TAB", "name": "Primaries Wheels Button on Color Tab", "posX": 635, "posY": 1475}
global PRIMARIES_BARS_TAB := {"var": "PRIMARIES_BARS_TAB", "name": "Primaries Bars Button on Color Tab", "posX": 675, "posY": 1475}
global LOG_WHEELS_TAB := {"var": "LOG_WHEELS_TAB", "name": "Log Wheels Button on Color Tab", "posX": 710, "posY": 1475}
global PREVIEW_WINDOW_POS := {"var": "PREVIEW_WINDOW_POS", "name": "Center of the Preview Window on Edit Tab", "posX": 1500, "posY": 600}
global TIMELINE_WINDOW_POS := {"var"Ie: "TIMELINE_WINDOW_POS", "name": "Position of the Timeline on Edit Tab", "posX": 1310, "posY": 1540}
global TIMELINE_TIMEBAR_POS := {"var": "TIMELINE_TIMEBAR_POS", "name": "Timeline Timebar on Edit Tab", "posX": 2475, "posY": 1290}
global MEDIA_POOL_BUTTON_POS := {"var": "MEDIA_POOL_BUTTON_POS", "name": "Media Pool Button on Edit Tab", "posX": 230, "posY": 80}
global FIRST_CLIP_POOL_POS := {"var": "FIRST_CLIP_POOL_POS", "name": "First Clip on Media Pool", "posX": 420, "posY": 220}
global EFFECTS_BUTTON_POS := {"var": "EFFECTS_BUTTON_POS", "name": "Effects Button on Edit Tab", "posX": 500, "posY": 80}
global INDEX_BUTTON_POS := {"var": "INDEX_BUTTON_POS", "name": "Index Button on Edit Tab", "posX": 760, "posY": 80}
global SOUND_LIB_BUTTON_POS := {"var": "SOUND_LIB_BUTTON_POS", "name": "Sound Library Button on Edit Tab", "posX": 1020, "posY": 80}
global SEARCH_SOUND_POS := {"var": "SEARCH_SOUND_POS", "name": "Search Bar on Sound Library", "posX": 130, "posY": 210}
global MIXER_BUTTON_POS := {"var": "MIXER_BUTTON_POS", "name": "Mixer Button on Edit Tab", "posX": 3200, "posY": 80}
global METADATA_BUTTON_POS := {"var": "METADATA_BUTTON_POS", "name": "Metadata Button on Edit Tab", "posX": 3420, "posY": 80}
global INSPECTOR_BUTTON_POS := {"var": "INSPECTOR_BUTTON_POS", "name": "Inspector Button on Edit Tab", "posX": 3640, "posY": 80}
global CURVES_PANEL_BUTTON_POS := {"var": "CURVES_PANEL_BUTTON_POS", "name": "Main Curves Button on Color Tab", "posX": 2055, "posY": 1477}
global HUEXHUE_PANEL_BUTTON_POS := {"var": "HUEXHUE_PANEL_BUTTON_POS", "name": "Hue vs Hue Button on Color Tab", "posX": 2093, "posY": 1477}
global HUEXSAT_PANEL_BUTTON_POS := {"var": "HUEXSAT_PANEL_BUTTON_POS", "name": "Hue vs Sat Button on Color Tab", "posX": 2131, "posY": 1477}
global HUEXLUM_PANEL_BUTTON_POS := {"var": "HUEXLUM_PANEL_BUTTON_POS", "name": "Hue vs Lum Button on Color Tab", "posX": 2169, "posY": 1477}
global LUMXSAT_PANEL_BUTTON_POS := {"var": "LUMXSAT_PANEL_BUTTON_POS", "name": "Lum vs Sat Button on Color Tab", "posX": 2207, "posY": 1477}
global SATXSAT_PANEL_BUTTON_POS := {"var": "SATXSAT_PANEL_BUTTON_POS", "name": "Sat vs Sat Button on Color Tab", "posX": 2245, "posY": 1477}
global VS_CURVES_RED_POINT_POS := {"var": "VS_CURVES_RED_POINT_POS", "name": "Red Point on Vs Curves", "posX": 1560, "posY": 2027}
global VS_CURVES_YELLOW_POINT_POS := {"var": "VS_CURVES_YELLOW_POINT_POS", "name": "Yellow Point on Vs Curves", "posX": 1619, "posY": 2027}
global VS_CURVES_GREEN_POINT_POS := {"var": "VS_CURVES_GREEN_POINT_POS", "name": "Green Point on Vs Curves", "posX": 1678, "posY": 2027}
global VS_CURVES_CYAN_POINT_POS := {"var": "VS_CURVES_CYAN_POINT_POS", "name": "Cyan Point on Vs Curves", "posX": 1735, "posY": 2027}
global VS_CURVES_BLUE_POINT_POS := {"var": "VS_CURVES_BLUE_POINT_POS", "name": "Blue Point on Vs Curves", "posX": 1793, "posY": 2027}
global VS_CURVES_PURPLE_POINT_POS := {"var": "VS_CURVES_PURPLE_POINT_POS", "name": "Purple Point on Vs Curves", "posX": 1852, "posY": 2027}
global VS_CURVES_BLACK_POINT_POS := {"var": "VS_CURVES_BLACK_POINT_POS", "name": "Black Point on Vs Curves", "posX": 1560, "posY": 2027}
global VS_CURVES_WHITE_POINT_POS := {"var": "VS_CURVES_WHITE_POINT_POS", "name": "White Point on Vs Curves", "posX": 1620, "posY": 2027}
global VS_CURVES_SPINE_POINT_POS := {"var": "VS_CURVES_SPINE_POINT_POS", "name": "Spine Point on Vs Curves", "posX": 1501, "posY": 2027}
global INPUT_HUEXHUE_POS := {"var": "INPUT_HUEXHUE_POS", "name": "Input Hue on Hue vs Hue", "posX": 2490, "posY": 2030}
global INPUT_HUEXSAT_POS := {"var": "INPUT_HUEXSAT_POS", "name": "Input Hue on Hue vs Sat", "posX": 2500, "posY": 2030}
global INPUT_HUEXLUM_POS := {"var": "INPUT_HUEXLUM_POS", "name": "Input Hue on Hue vs Lum", "posX": 2515, "posY": 2030}
global INPUT_LUMXSAT_POS := {"var": "INPUT_LUMXSAT_POS", "name": "Input Lum on Lum vs Sat", "posX": 2505, "posY": 2030}
;global INPUT_SATXSAT_POS := {"var": "INPUT_SATXSAT_POS", "name": "Input Sat on Sat vs Sat", "posX": 2500, "posY": 2030} ;CONTROL OF SAT vs SAT PANEL - NEED TO BE REVISED ON NEXT VERSION
global HUE_ROT_SAT_LUMGAIN_POS := {"var": "HUE_ROT_SAT_LUMGAIN_POS", "name": "Hue Rotate/Sat/Lum on Vs Curves", "posX": 2790, "posY": 2030}
global CURVES_RESET_BUTTON_POS := {"var": "CURVES_RESET_BUTTON_POS", "name": "Reset Button on Curves Panel", "posX": 2770, "posY": 1480}
global DEFAULT_BLACK_POINT_POS := {"var": "DEFAULT_BLACK_POINT_POS", "name": "Default Black Point Position on Main Curves", "posX": 1490, "posY": 2015}
global DEFAULT_SHADOW_POINT_POS := {"var": "DEFAULT_SHADOW_POINT_POS", "name": "Default Shadow Point Position on Main Curves", "posX": 1662, "posY": 1921}
global DEFAULT_MIDBLACK_POINT_POS := {"var": "DEFAULT_MIDBLACK_POINT_POS", "name": "Default Mid-Black Point Position on Main Curves", "posX": 1832, "posY": 1830}
global DEFAULT_MIDWHITE_POINT_POS := {"var": "DEFAULT_MIDWHITE_POINT_POS", "name": "Default Mid-White Point Position on Main Curves", "posX": 2003, "posY": 1737}
global DEFAULT_HIGH_POINT_POS := {"var": "DEFAULT_HIGH_POINT_POS", "name": "Default Highlights Point Position on Main Curves", "posX": 2174, "posY": 1646}
global DEFAULT_WHITE_POINT_POS := {"var": "DEFAULT_WHITE_POINT_POS", "name": "Default White Point Position on Main Curves", "posX": 2346, "posY": 1555}
global LUMA_LIFT_BAR_POS := {"var": "LUMA_LIFT_BAR_POS", "name": "Luma Bar on Lift Primaries Bars", "posX": 60, "posY": 1700}
global LIFT_RED_BAR_POS := {"var": "LIFT_RED_BAR_POS", "name": "Red Bar on Lift Primaries Bars", "posX": 130, "posY": 1700}
global LIFT_GREEN_BAR_POS := {"var": "LIFT_GREEN_BAR_POS", "name": "Green Bar on Lift Primaries Bars", "posX": 210, "posY": 1700}
global LIFT_BLUE_BAR_POS := {"var": "LIFT_BLUE_BAR_POS", "name": "Blue Bar on Lift Primaries Bars", "posX": 290, "posY": 1700}
global LUMA_GAMMA_BAR_POS := {"var": "LUMA_GAMMA_BAR_POS", "name": "Luma Bar on Gamma Primaries Bars", "posX": 420, "posY": 1700}
global GAMMA_RED_BAR_POS := {"var": "GAMMA_RED_BAR_POS", "name": "Red Bar on Gamma Primaries Bars", "posX": 500, "posY": 1700}
global GAMMA_GREEN_BAR_POS := {"var": "GAMMA_GREEN_BAR_POS", "name": "Green Bar on Gamma Primaries Bars", "posX": 575, "posY": 1700}
global GAMMA_BLUE_BAR_POS := {"var": "GAMMA_BLUE_BAR_POS", "name": "Blue Bar on Gamma Primaries Bars", "posX": 655, "posY": 1700}
global LUMA_GAIN_BAR_POS := {"var": "LUMA_GAIN_BAR_POS", "name": "Luma Bar on Gain Primaries Bars", "posX": 790, "posY": 1700}
global GAIN_RED_BAR_POS := {"var": "GAIN_RED_BAR_POS", "name": "Red Bar on Gain Primaries Bars", "posX": 865, "posY": 1700}
global GAIN_GREEN_BAR_POS := {"var": "GAIN_GREEN_BAR_POS", "name": "Green Bar on Gain Primaries Bars", "posX": 945, "posY": 1700}
global GAIN_BLUE_BAR_POS := {"var": "GAIN_BLUE_BAR_POS", "name": "Blue Bar on Gain Primaries Bars", "posX": 1020, "posY": 1700}
global OFFSET_RED_BAR_POS := {"var": "OFFSET_RED_BAR_POS", "name": "Red Bar on Offset Primaries Bars", "posX": 1185, "posY": 1700}
global OFFSET_GREEN_BAR_POS := {"var": "OFFSET_GREEN_BAR_POS", "name": "Green Bar on Offset Primaries Bars", "posX": 1265, "posY": 1700}
global OFFSET_BLUE_BAR_POS := {"var": "OFFSET_BLUE_BAR_POS", "name": "Blue Bar on Offset Primaries Bars", "posX": 1350, "posY": 1700}
global CURVES_PANEL_POS := {"var": "CURVES_PANEL_POS", "name": "Curves Panel Button", "posX": 1620, "posY": 1420}
global QUALIFIER_PANEL_POS := {"var": "QUALIFIER_PANEL_POS", "name": "Qualifier Panel Button", "posX": 1740, "posY": 1420}
global WINDOWS_PANEL_POS := {"var": "WINDOWS_PANEL_POS", "name": "Power Windows Panel Button", "posX": 1860, "posY": 1420}
global TRACKING_PANEL_POS := {"var": "TRACKING_PANEL_POS", "name": "Tracking Panel Button", "posX": 1980, "posY": 1420}
global BLUR_PANEL_POS := {"var": "BLUR_PANEL_POS", "name": "Blur/Sharpen/Mist Panel Button", "posX": 2100, "posY": 1420}
global RGB_MIXER_PANEL_POS := {"var": "RGB_MIXER_PANEL_POS", "name": "RGB Mixer Panel Button", "posX": 420, "posY": 1420}
global KEY_PANEL_POS := {"var": "KEY_PANEL_POS", "name": "Key Panel Button", "posX": 2220, "posY": 1420}
global SIZING_PANEL_POS := {"var": "SIZING_PANEL_POS", "name": "Sizing Panel Button", "posX": 2340, "posY": 1420}
global CURVES_DOTS_MENU_POS := {"var": "CURVES_DOTS_MENU_POS", "name": "3 Dots Menu on Curves Panel", "posX": 2845, "posY": 1475}
global CREATE_POINTS_MENU_POS := {"var": "CREATE_POINTS_MENU_POS", "name": "Create Default Anchor Points Menu", "posX": 3000, "posY": 1780}
global LIFT_SHADOWS_RESET_POS := {"var": "LIFT_SHADOWS_RESET_POS", "name": "Lift/Shadows Reset Button", "posX": 305, "posY": 1540}
global GAMMA_MID_RESET_POS := {"var": "GAMMA_MID_RESET_POS", "name": "Gamma/Mid Tones Reset Button", "posX": 675, "posY": 1540}
global GAIN_HIGH_RESET_POS := {"var": "GAIN_HIGH_RESET_POS", "name": "Gain/Highlights Reset Button", "posX": 1040, "posY": 1540}
global OFFSET_RESET_POS := {"var": "OFFSET_RESET_POS", "name": "Offset Reset Button", "posX": 1400, "posY": 1540}
global RESET_ALL_PRIMARIES_LOG_POS := {"var": "RESET_ALL_PRIMARIES_LOG_POS", "name": "Reset All Primaries/Log Button", "posX": 1400, "posY": 1480}
global SELECT_ALL_CURVES_BUTTON_POS := {"var": "SELECT_ALL_CURVES_BUTTON_POS", "name": "Select All Curves Button", "posX": 2560, "posY": 1535}
global SELECT_Y_CURVE_BUTTON_POS := {"var": "SELECT_Y_CURVE_BUTTON_POS", "name": "Select Y Curve Button", "posX": 2600, "posY": 1535}
global SELECT_R_CURVE_BUTTON_POS := {"var": "SELECT_R_CURVE_BUTTON_POS", "name": "Select R Curve Button", "posX": 2655, "posY": 1535}
global SELECT_G_CURVE_BUTTON_POS := {"var": "SELECT_G_CURVE_BUTTON_POS", "name": "Select G Curve Button", "posX": 2710, "posY": 1535}
global SELECT_B_CURVE_BUTTON_POS := {"var": "SELECT_B_CURVE_BUTTON_POS", "name": "Select B Curve Button", "posX": 2765, "posY": 1535}
global PREVIEW_WINDOW_COLOR_PAGE_POS := {"var": "PREVIEW_WINDOW_COLOR_PAGE_POS", "name": "Preview Window on Color Page", "posX": 1900, "posY": 500}
global GRAB_STILL_MENU_POS := {"var": "GRAB_STILL_MENU_POS", "name": "Grab Still on Preview Window Right Click Menu", "posX": 2015, "posY": 540}
global Y_CHANNEL_ITENSITY_CURVES_POS := {"var": "Y_CHANNEL_ITENSITY_CURVES_POS", "name": "Y Channel Intensity on Curves", "posX": 2740, "posY": 1605}
global R_CHANNEL_ITENSITY_CURVES_POS := {"var": "R_CHANNEL_ITENSITY_CURVES_POS", "name": "R Channel Intensity on Curves", "posX": 2740, "posY": 1655}
global G_CHANNEL_ITENSITY_CURVES_POS := {"var": "G_CHANNEL_ITENSITY_CURVES_POS", "name": "G Channel Intensity on Curves", "posX": 2740, "posY": 1705}
global B_CHANNEL_ITENSITY_CURVES_POS := {"var": "B_CHANNEL_ITENSITY_CURVES_POS", "name": "B Channel Intensity on Curves", "posX": 2740, "posY": 1755}
global SOFT_LOW_CURVES_POS := {"var": "SOFT_LOW_CURVES_POS", "name": "Soft Low on Curves", "posX": 2550, "posY": 1925}
global SOFT_HIGH_CURVES_POS := {"var": "SOFT_HIGH_CURVES_POS", "name": "Soft High on Curves", "posX": 2770, "posY": 1925}
global SOFT_LS_CURVES_POS := {"var": "SOFT_LS_CURVES_POS", "name": "Soft LS on Curves", "posX": 2550, "posY": 1975}
global SOFT_HS_CURVES_POS := {"var": "SOFT_HS_CURVES_POS", "name": "Soft HS on Curves", "posX": 2770, "posY": 1975}
global RESET_SOFT_CLIP_POS := {"var": "RESET_SOFT_CLIP_POS", "name": "Reset Soft Clip on Curves", "posX": 2850, "posY": 1840}
global ALL_CHANNELS_SOFT_CLIP := {"var": "ALL_CHANNELS_SOFT_CLIP", "name": "Select All Channels to Soft Clip on Curves", "posX": 2615, "posY": 1840}
global RED_CHANNEL_SOFT_CLIP := {"var": "RED_CHANNEL_SOFT_CLIP", "name": "Select Red Channel to Soft Clip on Curves", "posX": 2655, "posY": 1840}
global GREEN_CHANNEL_SOFT_CLIP := {"var": "GREEN_CHANNEL_SOFT_CLIP", "name": "Select Green Channel to Soft Clip on Curves", "posX": 2710, "posY": 1840}
global BLUE_CHANNEL_SOFT_CLIP := {"var": "BLUE_CHANNEL_SOFT_CLIP", "name": "Select Blue Channel to Soft Clip on Curves", "posX": 2765, "posY": 1840}
global BLUR_BUTTON_BLUR_PANEL_POS := {"var": "BLUR_BLUR_PANEL_POS", "name": "Blur Button on Blur Panel", "posX": 2077, "posY": 1477}
global SHARPEN_BUTTON_BLUR_PANEL_POS := {"var": "SHARPEN_BUTTON_BLUR_PANEL_POS", "name": "Sharpen Button on Blur Panel", "posX": 2115, "posY": 1477}
global MIST_BUTTON_BLUR_PANEL_POS := {"var": "MIST_BUTTON_BLUR_PANEL_POS", "name": "Mist Button on Blur Panel", "posX": 2153, "posY": 1477}
global PRIMARIES_PANEL_POS := {"var": "PRIMARIES_PANEL_POS", "name": "Primaries Panel", "posX": 295, "posY": 1420}
global PICK_BLACK_POINT_POS := {"var": "PICK_BLACK_POINT_POS", "name": "Pick Black Point Button on Primaries Bars Panel", "posX": 40, "posY": 1540}
global PICK_WHITE_POINT_POS := {"var": "PICK_WHITE_POINT_POS", "name": "Pick White Point on Primaries Bars Panel", "posX": 770, "posY": 1540}
global RGB_RED_OUT_RED_BAR := {"var": "RGB_RED_OUT_RED_BAR", "name": "RGB Mixer Red Output Red Bar", "posX": 140, "posY": 1725}
global RGB_RED_OUT_GREEN_BAR := {"var": "RGB_RED_OUT_GREEN_BAR", "name": "RGB Mixer Red Output Green Bar", "posX": 245, "posY": 1725}
global RGB_RED_OUT_BLUE_BAR := {"var": "RGB_RED_OUT_BLUE_BAR", "name": "RGB Mixer Red Output Blue Bar", "posX": 355, "posY": 1725}
global RGB_GREEN_OUT_RED_BAR := {"var": "RGB_GREEN_OUT_RED_BAR", "name": "RGB Mixer Green Output Red Bar", "posX": 615, "posY": 1725}
global RGB_GREEN_OUT_GREEN_BAR := {"var": "RGB_GREEN_OUT_GREEN_BAR", "name": "RGB Mixer Green Output Green Bar", "posX": 720, "posY": 1725}
global RGB_GREEN_OUT_BLUE_BAR := {"var": "RGB_GREEN_OUT_BLUE_BAR", "name": "RGB Mixer Green Output Blue Bar", "posX": 830, "posY": 1725}
global RGB_BLUE_OUT_RED_BAR := {"var": "RGB_BLUE_OUT_RED_BAR", "name": "RGB Mixer Blue Output Red Bar", "posX": 1095, "posY": 1725}
global RGB_BLUE_OUT_GREEN_BAR := {"var": "RGB_BLUE_OUT_GREEN_BAR", "name": "RGB Mixer Blue Output Green Bar", "posX": 1200, "posY": 1725}
global RGB_BLUE_OUT_BLUE_BAR := {"var": "RGB_BLUE_OUT_BLUE_BAR", "name": "RGB Mixer Blue Output Blue Bar", "posX": 1305, "posY": 1725}
global INVERT_RED_GREEN_RGB_MIXER_POS := {"var": "INVERT_RED_GREEN_RGB_MIXER_POS", "name": "Invert Red/Green Button on RGB Mixer", "posX": 80, "posY": 2030}
global INVERT_GREEN_BLUE_RGB_MIXER_POS := {"var": "INVERT_GREEN_BLUE_RGB_MIXER_POS", "name": "Invert Green/Blue Button on RGB Mixer", "posX": 180, "posY": 2030}
global INVERT_BLUE_RED_RGB_MIXER_POS := {"var": "INVERT_BLUE_RED_RGB_MIXER_POS", "name": "Invert Blue/Red Button on RGB Mixer", "posX": 280, "posY": 2030}
global MONOCHROME_RGB_MIXER_POS := {"var": "MONOCHROME_RGB_MIXER_POS", "name": "Monochrome Checkbox on RGB Mixer", "posX": 870, "posY": 2030}
global PRES_LUM_RGB_MIXER_POS := {"var": "PRES_LUM_RGB_MIXER_POS", "name": "Preserve Luminance Checkbox on RGB Mixer", "posX": 1120, "posY": 2030}
global RADIUS_RED_BAR_POS := {"var": "RADIUS_RED_BAR_POS", "name": "Radius Red Bar", "posX": 1575, "posY": 1725}
global RADIUS_GREEN_BAR_POS := {"var": "RADIUS_GREEN_BAR_POS", "name": "Radius Green Bar", "posX": 1680, "posY": 1725}
global RADIUS_BLUE_BAR_POS := {"var": "RADIUS_BLUE_BAR_POS", "name": "Radius Blue Bar", "posX": 1785, "posY": 1725}
global HV_RED_BAR_POS := {"var": "HV_RED_BAR_POS", "name": "H/V Red Bar", "posX": 2055, "posY": 1725}
global HV_GREEN_BAR_POS := {"var": "HV_GREEN_BAR_POS", "name": "H/V Green Bar", "posX": 2160, "posY": 1725}
global HV_BLUE_BAR_POS := {"var": "HV_BLUE_BAR_POS", "name": "H/V Blue Bar", "posX": 2265, "posY": 1725}
global SCALING_RED_BAR_POS := {"var": "SCALING_RED_BAR_POS", "name": "Scaling Red Bar", "posX": 2535, "posY": 1725}
global SCALING_GREEN_BAR_POS := {"var": "SCALING_GREEN_BAR_POS", "name": "Scaling Green Bar", "posX": 2640, "posY": 1725}
global SCALING_BLUE_BAR_POS := {"var": "SCALING_BLUE_BAR_POS", "name": "Scaling Blue Bar", "posX": 2745, "posY": 1725}
global CORING_SOFTNESS_BLUR_PANEL_POS := {"var": "CORING_SOFTNESS_BLUR_PANEL_POS", "name": "Coring Softness Sharpen Control", "posX": 2010, "posY": 2030}
global LEVEL_BLUR_PANEL_POS := {"var": "LEVEL_BLUR_PANEL_POS", "name": "Level Sharpen Control", "posX": 2280, "posY": 2030}
global MIX_BLUR_PANEL_POS := {"var": "MIX_BLUR_PANEL_POS", "name": "Mix Mist Control", "posX": 2530, "posY": 2030}
global RESET_RED_OUTPUT_RGB_MIXER_POS := {"var": "RESET_RED_OUTPUT_RGB_MIXER_POS", "name": "Reset Red Output Button on RGB Mixer", "posX": 415, "posY": 1540}
global RESET_GREEN_OUTPUT_RGB_MIXER_POS := {"var": "RESET_GREEN_OUTPUT_RGB_MIXER_POS", "name": "Reset Green Output Button on RGB Mixer", "posX": 890, "posY": 1540}
global RESET_BLUE_OUTPUT_RGB_MIXER_POS := {"var": "RESET_BLUE_OUTPUT_RGB_MIXER_POS", "name": "Reset Blue Output Button on RGB Mixer", "posX": 1370, "posY": 1540}
global RESET_RADIUS_BLUR_PANEL_POS := {"var": "RESET_RADIUS_BLUR_PANEL_POS", "name": "Reset Radius Button on Blur Panel", "posX": 1855, "posY": 1540}
global RESET_HV_BLUR_PANEL_POS := {"var": "RESET_HV_BLUR_PANEL_POS", "name": "Reset H/V Button on Blur Panel", "posX": 2330, "posY": 1540}
global RESET_SCALING_BLUR_PANEL_POS := {"var": "RESET_SCALING_BLUR_PANEL_POS", "name": "Reset Scaling Button on Blur Panel", "posX": 2810, "posY": 1540}
global RESET_RGB_MIXER_POS := {"var": "RESET_RGB_MIXER_POS", "name": "Reset All RGB Mixer Button", "posX": 1405, "posY": 1480}
global RESET_BLUR_PANEL_POS := {"var": "RESET_BLUR_PANEL_POS", "name": "Reset All Blur Panel Button", "posX": 2845, "posY": 1480}
global LINK_RADIUS_BLUR_PANEL_POS := {"var": "LINK_RADIUS_BLUR_PANEL_POS", "name": "Link Radius Button on Blur Panel", "posX": 1510, "posY": 1540}
global LINK_HV_BLUR_PANEL_POS := {"var": "LINK_HV_BLUR_PANEL_POS", "name": "Link H/V Button on Blur Panel", "posX": 2000, "posY": 1540}
global LINK_SCALING_BLUR_PANEL_POS := {"var": "LINK_SCALING_BLUR_PANEL_POS", "name": "Link Scaling Button on Blur Panel", "posX": 2470, "posY": 1540}
global TRANSFORM_SIZE_PW_POS := {"var": "TRANSFORM_SIZE_PW_POS", "name": "Transform Size on Power Windows", "posX": 2555, "posY": 1580}
global TRANSFORM_ASPECT_PW_POS := {"var": "TRANSFORM_ASPECT_PW_POS", "name": "Transform Aspect on Power Windows", "posX": 2795, "posY": 1580}
global TRANSFORM_PAN_PW_POS := {"var": "TRANSFORM_PAN_PW_POS", "name": "Transform Pan on Power Windows", "posX": 2555, "posY": 1635}
global TRANSFORM_TILT_PW_POS := {"var": "TRANSFORM_TILT_PW_POS", "name": "Transform Tilt on Power Windows", "posX": 2795, "posY": 1635}
global TRANSFORM_ROTATE_PW_POS := {"var": "TRANSFORM_ROTATE_PW_POS", "name": "Transform Rotate on Power Windows", "posX": 2555, "posY": 1690}
global TRANSFORM_OPACITY_PW_POS := {"var": "TRANSFORM_OPACITY_PW_POS", "name": "Transform Opacity on Power Windows", "posX": 2795, "posY": 1690}
global SOFTNESS_SOFT1_PW_POS := {"var": "SOFTNESS_SOFT1_PW_POS", "name": "Softness Soft 1 on Power Windows", "posX": 2555, "posY": 1810}
global SOFTNESS_SOFT2_PW_POS := {"var": "SOFTNESS_SOFT2_PW_POS", "name": "Softness Soft 2 on Power Windows", "posX": 2795, "posY": 1810}
global SOFTNESS_SOFT3_PW_POS := {"var": "SOFTNESS_SOFT3_PW_POS", "name": "Softness Soft 3 on Power Windows", "posX": 2555, "posY": 1865}
global SOFTNESS_SOFT4_PW_POS := {"var": "SOFTNESS_SOFT4_PW_POS", "name": "Softness Soft 4 on Power Windows", "posX": 2795, "posY": 1865}
global SOFTNESS_INSIDE_PW_POS := {"var": "SOFTNESS_INSIDE_PW_POS", "name": "Softness Inside on Power Windows", "posX": 2555, "posY": 1920}
global SOFTNESS_OUTSIDE_PW_POS := {"var": "SOFTNESS_OUTSIDE_PW_POS", "name": "Softness Outside on Power Windows", "posX": 2795, "posY": 1920}
global RESET_PW_POS := {"var": "RESET_PW_POS", "name": "Reset Button on Power Windows", "posX": 2770, "posY": 1480}
global FULL_INSPECTOR_BUTTON_POS := {"var": "FULL_INSPECTOR_BUTTON_POS", "name": "Full inspector Button on Edit Page", "posX": 3790, "posY": 65}
global INSPECTOR_OPACITY_POS := {"var": "INSPECTOR_OPACITY_POS", "name": "Opacity on Inspector Panel", "posX": 3615, "posY": 340}
global INSPECTOR_ZOOM_X_POS := {"var": "INSPECTOR_ZOOM_X_POS", "name": "Zoom X on Inspector Panel", "posX": 3405, "posY": 515}
global INSPECTOR_ZOOM_Y_POS := {"var": "INSPECTOR_ZOOM_Y_POS", "name": "Zoom Y on Inspector Panel", "posX": 3615, "posY": 515}
global INSPECTOR_POSITION_X_POS := {"var": "INSPECTOR_POSITION_X_POS", "name": "Position X on Inspector Panel", "posX": 3405, "posY": 580}
global INSPECTOR_POSITION_Y_POS := {"var": "INSPECTOR_POSITION_Y_POS", "name": "Position Y on Inspector Panel", "posX": 3615, "posY": 580}
global INSPECTOR_ROTATION_POS := {"var": "INSPECTOR_ROTATION_POS", "name": "Rotation on Inspector Panel", "posX": 3615, "posY": 645}
global INSPECTOR_ANCHOR_X_POS := {"var": "INSPECTOR_ANCHOR_X_POS", "name": "Anchor X on Inspector Panel", "posX": 3405, "posY": 710}
global INSPECTOR_ANCHOR_Y_POS := {"var": "INSPECTOR_ANCHOR_Y_POS", "name": "Anchor Y on Inspector Panel", "posX": 3615, "posY": 710}
global INSPECTOR_PITCH_POS := {"var": "INSPECTOR_PITCH_POS", "name": "Pitch on Inspector Panel", "posX": 3615, "posY": 770}
global INSPECTOR_YAW_POS := {"var": "INSPECTOR_YAW_POS", "name": "Yaw on Inspector Panel", "posX": 3615, "posY": 835}
global RESET_ALL_BASIC_TRANSFORM_POS := {"var": "RESET_ALL_BASIC_TRANSFORM_POS", "name": "Reset All Basic Transform on Inspector Panel", "posX": 3785, "posY": 430}
global RESET_INSPECTOR_ZOOM_POS := {"var": "RESET_INSPECTOR_ZOOM_POS", "name": "Reset Transform Zoom Button on Inspector Panel", "posX": 3785, "posY": 510}
global RESET_INSPECTOR_POSITION_POS := {"var": "RESET_INSPECTOR_POSITION_POS", "name": "Reset Transform Position Button on Inspector Panel", "posX": 3785, "posY": 575}
global RESET_INSPECTOR_ROTATION_POS := {"var": "RESET_INSPECTOR_ROTATION_POS", "name": "Reset Transform Rotation Button on Inspector Panel", "posX": 3785, "posY": 640}
global RESET_INSPECTOR_ANCHOR_POS := {"var": "RESET_INSPECTOR_ANCHOR_POS", "name": "Reset Transform Anchor Button on Inspector Panel", "posX": 3785, "posY": 705}
global RESET_INSPECTOR_PITCH_POS := {"var": "RESET_INSPECTOR_PITCH_POS", "name": "Reset Transform Pitch Button on Inspector Panel", "posX": 3785, "posY": 765}
global RESET_INSPECTOR_YAW_POS := {"var": "RESET_INSPECTOR_YAW_POS", "name": "Reset Transform Yaw Button on Inspector Panel", "posX": 3785, "posY": 830}
global RESET_INSPECTOR_FLIP_POS := {"var": "RESET_INSPECTOR_FLIP_POS", "name": "Reset Transform Flip Button on Inspector Panel", "posX": 3785, "posY": 895}
global RESET_INSPECTOR_OPACITY_POS := {"var": "RESET_INSPECTOR_OPACITY_POS", "name": "Reset Transform Opacity Button on Inspector Panel", "posX": 3785, "posY": 340}
global INSPECTOR_FLIP_HORIZONTAL_POS := {"var": "INSPECTOR_FLIP_HORIZONTAL_POS", "name": "Reset Transform Opacity Button on Inspector Panel", "posX": 3335, "posY": 905}
global INSPECTOR_FLIP_VERTICAL_POS := {"var": "INSPECTOR_FLIP_VERTICAL_POS", "name": "Reset Transform Opacity Button on Inspector Panel", "posX": 3415, "posY": 905}
global INSPECTOR_ZOOM_LINK_POS := {"var": "INSPECTOR_ZOOM_LINK_POS", "name": "Reset Transform Opacity Button on Inspector Panel", "posX": 3500, "posY": 510}
global INSPECTOR_OPACITY_KEYFRAME_POS := {"var": "INSPECTOR_OPACITY_KEYFRAME_POS", "name": "Opacity Keyframe Button on Inspector Panel", "posX": 3721, "posY": 340}
global INSPECTOR_ZOOM_KEYFRAME_POS := {"var": "INSPECTOR_ZOOM_KEYFRAME_POS", "name": "Zoom Keyframe Button on Inspector Panel", "posX": 3721, "posY": 513}
global INSPECTOR_POSITION_KEYFRAME_POS := {"var": "INSPECTOR_POSITION_KEYFRAME_POS", "name": "Position Keyframe Button on Inspector Panel", "posX": 3721, "posY": 577}
global INSPECTOR_ROTATION_KEYFRAME_POS := {"var": "INSPECTOR_ROTATION_KEYFRAME_POS", "name": "Rotation Keyframe Button on Inspector Panel", "posX": 3721, "posY": 640}
global INSPECTOR_ANCHOR_KEYFRAME_POS := {"var": "INSPECTOR_ANCHOR_KEYFRAME_POS", "name": "Anchor Keyframe Button on Inspector Panel", "posX": 3721, "posY": 705}
global INSPECTOR_PITCH_KEYFRAME_POS := {"var": "INSPECTOR_PITCH_KEYFRAME_POS", "name": "Pitch Keyframe Button on Inspector Panel", "posX": 3721, "posY": 769}
global INSPECTOR_YAW_KEYFRAME_POS := {"var": "INSPECTOR_YAW_KEYFRAME_POS", "name": "Yaw Keyframe Button on Inspector Panel", "posX": 3721, "posY": 833}
global RESET_CURVES_VS_POS := {"var": "RESET_CURVES_VS_POS", "name": "Reset Curves VS on Curves Panel", "posX": 2770, "posY": 1480}
global RESET_Y_CHANNEL_INTENSITY_POS := {"var": "RESET_Y_CHANNEL_INTENSITY_POS", "name": "Reset Y Channel Intensity on Curves Panel", "posX": 2850, "posY": 1600}
global RESET_R_CHANNEL_INTENSITY_POS := {"var": "RESET_R_CHANNEL_INTENSITY_POS", "name": "Reset R Channel Intensity on Curves Panel", "posX": 2850, "posY": 1650}
global RESET_G_CHANNEL_INTENSITY_POS := {"var": "RESET_G_CHANNEL_INTENSITY_POS", "name": "Reset G Channel Intensity on Curves Panel", "posX": 2850, "posY": 1700}
global RESET_B_CHANNEL_INTENSITY_POS := {"var": "RESET_B_CHANNEL_INTENSITY_POS", "name": "Reset B Channel Intensity on Curves Panel", "posX": 2850, "posY": 1750}
global NEUTRAL_PLACE_ON_NODES_PANEL_POS := {"var": "NEUTRAL_PLACE_ON_NODES_PANEL_POS", "name": "Neutral Place on Nodes Panel", "posX": 2890, "posY": 210}

;Save all the objects position constants on a array
global _positionsArray := [LIFT_SHAD_WHEEL_POS,GAM_MID_WHEEL_POS,GAIN_HIGH_WHEEL_POS,OFFSET_WHEEL_POS,LIFT_SHAD_HOR_WHEEL_POS,GAM_MID_HOR_WHEEL_POS,GAIN_HIGH_HOR_WHEEL_POS,OFFSET_HOR_WHEEL_POS,CONTRAST_POS_PRIMARIES,PIVOT_POS_PRIMARIES,SAT_POS_PRIMARIES,HUE_POS_PRIMARIES,LUMMIX_POS_PRIMARIES,CONTRAST_POS_LOG,PIVOT_POS_LOG,LR_POS_LOG,HR_POS_LOG,SAT_POS_LOG,HUE_POS_LOG,TEMP_POS,TINT_POS,MD_POS,COLBOOST_POS,SHAD_POS,HL_POS,WB_SELECTOR,BASIC_COLOR_PAGE1,BASIC_COLOR_PAGE2,PRIMARIES_WHEELS_TAB,PRIMARIES_BARS_TAB,LOG_WHEELS_TAB,PREVIEW_WINDOW_POS,TIMELINE_WINDOW_POS,TIMELINE_TIMEBAR_POS,MEDIA_POOL_BUTTON_POS,FIRST_CLIP_POOL_POS,EFFECTS_BUTTON_POS,INDEX_BUTTON_POS,SOUND_LIB_BUTTON_POS,SEARCH_SOUND_POS,MIXER_BUTTON_POS,METADATA_BUTTON_POS,INSPECTOR_BUTTON_POS,CURVES_PANEL_BUTTON_POS,HUEXHUE_PANEL_BUTTON_POS,HUEXSAT_PANEL_BUTTON_POS,HUEXLUM_PANEL_BUTTON_POS,LUMXSAT_PANEL_BUTTON_POS,SATXSAT_PANEL_BUTTON_POS,VS_CURVES_RED_POINT_POS,VS_CURVES_YELLOW_POINT_POS,VS_CURVES_GREEN_POINT_POS,VS_CURVES_CYAN_POINT_POS,VS_CURVES_BLUE_POINT_POS,VS_CURVES_PURPLE_POINT_POS,VS_CURVES_BLACK_POINT_POS,VS_CURVES_WHITE_POINT_POS,VS_CURVES_SPINE_POINT_POS,INPUT_HUEXHUE_POS,INPUT_HUEXSAT_POS,INPUT_HUEXLUM_POS,INPUT_LUMXSAT_POS,HUE_ROT_SAT_LUMGAIN_POS,CURVES_RESET_BUTTON_POS,DEFAULT_BLACK_POINT_POS,DEFAULT_SHADOW_POINT_POS,DEFAULT_MIDBLACK_POINT_POS,DEFAULT_MIDWHITE_POINT_POS,DEFAULT_HIGH_POINT_POS,DEFAULT_WHITE_POINT_POS,LUMA_LIFT_BAR_POS,LIFT_RED_BAR_POS,LIFT_GREEN_BAR_POS,LIFT_BLUE_BAR_POS,LUMA_GAMMA_BAR_POS,GAMMA_RED_BAR_POS,GAMMA_GREEN_BAR_POS,GAMMA_BLUE_BAR_POS,LUMA_GAIN_BAR_POS,GAIN_RED_BAR_POS,GAIN_GREEN_BAR_POS,GAIN_BLUE_BAR_POS,OFFSET_RED_BAR_POS,OFFSET_GREEN_BAR_POS,OFFSET_BLUE_BAR_POS,CURVES_PANEL_POS,QUALIFIER_PANEL_POS,WINDOWS_PANEL_POS,TRACKING_PANEL_POS,BLUR_PANEL_POS,RGB_MIXER_PANEL_POS,KEY_PANEL_POS,SIZING_PANEL_POS,CURVES_DOTS_MENU_POS,CREATE_POINTS_MENU_POS,LIFT_SHADOWS_RESET_POS,GAMMA_MID_RESET_POS,GAIN_HIGH_RESET_POS,OFFSET_RESET_POS,RESET_ALL_PRIMARIES_LOG_POS,SELECT_ALL_CURVES_BUTTON_POS,SELECT_Y_CURVE_BUTTON_POS,SELECT_R_CURVE_BUTTON_POS,SELECT_G_CURVE_BUTTON_POS,SELECT_B_CURVE_BUTTON_POS,PREVIEW_WINDOW_COLOR_PAGE_POS,GRAB_STILL_MENU_POS,Y_CHANNEL_ITENSITY_CURVES_POS,R_CHANNEL_ITENSITY_CURVES_POS,G_CHANNEL_ITENSITY_CURVES_POS,B_CHANNEL_ITENSITY_CURVES_POS,SOFT_LOW_CURVES_POS,SOFT_HIGH_CURVES_POS,SOFT_LS_CURVES_POS,SOFT_HS_CURVES_POS,RESET_SOFT_CLIP_POS,ALL_CHANNELS_SOFT_CLIP,RED_CHANNEL_SOFT_CLIP,GREEN_CHANNEL_SOFT_CLIP,BLUE_CHANNEL_SOFT_CLIP,BLUR_BUTTON_BLUR_PANEL_POS,SHARPEN_BUTTON_BLUR_PANEL_POS,MIST_BUTTON_BLUR_PANEL_POS,PRIMARIES_PANEL_POS,PICK_BLACK_POINT_POS,PICK_WHITE_POINT_POS,RGB_RED_OUT_RED_BAR,RGB_RED_OUT_GREEN_BAR,RGB_RED_OUT_BLUE_BAR,RGB_GREEN_OUT_RED_BAR,RGB_GREEN_OUT_GREEN_BAR,RGB_GREEN_OUT_BLUE_BAR,RGB_BLUE_OUT_RED_BAR,RGB_BLUE_OUT_GREEN_BAR,RGB_BLUE_OUT_BLUE_BAR,INVERT_RED_GREEN_RGB_MIXER_POS,INVERT_GREEN_BLUE_RGB_MIXER_POS,INVERT_BLUE_RED_RGB_MIXER_POS,MONOCHROME_RGB_MIXER_POS,PRES_LUM_RGB_MIXER_POS,RADIUS_RED_BAR_POS,RADIUS_GREEN_BAR_POS,RADIUS_BLUE_BAR_POS,HV_RED_BAR_POS,HV_GREEN_BAR_POS,HV_BLUE_BAR_POS,SCALING_RED_BAR_POS,SCALING_GREEN_BAR_POS,SCALING_BLUE_BAR_POS,CORING_SOFTNESS_BLUR_PANEL_POS,LEVEL_BLUR_PANEL_POS,MIX_BLUR_PANEL_POS,RESET_RED_OUTPUT_RGB_MIXER_POS,RESET_GREEN_OUTPUT_RGB_MIXER_POS,RESET_BLUE_OUTPUT_RGB_MIXER_POS,RESET_RADIUS_BLUR_PANEL_POS,RESET_HV_BLUR_PANEL_POS,RESET_SCALING_BLUR_PANEL_POS,RESET_RGB_MIXER_POS,RESET_BLUR_PANEL_POS,LINK_RADIUS_BLUR_PANEL_POS,LINK_HV_BLUR_PANEL_POS,LINK_SCALING_BLUR_PANEL_POS,TRANSFORM_ASPECT_PW_POS,TRANSFORM_PAN_PW_POS,TRANSFORM_TILT_PW_POS,TRANSFORM_ROTATE_PW_POS,TRANSFORM_OPACITY_PW_POS,SOFTNESS_SOFT1_PW_POS,SOFTNESS_SOFT2_PW_POS,SOFTNESS_SOFT3_PW_POS,SOFTNESS_SOFT4_PW_POS,SOFTNESS_INSIDE_PW_POS,SOFTNESS_OUTSIDE_PW_POS,RESET_PW_POS,FULL_INSPECTOR_BUTTON_POS,INSPECTOR_OPACITY_POS,INSPECTOR_ZOOM_X_POS,INSPECTOR_ZOOM_Y_POS,INSPECTOR_POSITION_X_POS,INSPECTOR_POSITION_Y_POS,INSPECTOR_ROTATION_POS,INSPECTOR_ANCHOR_X_POS,INSPECTOR_ANCHOR_Y_POS,INSPECTOR_PITCH_POS,INSPECTOR_YAW_POS,RESET_ALL_BASIC_TRANSFORM_POS,RESET_INSPECTOR_ZOOM_POS,RESET_INSPECTOR_POSITION_POS,RESET_INSPECTOR_ROTATION_POS,RESET_INSPECTOR_ANCHOR_POS,RESET_INSPECTOR_PITCH_POS,RESET_INSPECTOR_YAW_POS,RESET_INSPECTOR_FLIP_POS,RESET_INSPECTOR_OPACITY_POS,INSPECTOR_FLIP_HORIZONTAL_POS,INSPECTOR_FLIP_VERTICAL_POS,INSPECTOR_ZOOM_LINK_POS,INSPECTOR_OPACITY_KEYFRAME_POS,INSPECTOR_ZOOM_KEYFRAME_POS,INSPECTOR_POSITION_KEYFRAME_POS,INSPECTOR_ROTATION_KEYFRAME_POS,INSPECTOR_ANCHOR_KEYFRAME_POS,INSPECTOR_PITCH_KEYFRAME_POS,INSPECTOR_YAW_KEYFRAME_POS,RESET_CURVES_VS_POS,RESET_Y_CHANNEL_INTENSITY_POS,RESET_R_CHANNEL_INTENSITY_POS,RESET_G_CHANNEL_INTENSITY_POS,RESET_B_CHANNEL_INTENSITY_POS,NEUTRAL_PLACE_ON_NODES_PANEL_POS]

;Set buttons and control constant positions
counter := 1
Loop, read, %A_WorkingDir%/posx.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        object := _positionsArray[counter]
        object.posX := A_LoopField
        counter++
    }
}

counter := 1
Loop, read, %A_WorkingDir%/posy.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        object := _positionsArray[counter]
        object.posY := A_LoopField
        counter++
    }
}

;Set the initial position of each point on the curves panel
_blackPointMain1 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointMain1 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointMain1 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointMain1 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointMain1 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointMain1 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointY1 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointY1 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointY1 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointY1 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointY1 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointY1 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointR1 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointR1 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointR1 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointR1 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointR1 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointR1 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointG1 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointG1 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointG1 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointG1 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointG1 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointG1 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointB1 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointB1 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointB1 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointB1 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointB1 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointB1 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointMain2 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointMain2 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointMain2 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointMain2 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointMain2 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointMain2 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointY2 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointY2 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointY2 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointY2 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointY2 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointY2 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointR2 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointR2 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointR2 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointR2 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointR2 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointR2 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointG2 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointG2 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointG2 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointG2 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointG2 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointG2 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

_blackPointB2 := {"posX": DEFAULT_BLACK_POINT_POS["posX"], "posY": DEFAULT_BLACK_POINT_POS["posY"]}
_shadowPointB2 := {"posX": DEFAULT_SHADOW_POINT_POS["posX"], "posY": DEFAULT_SHADOW_POINT_POS["posY"]}
_midBlackPointB2 := {"posX": DEFAULT_MIDBLACK_POINT_POS["posX"], "posY": DEFAULT_MIDBLACK_POINT_POS["posY"]}
_midWhitePointB2 := {"posX": DEFAULT_MIDWHITE_POINT_POS["posX"], "posY": DEFAULT_MIDWHITE_POINT_POS["posY"]}
_highPointB2 := {"posX": DEFAULT_HIGH_POINT_POS["posX"], "posY": DEFAULT_HIGH_POINT_POS["posY"]}
_whitePointB2 := {"posX": DEFAULT_WHITE_POINT_POS["posX"], "posY": DEFAULT_WHITE_POINT_POS["posY"]}

;CONTROL OF SAT vs SAT PANEL - NEED TO BE REVISED ON NEXT VERSION
;_blackPointSatVsSat := {"posX": 1463, "posY": 1745} ;Saves initial position of Black Point on Sat vs Sat
;_whitePointSatVsSat := {"posX": 2855, "posY": 1745} ;Saves initial position of White Point on Sat vs Sat
; == All this variables need to be changed when changing the resolution or workspace area - END ==

;Creates one object for each curve on curves panels
global _curvePointsObjectMain1 := {"latestPoint": "off", "black": _blackPointMain1, "shadow": _shadowPointMain1, "midBlack": _midBlackPointMain1, "midWhite": _midWhitePointMain1, "high": _highPointMain1, "white": _whitePointMain1}
global _curvePointsObjectY1 := {"latestPoint": "off", "black": _blackPointY1, "shadow": _shadowPointY1, "midBlack": _midBlackPointY1, "midWhite": _midWhitePointY1, "high": _highPointY1, "white": _whitePointY1}
global _curvePointsObjectR1 := {"latestPoint": "off", "black": _blackPointR1, "shadow": _shadowPointR1, "midBlack": _midBlackPointR1, "midWhite": _midWhitePointR1, "high": _highPointR1, "white": _whitePointR1}
global _curvePointsObjectG1 := {"latestPoint": "off", "black": _blackPointG1, "shadow": _shadowPointG1, "midBlack": _midBlackPointG1, "midWhite": _midWhitePointG1, "high": _highPointG1, "white": _whitePointG1}
global _curvePointsObjectB1 := {"latestPoint": "off", "black": _blackPointB1, "shadow": _shadowPointB1, "midBlack": _midBlackPointB1, "midWhite": _midWhitePointB1, "high": _highPointB1, "white": _whitePointB1}
global _curvePointsObjectMain2 := {"latestPoint": "off", "black": _blackPointMain2, "shadow": _shadowPointMain2, "midBlack": _midBlackPointMain2, "midWhite": _midWhitePointMain2, "high": _highPointMain2, "white": _whitePointMain2}
global _curvePointsObjectY2 := {"latestPoint": "off", "black": _blackPointY2, "shadow": _shadowPointY2, "midBlack": _midBlackPointY2, "midWhite": _midWhitePointY2, "high": _highPointY2, "white": _whitePointY2}
global _curvePointsObjectR2 := {"latestPoint": "off", "black": _blackPointR2, "shadow": _shadowPointR2, "midBlack": _midBlackPointR2, "midWhite": _midWhitePointR2, "high": _highPointR2, "white": _whitePointR2}
global _curvePointsObjectG2 := {"latestPoint": "off", "black": _blackPointG2, "shadow": _shadowPointG2, "midBlack": _midBlackPointG2, "midWhite": _midWhitePointG2, "high": _highPointG2, "white": _whitePointG2}
global _curvePointsObjectB2 := {"latestPoint": "off", "black": _blackPointB2, "shadow": _shadowPointB2, "midBlack": _midBlackPointB2, "midWhite": _midWhitePointB2, "high": _highPointB2, "white": _whitePointB2}
;global _satVsSatPoints := {"black": _blackPointSatVsSat, "white": _whitePointSatVsSat} ;CONTROL OF SAT vs SAT PANEL - NEED TO BE REVISED ON NEXT VERSION

;Save what curve is active
global _activeCurves := "curvesMain1" ;Activate what curves you want to control. Can be: curvesMain1, curvesY1, curvesR1, curvesG1, cruvesB1, curvesMain2, curvesY2, curvesR2, curvesG2, cruvesB2 - ATTENTION: YOU NEED CLICK ON THE WAVE MIDDLE BUTTON WITH THE NAME OF THE CURVE BEFORE USE THE CURVE

; == Start creating GUI ==
global _variableToSet := "" ;Define what variable will be change when clicking the buttons on app
global _startPositionButtonsX := 10 ;Set the first button position on the screen (excludes start button) on X axis
global _startPositionButtonsY := 60 ;Set the first button position on the screen (excludes start button) on Y axis
global _counterButtonX := 10 ;Set the first button position on the screen (excludes start button) on Y axis
global _counterButtonY := 60 ;Set the first button position on the screen (excludes start button) on Y axis

;Start Global Mouse Position Variable
_setGlobalMousePos()

;Add the start controller button
Gui Add, Button, x10 y10 w1110 h30 gStartButton, Start DR Tangent Wave Booster

;Add each button for config each tools position on the screen
For index, object in _positionsArray {
    name := object.name
    varName := object.var
    Gui Add, Button, x%_counterButtonX% y%_counterButtonY% w130 h30 v%varName% gGenericButton, %name%
    
    _counterButtonY := _counterButtonY + 30
    if (index == 30){
        _counterButtonY := _startPositionButtonsY
        _counterButtonX := _counterButtonX + 140
    }Else if (index == 60 or index == 90 or index == 120 or index == 150 or index == 180 or index == 210){
        _counterButtonY := _startPositionButtonsY
        _counterButtonX := _counterButtonX + 140
    }
}

Gui Add, Button, x10 y980 w1110 h30 gSaveFileButton, Save new positions
    
Gui Show, w1130 h1020, Tangent Wave Booster Ver. 1.3 Beta
return
GuiEscape:
GuiClose:
    ExitApp

F8::
StartButton:
    if (tog := !tog){
        GuiControl,,Start DR Tangent Wave Booster,Stop DR Tangent Wave Booster
        _appStarted := "true"
    }Else{
        GuiControl,,Stop DR Tangent Wave Booster,Start DR Tangent Wave Booster
        _appStarted := "false"
    }
return

;Save all the actual seted positions on the position files
SaveFileButton:
    FileDelete %A_WorkingDir%/posx.ini
    FileDelete %A_WorkingDir%/posy.ini
    
    For index, object in _positionsArray {
        posX := object.posX
        posY := object.posY

        FileAppend %posX%`n, %A_WorkingDir%/posx.ini
        FileAppend %posY%`n, %A_WorkingDir%/posy.ini
    }
return

GenericButton:
    _variableToSet := A_GuiControl
    _isSetingVariable := "true"
    
    GuiControl, Disable, %_variableToSet%
return

_changePositionVariable(){
    CoordMode, Mouse, Client
    MouseGetPos, mousePosX, mousePosY

    For index, object in _positionsArray
    if (object.var == _variableToSet) {
        object.posX := mousePosX
        object.posY := mousePosY
    }
    
    _isSetingVariable := "false"
    _variableToSet := ""
}

Enter::
    if !(_isSetingVariable == "true"){
        Send, {Enter}
    }Else{
        _changePositionVariable()
    }
return
; == End creating GUI ==


#If (_appStarted == "true") ;Turn on and off the app
; == Functions ==

;Set Global Mouse Pos
_setGlobalMousePos(){
    MouseGetPos, mousePosX, mousePosY
    _globalMousePosX := mousePosX
    _globalMousePosY := mousePosY
}

;Start Timer to call release
_startReleaseTimer(){
    setTimer, _doRelease, -500
    _setGlobalMousePos()
}

;Release the left mouse button
_doRelease(){
    MouseGetPos, MousePosX, MousePosY
    
    if(_globalMousePosX == MousePosX and _globalMousePosY == MousePosY){
        if !(LbuttonState = "U"){
            _exitAnyControlFunction()
        }
    }Else{
        _startReleaseTimer()
    }
}

;Exit of any controller and clean the code
_exitAnyControlFunction(){
    ;Saves latest position of a point if using it
   	if (_activeController == "curves"){
        _savePointsPosition()
    }
    
    ;Reset some variables
    _activeBottomBlurControl := ""
    
    ;Release mouse buttom
    GetKeyState, LbuttonState, LButton, P
	if !(LbuttonState = "U"){
   	    Send, {LButton Up}
        Sleep 20
    }
    
    ;Turn of Active Controller
    _activeController := "off"
}

_changePageBasicControls(panel){
    if (_activePageBasicControls != panel){
        if (_activePageBasicControls == 1){
            _activePageBasicControls := 2
            MouseClick left, BASIC_COLOR_PAGE2["posX"], BASIC_COLOR_PAGE2["posY"], 1, 0
        }Else{
            _activePageBasicControls := 1
            MouseClick left, BASIC_COLOR_PAGE1["posX"], BASIC_COLOR_PAGE1["posY"], 1, 0
        }
    }
}

;Save the position of latest point on use if using a cuvers panel
_savePointsPosition(){
    MouseGetPos mousePosX, mousePosY
    
    ident := subStr(_activeCurves, 7)
    object := _returnCurvePointsObject(ident)
    
    object[object.latestPoint].posX := mousePosX
    object[object.latestPoint].posY := mousePosY
}

;Function to return a curves point object
_returnCurvePointsObject(ident){
    Switch ident{
        Case "Main1":
            return _curvePointsObjectMain1
        Case "Y1":
            return _curvePointsObjectY1
        Case "R1":
            return _curvePointsObjectR1
        Case "G1":
            return _curvePointsObjectG1
        Case "B1":
            return _curvePointsObjectB1
        Case "Main2":
            return _curvePointsObjectMain2
        Case "Y2":
            return _curvePointsObjectY2
        Case "R2":
            return _curvePointsObjectR2
        Case "G2":
            return _curvePointsObjectG2
        Case "B2":
            return _curvePointsObjectB2
    }   
}

;Function to select what curves point object is in use
_changeCurvePointsObject(object, button){
    Switch button
    {
        Case "black":
            if !(object["latestPoint"] == "black"){
                _exitAnyControlFunction()
                
                object["latestPoint"] := "black"
            }
        Case "shadow":
            if !(object["latestPoint"] == "shadow"){
                _exitAnyControlFunction()
                
                object["latestPoint"] := "shadow"
            }
        Case "midBlack":
            if !(object["latestPoint"] == "midBlack"){
                _exitAnyControlFunction()
                
                object["latestPoint"] := "midBlack"
            }
        Case "midWhite":
            if !(object["latestPoint"] == "midWhite"){
                _exitAnyControlFunction()
                
                object["latestPoint"] := "midWhite"
            }
        Case "high":
            if !(object["latestPoint"] == "high"){
                _exitAnyControlFunction()
                
                object["latestPoint"] := "high"
            }
        Case "white":
            if !(object["latestPoint"] == "white"){
                _exitAnyControlFunction()
                
                object["latestPoint"] := "white"
            }
    }
}

;Function to move mouse to the selected point on curves panel
_mouseMoveToSelectedPoint(object, button){
    GetKeyState, LbuttonState, LButton, P
    
    Switch button{
        Case "black":
            if (LbuttonState = "U"){
                MouseMove object["black"].posX, object["black"].posY, 0
                
                Send, {LButton Down}
                _startReleaseTimer()
            }Else{
                _exitAnyControlFunction()
            }
        Case "shadow":
            if (LbuttonState = "U"){
                MouseMove object["shadow"].posX, object["shadow"].posY, 0
                
                Send, {LButton Down}
                _startReleaseTimer()
            }Else{
                _exitAnyControlFunction()
            }
        Case "midBlack":
            if (LbuttonState = "U"){
                MouseMove object["midBlack"].posX, object["midBlack"].posY, 0
                
                Send, {LButton Down}
                _startReleaseTimer()
            }Else{
                _exitAnyControlFunction()
            }
        Case "midWhite":
            if (LbuttonState = "U"){
                MouseMove object["midWhite"].posX, object["midWhite"].posY, 0
                
                Send, {LButton Down}
                _startReleaseTimer()
            }Else{
                _exitAnyControlFunction()
            }
        Case "high":
            if (LbuttonState = "U"){
                MouseMove object["high"].posX, object["high"].posY, 0
                
                Send, {LButton Down}
                _startReleaseTimer()
            }Else{
                _exitAnyControlFunction()
            }
        Case "white":
            if (LbuttonState = "U"){
                MouseMove object["white"].posX, object["white"].posY, 0
                
                Send, {LButton Down}
                _startReleaseTimer()
            }Else{
                _exitAnyControlFunction()
            }
    }
}

;Function to select color point on Hue/Lum/Sat Curves and click on Input - colorPosX and Y is the position of the color point - Control can be "input" or "output"
_selectInputHueCurvesControls(colorPosX, colorPosY, control){
    if (_activePanel == "curves" and _activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()

    MouseClick Left, colorPosX, colorPosY, 1, 0
    
    if !(_activeController == "inputHueLumSat"){
        if (control == "input"){
            Switch _activeCurvesPanel{
                Case "hueXhue":
                    MouseMove INPUT_HUEXHUE_POS["posX"], INPUT_HUEXHUE_POS["posY"], 0
                Case "hueXsat":
                    MouseMove INPUT_HUEXSAT_POS["posX"], INPUT_HUEXSAT_POS["posY"], 0
                Case "hueXlum":
                    MouseMove INPUT_HUEXLUM_POS["posX"], INPUT_HUEXLUM_POS["posY"], 0
                Case "lumXsat":
                    MouseMove INPUT_LUMXSAT_POS["posX"], INPUT_LUMXSAT_POS["posY"], 0
                ;Case "satXsat": ;CONTROL OF SAT vs SAT PANEL - NEED TO BE REVISED ON NEXT VERSION
                    ;MouseMove INPUT_SATXSAT_POS["posX"], INPUT_SATXSAT_POS["posY"], 0
            }
        }Else{
            MouseMove HUE_ROT_SAT_LUMGAIN_POS["posX"], HUE_ROT_SAT_LUMGAIN_POS["posY"], 0        
        }
        
        GetKeyState, LbuttonState, LButton, P
        if (LbuttonState = "U"){
            Send, {LButton Down}
            _startReleaseTimer()
        }

        global _activeController := "inputHueLumSat"
    }
}

;CONTROL OF SAT vs SAT PANEL - NEED TO BE REVISED ON NEXT VERSION
;_moveBlackWhitePointsSatVsSat(point, direction){
    ;if (_activeCurvesPanel == "curves"){
        ;return
    ;}

    ;if !(_activeController == "inputHueLumSat"){
        ;_exitAnyControlFunction()
        ;
        ;if (point == "black" ){
            ;pointObject := _satVsSatPoints["black"]
            ;MouseMove pointObject["posX"], pointObject["posY"], 0
        ;}Else{
            ;pointObject := _satVsSatPoints["black"]
            ;MouseMove, pointObject["posX"], pointObject["posY"], 1, 0
            ;}
        ;}
        ;
        ;GetKeyState, LbuttonState, LButton, P
        ;if (LbuttonState = "U"){
            ;Send, {LButton Down}
        ;}

        ;global _activeController := "inputHueLumSat"
	;}
    ;
    ;if (direction == "increase"){
        ;MouseGetPos MousePosX, MousePosY
        ;MouseMove MousePosX, MousePosY+10
    ;}Else{
        ;MouseGetPos MousePosX, MousePosY
        ;MouseMove MousePosX, MousePosY-10
    ;}
;return

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

;Release mouse and than get the selected controller, send mouse to it position and start to drag it
_getControllerToStartMove(activeController, posX, posY){
    _exitAnyControlFunction()
        
    MouseMove posX, posY, 0
        
    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
        Send, {LButton Down}
        _startReleaseTimer()
    }

    _activeController := activeController
}

;Change the curves panel to next or preview one
_changeCurvesPanel(panel, object){
    _exitAnyControlFunction()
    
    if !(_activeCurvesPanel == panel){
        _activeCurvesPanel := panel
    }
    
    MouseClick Left, object["posX"], object["posY"], 1, 0
}

;Change the blur panel to next one
_changeBlurPanel(panel, object){
    _exitAnyControlFunction()
    
    if !(_activeBlurPanel == panel){
        _activeBlurPanel := panel
    }
    
    MouseClick Left, object["posX"], object["posY"], 1, 0
}

;When pressing Main, Y, Red, Green or Blue Curve control on Tangent, it checks if you are in the Main Curves Panel, if not it will send you to there
_checkIfOnCurvesPanel(){
    if !(_activePanel == "curves"){
        _activePanel := "curves"
        
        MouseClick Left, CURVES_PANEL_POS["posX"], CURVES_PANEL_POS["posY"], 1, 0
    }
    
    if !(_activeCurvesPanel == "curves")
    {
        _activeCurvesPanel := "curves"
        
        MouseClick Left, CURVES_PANEL_BUTTON_POS["posX"], CURVES_PANEL_BUTTON_POS["posY"], 1, 0
    }
}

F1:: ;F1 - Call exit any control (release)
	_exitAnyControlFunction()
return
; == END OF FUNCTIONS ==

; == Set Davinci to Initial State ==
F7:: ;F7 - Set Davinci to Initial State (Reset UI, set UI to Full Screen and go to the Edit Page)
    _exitAnyControlFunction()
    Sleep 10
    Send {F6}
    Sleep 200
    Send {F5}
    Sleep 200
    _activePage := "edit"
    Send +{4}
return

; == White Balance, toggles, resets and more ==
!j:: ;Alt+j - WB Selector
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _exitAnyControlFunction()
    
	MouseClick Left, WB_SELECTOR["posX"], WB_SELECTOR["posY"], 1, 0
    Sleep 100
	MouseMove, PREVIEW_WINDOW_POS["posX"], PREVIEW_WINDOW_POS["posY"], 0
return

;Use this if you want to a shortcut to toggle basic color controls
+n:: ;Shift+n - Toggle Basic Color Controls Page 1/2
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _exitAnyControlFunction()
    
    if (_activePageBasicControls == 1){
        _activePageBasicControls := 2
        MouseClick left, BASIC_COLOR_PAGE2["posX"], BASIC_COLOR_PAGE2["posY"], 1, 0
    }Else{
        _activePageBasicControls := 1
        MouseClick left, BASIC_COLOR_PAGE1["posX"], BASIC_COLOR_PAGE1["posY"], 1, 0
    }
return

^!+a:: ;Ctrl+Alt+Shift+a - Primaries Wheels Panel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        MouseClick Left, PRIMARIES_PANEL_POS["posX"], PRIMARIES_PANEL_POS["posY"], 1, 0
        
        _activeMasterPanel := "wheels"
    }
    
    _exitAnyControlFunction()
    
    _activePrimariesLogPanel := "primaries"
    MouseClick Left, PRIMARIES_WHEELS_TAB["posX"], PRIMARIES_WHEELS_TAB["posY"], 1, 0
    
    Sleep 10
    
    _activePageBasicControls := 1
    MouseClick left, BASIC_COLOR_PAGE1["posX"], BASIC_COLOR_PAGE1["posY"], 1, 0
return

^!+b:: ;Ctrl+Alt+Shift+b - Primaries Bars Panel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        MouseClick Left, PRIMARIES_PANEL_POS["posX"], PRIMARIES_PANEL_POS["posY"], 1, 0
        
        _activeMasterPanel := "wheels"
    }
    
    _exitAnyControlFunction()
    
    _activePrimariesLogPanel := "bars"
    MouseClick Left, PRIMARIES_BARS_TAB["posX"], PRIMARIES_BARS_TAB["posY"], 1, 0
    
    Sleep 10
    
    _activePageBasicControls := 1
    MouseClick left, BASIC_COLOR_PAGE1["posX"], BASIC_COLOR_PAGE1["posY"], 1, 0
return

^!+c:: ;Ctrl+Alt+Shift+c - Log Wheels Panel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        MouseClick Left, PRIMARIES_PANEL_POS["posX"], PRIMARIES_PANEL_POS["posY"], 1, 0
        
        _activeMasterPanel := "wheels"
    }
    
    _exitAnyControlFunction()
    
    _activePrimariesLogPanel := "log"
    MouseClick Left, LOG_WHEELS_TAB["posX"], LOG_WHEELS_TAB["posY"], 1, 0
    
    Sleep 10
    
    _activePageBasicControls := 1
    MouseClick left, BASIC_COLOR_PAGE1["posX"], BASIC_COLOR_PAGE1["posY"], 1, 0
return

!+0:: ;Alt+Shift+0 - Grab Still
    if !(_activePage == "color"){
        return
    }
    
    MouseClick right, PREVIEW_WINDOW_COLOR_PAGE_POS["posX"], PREVIEW_WINDOW_COLOR_PAGE_POS["posY"], 1, 0
    Sleep 10
    MouseClick left, GRAB_STILL_MENU_POS["posX"], GRAB_STILL_MENU_POS["posY"], 1, 0
return

; == Contrast Controls ==

^!+q:: ;Ctrl+Alt+Shift+q - Increase Contrast Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)

    if !(_activeController == "contrast"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("contrast", CONTRAST_POS_LOG["posX"], CONTRAST_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("contrast", CONTRAST_POS_PRIMARIES["posX"], CONTRAST_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "contrast"){
        _moveMouseOnAxis("X", "plus", 100)
	}
return

^!+w:: ;Ctrl+Alt+Shift+w - Reduce Contrast Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)

    if !(_activeController == "contrast"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("contrast", CONTRAST_POS_LOG["posX"], CONTRAST_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("contrast", CONTRAST_POS_PRIMARIES["posX"], CONTRAST_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "contrast"){
        _moveMouseOnAxis("X", "minus", 100)
	}
return

^+j:: ;Ctrl+Shift+j - Increase Contrast Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "contrast"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("contrast", CONTRAST_POS_LOG["posX"], CONTRAST_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("contrast", CONTRAST_POS_PRIMARIES["posX"], CONTRAST_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "contrast"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

^+k:: ;Ctrl+Shift+k - Reduce Contrast Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "contrast"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("contrast", CONTRAST_POS_LOG["posX"], CONTRAST_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("contrast", CONTRAST_POS_PRIMARIES["posX"], CONTRAST_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "contrast"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

^o:: ;Ctrl+o - Reset Contrast
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
	_exitAnyControlFunction()
    
    if (_activePrimariesLogPanel == "log"){
        MouseClick, Left, CONTRAST_POS_LOG["posX"], CONTRAST_POS_LOG["posY"], 1, 0
        Send, 1
        Send, {Enter}
    }Else{
        MouseClick, Left, CONTRAST_POS_PRIMARIES["posX"], CONTRAST_POS_PRIMARIES["posY"], 1, 0
        Send, 1
        Send, {Enter}
    }
return

; == Pivot Controls ==
^!+e:: ;Ctrl+Alt+Shift+e - Increase Pivot Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)

    if !(_activeController == "pivot"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("pivot", PIVOT_POS_LOG["posX"], PIVOT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("pivot", PIVOT_POS_PRIMARIES["posX"], PIVOT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "pivot"){
        _moveMouseOnAxis("X", "plus", 100)
	}
return

^!+l:: ;Ctrl+Alt+Shift+l - Reduce Pivot Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)

    if !(_activeController == "pivot"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("pivot", PIVOT_POS_LOG["posX"], PIVOT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("pivot", PIVOT_POS_PRIMARIES["posX"], PIVOT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "pivot"){
        _moveMouseOnAxis("X", "minus", 100)
	}
return

+y:: ;Shift+y - Increase Pivot Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "pivot"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("pivot", PIVOT_POS_LOG["posX"], PIVOT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("pivot", PIVOT_POS_PRIMARIES["posX"], PIVOT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "pivot"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

+u:: ;Shift+u - Reduce Pivot Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "pivot"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("pivot", PIVOT_POS_LOG["posX"], PIVOT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("pivot", PIVOT_POS_PRIMARIES["posX"], PIVOT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "pivot"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

^+b:: ;Ctrl+shift+b - Reset Pivot
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    _exitAnyControlFunction()
    
    if (_activePrimariesLogPanel == "log"){
        MouseClick, Left, PIVOT_POS_LOG["posX"], PIVOT_POS_LOG["posY"], 1, 0
        Send, 0.435
        Send, {Enter}
    }Else{
        MouseClick, Left, PIVOT_POS_PRIMARIES["posX"], PIVOT_POS_PRIMARIES["posY"], 1, 0
        Send, 0.435
        Send, {Enter}
    }
return

; == Saturation Controls ==
^!+t:: ;Ctrl+Alt+Shift+t - Increase Saturation Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "saturation"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("saturation", SAT_POS_LOG["posX"], SAT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("saturation", SAT_POS_PRIMARIES["posX"], SAT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "saturation"){
        _moveMouseOnAxis("X", "plus", 50)
	}
return

^!+y:: ;Ctrl+Alt+Shift+y - Reduce Saturation Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "saturation"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("saturation", SAT_POS_LOG["posX"], SAT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("saturation", SAT_POS_PRIMARIES["posX"], SAT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "saturation"){
        _moveMouseOnAxis("X", "minus", 50)
	}
return

^+p:: ;Ctrl+Shift+p - Increase Saturation Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "saturation"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("saturation", SAT_POS_LOG["posX"], SAT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("saturation", SAT_POS_PRIMARIES["posX"], SAT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "saturation"){
        _moveMouseOnAxis("X", "plus", 0.1)
	}
return

^+q:: ;Ctrl+Shift+q - Reduce Saturation Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "saturation"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("saturation", SAT_POS_LOG["posX"], SAT_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("saturation", SAT_POS_PRIMARIES["posX"], SAT_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "saturation"){
        _moveMouseOnAxis("X", "minus", 0.1)
	}
return

^Numpad0:: ;Ctrl+Numpad0 - Reset Saturation
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    _exitAnyControlFunction()
    
    if (_activePrimariesLogPanel == "log"){
        MouseClick, Left, SAT_POS_LOG["posX"], SAT_POS_LOG["posY"], 1, 0
        Send, 50
        Send, {Enter}
    }Else{
        MouseClick, Left, SAT_POS_PRIMARIES["posX"], SAT_POS_PRIMARIES["posY"], 1, 0
        Send, 50
        Send, {Enter}
    }
return

; == Hue Controls ==
+x:: ;Shift+x - Increase Hue Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "hue"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("hue", HUE_POS_LOG["posX"], HUE_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("hue", HUE_POS_PRIMARIES["posX"], HUE_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "hue"){
        _moveMouseOnAxis("X", "plus", 20)
	}
return

+b:: ;Shift+b - Reduce Hue Big  Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "hue"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("hue", HUE_POS_LOG["posX"], HUE_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("hue", HUE_POS_PRIMARIES["posX"], HUE_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "hue"){
        _moveMouseOnAxis("X", "minus", 20)
	}
return

+p:: ;Shift+p - Increase Hue Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "hue"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("hue", HUE_POS_LOG["posX"], HUE_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("hue", HUE_POS_PRIMARIES["posX"], HUE_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "hue"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

+g:: ;Shift+g - Reduce Hue Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "hue"){
        if (_activePrimariesLogPanel == "log"){
            _getControllerToStartMove("hue", HUE_POS_LOG["posX"], HUE_POS_LOG["posY"])
        }Else{
            _getControllerToStartMove("hue", HUE_POS_PRIMARIES["posX"], HUE_POS_PRIMARIES["posY"])
        }
	}Else if (_activeController == "hue"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^NumpadMult:: ;Ctrl+NumpadDel - Reset Hue
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    _exitAnyControlFunction()

    if (_activePrimariesLogPanel == "log"){
        MouseClick, Left, HUE_POS_LOG["posX"], HUE_POS_LOG["posY"], 1, 0
        Send, 50
        Send, {Enter}
    }Else{
        MouseClick, Left, HUE_POS_PRIMARIES["posX"], HUE_POS_PRIMARIES["posY"], 1, 0
        Send, 50
        Send, {Enter}
    }
return

; == Lum Mix Controls ==
^!+o:: ;Ctrl+Alt+Shift+o - Increase Lum Mix Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "lummix"){
        _getControllerToStartMove("lummix", LUMMIX_POS_PRIMARIES["posX"], LUMMIX_POS_PRIMARIES["posY"])
	}Else if (_activeController == "lummix"){
        _moveMouseOnAxis("X", "plus", 100)
	}
return

^!+p:: ;Ctrl+Alt+Shift+p - Reduce Lum Mix Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "lummix"){
        _getControllerToStartMove("lummix", LUMMIX_POS_PRIMARIES["posX"], LUMMIX_POS_PRIMARIES["posY"])
	}Else if (_activeController == "lummix"){
        _moveMouseOnAxis("X", "minus", 100)
	}
return

^+d:: ;Ctrl+Shift+d - Increase Lum Mix Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "lummix"){
        _getControllerToStartMove("lummix", LUMMIX_POS_PRIMARIES["posX"], LUMMIX_POS_PRIMARIES["posY"])
	}Else if (_activeController == "lummix"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

^+e:: ;Ctrl+Shift+e - Reduce Lum Mix Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "lummix"){
        _getControllerToStartMove("lummix", LUMMIX_POS_PRIMARIES["posX"], LUMMIX_POS_PRIMARIES["posY"])
	}Else if (_activeController == "lummix"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

^+y:: ;Ctrl+Shift+y - Reset Lum Mix
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(1)
    
    _exitAnyControlFunction()

    MouseClick Left, LUMMIX_POS_PRIMARIES["posX"], LUMMIX_POS_PRIMARIES["posY"], 1, 0
	Send, 0
	Send, {Enter}
return

; == Temperature controls ==
#^+q:: ;Win+Ctrl+Shift+q - Increase Temperature Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)
    
    if !(_activeController == "temperature"){
        _getControllerToStartMove("temperature", TEMP_POS["posX"], TEMP_POS["posY"])
	}Else if (_activeController == "temperature"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#^+w:: ;Win+Ctrl+Shift+q - Reduce Temperature Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "temperature"){
        _getControllerToStartMove("temperature", TEMP_POS["posX"], TEMP_POS["posY"])
	}Else if (_activeController == "temperature"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#^+e:: ;Win+Ctrl+Shift+e - Increase Temperature Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "temperature"){
        _getControllerToStartMove("temperature", TEMP_POS["posX"], TEMP_POS["posY"])
	}Else if (_activeController == "temperature"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

#^+r:: ;Win+Ctrl+Shift+r - Reduce Temperature Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "temperature"){
        _getControllerToStartMove("temperature", TEMP_POS["posX"], TEMP_POS["posY"])
	}Else if (_activeController == "temperature"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

#^+t:: ;Win+Ctrl+Shift+t - Reset Temperature
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

	_exitAnyControlFunction()
    
    MouseClick Left, TEMP_POS["posX"], TEMP_POS["posY"], 1, 0
	Send, 0
	Send, {Enter}
return

; == Tint controls ==
#^+y:: ;Win+Ctrl+Shift+y - Increase Tint Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)
    
    if !(_activeController == "tint"){
        _getControllerToStartMove("tint", TINT_POS["posX"], TINT_POS["posY"])
	}Else if (_activeController == "tint"){
        _moveMouseOnAxis("X", "plus", 4)
	}
return

#^+u:: ;Win+Ctrl+Shift+u - Reduce tint Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "tint"){
        _getControllerToStartMove("tint", TINT_POS["posX"], TINT_POS["posY"])
	}Else if (_activeController == "tint"){
        _moveMouseOnAxis("X", "minus", 4)
	}
return

#^+i:: ;Win+Ctrl+Shift+i - Increase tint Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "tint"){
        _getControllerToStartMove("tint", TINT_POS["posX"], TINT_POS["posY"])
	}Else if (_activeController == "tint"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

#^+o:: ;Win+Ctrl+Shift+o - Reduce tint Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "tint"){
        _getControllerToStartMove("tint", TINT_POS["posX"], TINT_POS["posY"])
	}Else if (_activeController == "tint"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

#^+p:: ;Win+Ctrl+Shift+p - Reset tint
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

	_exitAnyControlFunction()
    
    MouseClick Left, TINT_POS["posX"], TINT_POS["posY"], 1, 0
	Send, 0
	Send, {Enter}
return

; == MD controls ==

#^+a:: ;Win+Ctrl+Shift+a - Increase MD Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "md"){
        _getControllerToStartMove("md", MD_POS["posX"], MD_POS["posY"])
	}Else if (_activeController == "md"){
        _moveMouseOnAxis("X", "plus", 4)
	}
return

#^+s:: ;Win+Ctrl+Shift+s - Reduce MD Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "md"){
        _getControllerToStartMove("md", MD_POS["posX"], MD_POS["posY"])
	}Else if (_activeController == "md"){
        _moveMouseOnAxis("X", "minus", 4)
	}
return

#^+d:: ;Win+Ctrl+Shift+d - Reduce MD Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "md"){
        _getControllerToStartMove("md", MD_POS["posX"], MD_POS["posY"])
	}Else if (_activeController == "md"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

#^+f:: ;Win+Ctrl+Shift+f - Reduce MD Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "md"){
        _getControllerToStartMove("md", MD_POS["posX"], MD_POS["posY"])
	}Else if (_activeController == "md"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

#^+g:: ;Win+Ctrl+Shift+g - Reset MD
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

	_exitAnyControlFunction()
    
    MouseClick Left, MD_POS["posX"], MD_POS["posY"], 1, 0
	Send, 0
	Send, {Enter}
return

; == Cool Boost controls ==
#^+h:: ;Win+Ctrl+Shift+h - Increase Cool Boost Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "coolBoost"){
        _getControllerToStartMove("coolBoost", COLBOOST_POS["posX"], COLBOOST_POS["posY"])
	}Else if (_activeController == "coolBoost"){
        _moveMouseOnAxis("X", "plus", 4)
	}
return

#^+j:: ;Win+Ctrl+Shift+j - Reduce Cool Boost Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "coolBoost"){
        _getControllerToStartMove("coolBoost", COLBOOST_POS["posX"], COLBOOST_POS["posY"])
	}Else if (_activeController == "coolBoost"){
        _moveMouseOnAxis("X", "minus", 4)
	}
return

#^+k:: ;Win+Ctrl+Shift+k - Reduce Cool Boost Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "coolBoost"){
        _getControllerToStartMove("coolBoost", COLBOOST_POS["posX"], COLBOOST_POS["posY"])
	}Else if (_activeController == "coolBoost"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

#^+l:: ;Win+Ctrl+Shift+l - Reduce Cool Boost Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "coolBoost"){
        _getControllerToStartMove("coolBoost", COLBOOST_POS["posX"], COLBOOST_POS["posY"])
	}Else if (_activeController == "coolBoost"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

^h:: ;Ctrl+h - Reset Cool Boost
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

	_exitAnyControlFunction()
    
    MouseClick Left, COLBOOST_POS["posX"], COLBOOST_POS["posY"], 1, 0
	Send, 0
	Send, {Enter}
return

; == Shad controls ==
#^+z:: ;Win+Ctrl+Shift+z - Increase Shad Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)
    
    if !(_activeController == "shad"){
        _getControllerToStartMove("shad", SHAD_POS["posX"], SHAD_POS["posY"])
	}Else if (_activeController == "shad"){
        _moveMouseOnAxis("X", "plus", 4)
	}
return

#^+x:: ;Win+Ctrl+Shift+x - Reduce Shad Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "shad"){
        _getControllerToStartMove("shad", SHAD_POS["posX"], SHAD_POS["posY"])
	}Else if (_activeController == "shad"){
        _moveMouseOnAxis("X", "minus", 4)
	}
return

#^+c:: ;Win+Ctrl+Shift+c - Reduce Shad Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "shad"){
        _getControllerToStartMove("shad", SHAD_POS["posX"], SHAD_POS["posY"])
	}Else if (_activeController == "shad"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

#^+v:: ;Win+Ctrl+Shift+v - Reduce Shad Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "shad"){
        _getControllerToStartMove("shad", SHAD_POS["posX"], SHAD_POS["posY"])
	}Else if (_activeController == "shad"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

#^+b:: ;Win+Ctrl+Shift+b - Reset Shad
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

	_exitAnyControlFunction()
    
    MouseClick Left, SHAD_POS["posX"], SHAD_POS["posY"], 1, 0
	Send, 0
	Send, {Enter}
return

; == HL controls ==
#^+n:: ;Win+Ctrl+Shift+n - Increase HL Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)
    
    if !(_activeController == "hl"){
        _getControllerToStartMove("hl", HL_POS["posX"], HL_POS["posY"])
	}Else if (_activeController == "hl"){
        _moveMouseOnAxis("X", "plus", 4)
	}
return

#^+m:: ;Win+Ctrl+Shift+m - Reduce HL Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "hl"){
        _getControllerToStartMove("hl", HL_POS["posX"], HL_POS["posY"])
	}Else if (_activeController == "hl"){
        _moveMouseOnAxis("X", "minus", 4)
	}
return

#^+,:: ;Win+Ctrl+Shift+, - Reduce HL Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "hl"){
        _getControllerToStartMove("hl", HL_POS["posX"], HL_POS["posY"])
	}Else if (_activeController == "hl"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

#^+.:: ;Win+Ctrl+Shift+. - Reduce HL Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

    if !(_activeController == "hl"){
        _getControllerToStartMove("hl", HL_POS["posX"], HL_POS["posY"])
	}Else if (_activeController == "hl"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

^0:: ;Ctrl+0 - Reset HL
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    _changePageBasicControls(2)

	_exitAnyControlFunction()
    
    MouseClick Left, HL_POS["posX"], HL_POS["posY"], 1, 0
	Send, 0
	Send, {Enter}
return

; == LR controls ==
!+e:: ;Alt+Shift+e - Increase LR Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "lr"){
        _getControllerToStartMove("lr", LR_POS_LOG["posX"], LR_POS_LOG["posY"])
	}Else if (_activeController == "lr"){
        _moveMouseOnAxis("X", "plus", 100)
	}
return

!+t:: ;Alt+Shift+t - Reduce LR Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }
    
    if !(_activeController == "lr"){
        _getControllerToStartMove("lr", LR_POS_LOG["posX"], LR_POS_LOG["posY"])
	}Else if (_activeController == "lr"){
        _moveMouseOnAxis("X", "minus", 100)
	}
return

!+y:: ;Alt+Shift+y - Reduce LR Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }

    _changePageBasicControls(1)
    
    if !(_activeController == "lr"){
        _getControllerToStartMove("lr", LR_POS_LOG["posX"], LR_POS_LOG["posY"])
	}Else if (_activeController == "lr"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

!+u:: ;Alt+Shift+u - Reduce LR Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }

    _changePageBasicControls(1)

    if !(_activeController == "lr"){
        _getControllerToStartMove("lr", LR_POS_LOG["posX"], LR_POS_LOG["posY"])
	}Else if (_activeController == "lr"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

!+a:: ;Alt+Shift+a; - Reset LR
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }

    _changePageBasicControls(1)

	_exitAnyControlFunction()
	
    Sleep 10
    
    MouseClick Left, LR_POS_LOG["posX"], LR_POS_LOG["posY"], 1, 0
	Send, 0.333
	Send, {Enter}
return


; == HR controls ==
!+s:: ;Alt+Shift+s - Increase HR Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }

    _changePageBasicControls(1)
    
    if !(_activeController == "hr"){
        _getControllerToStartMove("hr", HR_POS_LOG["posX"], HR_POS_LOG["posY"])
	}Else if (_activeController == "hr"){
        _moveMouseOnAxis("X", "plus", 100)
	}
return

!+d:: ;Alt+Shift+d - Reduce HR Big Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }
    
    _changePageBasicControls(1)
    
    if !(_activeController == "hr"){
        _getControllerToStartMove("hr", HR_POS_LOG["posX"], HR_POS_LOG["posY"])
	}Else if (_activeController == "hr"){
        _moveMouseOnAxis("X", "minus", 100)
	}
return

!+f:: ;Alt+Shift+f - Reduce HR Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }

    _changePageBasicControls(1)

    if !(_activeController == "hr"){
        _getControllerToStartMove("hr", HR_POS_LOG["posX"], HR_POS_LOG["posY"])
	}Else if (_activeController == "hr"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

!+g:: ;Alt+Shift+g - Reduce HR Small Steps
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }
    
    _changePageBasicControls(1)

    if !(_activeController == "hr"){
        _getControllerToStartMove("hr", HR_POS_LOG["posX"], HR_POS_LOG["posY"])
	}Else if (_activeController == "hr"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

!+b:: ;Alt+Shift+b; - Reset HR
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        return
    }

    _changePageBasicControls(1)

	_exitAnyControlFunction()
	
    Sleep 10
    
    MouseClick Left, HR_POS_LOG["posX"], HR_POS_LOG["posY"], 1, 0
	Send, 0.550
	Send, {Enter}
return

; == Color Bars controls ==
!n:: ;Alt+n - Pick Black Point
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if (_activePrimariesLogPanel == "log"){
        return
    }
    
    _exitAnyControlFunction()
	
    MouseClick Left, PICK_BLACK_POINT_POS["posX"], PICK_BLACK_POINT_POS["posY"], 1, 0
return

!0:: ;Alt+0 - Pick White Point
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if (_activePrimariesLogPanel == "log"){
        return
    }
    
    _exitAnyControlFunction()
	
    MouseClick Left, PICK_WHITE_POINT_POS["posX"], PICK_WHITE_POINT_POS["posY"], 1, 0
return

^#F1:: ;Ctrl+Win+F1 - Lift Red Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }
    
	MouseClick WheelUp, LIFT_RED_BAR_POS["posX"], LIFT_RED_BAR_POS["posY"], 1, 0
return

^#F2:: ;Ctrl+Win+F2 - Lift Red Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }
    
    MouseClick WheelDown, LIFT_RED_BAR_POS["posX"], LIFT_RED_BAR_POS["posY"], 1, 0
return

^#F3:: ;Ctrl+Win+F3 - Lift Green Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, LIFT_GREEN_BAR_POS["posX"], LIFT_GREEN_BAR_POS["posY"], 1, 0
return

^#F4:: ;Ctrl+Win+F4 - Lift Green Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, LIFT_GREEN_BAR_POS["posX"], LIFT_GREEN_BAR_POS["posY"], 1, 0
return

^#F5:: ;Ctrl+Win+F5 - Lift Blue Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, LIFT_BLUE_BAR_POS["posX"], LIFT_BLUE_BAR_POS["posY"], 1, 0
return

^#F6:: ;Ctrl+Win+F6 - Lift Blue Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, LIFT_BLUE_BAR_POS["posX"], LIFT_BLUE_BAR_POS["posY"], 1, 0
return

^#F7:: ;Ctrl+Win+F7 - Gamma Red Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }
    
	MouseClick WheelUp, GAMMA_RED_BAR_POS["posX"], GAMMA_RED_BAR_POS["posY"], 1, 0
return

^#F8:: ;Ctrl+Win+F8 - Gamma Red Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, GAMMA_RED_BAR_POS["posX"], GAMMA_RED_BAR_POS["posY"], 1, 0
return

^#F9:: ;Ctrl+Win+F9 - Gamma Green Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, GAMMA_GREEN_BAR_POS["posX"], GAMMA_GREEN_BAR_POS["posY"], 1, 0
return

^#F10:: ;Ctrl+Win+F10 - Gamma Green Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, GAMMA_GREEN_BAR_POS["posX"], GAMMA_GREEN_BAR_POS["posY"], 1, 0
return

^#F11:: ;Ctrl+Win+F11 - Gamma Blue Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, GAMMA_BLUE_BAR_POS["posX"], GAMMA_BLUE_BAR_POS["posY"], 1, 0
return

^#F12:: ;Ctrl+Win+F12 - Gamma Blue Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, GAMMA_BLUE_BAR_POS["posX"], GAMMA_BLUE_BAR_POS["posY"], 1, 0
return

^!+f:: ;Ctrl+Alt+Shift+f - Gain Red Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, GAIN_RED_BAR_POS["posX"], GAIN_RED_BAR_POS["posY"], 1, 0
return

^!+g:: ;Ctrl+Alt+Shift+g - Gain Red Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, GAIN_RED_BAR_POS["posX"], GAIN_RED_BAR_POS["posY"], 1, 0
return

^!+h:: ;Ctrl+Alt+Shift+h - Gain Green Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, GAIN_GREEN_BAR_POS["posX"], GAIN_GREEN_BAR_POS["posY"], 1, 0
return

^!+i:: ;Ctrl+Alt+Shift+i - Gain Green Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, GAIN_GREEN_BAR_POS["posX"], GAIN_GREEN_BAR_POS["posY"], 1, 0
return

^!+j:: ;Ctrl+Alt+Shift+j - Gain Blue Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, GAIN_BLUE_BAR_POS["posX"], GAIN_BLUE_BAR_POS["posY"], 1, 0
return

^!+k:: ;Ctrl+Alt+Shift+k - Gain Blue Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, GAIN_BLUE_BAR_POS["posX"], GAIN_BLUE_BAR_POS["posY"], 1, 0
return

; == Offset Bars controls ==
^+g:: ;Ctrl+Shift+g - Offset Red Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, OFFSET_RED_BAR_POS["posX"], OFFSET_RED_BAR_POS["posY"], 1, 0
return

^+m:: ;Ctrl+Shift+m - Offset Red Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, OFFSET_RED_BAR_POS["posX"], OFFSET_RED_BAR_POS["posY"], 1, 0
return

^+t:: ;Ctrl+Shift+t - Offset Green Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, OFFSET_GREEN_BAR_POS["posX"], OFFSET_GREEN_BAR_POS["posY"], 1, 0
return

^+u:: ;Ctrl+Shift+u - Offset Green Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, OFFSET_GREEN_BAR_POS["posX"], OFFSET_GREEN_BAR_POS["posY"], 1, 0
return

^+PgUp:: ;Ctrl+Shift+PgUp - Offset Blue Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, OFFSET_BLUE_BAR_POS["posX"], OFFSET_BLUE_BAR_POS["posY"], 1, 0
return

^+PgDn:: ;Ctrl+Shift+PgUp - Offset Blue Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, OFFSET_BLUE_BAR_POS["posX"], OFFSET_BLUE_BAR_POS["posY"], 1, 0
return

; == Luma Controls ==
^!+F5:: ;Ctrl+Alt+Shift+F5 - Luma Lift Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, LUMA_LIFT_BAR_POS["posX"], LUMA_LIFT_BAR_POS["posY"], 1, 0
return

^!+F6:: ;Ctrl+Alt+Shift+F6 - Luma Lift Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, LUMA_LIFT_BAR_POS["posX"], LUMA_LIFT_BAR_POS["posY"], 1, 0
return

^!+F7:: ;Ctrl+Alt+Shift+F7 - Luma Gamma Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, LUMA_GAMMA_BAR_POS["posX"], LUMA_GAMMA_BAR_POS["posY"], 1, 0
return

^!+F8:: ;Ctrl+Alt+Shift+F8 - Luma Gamma Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, LUMA_GAMMA_BAR_POS["posX"], LUMA_GAMMA_BAR_POS["posY"], 1, 0
return

^!+F9:: ;Ctrl+Alt+Shift+F9 - Luma Gain Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelDown, LUMA_GAIN_BAR_POS["posX"], LUMA_GAIN_BAR_POS["posY"], 1, 0
return

^!+F10:: ;Ctrl+Alt+Shift+F10 - Luma Gain Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "bars"){
        return
    }

	MouseClick WheelUp, LUMA_GAIN_BAR_POS["posX"], LUMA_GAIN_BAR_POS["posY"], 1, 0
return

; == Primary/Log Wheels Controls ==
^!+F1:: ;Ctrl+Alt+Shift+F1 - Lift/Shadows TrackBall
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "liftShadow"){
        _exitAnyControlFunction()
        
        global _activeController := "liftShadow"
    }
    
    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
		MouseMove LIFT_SHAD_WHEEL_POS["posX"], LIFT_SHAD_WHEEL_POS["posY"], 0
        Send, {LButton Down}
        _startReleaseTimer()
    }Else{
		Send, {LButton Up}
	}
return

^!+F2:: ;Ctrl+Alt+Shift+F2 - Gamma/Midtones TrackBall
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "gammaMidtones"){
        _exitAnyControlFunction()
        
        global _activeController := "gammaMidtones"
    }
    
    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
		MouseMove GAM_MID_WHEEL_POS["posX"], GAM_MID_WHEEL_POS["posY"], 0
        Send, {LButton Down}
        _startReleaseTimer()
    }Else{
		Send, {LButton Up}
	}
return

^!+F3:: ;Ctrl+Alt+Shift+F3 - Gain/Highlights TrackBall
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "gainHighlights"){
        _exitAnyControlFunction()
        
        global _activeController := "gainHighlights"
    }

    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
		MouseMove GAIN_HIGH_WHEEL_POS["posX"], GAIN_HIGH_WHEEL_POS["posY"], 0
        Send, {LButton Down}
        _startReleaseTimer()
    }Else{
		Send, {LButton Up}
	}
return

^!+F4:: ;Ctrl+Alt+Shift+F4 - Offset TrackBall
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "offset"){
        _exitAnyControlFunction()
        
        global _activeController := "offset"
    }

    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
		MouseMove OFFSET_WHEEL_POS["posX"], OFFSET_WHEEL_POS["posY"], 0
        Send, {LButton Down}
        _startReleaseTimer()
    }Else{
		Send, {LButton Up}
	}
return

; == Control Jogs ==
^!+1:: ;Ctrl+Alt+Shift+1 - Lift Horizontal Wheel Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "liftHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "liftHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != LIFT_SHAD_HOR_WHEEL_POS["posX"]){
		MouseMove LIFT_SHAD_HOR_WHEEL_POS["posX"], LIFT_SHAD_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelUp}
	Sleep 10
return

^!+2:: ;Ctrl+Alt+Shift+2 - Lift Horizontal Wheel Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "liftHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "liftHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != LIFT_SHAD_HOR_WHEEL_POS["posX"]){
		MouseMove LIFT_SHAD_HOR_WHEEL_POS["posX"], LIFT_SHAD_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelDown}
	Sleep 10
return

^!+3:: ;Ctrl+Alt+Shift+3 - Gamma Horizontal Wheel Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "gammaHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "gammaHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != GAM_MID_HOR_WHEEL_POS["posX"]){
		MouseMove GAM_MID_HOR_WHEEL_POS["posX"], GAM_MID_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelUp}
	Sleep 10
return

^!+4:: ;Ctrl+Alt+Shift+4 - Gamma Horizontal Wheel Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "gammaHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "gammaHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != GAM_MID_HOR_WHEEL_POS["posX"]){
		MouseMove GAM_MID_HOR_WHEEL_POS["posX"], GAM_MID_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelDown}
	Sleep 10
return

^!+5:: ;Ctrl+Alt+Shift+5 - Gain Horizontal Wheel Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "gainHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "gainHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != GAIN_HIGH_HOR_WHEEL_POS["posX"]){
		MouseMove GAIN_HIGH_HOR_WHEEL_POS["posX"], GAIN_HIGH_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelUp}
	Sleep 10
return

^!+6:: ;Ctrl+Alt+Shift+6 - Gain Horizontal Wheel Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "gainHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "gainHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != GAIN_HIGH_HOR_WHEEL_POS["posX"]){
		MouseMove GAIN_HIGH_HOR_WHEEL_POS["posX"], GAIN_HIGH_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelDown}
	Sleep 10
return

^!+7:: ;Ctrl+Alt+Shift+7 - Offset Horizontal Wheel Up
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "offsetHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "offsetHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != OFFSET_HOR_WHEEL_POS["posX"]){
		MouseMove OFFSET_HOR_WHEEL_POS["posX"], OFFSET_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelUp}
	Sleep 10
return

^!+8:: ;Ctrl+Alt+Shift+8 - Offset Horizontal Wheel Down
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activeController == "offsetHorizontal"){
        _exitAnyControlFunction()
        
        _activeController == "offsetHorizontal"
    }
    
	MouseGetPos, MousePosX, MousePosY
	if(MousePosX != OFFSET_HOR_WHEEL_POS["posX"]){
		MouseMove OFFSET_HOR_WHEEL_POS["posX"], OFFSET_HOR_WHEEL_POS["posY"], 0
	}
	Send {WheelDown}
	Sleep 10
return

; == Reset Primaries and Logs ==
^!+Insert:: ;Ctrl+Alt+Shift+Insert - Reset Lift/Shadows
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
	MouseClick Left, LIFT_SHADOWS_RESET_POS["posX"], LIFT_SHADOWS_RESET_POS["posY"], 2, 0
return

^!+Delete:: ;Ctrl+Alt+Shift+Delete - Reset Gamma/Midtones
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
	MouseClick Left, GAMMA_MID_RESET_POS["posX"], GAMMA_MID_RESET_POS["posY"], 2, 0
return

^!+Home:: ;Ctrl+Alt+Shift+Home - Reset Gain/Highlights
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
	MouseClick Left, GAIN_HIGH_RESET_POS["posX"], GAIN_HIGH_RESET_POS["posY"], 2, 0
return

^!+End:: ;Ctrl+Alt+Shift+End - Reset Offset
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
	MouseClick Left, OFFSET_RESET_POS["posX"], OFFSET_RESET_POS["posY"], 2, 0
return

^!+PgUp:: ;Ctrl+Alt+Shift+PgUp - Reset All Primary
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "primaries"){
        MouseClick Left, PRIMARIES_WHEELS_TAB["posX"], PRIMARIES_WHEELS_TAB["posY"], 1, 0
        
        global _activePrimariesLogPanel := "primaries"
    }
    MouseClick Left, RESET_ALL_PRIMARIES_LOG_POS["posX"], RESET_ALL_PRIMARIES_LOG_POS["posY"], 1, 0
return

^!+PgDn:: ;Ctrl+Alt+Shift+PgDn - Reset All Log
    if !(_activePage == "color"){
        return
    }
    
    if !(_activeMasterPanel == "wheels"){
        return
    }
    
    if !(_activePrimariesLogPanel == "log"){
        MouseClick Left, LOG_WHEELS_TAB["posX"], LOG_WHEELS_TAB["posY"], 1, 0

        global _activePrimariesLogPanel := "log"
    }

    MouseClick Left, RESET_ALL_PRIMARIES_LOG_POS["posX"], RESET_ALL_PRIMARIES_LOG_POS["posY"], 1, 0
return

; == Curves Control ==
; At the first basic curves panel, every time that a point is realeased the function saves the position of the point on a variable and if you execute a _exitAnyControlFunction (clear command) it has to save the position too

; == Change Curves Panels ==
Numpad0:: ;Numpad0 - Previous Curves Panel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    Switch _activeCurvesPanel{
        Case "curves":
            _changeCurvesPanel("satXsat", SATXSAT_PANEL_BUTTON_POS)
        Case "hueXhue":
            _changeCurvesPanel("curves", CURVES_PANEL_BUTTON_POS)
        Case "hueXsat":
            _changeCurvesPanel("hueXhue", HUEXHUE_PANEL_BUTTON_POS)
        Case "hueXlum":
            _changeCurvesPanel("hueXsat", HUEXSAT_PANEL_BUTTON_POS)
        Case "lumXsat":
            _changeCurvesPanel("hueXlum", HUEXLUM_PANEL_BUTTON_POS)
        Case "satXsat":
            _changeCurvesPanel("lumXsat", LUMXSAT_PANEL_BUTTON_POS)
    }
return

Numpad1:: ;Numpad1 - Next Curves Panel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }

    Switch _activeCurvesPanel{
        Case "curves":
            _changeCurvesPanel("hueXhue", HUEXHUE_PANEL_BUTTON_POS)
        Case "hueXhue":
            _changeCurvesPanel("hueXsat", HUEXSAT_PANEL_BUTTON_POS)
        Case "hueXsat":
            _changeCurvesPanel("hueXlum", HUEXLUM_PANEL_BUTTON_POS)
        Case "hueXlum":
            _changeCurvesPanel("lumXsat", LUMXSAT_PANEL_BUTTON_POS)
        Case "lumXsat":
            _changeCurvesPanel("satXsat", SATXSAT_PANEL_BUTTON_POS)
        Case "satXsat":
            _changeCurvesPanel("curves", CURVES_PANEL_BUTTON_POS)
    }
return

!+Insert:: ;Alt+Shift+Insert - Reset Curves VS
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    MouseClick Left, RESET_CURVES_VS_POS["posX"], RESET_CURVES_VS_POS["posY"], 1, 0
return

; == Select Main Curves ==
^+F1:: ;Ctrl+Shift+F1 - Select Main Curves 1
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesMain1"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesMain1"
        MouseClick Left, SELECT_ALL_CURVES_BUTTON_POS["posX"], SELECT_ALL_CURVES_BUTTON_POS["posY"], 1, 0
    }
return

^+F2:: ;Ctrl+Shift+F2 - Select Y Curves 1
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesY1"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesY1"
        MouseClick Left, SELECT_Y_CURVE_BUTTON_POS["posX"], SELECT_Y_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

^+F3:: ;Ctrl+Shift+F3 - Select R Curves 1
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesR1"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesR1"
        MouseClick Left, SELECT_R_CURVE_BUTTON_POS["posX"], SELECT_R_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

^+F4:: ;Ctrl+Shift+F4 - Select G Curves 1
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesG1"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesG1"
        MouseClick Left, SELECT_G_CURVE_BUTTON_POS["posX"], SELECT_G_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

^+F5:: ;Ctrl+Shift+F5 - Select B Curves 1
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesB1"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesB1"
        MouseClick Left, SELECT_B_CURVE_BUTTON_POS["posX"], SELECT_B_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

^+F6:: ;Ctrl+Shift+F6 - Select Main Curves 2
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesMain2"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesMain2"
        MouseClick Left, SELECT_ALL_CURVES_BUTTON_POS["posX"], SELECT_ALL_CURVES_BUTTON_POS["posY"], 1, 0
    }
return

^+F7:: ;Ctrl+Shift+F7 - Select Y Curves 2
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesY2"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesY2"
        MouseClick Left, SELECT_Y_CURVE_BUTTON_POS["posX"], SELECT_Y_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

^+F8:: ;Ctrl+Shift+F8 - Select R Curves 2
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesR2"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesR2"
        MouseClick Left, SELECT_R_CURVE_BUTTON_POS["posX"], SELECT_R_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

^+F9:: ;Ctrl+Shift+F9 - Select G Curves 2
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesG2"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesG2"
        MouseClick Left, SELECT_G_CURVE_BUTTON_POS["posX"], SELECT_G_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

^+F10:: ;Ctrl+Shift+F10 - Select B Curves 2
    if !(_activePage == "color"){
        return
    }
    
    _checkIfOnCurvesPanel()
    
    if !(_activeCurves == "curvesB2"){
        _exitAnyControlFunction()
    
        _activeCurves := "curvesB2"
        MouseClick Left, SELECT_B_CURVE_BUTTON_POS["posX"], SELECT_B_CURVE_BUTTON_POS["posY"], 1, 0
    }
return

!Backspace:: ;Alt+Backspace - Create Default Points
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    MouseClick Left, CURVES_DOTS_MENU_POS["posX"], CURVES_DOTS_MENU_POS["posY"], 1, 1
    Sleep 10
    MouseClick Left, CREATE_POINTS_MENU_POS["posX"], CREATE_POINTS_MENU_POS["posY"], 1, 1
return

!Insert:: ;Alt+Insert - Get/Release black point
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    ident := subStr(_activeCurves, 7)
    object := _returnCurvePointsObject(ident)
    button := "black"
    
    _changeCurvePointsObject(object, button)

    if !(_activeController == "curves"){
        global _activeController := "curves"
    }
    
    _mouseMoveToSelectedPoint(object, button)
return

!Delete:: ;Alt+Delete - Get/Release shadow point on main curve
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    ident := subStr(_activeCurves, 7)
    object := _returnCurvePointsObject(ident)
    button := "shadow"
    
    _changeCurvePointsObject(object, button)

    if !(_activeController == "curves"){
        global _activeController := "curves"
    }
    
    _mouseMoveToSelectedPoint(object, button)
return

!Home:: ;alt+Home - Get/Release midtone black point on main curve
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    ident := subStr(_activeCurves, 7)
    object := _returnCurvePointsObject(ident)
    button := "midBlack"
    
    _changeCurvePointsObject(object, button)

    if !(_activeController == "curves"){
        global _activeController := "curves"
    }
    
    _mouseMoveToSelectedPoint(object, button)
return

!a:: ;Alt+a - Get/Release midtone white point on main curve
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    ident := subStr(_activeCurves, 7)
    object := _returnCurvePointsObject(ident)
    button := "midWhite"
    
    _changeCurvePointsObject(object, button)

    if !(_activeController == "curves"){
        global _activeController := "curves"
    }
    
    _mouseMoveToSelectedPoint(object, button)
return

!PgUp:: ;Alt+PgUp - Get/Release highlight point on main curve
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    ident := subStr(_activeCurves, 7)
    object := _returnCurvePointsObject(ident)
    button := "high"
    
    _changeCurvePointsObject(object, button)

    if !(_activeController == "curves"){
        global _activeController := "curves"
    }
    
    _mouseMoveToSelectedPoint(object, button)
return

!PgDn:: ;Alt+PgDn - Get/Release white point on main curve
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    ident := subStr(_activeCurves, 7)
    object := _returnCurvePointsObject(ident)
    button := "white"
    
    _changeCurvePointsObject(object, button)

    if !(_activeController == "curves"){
        global _activeController := "curves"
    }
    
    _mouseMoveToSelectedPoint(object, button)
return

^!Backspace:: ;Ctrl+Alt+Backspace - Reset Curves 1
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    _curvePointsObjectMain1["latestPoint"] := "off"
    _curvePointsObjectMain1["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectMain1["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectMain1["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectMain1["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectMain1["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectMain1["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectMain1["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectMain1["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectMain1["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectMain1["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectMain1["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectMain1["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]
    
    _curvePointsObjectY1["latestPoint"] := "off"
    _curvePointsObjectY1["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectY1["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectY1["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectY1["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectY1["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectY1["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectY1["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectY1["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectY1["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectY1["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectY1["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectY1["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]
    
    _curvePointsObjectR1["latestPoint"] := "off"
    _curvePointsObjectR1["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectR1["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectR1["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectR1["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectR1["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectR1["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectR1["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectR1["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectR1["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectR1["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectR1["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectR1["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]

    _curvePointsObjectG1["latestPoint"] := "off"
    _curvePointsObjectG1["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectG1["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectG1["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectG1["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectG1["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectG1["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectG1["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectG1["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectG1["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectG1["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectG1["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectG1["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]

    _curvePointsObjectB1["latestPoint"] := "off"
    _curvePointsObjectB1["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectB1["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectB1["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectB1["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectB1["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectB1["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectB1["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectB1["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectB1["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectB1["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectB1["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectB1["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]
    
    MouseClick Left, CURVES_RESET_BUTTON_POS["posX"], CURVES_RESET_BUTTON_POS["posY"], 2, 0
return

^!Insert:: ;Ctrl+Alt+Insert - Reset Curves 2
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    _curvePointsObjectMain2["latestPoint"] := "off"
    _curvePointsObjectMain2["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectMain2["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectMain2["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectMain2["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectMain2["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectMain2["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectMain2["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectMain2["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectMain2["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectMain2["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectMain2["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectMain2["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]
    
    _curvePointsObjectY2["latestPoint"] := "off"
    _curvePointsObjectY2["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectY2["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectY2["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectY2["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectY2["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectY2["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectY2["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectY2["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectY2["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectY2["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectY2["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectY2["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]
    
    _curvePointsObjectR2["latestPoint"] := "off"
    _curvePointsObjectR2["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectR2["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectR2["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectR2["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectR2["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectR2["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectR2["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectR2["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectR2["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectR2["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectR2["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectR2["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]
    
    _curvePointsObjectG2["latestPoint"] := "off"
    _curvePointsObjectG2["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectG2["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectG2["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectG2["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectG2["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectG2["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectG2["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectG2["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectG2["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectG2["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectG2["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectG2["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]
    
    _curvePointsObjectB2["latestPoint"] := "off"
    _curvePointsObjectB2["black"].posX := DEFAULT_BLACK_POINT_POS["posX"]
    _curvePointsObjectB2["black"].posY := DEFAULT_BLACK_POINT_POS["posY"]
    _curvePointsObjectB2["shadow"].posX := DEFAULT_SHADOW_POINT_POS["posX"]
    _curvePointsObjectB2["shadow"].posY := DEFAULT_SHADOW_POINT_POS["posY"]
    _curvePointsObjectB2["midBlack"].posX := DEFAULT_MIDBLACK_POINT_POS["posX"]
    _curvePointsObjectB2["midBlack"].posY := DEFAULT_MIDBLACK_POINT_POS["posY"]
    _curvePointsObjectB2["midWhite"].posX := DEFAULT_MIDWHITE_POINT_POS["posX"]
    _curvePointsObjectB2["midWhite"].posY := DEFAULT_MIDWHITE_POINT_POS["posY"]
    _curvePointsObjectB2["high"].posX := DEFAULT_HIGH_POINT_POS["posX"]
    _curvePointsObjectB2["high"].posY := DEFAULT_HIGH_POINT_POS["posY"]
    _curvePointsObjectB2["white"].posX := DEFAULT_WHITE_POINT_POS["posX"]
    _curvePointsObjectB2["white"].posY := DEFAULT_WHITE_POINT_POS["posY"]

    MouseClick Left, CURVES_RESET_BUTTON_POS["posX"], CURVES_RESET_BUTTON_POS["posY"], 2, 0
return

; == Control Curves Edit and Soft ==
Numpad2:: ;Numpad2 - Increase Y Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "yChannel"){
        _getControllerToStartMove("yChannel", Y_CHANNEL_ITENSITY_CURVES_POS["posX"], Y_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "yChannel"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

Numpad3:: ;Numpad3 - Reduce Y Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "yChannel"){
        _getControllerToStartMove("yChannel", Y_CHANNEL_ITENSITY_CURVES_POS["posX"], Y_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "yChannel"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

Numpad4:: ;Numpad4 - Increase R Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "rChannel"){
        _getControllerToStartMove("rChannel", R_CHANNEL_ITENSITY_CURVES_POS["posX"], R_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "rChannel"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

Numpad5:: ;Numpad5 - Reduce R Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "rChannel"){
        _getControllerToStartMove("rChannel", R_CHANNEL_ITENSITY_CURVES_POS["posX"], R_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "rChannel"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

Numpad6:: ;Numpad6 - Increase G Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "gChannel"){
        _getControllerToStartMove("gChannel", G_CHANNEL_ITENSITY_CURVES_POS["posX"], G_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "gChannel"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

Numpad7:: ;Numpad7 - Reduce G Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "gChannel"){
        _getControllerToStartMove("gChannel", G_CHANNEL_ITENSITY_CURVES_POS["posX"], G_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "gChannel"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

Numpad8:: ;Numpad8 - Increase B Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "bChannel"){
        _getControllerToStartMove("bChannel", B_CHANNEL_ITENSITY_CURVES_POS["posX"], B_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "bChannel"){
        _moveMouseOnAxis("X", "plus", 1)
	}
return

Numpad9:: ;Numpad9 - Reduce B Chanel
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "bChannel"){
        _getControllerToStartMove("bChannel", B_CHANNEL_ITENSITY_CURVES_POS["posX"], B_CHANNEL_ITENSITY_CURVES_POS["posY"])
	}Else if (_activeController == "bChannel"){
        _moveMouseOnAxis("X", "minus", 1)
	}
return

^+Insert:: ;Ctrl+Shift+Insert - Increase Soft Low
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softLow"){
        _getControllerToStartMove("softLow", SOFT_LOW_CURVES_POS["posX"], SOFT_LOW_CURVES_POS["posY"])
	}Else if (_activeController == "softLow"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^+Delete:: ;Ctrl+Shift+Delete - Reduce Soft Low
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softLow"){
        _getControllerToStartMove("softLow", SOFT_LOW_CURVES_POS["posX"], SOFT_LOW_CURVES_POS["posY"])
	}Else if (_activeController == "softLow"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^+End:: ;Ctrl+Shift+End - Increase Soft High
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softHigh"){
        _getControllerToStartMove("softHigh", SOFT_HIGH_CURVES_POS["posX"], SOFT_HIGH_CURVES_POS["posY"])
	}Else if (_activeController == "softHigh"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^+NumpadDiv:: ;Ctrl+Shift+NumpadDiv - Reduce Soft High
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softHigh"){
        _getControllerToStartMove("softHigh", SOFT_HIGH_CURVES_POS["posX"], SOFT_HIGH_CURVES_POS["posY"])
	}Else if (_activeController == "softHigh"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^+NumpadMult:: ;Ctrl+Shift+NumpadMult - Increase Soft LS
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softLS"){
        _getControllerToStartMove("softLS", SOFT_LS_CURVES_POS["posX"], SOFT_LS_CURVES_POS["posY"])
	}Else if (_activeController == "softLS"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^+NumpadAdd:: ;Ctrl+Shift+NumpadAdd - Reduce Soft LS
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softLS"){
        _getControllerToStartMove("softLS", SOFT_LS_CURVES_POS["posX"], SOFT_LS_CURVES_POS["posY"])
	}Else if (_activeController == "softLS"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^+NumpadSub:: ;Ctrl+Shift+NumpadSub - Increase Soft HS
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softHS"){
        _getControllerToStartMove("softHS", SOFT_HS_CURVES_POS["posX"], SOFT_HS_CURVES_POS["posY"])
	}Else if (_activeController == "softHS"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^+-:: ;Ctrl+Shift+- - Reduce Soft HS
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }

    if !(_activeController == "softHS"){
        _getControllerToStartMove("softHS", SOFT_HS_CURVES_POS["posX"], SOFT_HS_CURVES_POS["posY"])
	}Else if (_activeController == "softHS"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^#a:: ;Ctrl+Win+a - Select All Channels to Soft Clip
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, ALL_CHANNELS_SOFT_CLIP["posX"], ALL_CHANNELS_SOFT_CLIP["posY"], 1, 0
return

^#b:: ;Ctrl+Win+b - Select Red Channel to Soft Clip
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, RED_CHANNEL_SOFT_CLIP["posX"], RED_CHANNEL_SOFT_CLIP["posY"], 1, 0
return

^#c:: ;Ctrl+Win+c - Select Green Channels to Soft Clip
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, GREEN_CHANNEL_SOFT_CLIP["posX"], GREEN_CHANNEL_SOFT_CLIP["posY"], 1, 0
return

^#e:: ;Ctrl+Win+e - Select Blue Channel to Soft Clip
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, BLUE_CHANNEL_SOFT_CLIP["posX"], BLUE_CHANNEL_SOFT_CLIP["posY"], 1, 0
return

^#-:: ;Ctrl+Win+- - Reset Soft Clip on Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, RESET_SOFT_CLIP_POS["posX"], RESET_SOFT_CLIP_POS["posY"], 1, 0
return

!+Delete:: ;Alt+Shift+Delete - Reset Y Channel Intensity Bar
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, RESET_Y_CHANNEL_INTENSITY_POS["posX"], RESET_Y_CHANNEL_INTENSITY_POS["posY"], 1, 0
return


!+PgUp:: ;Alt+Shift+PgUp - Reset R Channel Intensity Bar
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, RESET_R_CHANNEL_INTENSITY_POS["posX"], RESET_R_CHANNEL_INTENSITY_POS["posY"], 1, 0
return

!+PgDn:: ;Alt+Shift+PgDn - Reset G Channel Intensity Bar
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, RESET_G_CHANNEL_INTENSITY_POS["posX"], RESET_G_CHANNEL_INTENSITY_POS["posY"], 1, 0
return

!+F11:: ;Alt+Shift+F11 - Reset B Channel Intensity Bar
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if !(_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, RESET_B_CHANNEL_INTENSITY_POS["posX"], RESET_B_CHANNEL_INTENSITY_POS["posY"], 1, 0
return

; == Select Hue Curves Points ==
#!a:: ;Win+Alt+a - Select Red Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_RED_POINT_POS["posX"], VS_CURVES_RED_POINT_POS["posY"], "input")
return

#!b:: ;Win+Alt+b - Select Yellow Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_YELLOW_POINT_POS["posX"], VS_CURVES_YELLOW_POINT_POS["posY"], "input")
return

#!c:: ;Win+Alt+c - Select Green Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_GREEN_POINT_POS["posX"], VS_CURVES_GREEN_POINT_POS["posY"], "input")
return

#!e:: ;Win+Alt+e - Select Cyan Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_CYAN_POINT_POS["posX"], VS_CURVES_CYAN_POINT_POS["posY"], "input")
return

#!f:: ;Win+Alt+f - Select Blue Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_BLUE_POINT_POS["posX"], VS_CURVES_BLUE_POINT_POS["posY"], "input")
return

#!g:: ;Win+Alt+g - Select Purple Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_PURPLE_POINT_POS["posX"], VS_CURVES_PURPLE_POINT_POS["posY"], "input")
return

#!h:: ;Win+Alt+h - Select Black Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_BLACK_POINT_POS["posX"], VS_CURVES_BLACK_POINT_POS["posY"], "input")
return

#!i:: ;Win+Alt+i - Select White Point Input on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_WHITE_POINT_POS["posX"], VS_CURVES_WHITE_POINT_POS["posY"], "input")
return

#!j:: ;Win+Alt+j - Select Red Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_RED_POINT_POS["posX"], VS_CURVES_RED_POINT_POS["posY"], "output")
return

#!k:: ;Win+Alt+k - Select Yellow Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_YELLOW_POINT_POS["posX"], VS_CURVES_YELLOW_POINT_POS["posY"], "output")
return

#!l:: ;Win+Alt+l - Select Green Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_GREEN_POINT_POS["posX"], VS_CURVES_GREEN_POINT_POS["posY"], "output")
return

#!m:: ;Win+Alt+m - Select Cyan Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_CYAN_POINT_POS["posX"], VS_CURVES_CYAN_POINT_POS["posY"], "output")
return

#!n:: ;Win+Alt+n - Select Blue Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_BLUE_POINT_POS["posX"], VS_CURVES_BLUE_POINT_POS["posY"], "output")
return

#!o:: ;Win+Alt+o - Select Purple Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_PURPLE_POINT_POS["posX"], VS_CURVES_PURPLE_POINT_POS["posY"], "output")
return

#!p:: ;Win+Alt+p - Select Black Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_BLACK_POINT_POS["posX"], VS_CURVES_BLACK_POINT_POS["posY"], "output")
return

#!q:: ;Win+Alt+q - Select White Point Output on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _selectInputHueCurvesControls(VS_CURVES_WHITE_POINT_POS["posX"], VS_CURVES_WHITE_POINT_POS["posY"], "output")
return

#!r:: ;Win+Alt+r - Select Spine Point on Hue Curves
    if !(_activePage == "color"){
        return
    }
    
    if !(_activePanel == "curves"){
        return
    }
    
    if (_activeCurvesPanel == "curves"){
        return
    }
    
    _exitAnyControlFunction()
    
    MouseClick Left, VS_CURVES_SPINE_POINT_POS["posX"], VS_CURVES_SPINE_POINT_POS["posY"], 1, 0
return

;CONTROL OF SAT vs SAT PANEL - NEED TO BE REVISED ON NEXT VERSION
;#!s:: ;Win+Alt+s - Increase Black Point On Sat vs Sat Curve
    ;_moveBlackWhitePointsSatVsSat("black", "increase")
;return

;#!t:: ;Win+Alt+t - Reduce Black Point On Sat vs Sat Curve
    ;_moveBlackWhitePointsSatVsSat("black", "reduce")
;return

;#!u:: ;Win+Alt+u - Increase White Point On Sat vs Sat Curve
    ;_moveBlackWhitePointsSatVsSat("white", "increase")
;return

;#!v:: ;Win+Alt+v - Reduce White Point On Sat vs Sat Curve
    ;_moveBlackWhitePointsSatVsSat("white", "reduce")
;return

; == Select Panels on Color Tab ==
!+c:: ;Alt+Shift+c - Open Curves Panel
    if !(_activePage == "color"){
        return
    }

    if (_activePanel == "curves"){
        return
    }Else{
        _activePanel := "curves"
        MouseClick, Left, CURVES_PANEL_POS["posX"], CURVES_PANEL_POS["posY"], 1, 0
    }
return

!+j:: ;Alt+Shift+j - Open Qualifier Panel
    if !(_activePage == "color"){
        return
    }

    if (_activePanel == "qualifier"){
        return
    }Else{
        _activePanel := "qualifier"
        MouseClick, Left, QUALIFIER_PANEL_POS["posX"], QUALIFIER_PANEL_POS["posY"], 1, 0
    }
return

!+k:: ;Alt+Shift+k - Open Power Windows Panel
    if !(_activePage == "color"){
        return
    }

    if (_activePanel == "windows"){
        return
    }Else{
        _activePanel := "windows"
        MouseClick, Left, WINDOWS_PANEL_POS["posX"], WINDOWS_PANEL_POS["posY"], 1, 0
    }
return

!+l:: ;Alt+Shift+c - Open Tracking Panel
    if !(_activePage == "color"){
        return
    }

    if (_activePanel == "tracking"){
        return
    }Else{
        _activePanel := "tracking"
        MouseClick, Left, TRACKING_PANEL_POS["posX"], TRACKING_PANEL_POS["posY"], 1, 0
    }
return

!+m:: ;Alt+Shift+m - Open RGB Mixer + Blur Panel
    if !(_activePage == "color"){
        return
    }

    if (_activePanel == "blur" and _activeMasterPanel == "rgbmixer"){
        return
    }Else{
        _activePanel := "blur"
        
        _activeMasterPanel := "rgbmixer"
        
        MouseClick, Left, RGB_MIXER_PANEL_POS["posX"], RGB_MIXER_PANEL_POS["posY"], 1, 0
        Sleep 10
        MouseClick, Left, BLUR_PANEL_POS["posX"], BLUR_PANEL_POS["posY"], 1, 0
    }
return

!+n:: ;Alt+Shift+c - Open Key Panel
    if !(_activePage == "color"){
        return
    }

    if (_activePanel == "key"){
        return
    }Else{
        _activePanel := "key"
        MouseClick, Left, KEY_PANEL_POS["posX"], KEY_PANEL_POS["posY"], 1, 0
    }
return

!+-:: ;Alt+Shift+- - Open Sizing Panel
    if !(_activePage == "color"){
        return
    }

    if (_activePanel == "sizing"){
        return
    }Else{
        _activePanel := "sizing"
        MouseClick, Left, SIZING_PANEL_POS["posX"], SIZING_PANEL_POS["posY"], 1, 0
    }
return

; == RGB Mixer Controllers ==
!#+a:: ;Shift+Alt+Win+a - Red Output - Red Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_RED_OUT_RED_BAR["posX"], RGB_RED_OUT_RED_BAR["posY"], 1, 0
return

!#+b:: ;Shift+Alt+Win+b - Red Output - Red Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_RED_OUT_RED_BAR["posX"], RGB_RED_OUT_RED_BAR["posY"], 1, 0
return

!#+c:: ;Shift+Alt+Win+c - Red Output - Green Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_RED_OUT_GREEN_BAR["posX"], RGB_RED_OUT_GREEN_BAR["posY"], 1, 0
return

!#+d:: ;Shift+Alt+Win+d - Red Output - Green Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_RED_OUT_GREEN_BAR["posX"], RGB_RED_OUT_GREEN_BAR["posY"], 1, 0
return

!#+e:: ;Shift+Alt+Win+e - Red Output - Blue Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_RED_OUT_BLUE_BAR["posX"], RGB_RED_OUT_BLUE_BAR["posY"], 1, 0
return

!#+f:: ;Shift+Alt+Win+f - Red Output - Blue Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_RED_OUT_BLUE_BAR["posX"], RGB_RED_OUT_BLUE_BAR["posY"], 1, 0
return

!#+g:: ;Shift+Alt+Win+g - Green Output - Red Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_GREEN_OUT_RED_BAR["posX"], RGB_GREEN_OUT_RED_BAR["posY"], 1, 0
return

!#+h:: ;Shift+Alt+Win+h - Green Output - Red Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_GREEN_OUT_RED_BAR["posX"], RGB_GREEN_OUT_RED_BAR["posY"], 1, 0
return

!#+i:: ;Shift+Alt+Win+i - Green Output - Green Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_GREEN_OUT_GREEN_BAR["posX"], RGB_GREEN_OUT_GREEN_BAR["posY"], 1, 0
return

!#+j:: ;Shift+Alt+Win+j - Green Output - Green Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_GREEN_OUT_GREEN_BAR["posX"], RGB_GREEN_OUT_GREEN_BAR["posY"], 1, 0
return

!#+k:: ;Shift+Alt+Win+k - Green Output - Blue Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_GREEN_OUT_BLUE_BAR["posX"], RGB_GREEN_OUT_BLUE_BAR["posY"], 1, 0
return

!#+l:: ;Shift+Alt+Win+l - Green Output - Blue Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_GREEN_OUT_BLUE_BAR["posX"], RGB_GREEN_OUT_BLUE_BAR["posY"], 1, 0
return

!#+m:: ;Shift+Alt+Win+m - Blue Output - Red Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_BLUE_OUT_RED_BAR["posX"], RGB_BLUE_OUT_RED_BAR["posY"], 1, 0
return

!#+n:: ;Shift+Alt+Win+n - Blue Output - Red Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_BLUE_OUT_RED_BAR["posX"], RGB_BLUE_OUT_RED_BAR["posY"], 1, 0
return

!#+o:: ;Shift+Alt+Win+o - Blue Output - Green Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_BLUE_OUT_GREEN_BAR["posX"], RGB_BLUE_OUT_GREEN_BAR["posY"], 1, 0
return

!#+p:: ;Shift+Alt+Win+p - Blue Output - Green Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_BLUE_OUT_GREEN_BAR["posX"], RGB_BLUE_OUT_GREEN_BAR["posY"], 1, 0
return

!#+q:: ;Shift+Alt+Win+q - Blue Output - Blue Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelDown, RGB_BLUE_OUT_BLUE_BAR["posX"], RGB_BLUE_OUT_BLUE_BAR["posY"], 1, 0
return

!#+r:: ;Shift+Alt+Win+r - Blue Output - Blue Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick WheelUp, RGB_BLUE_OUT_BLUE_BAR["posX"], RGB_BLUE_OUT_BLUE_BAR["posY"], 1, 0
return

; == RGB Mixer Bottom Bar ==
!#+s:: ;Shift+Alt+Win+s - Invert Red/Green Channels on RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick left, INVERT_RED_GREEN_RGB_MIXER_POS["posX"], INVERT_RED_GREEN_RGB_MIXER_POS["posY"], 1, 0
return

!#+t:: ;Shift+Alt+Win+t - Invert Green/Blue Channels on RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick left, INVERT_GREEN_BLUE_RGB_MIXER_POS["posX"], INVERT_GREEN_BLUE_RGB_MIXER_POS["posY"], 1, 0
return

!#+u:: ;Shift+Alt+Win+u - Invert Blue/Red Channels on RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick left, INVERT_BLUE_RED_RGB_MIXER_POS["posX"], INVERT_BLUE_RED_RGB_MIXER_POS["posY"], 1, 0
return

!#+v:: ;Shift+Alt+Win+v - Toggle Monochrome on RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick left, MONOCHROME_RGB_MIXER_POS["posX"], MONOCHROME_RGB_MIXER_POS["posY"], 1, 0
return

!#+w:: ;Shift+Alt+Win+w - Toggle Preserve Luminance on RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
	MouseClick left, PRES_LUM_RGB_MIXER_POS["posX"], PRES_LUM_RGB_MIXER_POS["posY"], 1, 0
return

; == BLUR Panel Controllers ==
!#+F1:: ;Shift+Alt+Win+F1 - Radius - Red Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, RADIUS_RED_BAR_POS["posX"], RADIUS_RED_BAR_POS["posY"], 1, 0
return

!#+F2:: ;Shift+Alt+Win+F2 - Radius - Red Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, RADIUS_RED_BAR_POS["posX"], RADIUS_RED_BAR_POS["posY"], 1, 0
return

!#+F3:: ;Shift+Alt+Win+F3 - Radius - Green Bar - Increase 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, RADIUS_GREEN_BAR_POS["posX"], RADIUS_GREEN_BAR_POS["posY"], 1, 0
return

!#+y:: ;Shift+Alt+Win+y - Radius - Green Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, RADIUS_GREEN_BAR_POS["posX"], RADIUS_GREEN_BAR_POS["posY"], 1, 0
return

!#+F5:: ;Shift+Alt+Win+F5 - Radius - Blue Bar - Increase 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, RADIUS_BLUE_BAR_POS["posX"], RADIUS_BLUE_BAR_POS["posY"], 1, 0
return

!#+F6:: ;Shift+Alt+Win+F6 - Radius - Blue Bar - Reduce 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, RADIUS_BLUE_BAR_POS["posX"], RADIUS_BLUE_BAR_POS["posY"], 1, 0
return

!#+F7:: ;Shift+Alt+Win+F7 - H/V - Red Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, HV_RED_BAR_POS["posX"], HV_RED_BAR_POS["posY"], 1, 0
return

!#+F8:: ;Shift+Alt+Win+F8 - H/V - Red Bar - Reduce 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, HV_RED_BAR_POS["posX"], HV_RED_BAR_POS["posY"], 1, 0
return

!#+F9:: ;Shift+Alt+Win+F9 - H/V - Green Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, HV_GREEN_BAR_POS["posX"], HV_GREEN_BAR_POS["posY"], 1, 0
return

!#+F10:: ;Shift+Alt+Win+F10 - H/V - Green Bar - Reduce 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, HV_GREEN_BAR_POS["posX"], HV_GREEN_BAR_POS["posY"], 1, 0
return

!#+F11:: ;Shift+Alt+Win+F11 - H/V - Blue Bar - Increase 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, HV_BLUE_BAR_POS["posX"], HV_BLUE_BAR_POS["posY"], 1, 0
return

!#+F12:: ;Shift+Alt+Win+F12 - H/V - Blue Bar - Reduce  
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, HV_BLUE_BAR_POS["posX"], HV_BLUE_BAR_POS["posY"], 1, 0
return

!#+1:: ;Shift+Alt+Win+1 - Scaling - Red Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, SCALING_RED_BAR_POS["posX"], SCALING_RED_BAR_POS["posY"], 1, 0
return

!#+2:: ;Shift+Alt+Win+2 - Scaling - Red Bar - Reduce 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, SCALING_RED_BAR_POS["posX"], SCALING_RED_BAR_POS["posY"], 1, 0
return

!#+3:: ;Shift+Alt+Win+3 - Scaling - Green Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, SCALING_GREEN_BAR_POS["posX"], SCALING_GREEN_BAR_POS["posY"], 1, 0
return

!#+4:: ;Shift+Alt+Win+4 - Scaling - Green Bar - Reduce 
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, SCALING_GREEN_BAR_POS["posX"], SCALING_GREEN_BAR_POS["posY"], 1, 0
return

!#+5:: ;Shift+Alt+Win+5 - Scaling - Blue Bar - Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelDown, SCALING_BLUE_BAR_POS["posX"], SCALING_BLUE_BAR_POS["posY"], 1, 0
return

!#+6:: ;Shift+Alt+Win+6 - Scaling - Blue Bar - Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
	MouseClick WheelUp, SCALING_BLUE_BAR_POS["posX"], SCALING_BLUE_BAR_POS["posY"], 1, 0
return

; == BLUR Panel Bottom Bar ==
+NumpadMult:: ;Shift+NumpadMult - Toggle Blur Panels
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }

    Switch _activeBlurPanel{
        Case "blur":
            _changeBlurPanel("sharpen", SHARPEN_BUTTON_BLUR_PANEL_POS)
        Case "sharpen":
            _changeBlurPanel("mist", MIST_BUTTON_BLUR_PANEL_POS)
        Case "mist":
            _changeBlurPanel("blur", BLUR_BUTTON_BLUR_PANEL_POS)
    }
return

!#+7:: ;Shift+Alt+Win+7 - Get/Release Coring Softness
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    if !(_activeBlurPanel == "sharpen"){
        return
    }
    
    GetKeyState, LbuttonState, LButton, P
	if (LbuttonState = "U"){
        MouseMove CORING_SOFTNESS_BLUR_PANEL_POS["posX"], CORING_SOFTNESS_BLUR_PANEL_POS["posY"], 0

   	    Send, {LButton Down}
        _startReleaseTimer()
        
        _activeBottomBlurControl := "coring"
    }Else if !(_activeBottomBlurControl == "coring"){
        _exitAnyControlFunction()

        MouseMove CORING_SOFTNESS_BLUR_PANEL_POS["posX"], CORING_SOFTNESS_BLUR_PANEL_POS["posY"], 0
        
   	    Send, {LButton Down}
        _startReleaseTimer()
        
        _activeBottomBlurControl := "coring"
    }Else{
        _exitAnyControlFunction()
    }
return

!#+8:: ;Shift+Alt+Win+8 - Get/Release Level Softness
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    if !(_activeBlurPanel == "sharpen"){
        return
    }
    
    GetKeyState, LbuttonState, LButton, P
	if (LbuttonState = "U"){
        MouseMove LEVEL_BLUR_PANEL_POS["posX"], LEVEL_BLUR_PANEL_POS["posY"], 0
        
   	    Send, {LButton Down}
        _startReleaseTimer()
        
        _activeBottomBlurControl := "level"
    }Else if !(_activeBottomBlurControl == "level"){
        _exitAnyControlFunction()
        
        MouseMove LEVEL_BLUR_PANEL_POS["posX"], LEVEL_BLUR_PANEL_POS["posY"], 0
        
   	    Send, {LButton Down}
        _startReleaseTimer()
        
        _activeBottomBlurControl := "level"
    }Else{
        _exitAnyControlFunction()
    }
return

!#+9:: ;Shift+Alt+Win+9 - Get/Release Mix Softness
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    if !(_activeBlurPanel == "mist"){
        return
    }
    
    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
        MouseMove MIX_BLUR_PANEL_POS["posX"], MIX_BLUR_PANEL_POS["posY"], 0
        
        Send, {LButton Down}
        _startReleaseTimer()
        
        _activeBottomBlurControl := "mix"
    }Else if !(_activeBottomBlurControl == "mix"){
        _exitAnyControlFunction()
        
        MouseMove MIX_BLUR_PANEL_POS["posX"], MIX_BLUR_PANEL_POS["posY"], 0
        
   	    Send, {LButton Down}
        _startReleaseTimer()
        
        _activeBottomBlurControl := "mix"
    }Else{
        _exitAnyControlFunction()
    }
return

; == Reset buttons on RGB Mixer and Blur Panel ==
!#+Insert:: ;Shift+Alt+Win+Insert - Reset Red Output RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
    MouseClick left, RESET_RED_OUTPUT_RGB_MIXER_POS["posX"], RESET_RED_OUTPUT_RGB_MIXER_POS["posY"], 1, 0
return

!#+Home:: ;Shift+Alt+Win+Home - Reset Green Output RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
    MouseClick left, RESET_GREEN_OUTPUT_RGB_MIXER_POS["posX"], RESET_GREEN_OUTPUT_RGB_MIXER_POS["posY"], 1, 0
return

!#+Delete:: ;Shift+Alt+Win+Delete - Reset Blue Output RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
    MouseClick left, RESET_BLUE_OUTPUT_RGB_MIXER_POS["posX"], RESET_BLUE_OUTPUT_RGB_MIXER_POS["posY"], 1, 0
return

!#+End:: ;Shift+Alt+Win+End - Reset Radius on Blur Panel
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    MouseClick left, RESET_RADIUS_BLUR_PANEL_POS["posX"], RESET_RADIUS_BLUR_PANEL_POS["posY"], 1, 0
return

!#+PgUp:: ;Shift+Alt+Win+PgUp - Reset H/V on Blur Panel
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    MouseClick left, RESET_HV_BLUR_PANEL_POS["posX"], RESET_HV_BLUR_PANEL_POS["posY"], 1, 0
return

!#+PgDn:: ;Shift+Alt+Win+PgDn - Reset Scaling on Blur Panel
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    MouseClick left, RESET_SCALING_BLUR_PANEL_POS["posX"], RESET_SCALING_BLUR_PANEL_POS["posY"], 1, 0
return

!#+0:: ;Shift+Alt+Win+0 - Reset All RGB Mixer
    if !(_activePage == "color"){
        return
    }

    if !(_activeMasterPanel == "rgbmixer"){
        return
    }
    
    MouseClick left, RESET_RGB_MIXER_POS["posX"], RESET_RGB_MIXER_POS["posY"], 1, 0
return

!#+-::  ;Shift+Alt+Win+- - Reset All Blur Panel
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    MouseClick left, RESET_BLUR_PANEL_POS["posX"], RESET_BLUR_PANEL_POS["posY"], 1, 0
return

!#+z:: ;Shift+Alt+Win+z - Link/Unlink Blur Panels
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "blur"){
        return
    }
    
    MouseClick left, LINK_RADIUS_BLUR_PANEL_POS["posX"], LINK_RADIUS_BLUR_PANEL_POS["posY"], 1, 0
    Sleep 10
    MouseClick left, LINK_HV_BLUR_PANEL_POS["posX"], LINK_HV_BLUR_PANEL_POS["posY"], 1, 0
    Sleep 10
    MouseClick left, LINK_SCALING_BLUR_PANEL_POS["posX"], LINK_SCALING_BLUR_PANEL_POS["posY"], 1, 0
return

; == Power Windows Controls ==
^!#a:: ;Ctrl+Alt+Win+a - PW Size Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformSize"){
        _getControllerToStartMove("transformSize", TRANSFORM_SIZE_PW_POS["posX"], TRANSFORM_SIZE_PW_POS["posY"])
	}Else if (_activeController == "transformSize"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#b:: ;Ctrl+Alt+Win+b - PW Size Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformSize"){
        _getControllerToStartMove("transformSize", TRANSFORM_SIZE_PW_POS["posX"], TRANSFORM_SIZE_PW_POS["posY"])
	}Else if (_activeController == "transformSize"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#c:: ;Ctrl+Alt+Win+c - PW Aspect Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformAspect"){
        _getControllerToStartMove("transformAspect", TRANSFORM_ASPECT_PW_POS["posX"], TRANSFORM_ASPECT_PW_POS["posY"])
	}Else if (_activeController == "transformAspect"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#d:: ;Ctrl+Alt+Win+d - PW Aspect Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformAspect"){
        _getControllerToStartMove("transformAspect", TRANSFORM_ASPECT_PW_POS["posX"], TRANSFORM_ASPECT_PW_POS["posY"])
	}Else if (_activeController == "transformAspect"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#e:: ;Ctrl+Alt+Win+e - PW Pan Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformPan"){
        _getControllerToStartMove("transformPan", TRANSFORM_PAN_PW_POS["posX"], TRANSFORM_PAN_PW_POS["posY"])
	}Else if (_activeController == "transformPan"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#f:: ;Ctrl+Alt+Win+f - PW Pan Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformPan"){
        _getControllerToStartMove("transformPan", TRANSFORM_PAN_PW_POS["posX"], TRANSFORM_PAN_PW_POS["posY"])
	}Else if (_activeController == "transformPan"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#g:: ;Ctrl+Alt+Win+g - PW Tilt Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformTilt"){
        _getControllerToStartMove("transformTilt", TRANSFORM_TILT_PW_POS["posX"], TRANSFORM_TILT_PW_POS["posY"])
	}Else if (_activeController == "transformTilt"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#h:: ;Ctrl+Alt+Win+h - PW Tilt Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformTilt"){
        _getControllerToStartMove("transformTilt", TRANSFORM_TILT_PW_POS["posX"], TRANSFORM_TILT_PW_POS["posY"])
	}Else if (_activeController == "transformTilt"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#i:: ;Ctrl+Alt+Win+i - PW Rotate Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformRotate"){
        _getControllerToStartMove("transformRotate", TRANSFORM_ROTATE_PW_POS["posX"], TRANSFORM_ROTATE_PW_POS["posY"])
	}Else if (_activeController == "transformRotate"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#j:: ;Ctrl+Alt+Win+j - PW Rotate Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }

    if !(_activeController == "transformRotate"){
        _getControllerToStartMove("transformRotate", TRANSFORM_ROTATE_PW_POS["posX"], TRANSFORM_ROTATE_PW_POS["posY"])
	}Else if (_activeController == "transformRotate"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#k:: ;Ctrl+Alt+Win+k - PW Opacity Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformOpacity"){
        _getControllerToStartMove("transformOpacity", TRANSFORM_OPACITY_PW_POS["posX"], TRANSFORM_OPACITY_PW_POS["posY"])
	}Else if (_activeController == "transformOpacity"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#l:: ;Ctrl+Alt+Win+l - PW Opacity Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "transformOpacity"){
        _getControllerToStartMove("transformOpacity", TRANSFORM_OPACITY_PW_POS["posX"], TRANSFORM_OPACITY_PW_POS["posY"])
	}Else if (_activeController == "transformOpacity"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#m:: ;Ctrl+Alt+Win+m - PW Soft 1 Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft1"){
        _getControllerToStartMove("softnessSoft1", SOFTNESS_SOFT1_PW_POS["posX"], SOFTNESS_SOFT1_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft1"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#n:: ;Ctrl+Alt+Win+n - PW Soft 1 Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft1"){
        _getControllerToStartMove("softnessSoft1", SOFTNESS_SOFT1_PW_POS["posX"], SOFTNESS_SOFT1_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft1"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#o:: ;Ctrl+Alt+Win+o - PW Soft 2 Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft2"){
        _getControllerToStartMove("softnessSoft2", SOFTNESS_SOFT2_PW_POS["posX"], SOFTNESS_SOFT2_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft2"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#p:: ;Ctrl+Alt+Win+p - PW Soft 2 Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft2"){
        _getControllerToStartMove("softnessSoft2", SOFTNESS_SOFT2_PW_POS["posX"], SOFTNESS_SOFT2_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft2"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#q:: ;Ctrl+Alt+Win+q - PW Soft 3 Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft3"){
        _getControllerToStartMove("softnessSoft3", SOFTNESS_SOFT3_PW_POS["posX"], SOFTNESS_SOFT3_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft3"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#r:: ;Ctrl+Alt+Win+r - PW Soft 3 Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft3"){
        _getControllerToStartMove("softnessSoft3", SOFTNESS_SOFT3_PW_POS["posX"], SOFTNESS_SOFT3_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft3"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#s:: ;Ctrl+Alt+Win+s - PW Soft 4 Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft4"){
        _getControllerToStartMove("softnessSoft4", SOFTNESS_SOFT4_PW_POS["posX"], SOFTNESS_SOFT4_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft4"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#t:: ;Ctrl+Alt+Win+t - PW Soft 4 Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessSoft4"){
        _getControllerToStartMove("softnessSoft4", SOFTNESS_SOFT4_PW_POS["posX"], SOFTNESS_SOFT4_PW_POS["posY"])
	}Else if (_activeController == "softnessSoft4"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#u:: ;Ctrl+Alt+Win+u - PW Inside Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessInside"){
        _getControllerToStartMove("softnessInside", SOFTNESS_INSIDE_PW_POS["posX"], SOFTNESS_INSIDE_PW_POS["posY"])
	}Else if (_activeController == "softnessInside"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#v:: ;Ctrl+Alt+Win+v - PW Inside Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }

    if !(_activeController == "softnessInside"){
        _getControllerToStartMove("softnessInside", SOFTNESS_INSIDE_PW_POS["posX"], SOFTNESS_INSIDE_PW_POS["posY"])
	}Else if (_activeController == "softnessInside"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#w:: ;Ctrl+Alt+Win+w - PW Outside Increase
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessOutside"){
        _getControllerToStartMove("softnessOutside", SOFTNESS_OUTSIDE_PW_POS["posX"], SOFTNESS_OUTSIDE_PW_POS["posY"])
	}Else if (_activeController == "softnessOutside"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!#x:: ;Ctrl+Alt+Win+x - PW Outside Reduce
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    if !(_activeController == "softnessOutside"){
        _getControllerToStartMove("softnessOutside", SOFTNESS_OUTSIDE_PW_POS["posX"], SOFTNESS_OUTSIDE_PW_POS["posY"])
	}Else if (_activeController == "softnessOutside"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

^!#y:: ;Ctrl+Alt+Win+y - Reset PW
    if !(_activePage == "color"){
        return
    }

    if !(_activePanel == "windows"){
        return
    }
    
    MouseClick left, RESET_PW_POS["posX"], RESET_PW_POS["posY"], 1, 0
return

; == Edit Tab ==
^NumpadSub:: ;Ctrl+NumpadSub - TL Zoom Out
    if !(_activePage == "edit"){
        return
    }
    
	Send, ^{-}
return

^NumpadAdd:: ;Ctrl+NumpadAdd - TL Zoom In
    if !(_activePage == "edit"){
        return
    }

	Send, ^{=}
return

^Insert:: ;Ctrl+Insert - Move Timeline Forward
    if !(_activePage == "edit"){
        return
    }

	MouseGetPos MousePosX, MousePosY
	if(MousePosY != TIMELINE_TIMEBAR_POS["posY"]){
		MouseMove TIMELINE_TIMEBAR_POS["posX"], TIMELINE_TIMEBAR_POS["posY"], 0
	}
    
	Send, {Alt Down}
	MouseClick WheelUp
	Send, {Alt Up}
return

^Del:: ;Ctrl+Del - Move Timeline Backwards
    if !(_activePage == "edit"){
        return
    }

	MouseGetPos MousePosX, MousePosY
	if(MousePosY != TIMELINE_TIMEBAR_POS["posY"]){
		MouseMove TIMELINE_TIMEBAR_POS["posX"], TIMELINE_TIMEBAR_POS["posY"], 0
	}
    
	Send, {Alt Down}
	MouseClick WheelDown
	Send, {Alt Up}
return

; == Select/Open/Close Panels on Edit Tab ==
^Numpad1:: ;Ctrl+Numpad1 - Select Preview Window (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, PREVIEW_WINDOW_POS["posX"], PREVIEW_WINDOW_POS["posY"], 1, 0
return

^Numpad2:: ;Ctrl+Numpad2 - Select Timeline (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, TIMELINE_WINDOW_POS["posX"], TIMELINE_WINDOW_POS["posY"], 1, 0
return

^Numpad3:: ;Ctrl+Numpad3 - Open/Close Media Pool (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, MEDIA_POOL_BUTTON_POS["posX"], MEDIA_POOL_BUTTON_POS["posY"], 1, 0
    Sleep 10
    MouseClick Left, FIRST_CLIP_POOL_POS["posX"], FIRST_CLIP_POOL_POS["posY"], 1, 0
return

^Numpad4:: ;Ctrl+Numpad4 - Open/Close Effects Library (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, EFFECTS_BUTTON_POS["posX"], EFFECTS_BUTTON_POS["posY"], 1, 0
return

^Numpad5:: ;Ctrl+Numpad5 - Open/Close Edit Index (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, INDEX_BUTTON_POS["posX"], INDEX_BUTTON_POS["posY"], 1, 0
return

^Numpad6:: ;Ctrl+Numpad6 - Open/Close Sound Library (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, SOUND_LIB_BUTTON_POS["posX"], SOUND_LIB_BUTTON_POS["posY"], 1, 0
    MouseClick Left, SEARCH_SOUND_POS["posX"], SEARCH_SOUND_POS["posY"], 1, 1
return

^Numpad7:: ;Ctrl+Numpad7 - Open/Close Mixer (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, MIXER_BUTTON_POS["posX"], MIXER_BUTTON_POS["posY"], 1, 0
return

^Numpad8:: ;Ctrl+Numpad8 - Open/Close Metadata (Edit Tab)
    if !(_activePage == "edit"){
        return
    }

	MouseClick Left, METADATA_BUTTON_POS["posX"], METADATA_BUTTON_POS["posY"], 1, 0
return

^Numpad9:: ;Ctrl+Numpad9 - Open/Close Inspector (Edit Tab)
    if !(_activePage == "edit"){
        return
    }
    
    if (_inspectorState == "closed"){
        _inspectorState := "opened"
    }Else{
        _inspectorState := "closed"
    }
    
	MouseClick Left, INSPECTOR_BUTTON_POS["posX"], INSPECTOR_BUTTON_POS["posY"], 1, 0

    sleep 10
    
    if (_fullInspectorState == "closed"){
        _fullInspectorState := "opened"

        MouseClick Left, FULL_INSPECTOR_BUTTON_POS["posX"], FULL_INSPECTOR_BUTTON_POS["posY"], 1, 0                
    }
return

; == Inspector Controls ==
#!w:: ;Win+Alt+w - Inspector Opacity Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorOpacity"){
        _getControllerToStartMove("inspectorOpacity", INSPECTOR_OPACITY_POS["posX"], INSPECTOR_OPACITY_POS["posY"])
	}Else if (_activeController == "inspectorOpacity"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!x:: ;Win+Alt+x - Inspector Opacity Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorOpacity"){
        _getControllerToStartMove("inspectorOpacity", INSPECTOR_OPACITY_POS["posX"], INSPECTOR_OPACITY_POS["posY"])
	}Else if (_activeController == "inspectorOpacity"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!y:: ;Win+Alt+y - Inspector Zoom X Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorZoomX"){
        _getControllerToStartMove("inspectorZoomX", INSPECTOR_ZOOM_X_POS["posX"], INSPECTOR_ZOOM_X_POS["posY"])
	}Else if (_activeController == "inspectorZoomX"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!z:: ;Win+Alt+z - Inspector Zoom X Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorZoomX"){
        _getControllerToStartMove("inspectorZoomX", INSPECTOR_ZOOM_X_POS["posX"], INSPECTOR_ZOOM_X_POS["posY"])
	}Else if (_activeController == "inspectorZoomX"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!Insert:: ;Win+Alt+Insert - Inspector Zoom Y Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorZoomY"){
        _getControllerToStartMove("inspectorZoomY", INSPECTOR_ZOOM_Y_POS["posX"], INSPECTOR_ZOOM_Y_POS["posY"])
	}Else if (_activeController == "inspectorZoomY"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!Delete:: ;Win+Alt+Delete - Inspector Zoom Y Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorZoomY"){
        _getControllerToStartMove("inspectorZoomY", INSPECTOR_ZOOM_Y_POS["posX"], INSPECTOR_ZOOM_Y_POS["posY"])
	}Else if (_activeController == "inspectorZoomY"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!Home:: ;Win+Alt+Home - Inspector Position X Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorPositionX"){
        _getControllerToStartMove("inspectorPositionX", INSPECTOR_POSITION_X_POS["posX"], INSPECTOR_POSITION_X_POS["posY"])
	}Else if (_activeController == "inspectorPositionX"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!End:: ;Win+Alt+End - Inspector Position X Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorPositionX"){
        _getControllerToStartMove("inspectorPositionX", INSPECTOR_POSITION_X_POS["posX"], INSPECTOR_POSITION_X_POS["posY"])
	}Else if (_activeController == "inspectorPositionX"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!PgUp:: ;Win+Alt+PgUp - Inspector Position Y Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorPositionY"){
        _getControllerToStartMove("inspectorPositionY", INSPECTOR_POSITION_Y_POS["posX"], INSPECTOR_POSITION_Y_POS["posY"])
	}Else if (_activeController == "inspectorPositionY"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!PgDn:: ;Win+Alt+PgDn - Inspector Position Y Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorPositionY"){
        _getControllerToStartMove("inspectorPositionY", INSPECTOR_POSITION_Y_POS["posX"], INSPECTOR_POSITION_Y_POS["posY"])
	}Else if (_activeController == "inspectorPositionY"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!F1:: ;Win+Alt+F1 - Inspector Rotation Angle Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorRotation"){
        _getControllerToStartMove("inspectorRotation", INSPECTOR_ROTATION_POS["posX"], INSPECTOR_ROTATION_POS["posY"])
	}Else if (_activeController == "inspectorRotation"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!F2:: ;Win+Alt+F2 - Inspector Rotation Angle Reduce 
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorRotation"){
        _getControllerToStartMove("inspectorRotation", INSPECTOR_ROTATION_POS["posX"], INSPECTOR_ROTATION_POS["posY"])
	}Else if (_activeController == "inspectorRotation"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!F3:: ;Win+Alt+F3 - Inspector Anchor Point X Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorAchorX"){
        _getControllerToStartMove("inspectorAchorX", INSPECTOR_ANCHOR_X_POS["posX"], INSPECTOR_ANCHOR_X_POS["posY"])
	}Else if (_activeController == "inspectorAchorX"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!F5:: ;Win+Alt+F5 - Inspector Anchor Point X Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorAchorX"){
        _getControllerToStartMove("inspectorAchorX", INSPECTOR_ANCHOR_X_POS["posX"], INSPECTOR_ANCHOR_X_POS["posY"])
	}Else if (_activeController == "inspectorAchorX"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!F6:: ;Win+Alt+F6 - Inspector Anchor Point Y Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorAchorY"){
        _getControllerToStartMove("inspectorAchorY", INSPECTOR_ANCHOR_Y_POS["posX"], INSPECTOR_ANCHOR_Y_POS["posY"])
	}Else if (_activeController == "inspectorAchorY"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!F7:: ;Win+Alt+F7 - Inspector Anchor Point Y Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorAchorY"){
        _getControllerToStartMove("inspectorAchorY", INSPECTOR_ANCHOR_Y_POS["posX"], INSPECTOR_ANCHOR_Y_POS["posY"])
	}Else if (_activeController == "inspectorAchorY"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!F8:: ;Win+Alt+F8 - Inspector Pitch Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorPitch"){
        _getControllerToStartMove("inspectorPitch", INSPECTOR_PITCH_POS["posX"], INSPECTOR_PITCH_POS["posY"])
	}Else if (_activeController == "inspectorPitch"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!F9:: ;Win+Alt+F9 - Inspector Pitch Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorPitch"){
        _getControllerToStartMove("inspectorPitch", INSPECTOR_PITCH_POS["posX"], INSPECTOR_PITCH_POS["posY"])
	}Else if (_activeController == "inspectorPitch"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

#!F10:: ;Win+Alt+F10 - Inspector Yaw Increase
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorYaw"){
        _getControllerToStartMove("inspectorYaw", INSPECTOR_YAW_POS["posX"], INSPECTOR_YAW_POS["posY"])
	}Else if (_activeController == "inspectorYaw"){
        _moveMouseOnAxis("X", "plus", 10)
	}
return

#!F11:: ;Win+Alt+F11 - Inspector Yaw Reduce
    if !(_activePage == "edit"){
        return
    }

    if !(_inspectorState == "opened"){
        return
    }
    
    if !(_activeController == "inspectorYaw"){
        _getControllerToStartMove("inspectorYaw", INSPECTOR_YAW_POS["posX"], INSPECTOR_YAW_POS["posY"])
	}Else if (_activeController == "inspectorYaw"){
        _moveMouseOnAxis("X", "minus", 10)
	}
return

^!+F11:: ;Ctrl+Alt+Shift+F11 - Inspector Flip Horizontal
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_FLIP_HORIZONTAL_POS["posX"], INSPECTOR_FLIP_HORIZONTAL_POS["posY"], 1, 0
return

^!+F12:: ;Ctrl+Alt+Shift+F12 - Inspector Flip Vertical
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_FLIP_VERTICAL_POS["posX"], INSPECTOR_FLIP_VERTICAL_POS["posY"], 1, 0
return

^!+Backspace:: ;Ctrl+Alt+Shift+Backspace - Inspector Link/Unlink Zoom
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_ZOOM_LINK_POS["posX"], INSPECTOR_ZOOM_LINK_POS["posY"], 1, 0
return

; == Inspector Add/Remove Keyframes==
^!#z::  ;Ctrl+Alt+Win+z - Inspector Add/Remove Keyframe Opacity
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_OPACITY_KEYFRAME_POS["posX"], INSPECTOR_OPACITY_KEYFRAME_POS["posY"], 1, 0
return

^!#Insert:: ;Ctrl+Alt+Win+Insert - Inspector Add/Remove Keyframe Zoom
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_ZOOM_KEYFRAME_POS["posX"], INSPECTOR_ZOOM_KEYFRAME_POS["posY"], 1, 0
return

^!#Home:: ;Ctrl+Alt+Win+Home - Inspector Add/Remove Keyframe Position
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_POSITION_KEYFRAME_POS["posX"], INSPECTOR_POSITION_KEYFRAME_POS["posY"], 1, 0
return

^!#Delete:: ;Ctrl+Alt+Win+Delete - Inspector Add/Remove Keyframe Rotation
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_ROTATION_KEYFRAME_POS["posX"], INSPECTOR_ROTATION_KEYFRAME_POS["posY"], 1, 0
return

^!#End:: ;Ctrl+Alt+Win+End - Inspector Add/Remove Keyframe Anchor
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_ANCHOR_KEYFRAME_POS["posX"], INSPECTOR_ANCHOR_KEYFRAME_POS["posY"], 1, 0
return 

^!#PgUp:: ;Ctrl+Alt+Win+PgUp - Inspector Add/Remove Keyframe Pitch
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_PITCH_KEYFRAME_POS["posX"], INSPECTOR_PITCH_KEYFRAME_POS["posY"], 1, 0
return

^!#PgDn:: ;Ctrl+Alt+Win+PgDn - Inspector Add/Remove Keyframe Yaw
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, INSPECTOR_YAW_KEYFRAME_POS["posX"], INSPECTOR_YAW_KEYFRAME_POS["posY"], 1, 0
return

; == Inspector Resets ==
#!F12:: ;Win+Alt+F12 - Reset All Basic Transform
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_ALL_BASIC_TRANSFORM_POS["posX"], RESET_ALL_BASIC_TRANSFORM_POS["posY"], 1, 0
return

^!+d:: ;Ctrl+Alt+Shift+d - Reset Inspector Zoom 
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_ZOOM_POS["posX"], RESET_INSPECTOR_ZOOM_POS["posY"], 1, 0
return

^!+m:: ;Ctrl+Alt+Shift+m - Reset Inspector Position 
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_POSITION_POS["posX"], RESET_INSPECTOR_POSITION_POS["posY"], 1, 0
return

^!+n:: ;Ctrl+Alt+Shift+n - Reset Inspector Rotation Angle
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_ROTATION_POS["posX"], RESET_INSPECTOR_ROTATION_POS["posY"], 1, 0
return

^!+s:: ;Ctrl+Alt+Shift+s - Reset Inspector Anchor Point
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_ANCHOR_POS["posX"], RESET_INSPECTOR_ANCHOR_POS["posY"], 1, 0
return

^!+u:: ;Ctrl+Alt+Shift+u - Reset Inspector Pitch
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_PITCH_POS["posX"], RESET_INSPECTOR_PITCH_POS["posY"], 1, 0
return

^!+v:: ;Ctrl+Alt+Shift+v - Reset Inspector Yaw
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_YAW_POS["posX"], RESET_INSPECTOR_YAW_POS["posY"], 1, 0
return

^!+x:: ;Ctrl+Alt+Shift+x - Reset Inspector Flip
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_FLIP_POS["posX"], RESET_INSPECTOR_FLIP_POS["posY"], 1, 0
return

^!+z:: ;Ctrl+Alt+Shift+z - Reset Inspector Opacity
    if !(_activePage == "edit"){
        return
    }
    
    MouseClick Left, RESET_INSPECTOR_OPACITY_POS["posX"], RESET_INSPECTOR_OPACITY_POS["posY"], 1, 0
return

; == Recreating some shortcut to work and test if the control is on the correctly active page to work ==
+1::
    Send +{1}
return

+2::
    if !(_activePage == "media"){
        _activePage := "media"
        Send +{2}
    }
return

+3::
    if !(_activePage == "cut"){
        _activePage := "cut"
        Send +{3}
    }
return

+4::
    if !(_activePage == "edit"){
        _activePage := "edit"
        Send +{4}
    }
return

+5::
    if !(_activePage == "fusion"){
        _activePage := "fusion"
        Send +{5}
    }
return

+6::
    if !(_activePage == "color"){
        _activePage := "color"
        Send +{6}
    }
return

+7::
    if !(_activePage == "fairlight"){
        _activePage := "fairlight"
        Send +{7}
    }
return

+8::
    if !(_activePage == "deliver"){
        _activePage := "deliver"
        Send +{8}
    }
return

+9::
    Send +{9}
return

+0::
    if !(_activePage == "color"){
        _activePage := "color"
        Send +{0}
    }
return

!+Home:: ;DAVINCI SHORTCUT EDITED - Next Node
    if !(_activePage == "color"){
        return
    }Else{
        MouseClick Left, NEUTRAL_PLACE_ON_NODES_PANEL_POS["posX"], NEUTRAL_PLACE_ON_NODES_PANEL_POS["posY"], 1, 0
        
        Send !+{Home}
    }
return

!+End:: ;DAVINCI SHORTCUT EDITED - Previous Node
    if !(_activePage == "color"){
        return
    }Else{
        MouseClick Left, NEUTRAL_PLACE_ON_NODES_PANEL_POS["posX"], NEUTRAL_PLACE_ON_NODES_PANEL_POS["posY"], 1, 0
        
        Send !+{End}
    }
return

+Home:: ;DAVINCI RESERVED - Reset Selected Node
    if !(_activePage == "color"){
        return
    }Else{
        MouseClick Left, NEUTRAL_PLACE_ON_NODES_PANEL_POS["posX"], NEUTRAL_PLACE_ON_NODES_PANEL_POS["posY"], 1, 0
        
        Send +{Home}
    }
return

PgUp:: ;DAVINCI SHORTCUT EDITED - Thumbnail REC MODE A
return

PgDn:: ;DAVINCI SHORTCUT EDITED - Thumbnail SOURCE MODE C
return
#If

;F2 - DEFAULT SHORTCUT TO MAKE TESTS

;return