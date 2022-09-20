;Control Booster for Tangent Panels
;Version: 2.7
;Developer: André Rodrigues - Media Environment
;Website: https://souandrerodrigues.com.br/controlbooster
;Contact: controlbooster@souandrerodrigues.com.br
;You can find video tutorials about how to setup and use all the functions on our website

;- TODO:
;- Add Pan, Semitones and cents control to audio inspector controllers on inspector mode

;Updates of 2.7 version:
;- Added knobs functions on HDR mode to control X and Y in each color wheel. The trackball for this function on this mode can be a little tricky when you need precision, so for small changes you can use the knobs now.
;- Implemented UIAutomation for checking the windows state on Davinci Resolve UI. With this you can close windows with your mouse and Control Booster will open again if necessary to use some tool like in Inspector and Media Pool for example.
;- We still need windows_status.ini to save the information about the Matte Finess status on Qualifier because it doesn't has an AutomationID sadly.

;Updates of 2.6 version:
;- The new name of the software is Control Booster. Since I have plans to create versions of the software for different controllers (and maybe other softwares too). So, each one will call Control Booster for "NAME OF THE CONTROLLER".
;- Big change on the Move Mouse and Drag function. Now when using a knob, jog wheel or trackball and change to another you have to wait the tool be auto released to use the next one. This way you don't mess with the tools when you change too fast or screw things when you miss hit some knob, jog or trackball.
;- For all the modes with trackballs and jog wheels controling the color wheels, the buttons over the jog wheels are now RESET buttons for the respective function of each trackball and jog wheel as in the native original behavior.
;- On Hue Curves every Hue Curves Mode has their input, hue, sat, lum, rotation and etc an controls with different sensitivities and pressing ALT key you use them in precision mode that make them slower.
;- On Hue Curves you have now 3 different sensitivities for the input, hue, sat, lum, rotation and etc. Two on the knobs as said before and 1 intermediary on the first and second Jog Wheel.
;- On HDR Mode you can control HDR Zones with a knob instead buttons for each zone. Just turn the knob and it will toggle between all the zones.
;- On HDR Mode the Max Range and Fallout (from the HDR Zone Panel) are now controled by knobs and not jog wheels anymore. You still having the fallout for each wheel on knobs too.
;- On HDR Mode you can control the exposure of each will using the jog wheels instead knobs. You can reset the exposure using the jog wheel button.

;Updates of 2.5 version:
;- New version of Tangent Wave Hub (still in BETA) made possible send messages to change modes directly from Control Booster. This means that is not necessary test each panel anymore to use a tool which makes the software way faster and less buggy.
;- Now the Mode Selection mode on the Tangent Panel works differently: When you choose a new mode, it not only change the mode in the Tangent Panel, but automatically changes the Page (EDIT or COLOR) and goes to the chosed Panel on the Davinci UI.
;- Added a field to setup the OSC Receive/Listen Port. The listening port will be always the receiving port +1, this was made by Tangent in their Tangent Mapper as default.
;- Added a prompt window on OSC2AHK Port Connection check function, if the port is in use the user will receive an alert about port in use or firewall/anti-virus blocking the port and it has a InputBox so the user can set a new OSC Receive Port.
;- Added a knob on Qualifier Mode to change between HSL and RGB panels. It still changing automatically between panels when you use a tool from HSL or RGB. I added this so you can turn off and on each HSL or RGB channels without have to use a tool to go to that panel.
;- Added the same function for changing between HSL and RGB panels using buttons instead a knob (this was useful for Element Panels).
;- New Color Warper Hue x Sat Mode.
;- New Color Warper Chroma x Lum Mode.
;- New Tracking Mode.
;- New Sizing Mode.
;- Removed the buttons for timeline view options (because the menu is not always in the same position). The functions and listeners (timelineViewOptionsAudioWaveforms, timelineViewOptionsStackedTimelines and timelineViewOptionsSubtitleTracks) still existing in the code but they are not in use anymore.
;- Removed the buttons for cursor/hand on Color Page Modes (because the menu is not always in the same position). The function and listener (colorInterfaceCursorHand) still existing in the code but they are not in use anymore.
;- Implemented all the listeners and functions for all the new modes.
;- Added all the new modes on the Control Booster configuration screen.
;- Reformulated all mappings for Tangent Panels on Tangent Hub with all the new functions and some smaller changes for better user experience.
;- Now Control Booster auto-minimize after start.

;Updates of 2.4 version:
;- Control Booster screen now resize with different DPI/Resolution Scales.
;- Added native support for more resolutions.
;- Implemented a new tool (BETA) to auto-setup the positions of the elements on the screen. Now you only need setup manually just a few things and there's a auto-guided method for this. You don't need goes and back to Control Booster and press the buttons to setup each position.
;- Bug fixed: When you move knobs too slow the field sometimes was selected and the tool stop to working. Now the code keeps the Enter Key pressed when you are moving the knobs and this prevents that behavior/bug.
;- Bug Fixed: When your scopes window are on a second screen or floating instead fixed on the Davinci UI, when you was using the control panel to change the scopes, it wasn't working because it closes the scopes window every time you choose some option. Now it will works fine, you just need check the checkbox on Control Booster to let Control Booster knows that your window is floating.
;- Added a new non-default shortcuts on Davinci keyboard shortcuts:
;- Ctrl + O - Label node name of the selected node.
;- Added a function for label node name the selected node - /labelNode.
;- Some improvements on the loadPositions() function and res_dpi_scale.ini file.
;- Created a combobox so user can choose how his Davinci Resolve UI layout looks like:
;- "NORMAL" is when the Davinci Resolve layout has 3 groups of panels on color page (camera raw, color checker, primaries and etc + Curves, Warper, Qualifier and etc + Keyframes, waveform and info)
;- "CONDENSED" is when the Davinci Resolve layout has 2 groups of panels on color page (camera raw, color checker, primaries and etc + Keyframes, waveform and info)
;- "WIDE"is when the Davinci Resolve is the same of NORMAL but is way wider (when you use big resolutions with smaller windows scale like 100% or 125% normally). In this layout the Qualifier tools doesn't has Matte Finess pages 1 and 2, it has all the Matte Finess tools in the same place.
;- Some changes on the code for the different layouts of Davinci Resolve.
;- Created a combobox so user can choose between 3 types of hashs for different resolutions/scales. If you choose 1 and the custom curves is not working, just choose one of the other hashs (2 or 3) until it work.
;- A new file for Custom Curves Hash (custom_curves_hashs.ini). Now it only has 3 types of hashs and the use don't need add more hashs when creating different types of resolutions/scale. Just need choose on Control Booster between the 3 modes.
;- Some changes on the resolution.ini file.
;- Added the address.ini files with the address of each button on Davinci UI.

;Updates of 2.3 version:
;- Control Booster UI updated.
;- New default positions of some UI elements updated after the Davinci Resolve 17.4 update.
;- Matte Finesse panel, variables and other stuffs changed to the new UI of Davinci Resolve 17.4.
;- 3 new shortcuts on F5, F6 and F7 buttons to toggle on/off the Timeline View Options: Stacked Timeline, Subtitle tracks and Audio Waveforms.
;- New knob on Edit Mode to control Monitoring Volume.
;- New Middle Trackball now navigate between clips on Edit Mode.
;- Wave and Elements Tangent Map updated with the new functions.

;Updates of 2.2.2 version:
;- Added the mapping for the Tangent Element Panel and Element VS App.
;- _toggleTimelineThumbMode function name fixed the missing "e" on "Timeline".
;- Added a new function that can be used to navigate left or right the HDR Wheels using a Knob or Jog Wheel instead pressing buttons.
;- Added 3 new functions to reset custom curves on knobs instead buttons (the buttons functions still existing in case that someone want use it). Did this so I could free 3 slots on buttons and put the new functions for Copy Curves.
;- Added 5 new functions to copy curves.
;- Added 4 new functions to reset each HSL and RGB Qualifier on knobs instead buttons (the buttons functions still existing in case that someone want use it). Did this so I could free 4 slots on buttons and put all the new functions for Qualifier Color Presets.
;- Added 9 new non-default shortcuts on Davinci keyboard shortcuts for Qualifier Color Presets:
;- Ctrl + Shift + Q - Create a Six Vector Blue Qualifier;
;- Ctrl + Shift + E - Create a Six Vector Cyan Qualifier;
;- Ctrl + Shift + Y - Create a Six Vector Green Qualifier;
;- Ctrl + Shift + U - Create a Six Vector Magenta Qualifier;
;- Ctrl + Shift + G - Create a Six Vector Red Qualifier;
;- Ctrl + Shift + J - Create a Six Vector Yellow Qualifier;
;- Ctrl + Shift + K - Create a Chroma Dark Qualifier;
;- Ctrl + Shift + B - Create a Chroma Light Qualifier;
;- Ctrl + Shift + M - Create a Chroma Dark and Light Qualifier;
;- Added 9 new functions for Qualifier Color Presets.

;Updates of 2.2.1 version:
;- Change on Tangent Map on Edit Mode. Some knobs and buttons changed places.
;- Right and left expander changed for Knobs.
;- Trim mode and Dynamic Trim mode changed for buttons.
;- Changed the Delete and Backspace buttons for the buttons on top of the Middle Jog - In all modes you have Backspace on the Left Button of the Middle Jog and Delete on the Right Button of the Middle Jog, except on HDR Mode that the Left Button is to reset Min/Max Range (but you still having Delete option on the Right Button).
;- Changed the Retime functions for two buttons (old Delet and Backspace).
;- All the Edit Interface buttons now are on First Bank pressing the alt key instead the second bank which now has the Insert Clip on Timeline functions buttons.
;- Change on Tangent Map HDR Mode where some reset buttons changed places.
;- Added some functions on Tangent Map for Elements VS extra panel using a tablet.
;- Created a function to check only if it is on edit page without open the inspector.
;- F-Keys now are different on Edit Mode and Color Mode. For Color Mode they keep as before, but on Edit Mode we have new functions from F1 to F7 (F8 and F9 still all modes the same). Now you select tools using the F1 to F4 keys and F5, F6 and F7 are free to be used in the future for more useful tools.

;Updates of 2.2 version:
;- Added the function - _enableDisableAllNodes.
;- Correction on Tangent Mapping, added the jog wheels for the Primaries Bars mode.
;- Donation links updated.
;- Added the possibility of add a behavior on the left and right button over the jog wheels. (thx Javier for the Protokol!)
;- Tangent Map updated. Resets for Min/Max Range and Falloff on HDR Mode was removed because now you can reset pressing the left button on top of the jog wheel.
;- Added copy, paste, cut and paste attributes for all modes on the first jog buttons (Left = Copy / Alt + left = Cut / Right = Paste / Alt + Right = Paste Attributes) - It not works when you on mouse emulation mode.
;- Updated the Tangent Map with these functions above.
;- All Jog Wheels and Trackball functions updated with the new Data == 0 option so you can assign behaviors for the left/right buttons over the Jog Wheels.
;- Updates on UX changing some functions on Inspector Mode of Tangent Map.
;- Updates on UX changing some functions on arrows and F-Keys.
;- Added a function that toggle between Timeline Thumbnail modes Rec Mode A our Source Mode C.
;- Updated the Tangent Map on the HDR Wheels bringing the Turn on/off and Show/Hide buttons for the zones to the third bank buttons, so we can keep the color interface buttons always on second page doesn' matter what color mode you are.

;Updates of 2.1.9 version:
;- A bug that causes strange behavior on inspector window and wrong save state on windows_status.ini was noted and fixed.
;- A bug where use some Matte Finesse didn't change correctly the panel to Qualifier and back for other panels was noted and fixed.
;- Fixed an mistake where some positions was wrong in some resolutions.
;- Fixed the problem where clicking on the first clip on media pool when open the media pool prevents you from navigate through clips. Now it clicks on a empty space on media pool and you can navigate through clips. The position variable for this was changed from pos_first_media_pool_clip to pos_media_pool_empty_space.
;- Minor UX change on EDIT Mode mapping.
;- Functions documentation created.

;Updates of 2.1.8 version:
;- Nodes menu transfered from dots to the actual menu.
;- Added reset buttons for Max/Min Range and Falloff on HDR Panels.
;- QHD100/125 resolution implemented and working.

;Updates of 2.1.7 version:
;- Some minor bugs corrections.
;- Removed the duplicate of Scopes Button from scopes tab.
;- Added the functions for Key Frames on the inspector panel and the mapping for these on the Mapper Software.
;- Some minor corrections of UX on the Mapper Software (edit and inspector).
;- Hashs for all resolutions added

;Updates of 2.1.6 version:
;- Key Panel functions created and working.
;- Motion Effects Panel functions created and working.

;Updates of 2.1.5 version:
;- Qualifier Panel functions created and Working.
;- Qualifier Matte Finesse Panel functions created and Working.
;- Minimize to tray and change icon color when the software is running or paused.
;- Added the _changePageSleepTime that sets a delay to start controling a tool after change the Davinci Page. This should be 0 if your PC is fast. But if your PC takes a while to change from one page to another, you should set this for one or more seconds to prevent bugs. 1 second = 1000.

;Updates of 2.1.4 version:
;- New shortcuts for F-Keys so you can have easy access for important shotcuts on these keys.
;- The nodes functions that where in F-Keys now are in a mode called Nodes and Scopes, that will have all the node shortcuts and selection of the Scopes. Did that because most of the colorists use a fixed node tree so you don't need create nodes all the time like you need all the shortcuts that are in F-Keys now.
;- Added shortcuts for Project Settings, Project Selection and Davinci Settings on Edit Mode.
;- Added Scopes panel control in the same mode of Nodes. Pressing alt key on Nodes and Scopes mode you have the buttons to select what scope you want see and options to turn on/off Display Qualifier Focus and Low Pass Filter.

;Updates of 2.1.3 version:
;- Added Printer Lights Panel.
;- Printer Lights functions created and working.
;- Added fast navigation between clips on Color page using Alt + Middle Jog Wheel (you still can navigate clip by clip using left and right controls below the fourth jog wheel).
;- Added Color Interface functions to control some stuffs like mouse cursor mode, image wipe, split screen, highlight and other stuffs from Color Page. These controllers are in the Buttons Bank 2 of each color control mode except HDR Wheels where it is the third bank.

;Updates of 2.1.2 version:
;- RGB Mixer panel functions created and working.
;- Blur, Sharpen and Mist panel functions created and working.
;- Power Windows panel functions created and working.
;- Added some shortcuts for color mode:
;- Alt + Up - Enable/Disable Selected Nodes - Davinci Resolve Default Shortcut: Ctrl + D
;- Alt + Down - Bypass Color Grading - Davinci Resolve Default Shortcut: Shift + D
;- Alt + F1 - Active Playhead A - Davinci Resolve NON-Default Shortcut: Shift + F1
;- Alt + F2 - Active Playhead B - Davinci Resolve NON-Default Shortcut: Shift + F2
;- Alt + F3 - Active Playhead C - Davinci Resolve NON-Default Shortcut: Shift + F3
;- Alt + F4 - Active Playhead D - Davinci Resolve NON-Default Shortcut: Shift + F4
;- Alt + F5 - Reset Playheads - Davinci Resolve NON-Default Shortcut: Shift + F5
;- Alt + F7 - Ripple Node Changes to Selected Clips - Davinci Resolve NON-Default Shortcut: Shift + F7

;Updates of 2.1.1 version:
;- Reset Davinci layout and put everything in default options.
;- Hue Curves Panels functions created and working.

;Updates of 2.1.0 version:
;- Implementation of the new system for the Custom Curves. Now it's possible identify and navigate trhough all the dots, create more dots and remove dots if you want. You can navigate through the dots using the third Jog Wheel and control them using the third Trackball.
;- For the new Custom Curves system we have a new .ini file called custom_curves_hashs.ini where we gonna save each hash for each type of dot for each resoltion/scale. Each resolution/scale need to have 5 hashs: ALL and Y dots (use the same hash). Red, Green, Blue and the selected dot (use the same hash for any color mode).
;- Curves Panels functions created and working.
;- Added a debug function DisplayArray() that shows all the contento of an array that has var, x, y format.
;- FHD100/125 and UHD100/125 resolutions implemented and working.

;Updates of 2.0.9 version:
;- Log Wheels Panel functions created and working.

;Updates of 2.0.8 version:
;- Primaries Bars Panel functions created and working.
;- In Color mode you can use Alternate + Inch Reverse Key to Reset All Node Grades and Alternate + Inch Forward Key to Reset Node Grade.

;Updates of 2.0.7 version:
;- Primaries Wheels Panel functions created and working.
;- Node navigation using Alternate + Fourth Jog Wheel.
;- Thumbnail navigation using Alternate + First Jog Wheel.
;- Mouse emulation now can be activated using F8 Key (for right trackball) and Alternate + F8 (for left trackball) Key on panel - The circle and dot buttons over the jog wheel are the left and right mouse buttons.
;- In any mode you can use F9 Key on panel to navigate fast through the modes.
;- In any mode you can use Alternate + F9 Key to start/stop Control Booster, so you can go out Davinci Screen without the controller click or move the mouse when you don't want that.
;- In any mode you can use Alternate + Play Key to Redo and Alternate + Reverse Play Key to Undo.
;- In any mode you can use Alternate + Stop Key to save the project.

;Updates of 2.0.6 version:
;- Implementation of auto change page/panel when using any tool.
;- The windows_status.ini can be used to save the latest panels status too, like for example HDR Zone Panel.
;- Save the latest page used and the latest state of the HDR Zone Panel on windows_status.ini.
;- HDR Panel functions created and working.

;Updates of 2.0.5 version:
;- Added stop/restart software button function so you can stop the script when you need pressing F8.
;- Inspector functions created and working.
;- Correction on windows_status.ini: There's no more "buttonName" variable, instead we have now only 2 variables: Var and Status. Var stores the name of the button pressed and status is if it is opened or closed.

;Updates of 2.0.4 version:
;- Reorganized the edit panel on Tagent Mapper with new functions and better UX organization.
;- Save the latest status of each window on edit page on windows_status.ini.
;- Edit Panel control functions created and working.
;- Open/Close windows function added.

;Updates of 2.0.3 version:
;- OSC comunication implemented.

;Updates of 2.0.2 version:
;- UHD150/175/200 resolution implemented and working.
;- Add a button so the user can add as much new resolutions he wants. Click on the button, write the name of the new resolution and hit ok. All the positions of the new resolution will be based on the last resolution. selected and can be changed after be created.

;Updates of 2.0.1 version:
;- New position variables and resolution method. Now we have a external file with all the positions and there's no need to have the variables in the code.

;Updates of 2.0 version:
;- Software all redesigned from start.
;- New OSC controls by Tangent Mapper.
;- New GUI.
;- Revised all the shortcuts and some positions of the controllers on Tangent Mapper.
;- Added support to be used with 2 or more screens setup since they have the same resolution/DPI Scale.

;Instructions about Control Booster:

;To update the softwares with new panel functions:
;1 - Create the new mode and each controller with all the OSC Address on Tangent Mapper
;2 - Create a adress file with the new positions address for normal, condensed and wide UI
;3 - Generate the res_dpi file  with the new positions for each resolution
;4 - Remove the numbers before variable names on the new res_dpi file
;5 - Copy all the new positions for the default res_dpi file
;6 - Create each OSC listener (add and remove listeners) for each new controller on Control Booster.AHK
;7 - Create each function for each listener on Control Booster.AHK

;Tip 1 - When setting a knob intensity on Tangent Mapper, use for the OSC Value format the option Interger and the knob sensitivity at Coarse. For the Min and Max values, use 0 to 5 if you want not too fast repeating. 0 to 6 for a little more. 0 to 10 and 0 to 50 will give you a fast response with a more sensible knob so only use this for things that doesn't matter repeat the same command more than one time. Example: For select all clips, you can repeat the command because doesn't matter, will select all and that's it. So you can use 0 to 50 because will give you a sensible and fast response. Although for delete you don't wanna the delete being pressed a lot of times in a row, so use 0 to 5.

;Tip 2 - When creating a new resolution/dpi scale setup, you have to create the hashs for the dots on curves panels. For this use the FindText class, run it using AHK than:
;2.1 - Open the custom_curves_hash.ini and create a new field with the same name of your resolution/dpi Scale scheme (just copy/paste one that is already in the document and change the name of the resolution inside the []) - Before you continue, check if it's working for your resolution tha same hashs that already exist in the file, you can try copy different resolutions and see if one of them already work for your resolution. If not, than proceed to create your own hashes;
;2.2 - For each type of dot, you have one hash. One for the Dot in ALL/Y modes, one for any dot selected, one for the dot in each color mode RGB. Total of 5 hashs for each resolution. You have to create one of each for your new resolution/dpi scale scheme;
;2.3 - To create each hash, start running the class FindText.ahk;
;2.4 - Click on capture;
;2.5 - Select the dot on the screen (inside the red/blue rectagle);
;2.6 - On the captured image, cut the edges to keep just the dot;
;2.7 - Use COLOR mode to select the gray part of the dot;
;2.8 - Click on the center of the dot image to select the color;
;2.9 - Click on COLOR2TWO Button;
;2.10 - Click on Ok Button;
;2.11 - Copy the on TEXT propertie to the custom_curves_hashs.ini respective hash place;
;2.12 - Repeat the process from 2.4 to 2.11 for each type of dot.

;Tip 3 - When creating a new position variable, remember to add it on res_dpi_scale_variables.ini file too.

;Tip 4 - When using custom curves, every time you turn off the Splines, remember to click on READ ALL DOTS button, otherwise the dots from spline curves will be saved as curves dots.

;Non-default Davinci Resolve shortcuts used (you need assign these shortcuts on your Davinci - You can use the Davinci Resolve Shortcut Map that comes with Control Booster):
;Shift+F1 - Active Playhead A
;Shift+F2 - Active Playhead B
;Shift+F3 - Active Playhead C
;Shift+F4 - Active Playhead D
;Shift+F5 - Reset Playheads
;Shift+F7 - Ripple Node Changes to Selected Clips
;Ctrl + F1 - Reset UI Layout
;Ctrl + F2 - Full Screen Window
;Shift + Y - Next Node
;Shift + U - Previous Node
;Ctrl + Alt + Q - Turn on/off Printer Lights (replace the original shortcut Ctrl + Alt + `)
;Ctrl + Alt + Numpad 4 - Half Printer Light Red -
;Ctrl + Alt + Numpad 7 - Half Printer Light Red +
;Ctrl + Alt + Numpad 5 - Half Printer Light Green -
;Ctrl + Alt + Numpad 8 - Half Printer Light Green +
;Ctrl + Alt + Numpad 6 - Half Printer Light Blue -
;Ctrl + Alt + Numpad 9 - Half Printer Light Blue +
;Ctrl + Alt + Numpad Sub - Half Printer Light Magenta -
;Ctrl + Alt + Numpad 1 - Half Printer Light Magenta +
;Ctrl + Alt + Numpad Mult - Half Printer Light Yellow -
;Ctrl + Alt + Numpad 3 - Half Printer Light Yellow +
;Ctrl + Alt + Numpad Enter - Half Printer Light Master -
;Ctrl + Alt + Numpad Add - Half Printer Light Master +
;Ctrl + H - Apply Grade
;Ctrl + Alt + A - Timeline Thumbnail Record A Mode
;Ctrl + Alt + C - Timeline Thumbnail Source C Mode
;F8 - Insert Clip on Timeline (changed from F9 which doesn't work sometimes for some bug on Davinci Resolve)
;Ctrl + Shift + Q - Create a Six Vector Blue Qualifier;
;Ctrl + Shift + E - Create a Six Vector Cyan Qualifier;
;Ctrl + Shift + Y - Create a Six Vector Green Qualifier;
;Ctrl + Shift + U - Create a Six Vector Magenta Qualifier;
;Ctrl + Shift + G - Create a Six Vector Red Qualifier;
;Ctrl + Shift + J - Create a Six Vector Yellow Qualifier;
;Ctrl + Shift + K - Create a Chroma Dark Qualifier;
;Ctrl + Shift + B - Create a Chroma Light Qualifier;
;Ctrl + Shift + M - Create a Chroma Dark and Light Qualifier.

;Special Thanks:
;To my wife and family (cliché but is obvious that I can't do nothing without them)
;To Tangent for create this amazing panel!
;To Andy Knox because he knows <3
;To Chris Hocking from CommandPost to help me with Control Booster for MAC.
;To all the guys that developed AHK and made my software possible.
;To Ludwig Frühschütz for the incredible OSC2AHK that allows the OSC communication between my software and Tangent Mapper (and other softwares with OSC Support).
;To FeiYue for the amazing class FindText that allows my software to find images on the screen and made possible the use of the tools on Custom Curves panel.
;Javier Perez (who is with me almost since the begin doing tests and helping with ideas)
;To some people from AHK Forum and Facebook group that helped me with some questions that I had when I was learning the language and with some help for the software:
;Joe Glines (The Automator Genius!)
;boiler (AHK Forum)
;mikeyww (AHK Forum)
;Ben Sacherich (AHK Facebook)
;Daniel Oxner (AHK Facebook)
;Jon Rees (AHK Facebook)
;Pierre Chiggles (AHK Facebook)
;To all donators!
;Leon (this guy!)
;Gq Lewis
;Ultra Mobile LLC
;Trevor Wright
;Ernest Savage
;Maira Rocha Tavares
;And to all Control Booster users! You guys rock!

;------------------------------------------------------------------------------------------ Software Code Start -------------------------------------------------------------------------------------------------------

; \/ AHK Setup \/

; #Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Maxmem 256 ;Set the max use of memory by the software
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Gui +LastFound
hWnd := WinExist()
CoordMode, Mouse, Screen

;Includes FindText class. This is a Third Party class that is used to find the dots on custom curves
#Include <FindText>
#Include %A_ScriptDir%\lib\UIA_Interface.ahk

#MaxHotkeysPerInterval, 200

; /\ End of AHK Setup /\

; \/ OSC2AHK Communication \/

;OSC Connection Parameters (default values seted here)
Global _osc_receiving_ip := "127.0.0.1"
Global _osc_listening_ip := "127.0.0.1"
Global _osc_receiving_port := 7002
Global _osc_listening_port := 7003

; OSC datatypes. Just for better readability, you also just could use the numbers
Global oscTypeNone := 1
Global oscTypeInt := 2
Global oscTypeFloat := 4
Global oscTypeString := 8

; /\ OSC2AHK Communication /\

; \/ GLOBAL VARIABLES \/

Global UIAutomation := UIA_Interface()

;Create a variable for the resolution and scale combo box and set the actual PC Resolution and DPIScale - String - Can be: "FHD100/125", "UHD100/125", UHD150/175/200" or any custom resoltuion/dpi scale created by the user.
Global comboboxResolutionScale
Global newResolutionItem
Global _comboboxResolutionItems

;Set the actual Resolution and Scale of the system
Global _resolutionAndScale := "UHD150/175/200"

;Set what Davinci Resolve UI Layout are in use. Can be: "NORMAL", "CONDENSED", "WIDE"
Global _davinciLayoutUI := "NORMAL"

;Define if app is runnig or in stand by
Global _appRunning := true

;Global timers and speeds
Global _releaseTime := -300
Global _releaseTimeForWheels := -500

;This variable set a delay to start using tools after change a page from EDIT to COLOR and vice-versa. So, if your computer is slow, you can set a delay to prevent some bugs like change the page and change the panel without actually change the panel (you change the variable but not the panel itself, so the software will think you are in the panel without be there. This can happen because the software send the command to change the page and after that to change the panel, but if the page change be too slow, you can lose the change panel command).
Global _changePageSleepTime := 0

;Set the active controllers, pages and panels
Global _globalMousePosX := 0
Global _globalMousePosY := 0

;Save ImageSearch Pixel
Global _imageSearchX := 0
Global _imageSearchY := 0

;Set the current panel in used
Global _currentPanel := ""

;Set the last panel used before the actual panel
Global _lastPanel := ""

;Define what position variable will be changed
Global _variableToSet := ""

;Tels the software that you are seting a new position for some element on the screen, so the software will wait for you to press ENTER to set the new position
Global _isSetingVariable := "false"

;Save the last button that was used to set a position. So you can turn on that button again clicking on "Enable Last Button" button
Global _lastButtonUsed

; == Array for the position variables - Set the position of each element on the Davinci Resolve workarea (if your resolution and/or scale doesn't work with any of the presets, you need setup each position manualy using Control Booster tool) ==
Global _positionsArray := []

;Array with all edit tools windows status
Global _editPageWindowsStatus := [] 

;Set the actual Matte Finesse page on Qualifier Panel. Can be: "1" or "2"
Global _actualMatteFinessePage := 1

;Set the actual Matte Finesse page on Qualifier Panel. Can be: "1" (Shrink), "2" (Grow), "3" (Opening) and "4" (Closing)
Global _actualMatteFinesseMode := 1

;Set the actual Temporal Frames on Motion Effects Panel. Can be: "0", "1", "2", "3", "4" and "5"
Global _actualTemporalNRFrames := 0

;Set the actual Temporal Motion Estimation Type on Motion Effects Panel. Can be: "1" (Faster), "2" (Better), "3" (None)
Global _actualTemporalNREstType := 1

;Set the actual Temporal Motion Range on Motion Effects Panel. Can be: "1" (Large), "2" (Medium), "3" (Small)
Global _actualTemporalNRMotionRange := 1

;Set the actual Spatial Mode on Motion Effects Panel. Can be: "1" (Faster), "2" (Better), "3" (Enhanced)
Global _actualSpatialNRMode := 1

;Set the actual Spatial Radius on Motion Effects Panel. Can be: "1" (Small), "2" (Medium), "3" (Large)
Global _actualSpatialNRRadius := 1

;Set the actual Motion Blur Motion Estimation Type on Motion Effects Panel. Can be: "1" (Faster), "2" (Better), "3" (None)
Global _actualMotionBlurEstType := 1

;Set the actual zone selected on HDR Zone Panel. Can be: "0" (Specular), "1" (Highlight), "2" (Light), "3" (Shadow), "4" (Black), "5" (Dark)
Global _actualZoneSelected := 0

;Set the actual Motion Blur Motion Range on Motion Effects Panel. Can be: "1" (Large), "2" (Medium), "3" (Small)
Global _actualMotionBlurMotionRange := 1

;Set the actual Color Space on Color Warper HuexSat Panel. Can be: "1" (HSV), "2" (HSL), "3" (HSY), "4" (HSP), "5" (HSP LOG)
Global _actualColorWarperHueSatColorSpace := 1

;Set the actual Hue Resolution on Color Warper HuexSat Panel. Can be: "1" (6), "2" (8), "3" (12), "4" (16), "5" (24)
Global _actualColorWarperHueSatHueRes := 1

;Set the actual Sat Resolution on Color Warper HuexSat Panel. Can be: "1" (6), "2" (8), "3" (12), "4" (16)
Global _actualColorWarperHueSatSatRes := 1

;Set the actual Color Space on Color Warper ChrxLum Panel. Can be: "1" (HSV), "2" (HSL), "3" (HSY), "4" (HSP), "5" (HSP LOG)
Global _actualColorWarperChrLumColorSpace := 1

;Set the actual Chroma Resolution on Color Warper ChrxLum Panel. Can be: "1" (4), "2" (6), "3" (8), "4" (12), "5" (16), "6" (24)
Global _actualColorWarperChrLumChromaRes := 1

;Set the actual Lum Resolution on Color Warper ChrxLum Panel. Can be: "1" (4), "2" (6), "3" (8), "4" (12), "5" (16), "6" (24)
Global _actualColorWarperChrLumLumRes := 1

;Set what controller are in use with a string name of the object. If is "off" no controller are in use.
Global _activeController := "OFF"

;Array that will contain the actual dots of the working Custom Curves
Global _customCurvesDotsArray := []

;A counter to navigate between the dots on Custom Curves
Global _customCurvesDotCounter := 1

;Set the actual Custom Curve being used
Global _actualCustomCurvesMode := "ALL"

;A variable just to toggle between Timeline Thumbnail modes, doesn't matter the value, will just toggle between the two modes.
Global _actualTimelineThumbnailMode := False

;When moving a dot on Curves panel it turns true so when you release the dot it will search for all dots positions again
Global _movingDot := False

;A variable to suspend some controls when needed. When true the controller will not work until the variable became false again
Global _delay := False

;Save all the hashs text for FindText function that will look for the dots on Custom Curves when using the Normal and Condensed Davinci UI Layout
Global _dotsHashsArray1 := []
Global _dotsHashsArray2 := []
Global _dotsHashsArray3 := []

;A flag variable to know if something is being drag
Global _isDrag := False

;A flag for the actual cursor mode on color page. True for CURSOR and False for HAND
Global _actualNodeCursorMode := True

;A flag for the actual color page zoom preview state (Zoom to fit or zoom to original size)
Global _colorPageZoomPreview := True

;Set if scopes panel is fixed or floating
Global _scopesFixed := 1

;Set if scopes panel is fixed or floating
Global _colorWarperFixed := 1

;Set what curves hashs will be in use. Can be: 1, 2 or 3
Global _actualCurvesHashs := 1

;Save globaly the variable of the GUI element
Global comboboxDavinciLayoutUI

;Save globaly the variable of the GUI element
Global comboboxCurvesHashs

;Save all the listeners being used by Control Booster
Global _listenersArray := []

; /\ END OF GLOBAL VARIABLES /\

; \/ READ AND LOAD EXTERNAL VARIABLES \/

;Read the network_config.ini file to set the IP and Send/Listen OSC Ports
Loop, read, %A_ScriptDir%\network_config.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        startingPos := InStr(A_Loopfield, "=")
        
        if (InStr(A_Loopfield, "listeningIP") != 0){
            _osc_listening_ip := SubStr(A_Loopfield, startingPos + 1)
        }Else if (InStr(A_Loopfield, "listeningPort") != 0){
            _osc_listening_port := SubStr(A_Loopfield, startingPos + 1)
        }Else if (InStr(A_Loopfield, "receivingIP") != 0){
            _osc_receiving_ip := SubStr(A_Loopfield, startingPos + 1)
        }Else if (InStr(A_Loopfield, "receivingPort") != 0){
            _osc_receiving_port := SubStr(A_Loopfield, startingPos + 1)
        }
    }
}

;Read the resolution and scale ini file to set the latest resolution and scale used on the variable _resolutionAndScale and the combobox resolution options
Loop, read, %A_ScriptDir%\resolution.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        startingPos := InStr(A_Loopfield, "=")
        
        if (InStr(A_Loopfield, "lastResScale") != 0){
            _resolutionAndScale := SubStr(A_Loopfield, startingPos + 1)
        }Else if (InStr(A_Loopfield, "davinciLayoutUI") != 0){
            _davinciLayoutUI := SubStr(A_Loopfield, startingPos + 1)
        }Else if (InStr(A_Loopfield, "actualCurvesHashs") != 0){
            _actualCurvesHashs := SubStr(A_Loopfield, startingPos + 1)
        }Else if (InStr(A_Loopfield, "comboboxItems") != 0){
            _comboboxResolutionItems := SubStr(A_Loopfield, startingPos + 1)
        }
    }
}

;Read all the variables from tb_functions.ini and populate _listenersArray
Loop, read, %A_ScriptDir%\cb_osc_address.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        _listenersArray.Push(A_Loopfield)
    }
}

;Start OSC2AHK opening the port 7002 and adding all the event listeners
StartOSC2AHK()

;Call the function to load all windows_status.ini and populate _editPageWindowsStatus array
LoadWindowsStatus()

;Call the function to load all the Text Hashs for the dots hashs arrays
LoadFindTextHashs()

; /\ END OF READ AND LOAD EXTERNAL VARIABLES /\

; \/ START GUI INTERFACE \/

Menu, Tray, Icon, %A_ScriptDir%\images\cb_ready.ico

Gui, -dpiscale

Global screenDPI := % A_ScreenDPI + 0
Global screenWidth := % A_ScreenWidth + 0

if (screenWidth >= 1280 AND screenWidth <= 1920){
    if (screenDPI >= 144){
        Gui Font, s6, Segoe UI
    }Else{
        Gui Font, s7, Segoe UI
    }
}Else if(screenWidth > 1920){
    if (screenDPI >= 144){
        Gui Font, s6, Segoe UI
    }Else{
        Gui Font, s10, Segoe UI
    }
}

Gui Add, Picture, x8 y8 w150 h150, %A_ScriptDir%\images\Logo.png
Gui Add, Text, x1200 y8 w700 h23 +0x200, How to setup manually your own resolution:
Gui Add, Text, x1200 y31 w700 h23, 1 - Click on "Add New Resolution Config" Button and set a name for it
Gui Add, Text, x1200 y54 w700 h23, 2 - Click on the button of the tool that you will change the position
Gui Add, Text, x1200 y77 w700 h23, 3 - Go to your software screen and position the mouse on top of the tool
Gui Add, Text, x1200 y100 w700 h23, 4 - Hit "ENTER" key to save that position - If you think you made a mistake, you can hit "Enable Last Button" and do that tool again
Gui Add, Text, x1200 y123 w700 h23, 5 - Repeat the process for each tool and after do it for all the tools, hit "Save Positions" button
Gui Add, Text, x1200 y146 w700 h23, * Please wait 5 to 10 seconds to do anything else on the software after hit "Save Positions" button
Gui Add, Button, g_start_stop_bt x192 y8 w150 h50, Stop Control Booster
Gui Add, Button, g_save_positions_bt x192 y64 w150 h50, Save Positions
Gui Add, Button, g_enable_last_button x192 y120 w150 h50, Enable Last Button
Gui Add, Button, g_add_combobox_items_input_box x790 y8 w150 h50, Add New Resolution Config
Gui Add, Text, x360 y8 w250 h23, Set Resolution / DPI Scale (in percentage):
Gui Add, ComboBox, g_change_resolution_and_scale vcomboboxResolutionScale x360 y32 w400, %_comboboxResolutionItems%
Gui Add, Text, x360 y64 w250 h23, Set what is your Davinci Resolve Layout:
Gui Add, ComboBox, g_change_davinci_layout_ui vcomboboxDavinciLayoutUI x360 y90 w400, NORMAL|CONDENSED|WIDE
Gui Add, Text, x360 y120 w250 h23, Set a type of curves Hashs:
Gui Add, ComboBox, g_change_curves_hash vcomboboxCurvesHashs x360 y148 w100, 1|2|3
Gui Add, Text, x540 y120 w250 h23, Define Receive/Listen OSC Port:
Gui Add, Edit, g_edit_osc_listen_port voscReceivePort x540 y148 w50 h21
GuiControl,, oscReceivePort, %_osc_receiving_port%
Gui Add, Edit, voscListenPort x600 y148 w50 h21 +Disabled
Gui Add, Button, g_set_osc_port x660 y148 w100 h21, Set OSC Port
Gui Add, CheckBox, g_set_scopes_state vscopesState x790 y90 w403 h23, Check this box if your scopes window is floating
Gui Add, CheckBox, g_set_color_warper_state vcolorWarperState x790 y120 w403 h23, Check this box if your color warper window is floating

Gui Add, Tab3, x8 y176 w1905 h900 Choose1, Edit Page Interface|Inspector Transform|Color Page Interface|Primaries Wheels/Jogs|Bars Jogs|Log Wheels/Jogs|HDR Wheels|Primaries Tools|Primaries YRBG|Bars YRBG|Log RGB|Log Tools|HDR Tools|HDR Controllers|HDR Zone|RGB Mixer|Curves UI|Custom Curves|Hue Curves|Color Warper Hue X Sat|Color Warper Chr X Lum|Qualifier|Qualifier Matte Finess|Power Windows|Tracking|BSM|Key|Motion Effects|Scopes|Sizing Edit|Sizing Input|Sizing Output|Sizing Node|Sizing Reference|Other

Gui Tab, 1
Gui Add, Picture, x480 y608 w950 h40, %A_ScriptDir%\images\Edit Page Top Buttons.png
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_left_expand x352 y604 w120 h50, Left Expand Button
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_media_pool x544 y544 w120 h50, Media Pool
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_effects_library x680 y664 w120 h50, Effects Library
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_edit_index x808 y544 w120 h50, Edit Index
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_sound_library x928 y664 w120 h50, Sound Library
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_mixer x1040 y544 w120 h50, Mixer
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_metadata x1144 y664 w120 h50, Metadata
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_inspector x1256 y544 w120 h50, Inspector
Gui Add, Button, g_set_variable_button vpos_edit_top_bts_right_expand x1440 y604 w120 h50, Right Expand Button

Gui Tab, 2
Gui Add, Picture, x200 y432 w570 h400,  %A_ScriptDir%\images\Inspector Transform Panel.png
Gui Add, Button, g_set_variable_button vpos_inspector_video x200 y368 w150 h50, Video
Gui Add, Button, g_set_variable_button vpos_inspector_transform_on_off x40 y432 w150 h50, Transform On/Off
Gui Add, Button, g_set_variable_button vpos_inspector_horizontal_flip x40 y712 w150 h50, Horizontal Flip
Gui Add, Button, g_set_variable_button vpos_inspector_vertical_flip x40 y784 w150 h50, Vertical Flip
Gui Add, Button, g_set_variable_button vpos_inspector_zoom_x x208 y848 w150 h50, Zoom X
Gui Add, Button, g_set_variable_button vpos_inspector_zoom_y x368 y848 w150 h50, Zoom Y
Gui Add, Button, g_set_variable_button vpos_inspector_position_x x208 y912 w150 h50, Position X
Gui Add, Button, g_set_variable_button vpos_inspector_position_y x368 y912 w150 h50, Position Y
Gui Add, Button, g_set_variable_button vpos_inspector_rotation_angle x456 y976 w150 h50, Rotation Anglers 
Gui Add, Button, g_set_variable_button vpos_inspector_anchor_point_x x536 y848 w150 h50, Anchor Point X
Gui Add, Button, g_set_variable_button vpos_inspector_anchor_point_y x696 y848 w150 h50, Anchor Point Y
Gui Add, Button, g_set_variable_button vpos_inspector_pitch x536 y912 w150 h50, Pitch
Gui Add, Button, g_set_variable_button vpos_inspector_yaw x696 y912 w150 h50, Yaw
Gui Add, Button, g_set_variable_button vpos_inspector_zoom_link x464 y368 w150 h50, Transform Zoom Link
Gui Add, Button, g_set_variable_button vpos_inspector_transform_reset x624 y368 w150 h50, Transform Reset
Gui Add, Button, g_set_variable_button vpos_inspector_zoom_reset x784 y400 w150 h50, Zoom Reset
Gui Add, Button, g_set_variable_button vpos_inspector_position_reset x784 y464 w150 h50, Position Reset
Gui Add, Button, g_set_variable_button vpos_inspector_rotation_angle_reset x784 y528 w150 h50, Rotation Angle Reset
Gui Add, Button, g_set_variable_button vpos_inspector_anchor_point_reset x784 y592 w150 h50, Anchor Point Reset
Gui Add, Button, g_set_variable_button vpos_inspector_pitch_reset x784 y656 w150 h50, Pitch Reset
Gui Add, Button, g_set_variable_button vpos_inspector_yaw_reset x784 y720 w150 h50, Yaw Reset
Gui Add, Button, g_set_variable_button vpos_inspector_flip_reset x784 y784 w150 h50, Flip Reset
Gui Add, Button, g_set_variable_button vpos_inspector_transform_keyframe x1064 y784 w150 h50, Key Frame - Transform
Gui Add, Button, g_set_variable_button vpos_inspector_zoom_keyframe x904 y848 w150 h50, Key Frame - Zoom
Gui Add, Button, g_set_variable_button vpos_inspector_anchor_keyframe x904 y912 w150 h50, Key Frame - Anchor Point
Gui Add, Button, g_set_variable_button vpos_inspector_position_keyframe x1064 y848 w150 h50, Key Frame - Position
Gui Add, Button, g_set_variable_button vpos_inspector_pitch_keyframe x1064 y912 w150 h50, Key Frame - Pitch
Gui Add, Button, g_set_variable_button vpos_inspector_rotation_keyframe x1224 y848 w150 h50, Key Frame - Rotation Angle
Gui Add, Button, g_set_variable_button vpos_inspector_yaw_keyframe x1224 y912 w150 h50, Key Frame - Yaw
Gui Add, Picture, x1152 y432 w570 h170,  %A_ScriptDir%\images\Inspector Audio Panel.png
Gui Add, Button, g_set_variable_button vpos_inspector_audio x1152 y368 w150 h50, Audio
Gui Add, Button, g_set_variable_button vpos_inspector_volume_on_off x992 y504 w150 h50, Volume On/Off
Gui Add, Button, g_set_variable_button vpos_inspector_audio_reset x1576 y368 w150 h50, Audio Reset
Gui Add, Button, g_set_variable_button vpos_inspector_volume_reset x1736 y552 w150 h50, Volume Reset
Gui Add, Button, g_set_variable_button vpos_inspector_volume x1512 y616 w150 h50, Volume
Gui Add, Button, g_set_variable_button vpos_inspector_volume_keyframe x1512 y680 w150 h50, Volume Key Frame

Gui Tab, 3
Gui Add, Picture, x480 y344 w950 h40, %A_ScriptDir%\images\Color Page Top Buttons.png
Gui Add, Button, g_set_variable_button vpos_color_top_bts_gallery x480 y280 w120 h50, Gallery
Gui Add, Button, g_set_variable_button vpos_color_top_bts_luts x576 y400 w120 h50, LUTs
Gui Add, Button, g_set_variable_button vpos_color_top_bts_media_pool x704 y280 w120 h50, Media Pool
Gui Add, Button, g_set_variable_button vpos_color_top_bts_timeline x848 y400 w120 h50, Timeline
Gui Add, Button, g_set_variable_button vpos_color_top_bts_clips x968 y280 w120 h50, Clips
Gui Add, Button, g_set_variable_button vpos_color_top_bts_nodes x1088 y400 w120 h50, Nodes
Gui Add, Button, g_set_variable_button vpos_color_top_bts_open_fx x1192 y280 w120 h50, Open FX
Gui Add, Button, g_set_variable_button vpos_color_top_bts_lightbox x1312 y400 w120 h50, Lightbox
Gui Add, Picture, x480 y856 w950 h130, %A_ScriptDir%\images\Color Panels Buttons.png
Gui Add, Button, g_set_variable_button vpos_color_page_bts_curves x320 y792 w120 h50, Curves
Gui Add, Button, g_set_variable_button vpos_color_page_bts_warper x448 y792 w120 h50, Warper
Gui Add, Button, g_set_variable_button vpos_color_page_bts_qualifier x576 y792 w120 h50, Qualifier
Gui Add, Button, g_set_variable_button vpos_color_page_bts_power_windows x704 y792 w120 h50, Power Windows
Gui Add, Button, g_set_variable_button vpos_color_page_bts_tracking x832 y792 w120 h50, Tracking
Gui Add, Button, g_set_variable_button vpos_color_page_bts_magic_mask x960 y792 w120 h50, Magic Mask
Gui Add, Button, g_set_variable_button vpos_color_page_bts_bsm x1088 y792 w120 h50, BSM
Gui Add, Button, g_set_variable_button vpos_color_page_bts_key x1216 y792 w120 h50, Key
Gui Add, Button, g_set_variable_button vpos_color_page_bts_sizing x1344 y792 w120 h50, Sizing
Gui Add, Button, g_set_variable_button vpos_color_page_bts_3d x1472 y792 w120 h50, 3D
Gui Add, Button, g_set_variable_button vpos_color_page_bts_camera_raw x320 y1000 w120 h50, Camera RAW
Gui Add, Button, g_set_variable_button vpos_color_page_bts_color_checker x448 y1000 w120 h50, Color Checker
Gui Add, Button, g_set_variable_button vpos_color_page_bts_color_wheels x576 y1000 w120 h50, Color Wheels
Gui Add, Button, g_set_variable_button vpos_color_page_bts_hdr_wheels x704 y1000 w120 h50, HDR Wheels
Gui Add, Button, g_set_variable_button vpos_color_page_bts_rgb_mixer x832 y1000 w120 h50, RGB Mixer
Gui Add, Button, g_set_variable_button vpos_color_page_bts_motion_effects x960 y1000 w120 h50, Motion Effects
Gui Add, Button, g_set_variable_button vpos_color_page_bts_key_frame_animation x1216 y1000 w120 h50, Key Frame Animation
Gui Add, Button, g_set_variable_button vpos_color_page_bts_scopes x1344 y1000 w120 h50, Scopes
Gui Add, Button, g_set_variable_button vpos_color_page_bts_information x1472 y1000 w120 h50, Information
Gui Add, Button, g_set_variable_button vpos_color_page_bts_key_frame_expander x1088 y1000 w120 h50, Key Frame Expander
Gui Add, Picture, x448 y568 w100 h65, %A_ScriptDir%\images\Cursor and Hand.png
Gui Add, Picture, x1056 y504 w200 h100, %A_ScriptDir%\images\Nodes Menu 1.png
Gui Add, Picture, x1392 y504 w200 h145, %A_ScriptDir%\images\Nodes Menu 2.png
Gui Add, Button, g_set_variable_button vpos_color_interface_tools_cursor_mode x320 y576 w120 h50, Cursor Mode
Gui Add, Button, g_set_variable_button vpos_color_interface_tools_hand_mode x560 y576 w120 h50, Hand Mode
Gui Add, Button, g_set_variable_button vpos_color_interface_tools_node_mode_menu x928 y504 w120 h50, Nodes Menu
Gui Add, Button, g_set_variable_button vpos_color_interface_tools_node_mode_1 x1264 y504 w120 h50, Nodes Mode 1
Gui Add, Button, g_set_variable_button vpos_color_interface_tools_node_mode_2 x1264 y568 w120 h50, Nodes Mode 2
Gui Add, Button, g_set_variable_button vpos_color_interface_tools_node_mode_3 x1264 y632 w120 h50, Nodes Mode 3
Gui Add, Button, g_set_variable_button vpos_color_interface_tools_node_mode_4 x1264 y696 w120 h50, Nodes Mode 4

Gui Tab, 4
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Wheels Panel.png
Gui Add, Button, g_set_variable_button vpos_primaries_wheels_dot x968 y368 w150 h50, Primaries Wheels Button
Gui Add, Button, g_set_variable_button vpos_primaries_bars_dot x1128 y368 w150 h50, Primaries Bars Button
Gui Add, Button, g_set_variable_button vpos_primaries_log_dot x1288 y368 w150 h50, Primaries Log Button
Gui Add, Button, g_set_variable_button vpos_primaries_first_wheel_reset x528 y848 w150 h50, Primaries Lift Reset
Gui Add, Button, g_set_variable_button vpos_primaries_first_wheel x528 y912 w150 h50, Lift Wheel
Gui Add, Button, g_set_variable_button vpos_primaries_first_jog x528 y976 w150 h50, Lift Jog
Gui Add, Button, g_set_variable_button vpos_primaries_second_wheel_reset x768 y848 w150 h50, Gamma Reset
Gui Add, Button, g_set_variable_button vpos_primaries_second_wheel x768 y912 w150 h50, Gamma Wheel
Gui Add, Button, g_set_variable_button vpos_primaries_second_jog x768 y976 w150 h50, Gamma Jog
Gui Add, Button, g_set_variable_button vpos_primaries_third_wheel_reset x1000 y848 w150 h50, Gain Reset
Gui Add, Button, g_set_variable_button vpos_primaries_third_wheel x1000 y912 w150 h50, Gain Wheel
Gui Add, Button, g_set_variable_button vpos_primaries_third_jog x1000 y976 w150 h50, Gain Jog
Gui Add, Button, g_set_variable_button vpos_primaries_fourth_wheel_reset x1240 y848 w150 h50, Offset Reset
Gui Add, Button, g_set_variable_button vpos_primaries_fourth_wheel x1240 y912 w150 h50, Offset Wheel
Gui Add, Button, g_set_variable_button vpos_primaries_fourth_jog x1240 y976 w150 h50, Offset Jog

Gui Tab, 5
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Bars Panel.png
Gui Add, Button, g_set_variable_button vpos_bars_first_wheel_reset x528 y848 w150 h50, Lift Reset
Gui Add, Button, g_set_variable_button vpos_bars_first_jog x528 y912 w150 h50, Lift Jog
Gui Add, Button, g_set_variable_button vpos_bars_second_wheel_reset x768 y848 w150 h50, Gamma Reset
Gui Add, Button, g_set_variable_button vpos_bars_second_jog x768 y912 w150 h50, Gamma Jog
Gui Add, Button, g_set_variable_button vpos_bars_third_wheel_reset x1000 y848 w150 h50, Gain Reset
Gui Add, Button, g_set_variable_button vpos_bars_third_jog x1000 y912 w150 h50, Gain Jog
Gui Add, Button, g_set_variable_button vpos_bars_fourth_wheel_reset x1240 y848 w150 h50, Offset Reset
Gui Add, Button, g_set_variable_button vpos_bars_fourth_jog x1240 y912 w150 h50, Offset Jog

Gui Tab, 6
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Log Panel.png
Gui Add, Button, g_set_variable_button vpos_log_first_wheel_reset x528 y848 w150 h50, Shadow Reset
Gui Add, Button, g_set_variable_button vpos_log_first_wheel x528 y912 w150 h50, Shadow Wheel
Gui Add, Button, g_set_variable_button vpos_log_first_jog x528 y976 w150 h50, Shadow Jog
Gui Add, Button, g_set_variable_button vpos_log_second_wheel_reset x768 y848 w150 h50, Midtone Reset
Gui Add, Button, g_set_variable_button vpos_log_second_wheel x768 y912 w150 h50, Midtone Wheel
Gui Add, Button, g_set_variable_button vpos_log_second_jog x768 y976 w150 h50, Midtone Jog
Gui Add, Button, g_set_variable_button vpos_log_third_wheel_reset x1000 y848 w150 h50, Highlights Reset
Gui Add, Button, g_set_variable_button vpos_log_third_wheel x1000 y912 w150 h50, Highlights Wheel
Gui Add, Button, g_set_variable_button vpos_log_third_jog x1000 y976 w150 h50, Highlights Jog
Gui Add, Button, g_set_variable_button vpos_log_fourth_wheel_reset x1240 y848 w150 h50, Offset Reset
Gui Add, Button, g_set_variable_button vpos_log_fourth_wheel x1240 y912 w150 h50, Offset Wheel
Gui Add, Button, g_set_variable_button vpos_log_fourth_jog x1240 y976 w150 h50, Offset Jog

Gui Tab, 7
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\HDR Panel.png
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel_reset x528 y848 w150 h50, HDR First Wheel Reset
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel x528 y912 w150 h50, HDR First Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel_reset x768 y848 w150 h50, HDR Second Wheel Reset
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel x768 y912 w150 h50, HDR Second Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel_reset x1000 y848 w150 h50, HDR Third Wheel Reset
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel x1000 y912 w150 h50, HDR Third Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_fourth_wheel_reset x1240 y848 w150 h50, HDR Fourth Wheel Reset
Gui Add, Button, g_set_variable_button vpos_hdr_fourth_wheel x1240 y912 w150 h50, HDR Fourth Wheel

Gui Tab, 8
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Wheels Panel.png
Gui Add, Button, g_set_variable_button vpos_primaries_reset x1448 y432 w150 h50, Primaries Reset
Gui Add, Button, g_set_variable_button vpos_primaries_temp x624 y368 w150 h50, Temperature
Gui Add, Button, g_set_variable_button vpos_primaries_tint x784 y368 w150 h50, Tint
Gui Add, Button, g_set_variable_button vpos_primaries_contrast x944 y368 w150 h50, Contrast
Gui Add, Button, g_set_variable_button vpos_primaries_pivot x1104 y368 w150 h50, Pivot
Gui Add, Button, g_set_variable_button vpos_primaries_middetail x1264 y368 w150 h50, Mid/Detail
Gui Add, Button, g_set_variable_button vpos_primaries_cool_boost x488 y848 w150 h50, Cool Boost
Gui Add, Button, g_set_variable_button vpos_primaries_shadow x648 y848 w150 h50, Shadow
Gui Add, Button, g_set_variable_button vpos_primaries_high_light x808 y848 w150 h50, High Light
Gui Add, Button, g_set_variable_button vpos_primaries_saturation x968 y848 w150 h50, Saturation
Gui Add, Button, g_set_variable_button vpos_primaries_hue x1128 y848 w150 h50, Hue
Gui Add, Button, g_set_variable_button vpos_primaries_lum_mix x1288 y848 w150 h50, Lum Mix

Gui Tab, 9
Gui Add, Picture, x480 y352 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Wheels Panel.png
Gui Add, Button, g_set_variable_button vpos_primaries_auto_balance x320 y352 w150 h50, Auto Balance
Gui Add, Button, g_set_variable_button vpos_primaries_awb_picker x320 y416 w150 h50, AWB Picker
Gui Add, Button, g_set_variable_button vpos_primaries_black_point_picker x488 y288 w150 h50, Black Point Picker
Gui Add, Button, g_set_variable_button vpos_primaries_white_point_picker x920 y288 w150 h50, White Point Picker
Gui Add, Button, g_set_variable_button vpos_primaries_lift_y x528 y768 w150 h50, Lift Y
Gui Add, Button, g_set_variable_button vpos_primaries_lift_r x528 y832 w150 h50, Lift R
Gui Add, Button, g_set_variable_button vpos_primaries_lift_g x528 y896 w150 h50, Lift G
Gui Add, Button, g_set_variable_button vpos_primaries_lift_b x528 y960 w150 h50, Lift B
Gui Add, Button, g_set_variable_button vpos_primaries_gamma_y x776 y768 w150 h50, Gamma Y
Gui Add, Button, g_set_variable_button vpos_primaries_gamma_r x776 y832 w150 h50, Gamma R
Gui Add, Button, g_set_variable_button vpos_primaries_gamma_g x776 y896 w150 h50, Gamma G
Gui Add, Button, g_set_variable_button vpos_primaries_gamma_b x776 y960 w150 h50, Gamma B
Gui Add, Button, g_set_variable_button vpos_primaries_gain_y x1008 y768 w150 h50, Gain Y
Gui Add, Button, g_set_variable_button vpos_primaries_gain_r x1008 y832 w150 h50, Gain R
Gui Add, Button, g_set_variable_button vpos_primaries_gain_g x1008 y896 w150 h50, Gain G
Gui Add, Button, g_set_variable_button vpos_primaries_gain_b x1008 y960 w150 h50, Gain B
Gui Add, Button, g_set_variable_button vpos_primaries_offset_r x1240 y768 w150 h50, Offset R
Gui Add, Button, g_set_variable_button vpos_primaries_offset_g x1240 y832 w150 h50, Offset G
Gui Add, Button, g_set_variable_button vpos_primaries_offset_b x1240 y896 w150 h50, Offset B

Gui Tab, 10
Gui Add, Picture, x480 y352 w956 h406 +0x400000 , %A_ScriptDir%\images\Primaries Bars Panel.png
Gui Add, Button, g_set_variable_button vpos_bars_auto_balance x320 y352 w150 h50, Auto Balance
Gui Add, Button, g_set_variable_button vpos_bars_awb_picker x320 y416 w150 h50, AWB Picker
Gui Add, Button, g_set_variable_button vpos_bars_black_point_picker x488 y288 w150 h50, Black Point Picker
Gui Add, Button, g_set_variable_button vpos_bars_white_point_picker x920 y288 w150 h50, White Point Picker
Gui Add, Button, g_set_variable_button vpos_bars_lift_y x528 y768 w150 h50, Lift Y
Gui Add, Button, g_set_variable_button vpos_bars_lift_r x528 y832 w150 h50, Lift R
Gui Add, Button, g_set_variable_button vpos_bars_lift_g x528 y896 w150 h50, Lift G
Gui Add, Button, g_set_variable_button vpos_bars_lift_b x528 y960 w150 h50, Lift B
Gui Add, Button, g_set_variable_button vpos_bars_gamma_y x776 y768 w150 h50, Gamma Y
Gui Add, Button, g_set_variable_button vpos_bars_gamma_r x776 y832 w150 h50, Gamma R
Gui Add, Button, g_set_variable_button vpos_bars_gamma_g x776 y896 w150 h50, Gamma G
Gui Add, Button, g_set_variable_button vpos_bars_gamma_b x776 y960 w150 h50, Gamma B
Gui Add, Button, g_set_variable_button vpos_bars_gain_y x1008 y768 w150 h50, Gain Y
Gui Add, Button, g_set_variable_button vpos_bars_gain_r x1008 y832 w150 h50, Gain R
Gui Add, Button, g_set_variable_button vpos_bars_gain_g x1008 y896 w150 h50, Gain G
Gui Add, Button, g_set_variable_button vpos_bars_gain_b x1008 y960 w150 h50, Gain B
Gui Add, Button, g_set_variable_button vpos_bars_offset_r x1240 y768 w150 h50, Offset R
Gui Add, Button, g_set_variable_button vpos_bars_offset_g x1240 y832 w150 h50, Offset G
Gui Add, Button, g_set_variable_button vpos_bars_offset_b x1240 y896 w150 h50, Offset B

Gui Tab, 11
Gui Add, Picture, x480 y352 w956 h406 +0x400000 , %A_ScriptDir%\images\Log Panel.png
Gui Add, Button, g_set_variable_button vpos_log_auto_balance x320 y352 w150 h50, Auto Balance
Gui Add, Button, g_set_variable_button vpos_log_awb_picker x320 y416 w150 h50, AWB Picker
Gui Add, Button, g_set_variable_button vpos_log_shadow_r x528 y768 w150 h50, Shadow R
Gui Add, Button, g_set_variable_button vpos_log_shadow_g x528 y832 w150 h50, Shadow G
Gui Add, Button, g_set_variable_button vpos_log_shadow_b x528 y896 w150 h50, Shadow B
Gui Add, Button, g_set_variable_button vpos_log_midtone_r x776 y768 w150 h50, Midtone R
Gui Add, Button, g_set_variable_button vpos_log_midtone_g x776 y832 w150 h50, Midtone G
Gui Add, Button, g_set_variable_button vpos_log_midtone_b x776 y896 w150 h50, Midtone B
Gui Add, Button, g_set_variable_button vpos_log_highlights_r x1008 y768 w150 h50, Highlights R
Gui Add, Button, g_set_variable_button vpos_log_highlights_g x1008 y832 w150 h50, Highlights G
Gui Add, Button, g_set_variable_button vpos_log_highlights_b x1008 y896 w150 h50, Highlights B

Gui Tab, 12
Gui Add, Picture, x480 y432 w956 h406 +0x400000 , %A_ScriptDir%\images\Log Panel.png
Gui Add, Button, g_set_variable_button vpos_log_temperature x480 y368 w150 h50, Temperature
Gui Add, Button, g_set_variable_button vpos_log_tint x640 y368 w150 h50, Tint
Gui Add, Button, g_set_variable_button vpos_log_contrast x800 y368 w150 h50, Contrast
Gui Add, Button, g_set_variable_button vpos_log_pivot x960 y368 w150 h50, Pivot
Gui Add, Button, g_set_variable_button vpos_log_low_range x1120 y368 w150 h50, Low Range
Gui Add, Button, g_set_variable_button vpos_log_high_range x1280 y368 w150 h50, High Range
Gui Add, Button, g_set_variable_button vpos_log_middetail x480 y848 w150 h50, Mid/Det
Gui Add, Button, g_set_variable_button vpos_log_cool_boost x640 y848 w150 h50, Cool Boost
Gui Add, Button, g_set_variable_button vpos_log_shadow x800 y848 w150 h50, Shadow
Gui Add, Button, g_set_variable_button vpos_log_high_light x960 y848 w150 h50, High Light
Gui Add, Button, g_set_variable_button vpos_log_saturation x1120 y848 w150 h50, Saturation
Gui Add, Button, g_set_variable_button vpos_log_hue x1280 y848 w150 h50, Hue

Gui Tab, 13
Gui Add, Picture, x485 y432 w950 h400 +0x400000, %A_ScriptDir%\images\HDR Panel.png
Gui Add, Button, g_set_variable_button vpos_hdr_open_zone x960 y368 w150 h50, Open Zone Panel
Gui Add, Button, g_set_variable_button vpos_hdr_wheels x1120 y368 w150 h50, HDR Wheels Toggle
Gui Add, Button, g_set_variable_button vpos_hdr_zone_toggle x1280 y368 w150 h50, HDR Zone Toggle
Gui Add, Button, g_set_variable_button vpos_hdr_reset_all x1448 y432 w150 h50, HDR Reset All
Gui Add, Button, g_set_variable_button vpos_zone_reset_all x1448 y496 w150 h50, HDR Reset All - When Zone is Open
Gui Add, Button, g_set_variable_button vpos_hdr_temperature x488 y848 w120 h50, Temperature
Gui Add, Button, g_set_variable_button vpos_hdr_tint x624 y848 w120 h50, Tint
Gui Add, Button, g_set_variable_button vpos_hdr_hue x760 y848 w120 h50, Hue
Gui Add, Button, g_set_variable_button vpos_hdr_contrast x896 y848 w120 h50, Contrast
Gui Add, Button, g_set_variable_button vpos_hdr_pivot x1032 y848 w120 h50, Pivot
Gui Add, Button, g_set_variable_button vpos_hdr_md x1168 y848 w120 h50, MD
Gui Add, Button, g_set_variable_button vpos_hdr_black_offset x1304 y848 w120 h50, Black Offset

Gui Tab, 14
Gui Add, Picture, x480 y432 w950 h400 +0x400000, %A_ScriptDir%\images\HDR Panel.png
Gui Add, Button, g_set_variable_button vpos_hdr_wheels_left_arrow x776 y368 w150 h50, HDR Wheels Left
Gui Add, Button, g_set_variable_button vpos_hdr_wheels_right_arrow x984 y368 w150 h50, HDR Wheels Right
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel_hl x320 y512 w150 h50, First Wheel High Light
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel_exp x496 y848 w100 h50, Exp First Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel_sat x608 y848 w100 h50, Sat First Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel_x x496 y912 w100 h50, X First Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel_y x608 y912 w100 h50, Y First Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_first_wheel_falloff x496 y976 w100 h50, Falloff First Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel_hl x320 y576 w150 h50, Second Wheel High Light
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel_exp x736 y848 w100 h50, Exp Second Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel_sat x848 y848 w100 h50, Sat Second Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel_x x736 y912 w100 h50, X Second Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel_y x848 y912 w100 h50, Y Second Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_second_wheel_falloff x736 y976 w100 h50, Falloff Second Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel_hl x320 y640 w150 h50, Third Wheel High Light
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel_exp x968 y848 w100 h50, Exp Third Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel_sat x1080 y848 w100 h50, Sat Third Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel_x x968 y912 w100 h50, X Third Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel_y x1080 y912 w100 h50, Y Third Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_third_wheel_falloff x968 y976 w100 h50, Falloff Third Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_fourth_wheel_exp x1200 y848 w100 h50, Exp Fourth Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_fourth_wheel_sat x1312 y848 w100 h50, Sat Fourth Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_fourth_wheel_x x1200 y912 w100 h50, X Fourth Wheel
Gui Add, Button, g_set_variable_button vpos_hdr_fourth_wheel_y x1312 y912 w100 h50, Y Fourth Wheel

Gui Tab, 15
Gui Add, Picture, x480 y432 w950 h400 +0x400000, %A_ScriptDir%\images\Zones Panel.png
Gui Add, Button, g_set_variable_button vpos_zone_close_zone x1440 y440 w150 h50, Close Zone Panel
Gui Add, Button, g_set_variable_button vpos_zone_reset x1440 y504 w150 h50, HDR Reset (Zone Panel)
Gui Add, Button, g_set_variable_button vpos_zone_max_range x952 y848 w150 h50, Max/Min Range
Gui Add, Button, g_set_variable_button vpos_zone_falloff x1128 y848 w150 h50, Falloff
Gui Add, Button, g_set_variable_button vpos_zone_create_new_zone x560 y848 w150 h50, Create New Zone
Gui Add, Button, g_set_variable_button vpos_zone_show_hide_black x224 y456 w120 h50, Black Show/Hide
Gui Add, Button, g_set_variable_button vpos_zone_on_off_black x96 y456 w120 h50, Black On/Off
Gui Add, Button, g_set_variable_button vpos_zone_black x352 y456 w120 h50, Black
Gui Add, Button, g_set_variable_button vpos_zone_show_hide_dark x224 y520 w120 h50, Dark Show/Hide
Gui Add, Button, g_set_variable_button vpos_zone_on_off_dark x96 y520 w120 h50, Dark On/Off
Gui Add, Button, g_set_variable_button vpos_zone_dark x352 y520 w120 h50, Dark
Gui Add, Button, g_set_variable_button vpos_zone_show_hide_shadow x224 y584 w120 h50, Shadow Show/Hide
Gui Add, Button, g_set_variable_button vpos_zone_on_off_shadow x96 y584 w120 h50, Shadow On/Off
Gui Add, Button, g_set_variable_button vpos_zone_shadow x352 y584 w120 h50, Shadow
Gui Add, Button, g_set_variable_button vpos_zone_show_hide_light x224 y648 w120 h50, Light Show/Hide
Gui Add, Button, g_set_variable_button vpos_zone_on_off_light x96 y648 w120 h50, Light On/Off
Gui Add, Button, g_set_variable_button vpos_zone_light x352 y648 w120 h50, Light
Gui Add, Button, g_set_variable_button vpos_zone_show_hide_highlight x224 y712 w120 h50, Highlight Show/Hide
Gui Add, Button, g_set_variable_button vpos_zone_on_off_highlight x96 y712 w120 h50, Highlight On/Off
Gui Add, Button, g_set_variable_button vpos_zone_highlight x352 y712 w120 h50, Highlight
Gui Add, Button, g_set_variable_button vpos_zone_show_hide_specular x224 y776 w120 h50, Specular Show/Hide
Gui Add, Button, g_set_variable_button vpos_zone_on_off_specular x96 y776 w120 h50, Specular On/Off
Gui Add, Button, g_set_variable_button vpos_zone_specular x352 y776 w120 h50, Specular

Gui Tab, 16
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\RGB Mixer Panel.png
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_red_output_reset x568 y368 w150 h50, Red Output Reset
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_green_output_reset x880 y368 w150 h50, Green Output Reset
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_blue_output_reset x1200 y368 w150 h50, Blue Output Reset
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_reset x1440 y432 w150 h50, RGB Mixer Reset
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_monochrome x1440 y720 w150 h50, Monochrome
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_preserve_luminance x1440 y784 w150 h50, Preserve Luminance
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_red_to_green x320 y656 w150 h50, Red to Green
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_green_to_blue x320 y720 w150 h50, Green to Blue
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_blue_to_red x320 y784 w150 h50, Blue to Red
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_red_output_red x560 y848 w150 h50, Red Output - Red
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_red_output_green x560 y912 w150 h50, Red Output - Green
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_red_output_blue x560 y976 w150 h50, Red Output - Blue
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_green_output_red x880 y848 w150 h50, Green Output - Red
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_green_output_green x880 y912 w150 h50, Green Output - Green
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_green_output_blue x880 y976 w150 h50, Green Output - Blue
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_blue_output_red x1200 y848 w150 h50, Blue Output - Red
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_blue_output_green x1200 y912 w150 h50, Blue Output - Green
Gui Add, Button, g_set_variable_button vpos_rgb_mixer_blue_output_blue x1200 y976 w150 h50, Blue Output - Blue

Gui Tab, 17
Gui Add, Text, x480 y330 w1000 h23 +0x200, * The top left corner and bottom right corner need to be somewhere outside of the graphic rectangle, you don't need be pricise, just somewhere outside of the rectangle
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Curves Panel 1.png
Gui Add, Button, g_set_variable_button vpos_custom_top_left x320 y432 w150 h50, Custom Curves Graphic Top Left Corner
Gui Add, Button, g_set_variable_button vpos_custom_bottom_right x960 y848 w150 h50, Custom Curves Graphic Right Bottom Corner
Gui Add, Button, g_set_variable_button vpos_curves_buttons_custom_dot x480 y368 w120 h50, Custom Button
Gui Add, Button, g_set_variable_button vpos_curves_buttons_huexhue_dot x616 y368 w120 h50, Hue x Hue Button
Gui Add, Button, g_set_variable_button vpos_curves_buttons_huexsat_dot x752 y368 w120 h50, Hue x Sat Button
Gui Add, Button, g_set_variable_button vpos_curves_buttons_huexlum_dot x888 y368 w120 h50, Hue x Lum Button
Gui Add, Button, g_set_variable_button vpos_curves_buttons_satxlum_dot x1296 y368 w120 h50, Sat x Lum Button
Gui Add, Button, g_set_variable_button vpos_curves_buttons_lumxsat_dot x1024 y368 w120 h50, Lum x Sat Button
Gui Add, Button, g_set_variable_button vpos_curves_buttons_satxsat_dot x1160 y368 w120 h50, Sat x Sat Button
Gui Add, Button, g_set_variable_button vpos_curves_buttons_reset x1440 y432 w150 h50, Reset

Gui Tab, 18
Gui Add, Picture, x40 y432 w950 h400, %A_ScriptDir%\images\Curves Panel 2.png
Gui Add, Button, g_set_variable_button vpos_custom_edit_link_on_off x40 y368 w150 h50, Edit Link On/Off
Gui Add, Button, g_set_variable_button vpos_custom_edit_y_on_off x200 y368 w150 h50, Edit Y On/Off
Gui Add, Button, g_set_variable_button vpos_custom_edit_r_on_off x360 y368 w150 h50, Edit R On/Off
Gui Add, Button, g_set_variable_button vpos_custom_edit_g_on_off x520 y368 w150 h50, Edit G On/Off
Gui Add, Button, g_set_variable_button vpos_custom_edit_b_on_off x680 y368 w150 h50, Edit B On/Off
Gui Add, Button, g_set_variable_button vpos_custom_edit_reset x840 y368 w150 h50, Edit Reset
Gui Add, Button, g_set_variable_button vpos_custom_intensity_lum x1000 y464 w150 h50, Intensity Lum
Gui Add, Button, g_set_variable_button vpos_custom_intensity_red x1000 y528 w150 h50, Intensity Red
Gui Add, Button, g_set_variable_button vpos_custom_intensity_green x1000 y592 w150 h50, Intensity Green
Gui Add, Button, g_set_variable_button vpos_custom_intensity_blue x1000 y656 w150 h50, Intensity Blue
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_link x200 y848 w150 h50, Soft Clip Link
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_r x360 y848 w150 h50, Soft Clip R
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_g x520 y848 w150 h50, Soft Clip G
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_b x680 y848 w150 h50, Soft Clip B
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_reset x840 y848 w150 h50, Soft Clip Reset
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_low x680 y912 w150 h50, Soft Clip Low
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_low_smooth x680 y976 w150 h50, Soft Clip Low Smooth
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_high x840 y912 w150 h50, Soft Clip High
Gui Add, Button, g_set_variable_button vpos_custom_soft_clip_high_smooth x840 y976 w150 h50, Soft Clip High Smooth
Gui Add, Button, g_set_variable_button vpos_custom_intensity_lum_reset x1160 y464 w150 h50, Intensity Lum Reset
Gui Add, Button, g_set_variable_button vpos_custom_intensity_red_reset x1160 y528 w150 h50, Intensity Red Reset
Gui Add, Button, g_set_variable_button vpos_custom_intensity_green_reset x1160 y592 w150 h50, Intensity Green Reset
Gui Add, Button, g_set_variable_button vpos_custom_intensity_blue_reset x1160 y656 w150 h50, Intensity Blue Reset
Gui Add, Picture, x1520 y432 w360 h420, %A_ScriptDir%\images\Curves Panel Dots Menu.png
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu x1520 y368 w150 h50, Dots Menu
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu_copy_to_lum x1360 y440 w150 h50, Copy to Lum
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu_copy_to_red x1360 y504 w150 h50, Copy to Red
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu_copy_to_green x1360 y568 w150 h50, Copy to Green
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu_copy_to_blue x1360 y632 w150 h50, Copy to Blue
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu_copy_to_all x1360 y696 w150 h50, Copy to All
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu_editable_splines x1360 y760 w150 h50, Editable Splines
Gui Add, Button, g_set_variable_button vpos_custom_dots_menu_add_default_anchors x1360 y824 w150 h50, Add Default Anchors

Gui Tab, 19
Gui Add, Text, x480 y400 w1000 h23 +0x200, * The top left corner and bottom right corner need to be somewhere outside of the graphic rectangle, you don't need be pricise, just somewhere outside of the rectangle
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Hue Curves Panel.png
Gui Add, Button, g_set_variable_button vpos_hue_curves_top_left x320 y432 w150 h50, Hue Curves Graphic Top Left Corner
Gui Add, Button, g_set_variable_button vpos_hue_curves_spline x320 y784 w150 h50, Spline
Gui Add, Button, g_set_variable_button vpos_hue_curves_red x480 y848 w150 h50, Red
Gui Add, Button, g_set_variable_button vpos_hue_curves_yellow x640 y848 w150 h50, Yellow
Gui Add, Button, g_set_variable_button vpos_hue_curves_green x800 y848 w150 h50, Green
Gui Add, Button, g_set_variable_button vpos_hue_curves_cyan x480 y912 w150 h50, Cyan
Gui Add, Button, g_set_variable_button vpos_hue_curves_blue x640 y912 w150 h50, Blue
Gui Add, Button, g_set_variable_button vpos_hue_curves_magenta x800 y912 w150 h50, Magenta
Gui Add, Button, g_set_variable_button vpos_hue_curves_input_hue x1055 y848 w150 h50, Input Hue
Gui Add, Button, g_set_variable_button vpos_hue_curves_input_hue_satxlum x1055 y912 w150 h50, Input Hue Sat X Lum
Gui Add, Button, g_set_variable_button vpos_hue_curves_output x1255 y848 h50, Output Hue Rotate/Sat/Lum
Gui Add, Button, g_set_variable_button vpos_hue_curves_bottom_right x1440 y784 w150 h50, Hue Curves Graphic Bottom Right Corner

Gui Tab, 20
Gui Add, Picture, x184 y312 w950 h400, %A_ScriptDir%\images\Color Warper Hue x Sat Panel.png
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_dot x752 y248 w120 h50, Color Warper Hue x Sat
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_dot x880 y248 w120 h50, Color Warper Chr x Lum
Gui Add, Button, g_set_variable_button vpos_color_warper_reset_all x1008 y248 w120 h50, Color Warper Reset All
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_select x1144 y320 w120 h50, Select / Deselect
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_draw x1272 y320 w120 h50, Draw
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_pin x1400 y320 w120 h50, Pin / De-pin
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_pull x1528 y320 w120 h50, Pull Points
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_push x1656 y320 w120 h50, Push Points
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_increase_falloff x1144 y384 w120 h50, Increase Fall Off
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_decrease_falloff x1272 y384 w120 h50, Decrease Fall Off
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_invert_selection x1400 y384 w120 h50, Invert Selection
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_convert_to_pin x1528 y384 w120 h50, Convert To Pin
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_pin_column x1144 y448 w120 h50, Pin Column
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_pin_ring x1272 y448 w120 h50, Pin Ring
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_select_all x1400 y448 w120 h50, Select / Deselect All
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_reset_selection x1528 y448 w120 h50, Reset Selection
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_auto_lock x1144 y512 w120 h50, Auto Lock
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_bar x1144 y576 w120 h50, Hue Bar
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_bar x1272 y576 w120 h50, Saturation Bar
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_lum_bar x1400 y576 w120 h50, Luma Bar
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_feather x1144 y640 w120 h50, Smooth Hue
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_reset x1272 y640 w120 h50, Reset Hue
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_feather x1400 y640 w120 h50, Smooth Saturation
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_reset x1528 y640 w120 h50, Reset Saturation
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_lum_reset x1656 y640 w120 h50, Reset Luma
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_resolution x184 y720 w120 h50, Hue Resolution
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_resolution_1 x184 y784 w120 h40, Option 6
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_resolution_2 x184 y832 w120 h40, Option 8
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_resolution_3 x184 y880 w120 h40, Option 12
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_resolution_4 x184 y928 w120 h40, Option 16
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_hue_resolution_5 x184 y976 w120 h40, Option 24
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_resolution x320 y720 w120 h50, Saturation Resolution
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_resolution_1 x320 y784 w120 h40, Option 6
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_resolution_2 x320 y832 w120 h40, Option 8
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_resolution_3 x320 y880 w120 h40, Option 12
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_sat_resolution_4 x320 y928 w120 h40, Option 16
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_color_space x664 y720 w120 h50, Color Space
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_color_space_hsv x664 y784 w120 h40, HSV
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_color_space_hsl x664 y832 w120 h40, HSL
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_color_space_hsy x664 y880 w120 h40, HSY
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_color_space_hsp x664 y928 w120 h40, HSP
Gui Add, Button, g_set_variable_button vpos_color_warper_huexsat_color_space_hsp_log x664 y976 w120 h40, HSP LOG

Gui Tab, 21
Gui Add, Picture, x184 y312 w950 h400, %A_ScriptDir%\images\Color Warper Chroma x Lum Panel.png
Gui Add, Picture, x184 y312 w950 h400, %A_ScriptDir%\images\Color Warper Chroma x Lum Panel.png
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_select x1144 y320 w120 h50, Select / Deselect
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_draw x1272 y320 w120 h50, Draw
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_pin x1400 y320 w120 h50, Pin / De-pin
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_pull x1528 y320 w120 h50, Pull Points
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_push x1656 y320 w120 h50, Push Points
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_increase_falloff x1144 y384 w120 h50, Increase Fall Off
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_decrease_falloff x1272 y384 w120 h50, Decrease Fall Off
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_invert_selection x1400 y384 w120 h50, Invert Selection
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_convert_to_pin x1528 y384 w120 h50, Convert To Pin
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_pin_column x1144 y448 w120 h50, Pin Column
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_pin_ring x1272 y448 w120 h50, Pin Ring
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_select_all x1400 y448 w120 h50, Select / Deselect All
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_reset_selection x1528 y448 w120 h50, Reset Selection
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_auto_lock x1144 y512 w120 h50, Auto Lock
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_bar x1144 y576 w120 h50, Chroma Bar
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_bar x1272 y576 w120 h50, Luma Bar
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_feather x1144 y640 w120 h50, Smoothe Chroma
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_reset x1272 y640 w120 h50, Reset Chroma
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_feather x1400 y640 w120 h50, Smooth Luma
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_reset x1528 y640 w120 h50, Reset Luma
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_resolution x184 y720 w120 h50, Chroma Resolution
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_resolution_pos_color_warper_chrxlum_chroma_resolution_2 x184 y832 w120 h40, Option 6
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_resolution_pos_color_warper_chrxlum_chroma_resolution_3 x184 y880 w120 h40, Option 8
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_resolution_pos_color_warper_chrxlum_chroma_resolution_4 x184 y928 w120 h40, Option 12
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_resolution_pos_color_warper_chrxlum_chroma_resolution_5 x184 y976 w120 h40, Option 16
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_resolution_pos_color_warper_chrxlum_chroma_resolution_6 x184 y1024 w120 h40, Option 24
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_resolution x320 y720 w120 h50, Luma Resolution
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_resolution_2 x320 y832 w120 h40, Option 6
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_resolution_3 x320 y880 w120 h40, Option 8
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_resolution_4 x320 y928 w120 h40, Option 12
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_resolution_5 x320 y976 w120 h40, Option 16
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_color_space x664 y720 w120 h50, Color Space
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_color_space_hsv x664 y784 w120 h40, HSV
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_color_space_hsl x664 y832 w120 h40, HSL
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_color_space_hsy x664 y880 w120 h40, HSY
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_color_space_hsp x664 y928 w120 h40, HSP
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_color_space_hsp_log x664 y976 w120 h40, HSP LOG
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_chroma_resolution_pos_color_warper_chrxlum_chroma_resolution_1 x184 y784 w120 h40, Option 4
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_resolution_1 x320 y784 w120 h40, Option 4
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_lum_resolution_6 x320 y1024 w120 h40, Option 24
Gui Add, Button, g_set_variable_button vpos_color_warper_chrxlum_axis_angle x512 y720 w120 h50, Axis Angle Bar

Gui Tab, 22
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Qualifier Panel.png
Gui Add, Button, g_set_variable_button vpos_qualifier_hsl_dot x1120 y304 w150 h50, Qualifier HSL Button
Gui Add, Button, g_set_variable_button vpos_qualifier_rgb_dot x1280 y304 w150 h50, Qualifier RGB Button
Gui Add, Button, g_set_variable_button vpos_qualifier_reset x1440 y432 w150 h50, Qualifier Reset
Gui Add, Button, g_set_variable_button vpos_qualifier_picker x480 y368 w150 h50, Qualifier Picker
Gui Add, Button, g_set_variable_button vpos_qualifier_picker_substract x640 y368 w150 h50, Qualifier Picker Substract
Gui Add, Button, g_set_variable_button vpos_qualifier_picker_add x800 y368 w150 h50, Qualifier Picker Add
Gui Add, Button, g_set_variable_button vpos_qualifier_feather_substract x960 y368 w150 h50, Qualifier Feather Substract
Gui Add, Button, g_set_variable_button vpos_qualifier_feather_add x1120 y368 w150 h50, Qualifier Feather Add
Gui Add, Button, g_set_variable_button vpos_qualifier_invert x1280 y368 w150 h50, Qualifier Invert
Gui Add, Button, g_set_variable_button vpos_qualifier_hue_on_off x320 y464 w150 h50, Hue On/Off
Gui Add, Button, g_set_variable_button vpos_qualifier_hue_center x480 y848 w150 h50, Hue Center/Red Low
Gui Add, Button, g_set_variable_button vpos_qualifier_hue_width x640 y848 w150 h50, Hue Width/Red High
Gui Add, Button, g_set_variable_button vpos_qualifier_hue_soft x800 y848 w150 h50, Hue Soft/Red Low Soft
Gui Add, Button, g_set_variable_button vpos_qualifier_hue_sym x960 y848 w150 h50, Hue Sym/Red High Soft
Gui Add, Button, g_set_variable_button vpos_qualifier_hue_reset x1120 y848 w150 h50, Hue/Red Reset
Gui Add, Button, g_set_variable_button vpos_qualifier_saturation_on_off x320 y592 w150 h50, Saturation/Green On/Off
Gui Add, Button, g_set_variable_button vpos_qualifier_saturation_low x480 y912 w150 h50, Saturation/Green Low
Gui Add, Button, g_set_variable_button vpos_qualifier_saturation_high x640 y912 w150 h50, Saturation/Green High
Gui Add, Button, g_set_variable_button vpos_qualifier_saturation_low_soft x800 y912 w150 h50, Saturation/Green Low Soft
Gui Add, Button, g_set_variable_button vpos_qualifier_saturation_high_soft x960 y912 w150 h50, Saturation/Green High Soft
Gui Add, Button, g_set_variable_button vpos_qualifier_saturation_reset x1120 y912 w150 h50, Saturation/Green Reset
Gui Add, Button, g_set_variable_button vpos_qualifier_luminance_on_off x320 y712 w150 h50, Luminance/Blue On/Off
Gui Add, Button, g_set_variable_button vpos_qualifier_luminance_low x480 y976 w150 h50, Luminance/Blue Low
Gui Add, Button, g_set_variable_button vpos_qualifier_luminance_high x640 y976 w150 h50, Luminance/Blue High
Gui Add, Button, g_set_variable_button vpos_qualifier_luminance_low_soft x800 y976 w150 h50, Luminance/Blue Low Soft
Gui Add, Button, g_set_variable_button vpos_qualifier_luminance_high_soft x960 y976 w150 h50, Luminance/Blue High Soft
Gui Add, Button, g_set_variable_button vpos_qualifier_luminance_reset x1120 y976 w150 h50, Luminance/Blue Reset

Gui Tab, 23
Gui Add, Picture, x672 y320 w570 h400, %A_ScriptDir%\images\Qualifier Matte Finesse Panel.png
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1 x672 y256 w150 h50, Matte Finesse 1
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2 x1088 y256 w150 h50, Matte Finesse 2
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1_pre_filter x512 y392 w150 h50, Pre-Filter
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1_clean_black x512 y456 w150 h50, Clean Black
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1_clean_white x512 y520 w150 h50, Clean White
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1_black_clip x512 y584 w150 h50, Black Clip
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1_white_clip x512 y648 w150 h50, White Clip
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1_blur_radius x512 y712 w150 h50, Blur Radius
Gui Add, Button, g_set_variable_button vpos_matte_finesse_1_in_out_ratio x512 y776 w150 h50, In/Out Ratio
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_morph_menu x1256 y392 w150 h50, Morph Menu
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_shrink x1256 y456 w150 h50, Shrink
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_grow x1256 y520 w150 h50, Grow
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_opening x1256 y584 w150 h50, Opening
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_closing x1256 y648 w150 h50, Closing
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_morph_radius x1416 y392 w150 h50, Morph Radius
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_denoise x1416 y456 w150 h50, Denoise
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_shadow x1416 y520 w150 h50, Shadow
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_midtone x1416 y584 w150 h50, Midtone
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_highlight x1416 y648 w150 h50, Highlight
Gui Add, Button, g_set_variable_button vpos_matte_finesse_2_post_filter x1416 y712 w150 h50, Post-Filter

Gui Tab, 24
Gui Add, Picture, x480 y320 w950 h400, %A_ScriptDir%\images\Power Windows Panel.png
Gui Add, Button, g_set_variable_button vpos_power_window_add_linear x480 y256 w150 h50, Add Linear
Gui Add, Button, g_set_variable_button vpos_power_window_add_circle x640 y256 w150 h50, Add Circle
Gui Add, Button, g_set_variable_button vpos_power_window_add_polygon x800 y256 w150 h50, Add Polygon
Gui Add, Button, g_set_variable_button vpos_power_window_add_curve x960 y256 w150 h50, Add Curve
Gui Add, Button, g_set_variable_button vpos_power_window_add_gradient x1120 y256 w150 h50, Add Gradient
Gui Add, Button, g_set_variable_button vpos_power_window_delete_power_window x1280 y256 w150 h50, Delete Power Window
Gui Add, Button, g_set_variable_button vpos_power_window_reset x1440 y320 w150 h50, Power Window Reset
Gui Add, Button, g_set_variable_button vpos_power_window_size x784 y736 w150 h50, Size
Gui Add, Button, g_set_variable_button vpos_power_window_aspect x944 y736 w150 h50, Aspect
Gui Add, Button, g_set_variable_button vpos_power_window_pan x784 y800 w150 h50, Pan
Gui Add, Button, g_set_variable_button vpos_power_window_tilt x944 y800 w150 h50, Tilt
Gui Add, Button, g_set_variable_button vpos_power_window_rotate x784 y864 w150 h50, Rotate
Gui Add, Button, g_set_variable_button vpos_power_window_opacity x944 y864 w150 h50, Opacity
Gui Add, Button, g_set_variable_button vpos_power_window_soft_1 x1120 y736 w150 h50, Soft 1
Gui Add, Button, g_set_variable_button vpos_power_window_soft_2 x1280 y736 w150 h50, Soft 2
Gui Add, Button, g_set_variable_button vpos_power_window_soft_3 x1120 y800 w150 h50, Soft 3
Gui Add, Button, g_set_variable_button vpos_power_window_soft_4 x1280 y800 w150 h50, Soft 4
Gui Add, Button, g_set_variable_button vpos_power_window_inside x1120 y864 w150 h50, Inside
Gui Add, Button, g_set_variable_button vpos_power_window_outside x1280 y864 w150 h50, Outside

Gui Tab, 25
Gui Add, Picture, x184 y448 w950 h400, %A_ScriptDir%\images\Tracker Panel.png
Gui Add, Picture, x1344 y440 w400 h340, %A_ScriptDir%\images\Tracker Panel Dots Menu.png
Gui Add, Button, g_set_variable_button vpos_tracking_window x1144 y448 w120 h50, Tracking Window
Gui Add, Button, g_set_variable_button vpos_tracking_fx x1144 y512 w120 h50, Tracking FX
Gui Add, Button, g_set_variable_button vpos_tracking_reset_all x1144 y576 w120 h50, Reset All
Gui Add, Button, g_set_variable_button vpos_tracking_dots_menu x1344 y384 w120 h50, Dots Menu
Gui Add, Button, g_set_variable_button vpos_tracking_show_track x1752 y576 w120 h50, Show Track
Gui Add, Button, g_set_variable_button vpos_tracking_copy_data x1752 y640 w120 h50, Copy Data
Gui Add, Button, g_set_variable_button vpos_tracking_paste_data x1752 y704 w120 h50, Paste Data
Gui Add, Button, g_set_variable_button vpos_tracking_one_frame_reverse x56 y448 w120 h50, One Frame Reverse
Gui Add, Button, g_set_variable_button vpos_tracking_reverse x56 y512 w120 h50, Reverse
Gui Add, Button, g_set_variable_button vpos_tracking_stop x56 y576 w120 h50, Stop
Gui Add, Button, g_set_variable_button vpos_tracking_reverse_forward x56 y640 w120 h50, Reverse / Forward
Gui Add, Button, g_set_variable_button vpos_tracking_forward x56 y704 w120 h50, Forward
Gui Add, Button, g_set_variable_button vpos_tracking_one_frame_forward x56 y768 w120 h50, One Frame Forward
Gui Add, Button, g_set_variable_button vpos_tracking_pan x320 y384 w120 h50, Pan
Gui Add, Button, g_set_variable_button vpos_tracking_tilt x448 y384 w120 h50, Tilt
Gui Add, Button, g_set_variable_button vpos_tracking_zoom x576 y384 w120 h50, Zoom
Gui Add, Button, g_set_variable_button vpos_tracking_rotate x704 y384 w120 h50, Rotate
Gui Add, Button, g_set_variable_button vpos_tracking_3d x832 y384 w120 h50, 3D
Gui Add, Button, g_set_variable_button vpos_tracking_clip x1144 y640 w120 h50, Clip
Gui Add, Button, g_set_variable_button vpos_tracking_frame x1144 y704 w120 h50, Frame
Gui Add, Button, g_set_variable_button vpos_tracking_add_point x184 y856 w120 h50, Add Point
Gui Add, Button, g_set_variable_button vpos_tracking_remove_point x312 y856 w120 h50, Remove Point
Gui Add, Button, g_set_variable_button vpos_tracking_previous_keyframe x760 y856 w120 h50, Previous Keyframe
Gui Add, Button, g_set_variable_button vpos_tracking_add_remove_keyframe x888 y856 w120 h50, Add/Remove Keyframe
Gui Add, Button, g_set_variable_button vpos_tracking_next_keyframe x1016 y856 w120 h50, Next Keyframe

Gui Tab, 26
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\BSM Panel.png
Gui Add, Button, g_set_variable_button vpos_bsm_blur_dot x960 y304 w150 h50, Blur Button
Gui Add, Button, g_set_variable_button vpos_bsm_sharpen_dot x1120 y304 w150 h50, Sharpen Button
Gui Add, Button, g_set_variable_button vpos_bsm_mist_dot x1280 y304 w150 h50, Mist Button
Gui Add, Button, g_set_variable_button vpos_bsm_radius_reset x640 y368 w150 h50, Radius Reset
Gui Add, Button, g_set_variable_button vpos_bsm_reset x1440 y432 w150 h50, Blur/Sharpen/Mist Reset
Gui Add, Button, g_set_variable_button vpos_bsm_scaling_r x1200 y848 w150 h50, Scaling R
Gui Add, Button, g_set_variable_button vpos_bsm_coring_softness x320 y656 w150 h50, Coring Softness
Gui Add, Button, g_set_variable_button vpos_bsm_radius_b x568 y976 w150 h50, Radius B
Gui Add, Button, g_set_variable_button vpos_bsm_radius_link x480 y368 w150 h50, Radius Link
Gui Add, Button, g_set_variable_button vpos_bsm_ratio_reset x960 y368 w150 h50, Ratio Reset
Gui Add, Button, g_set_variable_button vpos_bsm_scaling_g x1200 y912 w150 h50, Scaling G
Gui Add, Button, g_set_variable_button vpos_bsm_scaling_link x1120 y368 w150 h50, Scaling Link
Gui Add, Button, g_set_variable_button vpos_bsm_ratio_g x880 y912 w150 h50, Ratio G
Gui Add, Button, g_set_variable_button vpos_bsm_radius_r x568 y848 w150 h50, Radius R
Gui Add, Button, g_set_variable_button vpos_bsm_scaling_reset x1280 y368 w150 h50, Scaling Reset
Gui Add, Button, g_set_variable_button vpos_bsm_level x320 y720 w150 h50, Level
Gui Add, Button, g_set_variable_button vpos_bsm_mix x320 y784 w150 h50, Mix
Gui Add, Button, g_set_variable_button vpos_bsm_ratio_b x880 y976 w150 h50, Ratio B
Gui Add, Button, g_set_variable_button vpos_bsm_scaling_b x1200 y976 w150 h50, Scaling B
Gui Add, Button, g_set_variable_button vpos_bsm_ratio_link x800 y368 w150 h50, Ratio Link
Gui Add, Button, g_set_variable_button vpos_bsm_radius_g x568 y912 w150 h50, Radius G
Gui Add, Button, g_set_variable_button vpos_bsm_ratio_r x880 y848 w150 h50, Ratio R

Gui Tab, 27
Gui Add, Picture, x480 y320 w950 h400, %A_ScriptDir%\images\Key Panel.png
Gui Add, Button, g_set_variable_button vpos_key_reset x1280 y256 w150 h50, Reset Key
Gui Add, Button, g_set_variable_button vpos_key_input_invert_matte_mask x1440 y320 w150 h50, Input Invert Matte/Mask
Gui Add, Button, g_set_variable_button vpos_key_input_invert_key x1440 y384 w150 h50, Input Invert Key
Gui Add, Button, g_set_variable_button vpos_key_output_invert_key x1440 y496 w150 h50, Output Invert Key
Gui Add, Button, g_set_variable_button vpos_key_qualifier_invert_matte_mask x1440 y584 w150 h50, Qualifier Invert Matte/Mask
Gui Add, Button, g_set_variable_button vpos_key_qualifier_invert_key x1440 y648 w150 h50, Qualifier Invert Key
Gui Add, Button, g_set_variable_button vpos_key_input_gain x1040 y736 w150 h50, Input Gain
Gui Add, Button, g_set_variable_button vpos_key_input_offset x1256 y736 w150 h50, Input Offset
Gui Add, Button, g_set_variable_button vpos_key_input_blur_r x1040 y800 w150 h50, Input Blur R.
Gui Add, Button, g_set_variable_button vpos_key_input_blur_h_v x1256 y800 w150 h50, Input Blur H/V
Gui Add, Button, g_set_variable_button vpos_key_output_gain x1040 y864 w150 h50, Output Gain
Gui Add, Button, g_set_variable_button vpos_key_output_offset x1256 y864 w150 h50, Output Offset
Gui Add, Button, g_set_variable_button vpos_key_qualifier_gain x1040 y928 w150 h50, Qualifier Gain
Gui Add, Button, g_set_variable_button vpos_key_qualifier_offset x1256 y928 w150 h50, Qualifier Offset

Gui Tab, 28
Gui Add, Picture, x480 y432 w950 h400, %A_ScriptDir%\images\Motion Effects Panel.png
Gui Add, Button, g_set_variable_button vpos_motion_effects_reset x1312 y368 w120 h50, Reset Motion Effects
Gui Add, Button, g_set_variable_button vpos_motion_effects_frames x96 y432 w120 h50, Frames
Gui Add, Button, g_set_variable_button vpos_motion_effects_frames_0 x96 y496 w120 h50, Frames - 0
Gui Add, Button, g_set_variable_button vpos_motion_effects_frames_1 x96 y560 w120 h50, Frames - 1
Gui Add, Button, g_set_variable_button vpos_motion_effects_frames_2 x96 y624 w120 h50, Frames - 2
Gui Add, Button, g_set_variable_button vpos_motion_effects_frames_3 x96 y688 w120 h50, Frames - 3
Gui Add, Button, g_set_variable_button vpos_motion_effects_frames_4 x96 y752 w120 h50, Frames - 4
Gui Add, Button, g_set_variable_button vpos_motion_effects_frames_5 x96 y816 w120 h50, Frames - 5
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_mo_est_type x224 y432 w120 h50, Temporal Mo. Est. Type
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_mo_est_type_faster x224 y496 w120 h50, Temporal Mo. Type - Faster
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_mo_est_type_better x224 y560 w120 h50, Temporal Mo. Type - Better
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_mo_est_type_none x224 y624 w120 h50, Temporal Mo. Type - None
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_motion_range x352 y432 w120 h50, Temporal Motion Range
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_motion_range_large x352 y496 w120 h50, Temp. Range - Large
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_motion_range_medium x352 y560 w120 h50, Temp. Range - Medium
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_motion_range_small x352 y624 w120 h50, Temporal Range - Small
Gui Add, Button, g_set_variable_button vpos_motion_effects_reset_temporal_nr x352 y688 w120 h50, Reset Temporal NR
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_luma_chroma_link x352 y752 w120 h50, Temporal Luma/Chroma Link
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_luma x480 y840 w120 h50, Temporal - Luma
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_chroma x480 y904 w120 h50, Temporal - Chroma
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_motion x480 y968 w120 h50, Temporal - Motion
Gui Add, Button, g_set_variable_button vpos_motion_effects_temporal_blend x672 y904 w120 h50, Temporal - Blend
Gui Add, Button, g_set_variable_button vpos_motion_effects_reset_temporal_threshold x672 y840 w120 h50, Reset Temporal Threshold
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_mode x616 y304 w120 h50, Mode
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_mode_faster x744 y304 w120 h50, Mode - Faster
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_mode_better x872 y304 w120 h50, Mode - Better
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_mode_enhanced x1000 y304 w120 h50, Mode - Enhanced
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_radius x616 y368 w120 h50, Radius
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_radius_small x744 y368 w120 h50, Radius - Small
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_radius_medium x872 y368 w120 h50, Radius - Medium
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_radius_large x1000 y368 w120 h50, Radius - Large
Gui Add, Button, g_set_variable_button vpos_motion_effects_reset_spatial_nr x1128 y368 w120 h50, Reset Spatial NR
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_luma x824 y840 w120 h50, Spatial - Luma
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_chroma x824 y904 w120 h50, Spatial - Chroma
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_luma_chroma_link x824 y968 w120 h50, Spatial Luma/Chroma Link
Gui Add, Button, g_set_variable_button vpos_motion_effects_spatial_blend x992 y904 w120 h50, Spatial - Blend
Gui Add, Button, g_set_variable_button vpos_motion_effects_reset_spatial_threshold x992 y840 w120 h50, Reset Spatial Threshold
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_mo_est_type x1440 y464 w120 h50, Blur Mo. Est. Type
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_mo_est_type_faster x1440 y528 w120 h50, Blur - Type - Faster
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_mo_est_type_better x1440 y592 w120 h50, Blur - Type - Better
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_mo_est_type_none x1440 y656 w120 h50, Blur - Type - None
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_motion_range x1568 y464 w120 h50, Blur - Motion Range
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_motion_range_large x1568 y528 w120 h50, Blur - Range - Large
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_motion_range_medium x1568 y592 w120 h50, Blur - Range - Medium
Gui Add, Button, g_set_variable_button vpos_motion_effects_blur_motion_range_small x1568 y656 w120 h50, Blur - Range - Small
Gui Add, Button, g_set_variable_button vpos_motion_effects_motion_blur x1696 y528 w120 h50, Motion Blur
Gui Add, Button, g_set_variable_button vpos_motion_effects_reset_motion_blur x1696 y464 w120 h50, Reset Motion Blur

Gui Tab, 29
Gui Add, Picture, x600 y464 w420 h360, %A_ScriptDir%\images\Scopes.png
Gui Add, Picture, x1032 y576 w370 h240, %A_ScriptDir%\images\Scopes Dots Menu.png
Gui Add, Button, g_set_variable_button vpos_scopes_menu x440 y456 w150 h50, Scopes Menu
Gui Add, Button, g_set_variable_button vpos_scopes_waveform x440 y584 w150 h50, Waveform Option
Gui Add, Button, g_set_variable_button vpos_scopes_parade x440 y520 w150 h50, Parade Option
Gui Add, Button, g_set_variable_button vpos_scopes_vectorscope x440 y648 w150 h50, Vectorscope Option
Gui Add, Button, g_set_variable_button vpos_scopes_histogram x440 y712 w150 h50, Histogram Option
Gui Add, Button, g_set_variable_button vpos_scopes_cie x440 y776 w150 h50, CIE Option
Gui Add, Button, g_set_variable_button vpos_scopes_dots_menu x1032 y512 w150 h50, Dots Menu
Gui Add, Button, g_set_variable_button vpos_scopes_display_focus x1416 y672 w150 h50, Display Qualifier Focus
Gui Add, Button, g_set_variable_button vpos_scopes_low_pass_filter x1416 y736 w150 h50, Low Pass Filter

Gui Tab, 30
Gui Add, Picture, x480 y480 w950 h400, %A_ScriptDir%\images\Sizing Edit.png
Gui Add, Button, g_set_variable_button vpos_sizing_edit x664 y416 w120 h50, Edit Sizing Button
Gui Add, Button, g_set_variable_button vpos_sizing_input x792 y416 w120 h50, Input Sizing Button
Gui Add, Button, g_set_variable_button vpos_sizing_output x920 y416 w120 h50, Output Sizing Button
Gui Add, Button, g_set_variable_button vpos_sizing_node x1048 y416 w120 h50, Node Sizing Button
Gui Add, Button, g_set_variable_button vpos_sizing_reference x1176 y416 w120 h50, Reference Sizing Button
Gui Add, Button, g_set_variable_button vpos_sizing_reset_all x1304 y416 w120 h50, Reset All
Gui Add, Button, g_set_variable_button vpos_sizing_edit_pan x352 y480 w120 h50, Pan
Gui Add, Button, g_set_variable_button vpos_sizing_edit_tilt x352 y544 w120 h50, Tilt
Gui Add, Button, g_set_variable_button vpos_sizing_edit_rotate x352 y608 w120 h50, Rotate
Gui Add, Button, g_set_variable_button vpos_sizing_edit_lens_correction x352 y672 w120 h50, Lens Correction
Gui Add, Button, g_set_variable_button vpos_sizing_edit_distortion x352 y736 w120 h50, Distortion
Gui Add, Button, g_set_variable_button vpos_sizing_edit_link_zoom x816 y888 w120 h50, Link Zoom
Gui Add, Button, g_set_variable_button vpos_sizing_edit_reset_sizing x984 y888 w120 h50, Reset Sizing
Gui Add, Button, g_set_variable_button vpos_sizing_edit_zoom_x x816 y952 w120 h50, Zoom X
Gui Add, Button, g_set_variable_button vpos_sizing_edit_zoom_y x984 y952 w120 h50, Zoom Y
Gui Add, Button, g_set_variable_button vpos_sizing_edit_pitch x816 y1016 w120 h50, Pitch
Gui Add, Button, g_set_variable_button vpos_sizing_edit_yaw x984 y1016 w120 h50, Yaw
Gui Add, Button, g_set_variable_button vpos_sizing_edit_horizontal_flip x816 y1080 w120 h50, Horizontal Flip
Gui Add, Button, g_set_variable_button vpos_sizing_edit_vertical_flip x984 y1080 w120 h50, Vertical Flip
Gui Add, Button, g_set_variable_button vpos_sizing_edit_reset_crop x1440 y480 w120 h50, Reset Cropping
Gui Add, Button, g_set_variable_button vpos_sizing_edit_left x1440 y544 w120 h50, Left
Gui Add, Button, g_set_variable_button vpos_sizing_edit_right x1440 y608 w120 h50, Right
Gui Add, Button, g_set_variable_button vpos_sizing_edit_top x1440 y672 w120 h50, Top
Gui Add, Button, g_set_variable_button vpos_sizing_edit_bottom x1440 y736 w120 h50, Bottom
Gui Add, Button, g_set_variable_button vpos_sizing_edit_softness x1440 y800 w120 h50, Softness

Gui Tab, 31
Gui Add, Picture, x480 y480 w950 h400, %A_ScriptDir%\images\Sizing Input.png
Gui Add, Button, g_set_variable_button vpos_sizing_input_pan x352 y480 w120 h50, Pan
Gui Add, Button, g_set_variable_button vpos_sizing_input_tilt x352 y544 w120 h50, Tilt
Gui Add, Button, g_set_variable_button vpos_sizing_input_zoom x352 y608 w120 h50, Zoom
Gui Add, Button, g_set_variable_button vpos_sizing_input_rotate x352 y672 w120 h50, Rotate
Gui Add, Button, g_set_variable_button vpos_sizing_input_reset_sizing x984 y888 w120 h50, Reset Sizing
Gui Add, Button, g_set_variable_button vpos_sizing_input_width x816 y952 w120 h50, Width
Gui Add, Button, g_set_variable_button vpos_sizing_input_height x984 y952 w120 h50, Height
Gui Add, Button, g_set_variable_button vpos_sizing_input_pitch x816 y1016 w120 h50, Pitch
Gui Add, Button, g_set_variable_button vpos_sizing_input_yaw x984 y1016 w120 h50, Yaw
Gui Add, Button, g_set_variable_button vpos_sizing_input_horizontal_flip x816 y1080 w120 h50, Horizontal Flip
Gui Add, Button, g_set_variable_button vpos_sizing_input_vertical_flip x984 y1080 w120 h50, Vertical Flip
Gui Add, Button, g_set_variable_button vpos_sizing_input_reset_blanking x1440 y512 w120 h50, Reset Blanking
Gui Add, Button, g_set_variable_button vpos_sizing_input_top x1440 y576 w120 h50, Top
Gui Add, Button, g_set_variable_button vpos_sizing_input_right x1440 y640 w120 h50, Right
Gui Add, Button, g_set_variable_button vpos_sizing_input_bottom x1440 y704 w120 h50, Bottom
Gui Add, Button, g_set_variable_button vpos_sizing_input_left x1440 y768 w120 h50, Left
Gui Add, Button, g_set_variable_button vpos_sizing_input_somooth x1440 y832 w120 h50, Smooth

Gui Tab, 32
Gui Add, Picture, x480 y480 w950 h400, %A_ScriptDir%\images\Sizing Output.png
Gui Add, Button, g_set_variable_button vpos_sizing_output_pan x352 y480 w120 h50, Pan
Gui Add, Button, g_set_variable_button vpos_sizing_output_tilt x352 y544 w120 h50, Tilt
Gui Add, Button, g_set_variable_button vpos_sizing_output_zoom x352 y608 w120 h50, Zoom
Gui Add, Button, g_set_variable_button vpos_sizing_output_rotate x352 y672 w120 h50, Rotate
Gui Add, Button, g_set_variable_button vpos_sizing_output_reset_sizing x984 y888 w120 h50, Reset Sizing
Gui Add, Button, g_set_variable_button vpos_sizing_output_width x816 y952 w120 h50, Width
Gui Add, Button, g_set_variable_button vpos_sizing_output_height x984 y952 w120 h50, Height
Gui Add, Button, g_set_variable_button vpos_sizing_output_pitch x816 y1016 w120 h50, Pitch
Gui Add, Button, g_set_variable_button vpos_sizing_output_yaw x984 y1016 w120 h50, Yaw
Gui Add, Button, g_set_variable_button vpos_sizing_output_horizontal_flip x816 y1080 w120 h50, Horizontal Flip
Gui Add, Button, g_set_variable_button vpos_sizing_output_vertical_flip x984 y1080 w120 h50, Vertical Flip
Gui Add, Button, g_set_variable_button vpos_sizing_output_reset_blanking x1440 y512 w120 h50, Reset Blanking
Gui Add, Button, g_set_variable_button vpos_sizing_output_top x1440 y576 w120 h50, Top
Gui Add, Button, g_set_variable_button vpos_sizing_output_right x1440 y640 w120 h50, Right
Gui Add, Button, g_set_variable_button vpos_sizing_output_bottom x1440 y704 w120 h50, Bottom
Gui Add, Button, g_set_variable_button vpos_sizing_output_left x1440 y768 w120 h50, Left
Gui Add, Button, g_set_variable_button vpos_sizing_output_somooth x1440 y832 w120 h50, Smooth

Gui Tab, 33
Gui Add, Picture, x480 y480 w950 h400, %A_ScriptDir%\images\Sizing Input.png
Gui Add, Button, g_set_variable_button vpos_sizing_node_pan x352 y480 w120 h50, Pan
Gui Add, Button, g_set_variable_button vpos_sizing_node_tilt x352 y544 w120 h50, Tilt
Gui Add, Button, g_set_variable_button vpos_sizing_node_zoom x352 y608 w120 h50, Zoom
Gui Add, Button, g_set_variable_button vpos_sizing_node_rotate x352 y672 w120 h50, Rotate
Gui Add, Button, g_set_variable_button vpos_sizing_node_key_lock x352 y736 w120 h50, Key Lock
Gui Add, Button, g_set_variable_button vpos_sizing_node_reset_sizing x984 y888 w120 h50, Reset Sizing
Gui Add, Button, g_set_variable_button vpos_sizing_node_width x816 y952 w120 h50, Width
Gui Add, Button, g_set_variable_button vpos_sizing_node_height x984 y952 w120 h50, Height
Gui Add, Button, g_set_variable_button vpos_sizing_node_pitch x816 y1016 w120 h50, Pitch
Gui Add, Button, g_set_variable_button vpos_sizing_node_yaw x984 y1016 w120 h50, Yaw
Gui Add, Button, g_set_variable_button vpos_sizing_node_horizontal_flip x816 y1080 w120 h50, Horizontal Flip
Gui Add, Button, g_set_variable_button vpos_sizing_node_vertical_flip x984 y1080 w120 h50, Vertical Flip
Gui Add, Button, g_set_variable_button vpos_sizing_node_reset_blanking x1440 y512 w120 h50, Reset Blanking
Gui Add, Button, g_set_variable_button vpos_sizing_node_top x1440 y576 w120 h50, Top
Gui Add, Button, g_set_variable_button vpos_sizing_node_right x1440 y640 w120 h50, Right
Gui Add, Button, g_set_variable_button vpos_sizing_node_bottom x1440 y704 w120 h50, Bottom
Gui Add, Button, g_set_variable_button vpos_sizing_node_left x1440 y768 w120 h50, Left
Gui Add, Button, g_set_variable_button vpos_sizing_node_somooth x1440 y832 w120 h50, Smooth

Gui Tab, 34
Gui Add, Picture, x480 y480 w950 h400, %A_ScriptDir%\images\Sizing Input.png
Gui Add, Button, g_set_variable_button vpos_sizing_reference_pan x352 y480 w120 h50, Pan
Gui Add, Button, g_set_variable_button vpos_sizing_reference_tilt x352 y544 w120 h50, Tilt
Gui Add, Button, g_set_variable_button vpos_sizing_reference_zoom x352 y608 w120 h50, Zoom
Gui Add, Button, g_set_variable_button vpos_sizing_reference_rotate x352 y672 w120 h50, Rotate
Gui Add, Button, g_set_variable_button vpos_sizing_reference_reset_sizing x984 y888 w120 h50, Reset Sizing
Gui Add, Button, g_set_variable_button vpos_sizing_reference_width x816 y952 w120 h50, Width
Gui Add, Button, g_set_variable_button vpos_sizing_reference_height x984 y952 w120 h50, Height
Gui Add, Button, g_set_variable_button vpos_sizing_reference_pitch x816 y1016 w120 h50, Pitch
Gui Add, Button, g_set_variable_button vpos_sizing_reference_yaw x984 y1016 w120 h50, Yaw
Gui Add, Button, g_set_variable_button vpos_sizing_reference_horizontal_flip x816 y1080 w120 h50, Horizontal Flip
Gui Add, Button, g_set_variable_button vpos_sizing_reference_vertical_flip x984 y1080 w120 h50, Vertical Flip
Gui Add, Button, g_set_variable_button vpos_sizing_reference_reset_blanking x1440 y512 w120 h50, Reset Blanking
Gui Add, Button, g_set_variable_button vpos_sizing_reference_top x1440 y576 w120 h50, Top
Gui Add, Button, g_set_variable_button vpos_sizing_reference_right x1440 y640 w120 h50, Right
Gui Add, Button, g_set_variable_button vpos_sizing_reference_bottom x1440 y704 w120 h50, Bottom
Gui Add, Button, g_set_variable_button vpos_sizing_reference_left x1440 y768 w120 h50, Left
Gui Add, Button, g_set_variable_button vpos_sizing_reference_somooth x1440 y832 w120 h50, Smooth

Gui Tab, 35
Gui Add, Picture, x40 y312 w950 h51, %A_ScriptDir%\images\Timeline Time Bar.png
Gui Add, Picture, x40 y472 w529 h185, %A_ScriptDir%\images\Empty Space on Media Pool.png
Gui Add, Picture, x1352 y312 w529 h185, %A_ScriptDir%\images\Color Page Thumbnails.png
Gui Add, Picture, x40 y768 w250 h80, %A_ScriptDir%\images\Monitoring Volume.png
Gui Add, Picture, x616 y472 w440 h220, %A_ScriptDir%\images\Timeline View Options.png
Gui Add, Button, g_set_variable_button vpos_timeline_time_bar x40 y250 w150 h50, Timeline Time Bar
Gui Add, Button, g_set_variable_button vpos_media_pool_empty_space x40 y408 w150 h50, Media Pool Empty Space
Gui Add, Button, g_set_variable_button vpos_color_page_thumbnails x1352 y248 w150 h50, Color Page Thumbnails
Gui Add, Button, g_set_variable_button vpos_edit_monitoring_volume_button x40 y704 w150 h50, Monitoring Volume Button
Gui Add, Button, g_set_variable_button vpos_edit_monitoring_volume_bar x200 y704 w150 h50, Monitoring Volume Bar
Gui Add, Button, g_set_variable_button vpos_timeline_view_options x768 y408 w150 h50, Timeline View Options
Gui Add, Button, g_set_variable_button vpos_timeline_view_options_stacked_timelines x600 y704 w150 h50, Stacked Timelines
Gui Add, Button, g_set_variable_button vpos_timeline_view_options_subtitle_tracks x768 y704 w150 h50, Subtitle Tracks
Gui Add, Button, g_set_variable_button vpos_timeline_view_options_audio_waveforms x936 y704 w150 h50, Audio Waveforms

Gui Tab

;Gui Show, % "w" . A_ScreenWidth-100 . " h" . A_ScreenHeight-100, Control Booster for Tangent Panels - 2.7
Gui Show, % "w" . 1920 . " h" . 1080, Control Booster for Tangent Panels - 2.7

if (_scopesFixed == 1){
    GuiControl,, scopesState, 1
}

if (_colorWarperFixed == 1){
    GuiControl,, colorWarperState, 1
}

WinMinimize Control Booster for Tangent Panels - 2.7
WinMinimize Tangent Mapper

; \/ APP START \/

;Start load all positions and populate _positionArra(x) (this function NEED to be called inside the GUI construction at the end of it)
LoadPositions()

; /\ END APP START /\

Return

GuiClose:
    ExitApp

; /\ END OF GUI INTERFACE /\

#If (_appRunning) ;Turn on and off all the other functions of the app, making it stop if you need. Shortcut to turn on/off is F8

; \/ FUNCTIONS \/

;Start the OSC2AHK
StartOSC2AHK(){
    ;Load OSC2AHK DLL
    DllCall("LoadLibrary", "Str", "osc2ahk.dll", "Ptr")

    ;Open OSC2AHK Port
    hWnd := WinExist()
    success := DllCall("osc2ahk.dll\open", UInt, hWnd, UInt, _osc_receiving_port)
    if (success != 0){
        InputBox, newOscReceivePort, OSC Receive Port %_osc_receiving_port% Error, Failed to open port for OSC2AHK.DLL!`n`nPlease check if the port %_osc_receiving_port% is in use or if your firewall and/or your anti-virus is blocking the port or the OSC2AHK.dll and Control Booster.exe.`n`nYou can add an exception to your firewall and/or anti-virus for the Control Booster.exe and the OSC2AHK.dll.`n`nYou can also set a new OSC Receive Port below and hit OK:,, 500, 280
        if ErrorLevel
            ExitApp
        else
            _set_new_osc_port(newOscReceivePort)
            Reload
    }Else{
        msgbox, Control Booster for Tangent Panels is ready to be used!
    }
    
    ;Add a exclusive listener for Start/Stop the Control Booster that will never be removed
    DllCall("OSC2AHK.dll\addListener", AStr, "/startStop", UInt, 0x5000, UInt, oscTypeInt)
    OnMessage(0x5000, "_startStop")
    
    ;Call function to add OSC2AHK Listeners
    Osc2ahkAddOrRemoveListeners()
}

;Add or remove OSC2AHK Listeners - OSC2AHK Listerners
Osc2ahkAddOrRemoveListeners(addOrRemove := "add"){
    if (addOrRemove == "add"){
        counter := 1000
    
        For index, address in _listenersArray
        {
            oscAddress := "/" . address
            functionName := "_" . address
            listenerID := "0x" . counter
            
            DllCall("OSC2AHK.dll\addListener", AStr, oscAddress, UInt, listenerID, UInt, oscTypeInt)
            OnMessage(listenerID, functionName)
            
            counter++
        }
    
        ;TEMPORARY LISTENER FOR TEST OSC SEND/RECEIVE MESSAGES
        ;DllCall("OSC2AHK.dll\addListener", AStr, "/testReceivingOSCMessage", UInt, 0x3000, UInt, oscTypeInt)
        ;OnMessage(0x3000, "_testReceivingOSCMessage")

        ;DllCall("OSC2AHK.dll\addListener", AStr, "/testSendStringOSC", UInt, 0x3001, UInt, oscTypeString)
        ;OnMessage(0x3001, "_testSendStringOSC")
        
        ;DllCall("OSC2AHK.dll\addListener", AStr, "/testSendIntOSC", UInt, 0x3002, UInt, oscTypeString)
        ;OnMessage(0x3002, "_testSendIntOSC")
        
        ;DllCall("OSC2AHK.dll\addListener", AStr, "/testSendFloatOSC", UInt, 0x3003, UInt, oscTypeString)
        ;OnMessage(0x3003, "_testSendFloatOSC")
    }Else{
        counter := 1000
        
        For index, address in _listenersArray
        {
            oscAddress := "/" . address
            functionName := "_" . address
            listenerID := "0x" . counter
            
            DllCall("OSC2AHK.dll\removeListener", AStr, oscAddress, UInt, listenerID, UInt, oscTypeInt)
            OnMessage(listenerID, functionName)
            
            counter++
        }
    }
}

;===== Load and save positions functions =====

;Load the positions of each element on the screen from a external file (depends of what resolution / dpi scale is seted)
LoadPositions(){
    ;Set the Combo Box Resolution/Scale for the latest Resolution/Scale used
    GuiControl, Text, comboboxResolutionScale, %_resolutionAndScale%

    ;Set the Combo Box Davinci Layout UI for the latest choosed
    GuiControl, Text, comboboxDavinciLayoutUI, %_davinciLayoutUI%

    ;Set the Combo Box Actual Curves Hashs for the latest choosed
    GuiControl, Text, comboboxCurvesHashs, %_actualCurvesHashs%
    
    ;Reset _positionsArray
    _positionsArray := []

    ;Set a counter from 1 to 3 so loop knows if it is Var (1), X(2), Y(3)
    counter := 1

    ;Set a counter for the Array Position
    arrayPos := 1
    
    ;The actual array being populated
    actualArray := 1
    
    ;Loop through res_dpi_scale.ini file to populate the _positionArray(x) arrays
    Loop, read, %A_ScriptDir%\res_dpi_scale.ini
    {
        Loop, parse, A_LoopReadLine, %A_Tab%
        {
            if (InStr(A_Loopfield, _resolutionAndScale) == 0){
                continue
            }
            
            if (InStr(A_Loopfield, "[") == 1){
                continue
            }
            
            resolutionFound := True
            
            startingPos := InStr(A_Loopfield, "=")
                    
            switch (counter){
                Case 1:
                    object := []

                    _positionsArray.Push(object)
                    
                    _positionsArray[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)
                    
                    counter++
                continue
                Case 2:
                    _positionsArray[arrayPos].x := SubStr(A_Loopfield, startingPos + 1)

                    counter++
                continue
                Case 3:
                    _positionsArray[arrayPos].y := SubStr(A_Loopfield, startingPos + 1)
                    
                    counter := 1
                    arrayPos++
                continue
            }
        }
    }
            
    ;Remove the coment to display all the content of the _positionsArray
    ;DisplayArray("Positions Array 1", _positionsArray)
    ;arrayLenght := NumGet(&_positionsArray + 4*A_PtrSize)
    ;MsgBox %arrayLenght%
}

;Load the Edit Windows status of the last session from windows_status.ini
LoadWindowsStatus(){
    ;Set a counter from 1 to 3 so loop knows if it is Var (1), status(2)
    counter := 1
    
    ;Set a counter for the Array Position
    arrayPos := 1
    
    ;Reset Windows Status
    _editPageWindowsStatus := []
    
    setScopesFixed := False
    setColorWarperFixed := False
    
    ;Loop through windows_status.ini to load and populate the latest windows status on _editPageWindowsStatus array
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
                        
                        if InStr(A_LoopField, "scopes_fixed"){
                            setScopesFixed := True
                        }
                        
                        if InStr(A_LoopField, "color_warper_fixed"){
                            setColorWarperFixed := True
                        }
                        
                        _editPageWindowsStatus[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 2:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        if (setScopesFixed){
                            _scopesFixed := SubStr(A_Loopfield, startingPos + 1)
                            
                            setScopesFixed := False
                        }
                        
                        if (setColorWarperFixed){
                            _colorWarperFixed := SubStr(A_Loopfield, startingPos + 1)
                            
                            setColorWarperFixed := False
                        }

                        _editPageWindowsStatus[arrayPos].status := SubStr(A_Loopfield, startingPos + 1)
                        
                        counter := 1
                        arrayPos++
                    continue
                }
            }
        }
    }
}

LoadFindTextHashs(){
    ;Set a counter from 1 to 2 so loop knows if it is Var (1), text(2)
    counter := 1
    
    ;Set a counter for the Array Position
    arrayPos := 1
    
    ;Loop through custom_curves_hashs.ini file to populate the _dotsHashsArray1, 2 and 3 with all the hashs for dots on custom curves panel
    Loop, read, %A_ScriptDir%\custom_curves_hashs.ini
    {
        Loop, parse, A_LoopReadLine, %A_Tab%
        {
            if (InStr(A_Loopfield, "TYPE 1") != 0){
                continue
            }
            
            if (InStr(A_Loopfield, "dotsHashArray1") != 0){
                switch (counter){
                    Case 1:
                        object := []
                        _dotsHashsArray1.Push(object)
                        
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _dotsHashsArray1[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 2:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _dotsHashsArray1[arrayPos].text := SubStr(A_Loopfield, startingPos + 1)

                        counter := 1
                        arrayPos++
                    continue
                }
            }
            
            if (InStr(A_Loopfield, "TYPE 2") != 0){
                counter := 1
                arrayPos := 1
                
                continue
            }
            
            if (InStr(A_Loopfield, "dotsHashArray2") != 0){
                switch (counter){
                    Case 1:
                        object := []
                        _dotsHashsArray2.Push(object)
                        
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _dotsHashsArray2[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 2:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _dotsHashsArray2[arrayPos].text := SubStr(A_Loopfield, startingPos + 1)

                        counter := 1
                        arrayPos++
                    continue
                }
            }
            
            if (InStr(A_Loopfield, "TYPE 3") != 0){
                counter := 1
                arrayPos := 1
                
                continue
            }
            
            if (InStr(A_Loopfield, "dotsHashArray3") != 0){
                switch (counter){
                    Case 1:
                        object := []
                        _dotsHashsArray3.Push(object)
                        
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _dotsHashsArray3[arrayPos].var := SubStr(A_Loopfield, startingPos + 1)

                        counter++
                    continue
                    Case 2:
                        startingPos := InStr(A_Loopfield, "=")
                        
                        _dotsHashsArray3[arrayPos].text := SubStr(A_Loopfield, startingPos + 1)

                        counter := 1
                        arrayPos++
                    continue
                }
            }
        }
    }
}

;Get the mouse actual position and store the X and Y on the respective object variable inside the respective _positionArray(x)
ChangePositionVariable(){
    MouseGetPos, mousePosX, mousePosY

    For index, object in _positionsArray
    if (object.var == _variableToSet) {
        object.x := mousePosX
        object.y := mousePosY
    }
        
    _isSetingVariable := "false"
    _variableToSet := ""
}

;Write in the INI file all the positions stored on the _positionsArray under the respective resolution
UpdateIniResScaleFile(resolutionScale){
    For arrayNum, array in _positionsArray
        For index, varxy in ["var", "x", "y"]
        IniWrite, % array[varxy], %A_ScriptDir%\res_dpi_scale.ini, %resolutionScale%, %resolutionScale% - %arrayNum%%varxy%
        
    Reload
}

;Add a new resolution configuration to the combobox
AddcomboboxItems(item){
    ;Add the new item to the combobox
    GuiControl,, comboboxResolutionScale, %item%
    
    ;Add the new item to the variable that stores all the combobox items
    _comboboxResolutionItems := _comboboxResolutionItems . "|" . item
    
    ;Write the new item on the ini file for future load
    IniWrite, %_comboboxResolutionItems%, %A_ScriptDir%\resolution.ini, RESOLUTION, comboboxItems
    
    ;Change the resolution and scale variable to the new item
    _resolutionAndScale := item
    
    ;Change the combobox for the new item
    GuiControl, Text, comboboxResolutionScale, %_resolutionAndScale%

    CoordMode, Mouse, Screen
    
    ;Reset and populate the _positionArray(x) arrays with the new positions and write the new positions on the INI file too
    UpdateIniResScaleFile(_resolutionAndScale)
}

;Save all the windows status on the windows_status.ini
SaveWindowsStatus(){
    For arrayNum, array in _editPageWindowsStatus
        For index, varstatus in ["var", "status"]
        IniWrite, % array[varstatus], %A_ScriptDir%\windows_status.ini, EDIT WINDOWS STATUS, %arrayNum%%varstatus%
}

SaveNetworkConfig(){
    For arrayNum, array in _editPageWindowsStatus
        For index, varstatus in ["var", "status"]
        IniWrite, % array[varstatus], %A_ScriptDir%\windows_status.ini, EDIT WINDOWS STATUS, %arrayNum%%varstatus%
}

;===== End of Load and Save Position Functions =====

;===== Mouse Functions =====

;Move mouse on determined axis, incrementing or reducing the determined value - Axis can be "X" or "Y" - Action can be "plus" or "minus" - Value can be any positive value
MoveMouseOnAxis(axis, action, value){
    MouseGetPos MousePosX, MousePosY

    Switch axis{
        Case "X":
            if (action == "plus"){
                MouseMove MousePosX+Value, MousePosY
            }Else{
                MouseMove MousePosX-Value, MousePosY
            }
        Return
        Case "Y":
            if (action == "plus"){
                MouseMove MousePosX, MousePosY+Value
            }Else{
                MouseMove MousePosX, MousePosY-Value
            }
        Return
    }
}

;Move mouse to object position
MoveMouseToPosition(object, addX := 0, addY := 0){
    object := GetObjectOnPositionsArray(object)
    
    MouseMove, object["x"] + addX, object["y"] + addY, 0
}

;Move mouse and click on object
MoveMouseAndClick(object){
    object := GetObjectOnPositionsArray(object)
    
    MouseClick Left, object["x"], object["y"], 1, 0
}

;Move mouse to some object position and add pixels to X and/or Y position and then click
MoveMouseAndClickAddAxis(object, addX := 0, addY := 0){
    object := GetObjectOnPositionsArray(object)
    
    MouseClick Left, object["x"] + addX, object["y"] + addY, 1, 0
}

;Move mouse and double click on object
MoveMouseAndDoubleClick(object){
    object := GetObjectOnPositionsArray(object)

    MouseClick Left, object["x"], object["y"], 2, 10
}

;Move mouse and start grabing object
;Big change on verson 2.7 - Now if you're using some tool, will not release to get other tool. You need wait the auto release to use another tool
MoveMouseAndDrag(data, axis, objectName := "NULL", isDot := False, speedMultiplier := 0){
    if (_activeController != objectName AND _activeController != "OFF"){
        Return
    }Else if (_activeController == "OFF"){
        ;Setup the variable with the controller being used
        _activeController := objectName

        if (objectName != "NULL"){
            object := GetObjectOnPositionsArray(objectName)   
                
            ;Move mouse to the controller position
            MouseMove object.x, object.y, 0
        }

        ;Keep the Enter Key pressed down during the drag movement to prevent the bug where the field is selected when doing smooth adjustments
        GetKeyState, EnterState, Enter, P
        if (EnterState = "U"){
            Send {Enter Down}
        }
        
        ;Start grabing and set a timer to auto release
        GetKeyState, LbuttonState, LButton, P
        if (LbuttonState = "U"){
            Send {LButton Down}
            
            if (isDot){
                _movingDot := True
            }
            
            _isDrag := True
            
            StartAutoReleaseTimer()
        }
    }
    
    varData := speedMultiplier > 0 ? data * speedMultiplier : data
    
    if (axis == "x"){
        setTimer, AutoReleaseControls, Off
        StartAutoReleaseTimer()
        
        MouseGetPos, mousePosX, mousePosY
        MouseMove mousePosX + varData, mousePosY, 0
    }Else{
        setTimer, AutoReleaseControls, Off
        StartAutoReleaseTimer()
        
        MouseGetPos, mousePosX, mousePosY
        MouseMove mousePosX, mousePosY - varData, 0
    }
}

;Make mouse scroll with or without a alternate key pressed
MouseScroll(direction, alternateKey := "NONE"){
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
                Send {Ctrl Up}
            }Else{
                Send {Ctrl Down}
                MouseClick WheelDown
                Send {Ctrl Up}
            }
        Return
        Case "SHIFT":
            if (direction == "UP"){
                Send {Shift Down}
                MouseClick WheelUp
                Send {Shift Up}
            }Else{
                Send {Shift Down}
                MouseClick WheelDown
                Send {Shift Up}
            }
        Return
        Case "ALT":
            if (direction == "UP"){
                Send {Alt Down}
                MouseClick WheelUp
                Send {Alt Up}
            }Else{
                Send {Alt Down}
                MouseClick WheelDown
                Send {Alt Up}
            }
        Return
        Case "WIN":
            if (direction == "UP"){
                Send {LWin Down}
                MouseClick WheelUp
                Send {LWin Up}
            }Else{
                Send {LWin Down}
                MouseClick WheelDown
                Send {LWin Up}
            }
        Return
    }
}

;Move mouse to specific position and start grabing (if NULL it start grabing where mouse is at the moment)
MoveMouseAndKeepGrab(objectName := "NULL"){
    if (objectName != "NULL"){
        object := GetObjectOnPositionsArray(objectName)   
        
        ;Move mouse to the controller position
        MouseMove object.x, object.y, 0
    }
        
    ;Start grabing and set a timer to auto release
    GetKeyState, LbuttonState, LButton, P
    if (LbuttonState = "U"){
        Send {LButton Down}
    }
}

;Release mouse grab
ReleaseMouseGrabing(){
    ;Release the Enter Key that was keeped pressed down during the drag movement to prevent the bug where the field is selected when doing smooth adjustments
    GetKeyState, EnterState, Enter, P
    if !(EnterState = "U"){
        Send {Enter Up}
    }

    GetKeyState, LbuttonState, LButton, P
	if !(LbuttonState = "U"){
   	    Send {LButton Up}
        _isDrag := False
    }
}

;Save on global variables the actual global mouse position
SetGlobalMousePos(){
    MouseGetPos, mousePosX, mousePosY
    
    _globalMousePosX := mousePosX
    _globalMousePosY := mousePosY
}

;===== End of Mouse Functions =====

;===== DLLCall Functions =====

;This is a default function for a Jog. With this you can set a behavior for the Left button over the jog wheels on the panel. They will always be at the Jog Wheel function when DATA = 0
;_nameOfTheFunctionForJogWheel(oscType, data, msgID, hwnd){
    ;if (data == 0){     ;Behavior when pressing the left button over the jog wheel
        ;Return
    ;}

    ;if (data < 0){    ;Behavior when moving the jog wheel to the left
        ;Return
    ;}Else if (data > 0){     ;Behavior when moving the jog wheel to the right
        ;Return
    ;}
;}

;This is a default function for a Trackball on X axis. With this you can set a behavior for the Right button over the jog wheels on the panel. They will always be at the Trackball X axis function when DATA = 0
;_nameOfTheFunctionForJogWheel(oscType, data, msgID, hwnd){
    ;if (data == 0){     ;Behavior when pressing the Right button over the jog wheel
        ;Return
    ;}

    ;if (data < 0){    ;Behavior when moving the trackball X axis to the left
        ;Return
    ;}Else if (data > 0){     ;Behavior when moving the trackball X axis to the right
        ;Return
    ;}
;}

;On both cases, the data == 0 check and behavior can be after the Change Panel function so it will force to change to that pabel when the buttons left or right are pressed
;_nameOfTheFunctionForJogWheel(oscType, data, msgID, hwnd){
    ;changePanelFunction

    ;if (data == 0){     ;Behavior when pressing the left button over the jog wheel
        ;Return
    ;}Else if (data < 0){    ;Behavior when moving the jog wheel to the left
        ;Return
    ;}Else if (data > 0){     ;Behavior when moving the jog wheel to the right
        ;Return
    ;}
;}


;===== HOW TO SEND MESSAGES TO TANGENT HUB AND Control Booster TROUGH OSC2AHK =====

;--- SEND STRING ---

;_testSendStringOSC(oscType, data, msgID, hwnd){
    ;This will send a String
    ;DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/address", AStr, "DATA")
;}

;--- SEND INT ---

;_testSendIntOSC(oscType, data, msgID, hwnd){
    ;This will send a INT
    ;DllCall("OSC2AHK.dll\sendOscMessageInt", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/address", Int, DATA)
;}

;--- SEND FLOAT ---

;_testSendFloatOSC(oscType, data, msgID, hwnd){
    ;This will send a INT
    ;DllCall("OSC2AHK.dll\sendOscMessageFloat", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/address", Float, DATA)
;}

;--- RECEIVING OSC MESSAGE SENT ---

;_testReceivingOSCMessage(oscType, data, msgID, hwnd){
    ;MsgBox "THE MESSAGE WAS LISTENED, OSC TYPE IS: " + %oscType% + "AND DATA IS: " + %data%
;}

;===== END OF OSC SENDING MESSAGES TO TANGENT HUB AND Control Booster =====

;***** Change mode functions *****

;Button - Open Parimaries Wheels panel on Davinci UI and change the mode on the Tangent Panel
_primariesWheels(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_color_wheels")
    MoveMouseAndClick("pos_primaries_wheels_dot")
    
    _lastPanel := _currentPanel
    _currentPanel := "PRIMARIES WHEELS"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[1]")
}

;Button - Open the EDIT page on Davinci UI and change the mode on the Tangent Panel
_editMode(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("EDIT")
    
    _lastPanel := _currentPanel
    _currentPanel := "EDIT"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[2]")
}

;Button - Open the Inspector panel on Davinci UI at the Video page and change the mode on the Tangent Panel
_inspectorMode(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("EDIT")
    
    CheckIfInspector()
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[3]")
}

;Button - Change to Printer Lights mode on the Tangent Panel
_printerLights(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[4]")
}

;Button - Change to Nodes and Scopes mode on the Tangent Panel
_nodesAndScopes(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[5]")
}

;Button - Open Parimaries Bars panel on Davinci UI and change the mode on the Tangent Panel
_primariesBars(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_color_wheels")
    MoveMouseAndClick("pos_primaries_bars_dot")
    
    _lastPanel := _currentPanel
    _currentPanel := "PRIMARIES BARS"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[6]")
}

;Button - Open Log Wheels panel on Davinci UI and change the mode on the Tangent Panel
_logWheels(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_color_wheels")
    MoveMouseAndClick("pos_primaries_log_dot")
    
    _lastPanel := _currentPanel
    _currentPanel := "LOG WHEELS"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[7]")
}

;Button - Open Qualifier panel on Davinci UI and change the mode on the Tangent Panel
_qualifier(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_qualifier")
    MoveMouseAndClick("pos_qualifier_hsl_dot")
    
    _lastPanel := _currentPanel
    _currentPanel := "QUALIFIER HSL"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[16]")
}

;Button - Open Power Windows panel on Davinci UI and change the mode on the Tangent Panel
_powerWindows(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_power_windows")
    
    _lastPanel := _currentPanel
    _currentPanel := "POWER WINDOWS"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[17]")
}

;Button - Open BSM panel on Davinci UI and change the mode on the Tangent Panel
_blurSharpenMist(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_bsm")
    MoveMouseAndClick("pos_bsm_blur_dot")
    
    _lastPanel := _currentPanel
    _currentPanel := "BSM BLUR"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[18]")
}

;Button - Open RGB Mixer panel on Davinci UI and change the mode on the Tangent Panel
_rgbMixer(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_rgb_mixer")
    
    _lastPanel := _currentPanel
    _currentPanel := "RGB MIXER"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[19]")
}

;Button - Open Key panel on Davinci UI and change the mode on the Tangent Panel
_key(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_key")
    
    _lastPanel := _currentPanel
    _currentPanel := "KEY"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[20]")
}

;Button - Open Motion Effects panel on Davinci UI and change the mode on the Tangent Panel
_motionEffects(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_motion_effects")
    
    _lastPanel := _currentPanel
    _currentPanel := "MOTION EFFECTS"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[21]")
}

;Button - Open Color Warper HueXSat panel on Davinci UI and change the mode on the Tangent Panel
_colorWarperHueSat(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    if !(_colorWarperFixed){
        MoveMouseAndClick("pos_color_page_bts_warper")
    }
    
    MoveMouseAndClick("pos_color_warper_huexsat_dot")
    
    _lastPanel := _currentPanel
    _currentPanel := "COLOR WARPER HUEXSAT"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[22]")
}

;Button - Open Color Warper ChrxLum panel on Davinci UI and change the mode on the Tangent Panel
_colorWarperChrLum(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    if !(_colorWarperFixed){
        MoveMouseAndClick("pos_color_page_bts_warper")
    }

    MoveMouseAndClick("pos_color_warper_chrxlum_dot")
    
    _lastPanel := _currentPanel
    _currentPanel := "COLOR WARPER CHRXLUM"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[23]")
}

;Button - Open Tracking panel on Davinci UI and change the mode on the Tangent Panel
_tracking(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_tracking")
    
    _lastPanel := _currentPanel
    _currentPanel := "TRACKING"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[24]")
}

;Button - Open Sizing Edit panel on Davinci UI and change the mode on the Tangent Panel
_sizingModeEdit(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_sizing_edit")
    
    _lastPanel := _currentPanel
    _currentPanel := "SIZING EDIT"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[25]")
}

;Button - Open Sizing Input panel on Davinci UI and change the mode on the Tangent Panel
_sizingModeInput(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_color_page_bts_sizing")
    MoveMouseAndClick("pos_sizing_input")
    
    _lastPanel := _currentPanel
    _currentPanel := "SIZING INPUT"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[26]")
}

;Button - Open Sizing Output panel on Davinci UI and change the mode on the Tangent Panel
_sizingModeOutput(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_sizing_output")
    
    _lastPanel := _currentPanel
    _currentPanel := "SIZING OUTPUT"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[27]")
}

;Button - Open Sizing Node panel on Davinci UI and change the mode on the Tangent Panel
_sizingModeNode(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_sizing_node")
    
    _lastPanel := _currentPanel
    _currentPanel := "SIZING NODE"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[28]")
}

;Button - Open Sizing Reference panel on Davinci UI and change the mode on the Tangent Panel
_sizingModeReference(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    ChangePage("COLOR")
    
    MoveMouseAndClick("pos_sizing_reference")
    
    _lastPanel := _currentPanel
    _currentPanel := "SIZING REFERENCE"
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[29]")
}

;***** End of Change mode functions *****

;----- Color mode functions -----

;***** Sizing Node mode functions *****

;***** Sizing Input mode functions *****

;Knob - Toggle Horizontal Flip (left) and Vertical Flip (right) on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_sizingInputFlip(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        MoveMouseAndClick("pos_sizing_input_horizontal_flip")        
        Return
    }Else if (data > 0){
        MoveMouseAndClick("pos_sizing_input_vertical_flip")
        Return
    }
}

;Knob - Increment, Decrement or Reset Yaw on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_sizingInputYaw(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_yaw", 0)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_yaw")        
        Return
    }
}

;Knob - Increment, Decrement or Reset Pitch on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_sizingInputPitch(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_pitch", 0)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_pitch")        
        Return
    }
}

;Knob - Increment, Decrement or Reset Height on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_sizingInputHeight(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_height", 1)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_height")
        Return
    }
}

;Knob - Increment, Decrement or Reset Width on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_sizingInputWidth(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_width", 1)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_width")
        Return
    }
}

;Knob - Increment, Decrement or Reset Rotate on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_sizingInputRotate(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_rotate", 0)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_rotate")        
        Return
    }
}

;Knob - Increment, Decrement or Reset Zoom on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_sizingInputZoom(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_zoom", 1)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_zoom")
        Return
    }
}

;Knob - Increment, Decrement or Reset Tilt on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Between Fine and Medium
_sizingInputTilt(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_tilt", 0)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_tilt")        
        Return
    }
}

;Knob - Increment, Decrement or Reset Pan on Sizing Input Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Between Fine and Medium
_sizingInputPan(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_sizing_input_pan", 0)
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_sizing_input_pan")        
        Return
    }
}

;Button - Reset Blanking on Sizing Input Panel
_sizingInputResetBlanking(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_sizing_input_reset_blanking")
}

;Button - Reset Sizing on Sizing Input Panel
_sizingInputResetSizing(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_sizing_input_reset_sizing")
}

;Button - Reset Blanking on Sizing Input Panel
_sizingInputSmooth(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_sizing_input_blanking_smooth")
}

;***** End of Sizing Input mode functions *****

;***** Tracking mode functions *****

;Jog - Render one frame reverse or forward on Tracking Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_trackingStepFramesTrack(oscType, data, msgID, hwnd){
    if (data < 0){
        MoveMouseAndClick("pos_tracking_one_frame_reverse")
        Return
    }Else if (data > 0){
        MoveMouseAndClick("pos_tracking_one_frame_forward")
        Return
    }
}

;Knob - Toggle between Window and FX panels on Tracking Panel - Default Knob Sensitivity: Min: 0 - Max: 20 - Step: 1 - Coarse
_trackingToggleWindowFX(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        MoveMouseAndClick("pos_tracking_window")        
        Return
    }Else if (data > 0){
        MoveMouseAndClick("pos_tracking_fx")
        Return
    }
}

;Knob - Toggle between Clip and Frame options on Tracking Panel - Default Knob Sensitivity: Min: 0 - Max: 20 - Step: 1 - Coarse
_trackingToggleClipFrame(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        MoveMouseAndClick("pos_tracking_clip")        
        Return
    }Else if (data > 0){
        MoveMouseAndClick("pos_tracking_frame")
        Return
    }
}

;Button - Tracking Show Tracking on Tracking Panel
_trackingShowTracking(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_dots_menu")
    
    Sleep 10
    
    MoveMouseAndClick("pos_tracking_show_track")
}

;Button - Tracking Tilt on Tracking Panel
_trackingTilt(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_tilt")
}

;Button - Tracking Pan on Tracking Panel
_trackingPan(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_pan")
}

;Button - Tracking Next Keyframe on Tracking Panel
_trackingNextKeyframe(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_next_keyframe")
}

;Button - Tracking Previous Keyframe on Tracking Panel
_trackingPreviousKeyframe(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_previous_keyframe")
}

;Button - Add Tracking Point on Tracking Panel
_trackingAddPoint(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_add_point")
}

;Button - Tracking Forward on Tracking Panel
_trackingTrackForward(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_forward")
}

;Button - Stop Tracking on Tracking Panel
_trackingStopTracking(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_tracking_stop")
}

;***** End of Tracking mode functions *****

;***** Color Warper ChrXLum mode functions *****

;Knob - Run through Color Space options on Color Warper ChrXLum Panel - Default Knob Sensitivity: Min: 0 - Max: 20 - Step: 1 - Coarse
_cwChrLumColorSpace(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if(data < 0){
        if (_actualColorWarperChrLumColorSpace <= 1){
            _actualColorWarperChrLumColorSpace := 5
        }Else{
            _actualColorWarperChrLumColorSpace--
        }
    }Else if(data > 0){
        if (_actualColorWarperChrLumColorSpace >= 5){
            _actualColorWarperChrLumColorSpace := 1
        }Else{
            _actualColorWarperChrLumColorSpace++
        }
    }
    
    MoveMouseAndClick("pos_color_warper_chrxlum_color_space")

    Switch (_actualColorWarperChrLumColorSpace){
        Case "1":
            MoveMouseAndClick("pos_color_warper_chrxlum_color_space_hsv")
        Return
        Case "2":
            MoveMouseAndClick("pos_color_warper_chrxlum_color_space_hsl")
        Return
        Case "3":
            MoveMouseAndClick("pos_color_warper_chrxlum_color_space_hsy")
        Return
        Case "4":
            MoveMouseAndClick("pos_color_warper_chrxlum_color_space_hsp")
        Return
        Case "5":
            MoveMouseAndClick("pos_color_warper_chrxlum_color_space_hsp_log")
        Return
    }
}

;Knob - Toggle between Grids 1 (left) and 2(right) on Color Warper ChrXLum Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_cwChrLumToggleGrids(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if(data < 0){
        MoveMouseAndClick("pos_color_warper_chrxlum_grid_1")
    }Else if(data > 0){
        MoveMouseAndClick("pos_color_warper_chrxlum_grid_2")        
    }
}

;***** Color Warper HueXSat mode functions *****

;Knob - Increment, decrement or reset Luma on Color Warper HueXSat Panel - Default Knob Sensitivity: Min: 0 - Max: 2000 - Step: 1 - Coarse
_cwHueSatHueBar(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndClick("pos_color_warper_huexsat_hue_reset")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_color_warper_huexsat_hue_bar")
        Return
    }
}

;Knob - Increment, decrement or reset Luma on Color Warper HueXSat Panel - Default Knob Sensitivity: Min: 0 - Max: 2000 - Step: 1 - Coarse
_cwHueSatLumaBar(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndClick("pos_color_warper_huexsat_lum_reset")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_color_warper_huexsat_lum_bar")
        Return
    }
}

;Knob - Run through Hue Resolution options on Color Warper HueXSat Panel - Default Knob Sensitivity: Min: 0 - Max: 20 - Step: 1 - Coarse
_cwHueSatHueResolution(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if(data < 0){
        if (_actualColorWarperHueSatHueRes <= 1){
            _actualColorWarperHueSatHueRes := 5
        }Else{
            _actualColorWarperHueSatHueRes--
        }
    }Else if(data > 0){
        if (_actualColorWarperHueSatHueRes >= 5){
            _actualColorWarperHueSatHueRes := 1
        }Else{
            _actualColorWarperHueSatHueRes++
        }
    }
    
    MoveMouseAndClick("pos_color_warper_huexsat_hue_resolution")
    
    Switch (_actualColorWarperHueSatHueRes){
        Case "1":
            MoveMouseAndClick("pos_color_warper_huexsat_hue_resolution_1")            
        Return
        Case "2":
            MoveMouseAndClick("pos_color_warper_huexsat_hue_resolution_2")            
        Return
        Case "3":
            MoveMouseAndClick("pos_color_warper_huexsat_hue_resolution_3")            
        Return
        Case "4":
            MoveMouseAndClick("pos_color_warper_huexsat_hue_resolution_4")            
        Return
        Case "5":
            MoveMouseAndClick("pos_color_warper_huexsat_hue_resolution_5")
        Return
    }
}

;Knob - Smooth Hue on Color Warper HueXSat Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_cwHueSatSmoothHue(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else {
        MoveMouseAndClick("pos_color_warper_huexsat_hue_feather")
    }
}

;Knob - Smooth Saturation on Color Warper HueXSat Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_cwHueSatSmoothSat(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else {
        MoveMouseAndClick("pos_color_warper_huexsat_sat_feather")
    }
}

;Button - Select / Deselect on Color Warper HueXSat Panel
_cwHueSatSelect(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_color_warper_huexsat_select")
}

;Button - Draw on Color Warper HueXSat Panel
_cwHueSatDraw(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_color_warper_huexsat_draw")
}

;Button - Pull Points on Color Warper HueXSat Panel
_cwHueSatPullPoints(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_color_warper_huexsat_pull")
}

;Button - Push Points on Color Warper HueXSat Panel
_cwHueSatPushPoints(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_color_warper_huexsat_push")
}

;***** End of Color Warper HueXSat mode functions *****

;***** Motion Effects mode functions *****

;Knob - Run through Spatial NR Radius options on Motion Effects Panel - Default Knob Sensitivity: Min: 0 - Max: 20 - Step: 1 - Coarse
_motionEffectsSpatialRadius(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if(data < 0){
        if (_actualSpatialNRRadius <= 1){
            _actualSpatialNRRadius := 3
        }Else{
            _actualSpatialNRRadius--
        }
    }Else if(data > 0){
        if (_actualSpatialNRRadius >= 3){
            _actualSpatialNRRadius := 1
        }Else{
            _actualSpatialNRRadius++
        }
    }
    
    MoveMouseAndClick("pos_motion_effects_spatial_radius")
    
    Switch (_actualSpatialNRRadius){
        Case "1":
            MoveMouseAndClick("pos_motion_effects_spatial_radius_small")
        Return
        Case "2":
            MoveMouseAndClick("pos_motion_effects_spatial_radius_medium")
        Return
        Case "3":
            MoveMouseAndClick("pos_motion_effects_spatial_radius_large")
        Return
    }
}

;Knob - Run through Spatial NR Mode options on Motion Effects Panel - Default Knob Sensitivity: Min: 0 - Max: 20 - Step: 1 - Coarse
_motionEffectsSpatialMode(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if(data < 0){
        if (_actualSpatialNRMode <= 1){
            _actualSpatialNRMode := 3
        }Else{
            _actualSpatialNRMode--
        }
    }Else if(data > 0){
        if (_actualSpatialNRMode >= 3){
            _actualSpatialNRMode := 1
        }Else{
            _actualSpatialNRMode++
        }
    }
    
    MoveMouseAndClick("pos_motion_effects_spatial_mode")
    
    Switch (_actualSpatialNRMode){
        Case "1":
            MoveMouseAndClick("pos_motion_effects_spatial_mode_faster")
        Return
        Case "2":
            MoveMouseAndClick("pos_motion_effects_spatial_mode_better")
        Return
        Case "3":
            MoveMouseAndClick("pos_motion_effects_spatial_mode_enhanced")
        Return
    }
}

;Knob - Increment, decrement or reset Blend on Motion Effects Temporal NR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_motionEffectsTemporalBlend(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_motion_effects_temporal_blend", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_motion_effects_temporal_blend")
        Return
    }
}

;Knob - Increment, decrement or reset Motion on Motion Effects Temporal NR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_motionEffectsTemporalMotion(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_motion_effects_temporal_motion", 50)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_motion_effects_temporal_motion")
        Return
    }
}

;Knob - Increment, decrement or reset Chroma on Motion Effects Temporal NR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_motionEffectsTemporalChroma(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_motion_effects_temporal_chroma", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_motion_effects_temporal_chroma")
        Return
    }
}

;Knob - Increment, decrement or reset Luma on Motion Effects Temporal NR Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_motionEffectsTemporalLuma(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_motion_effects_temporal_luma", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_motion_effects_temporal_luma")
        Return
    }
}

;Button - Reset Motion Effects
_motionEffectsReset(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_motion_effects_reset")
}

;Button - Reset Motion Blur on Motion Effects Panel
_motionEffectsMotionBlur(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_motion_effects_reset_motion_blur")
}

;Button - Reset Spatial Threshold on Motion Effects Panel
_motionEffectsSpatialResetThreshold(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_motion_effects_reset_spatial_threshold")
}

;Button - Reset Spatial NR on Motion Effects Panel
_motionEffectsSpatialResetNR(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_motion_effects_reset_spatial_nr")
}

;Button - Reset Temporal Threshold on Motion Effects Panel
_motionEffectsTemporalResetThreshold(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_motion_effects_reset_temporal_threshold")
}

;Button - Reset Temporal NR on Motion Effects Panel
_motionEffectsTemporalResetNR(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_motion_effects_reset_temporal_nr")
}

;Button - Link/Unlink Chroma and Luma on Motion Effects Temporal NR Panel
_motionEffectsTemporalLink(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_motion_effects_temporal_luma_chroma_link")
}

;***** End of Motion Effects mode functions *****

;***** Key mode functions *****

;Knob - Increment, decrement or reset Qualifier Offset on Key Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_keyQualifierOffset(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_key_qualifier_offset", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_key_qualifier_offset")
        Return
    }
}

;Knob - Increment, decrement or reset Input Blur R. on Key Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_keyInputBlurR(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_key_input_blur_r", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_key_input_blur_r")
        Return
    }
}

;Knob - Increment, decrement or reset Input Gain on Key Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_keyInputGain(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_key_input_gain", 1)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_key_input_gain")
        Return
    }
}

;Button - Reset Key
_keyReset(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_key_reset")
}

;Button - Invert Qualifier Key on Key panel
_keyQualifierKey(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_key_qualifier_invert_key")
}

;Button - Invert Qualifier Matte Mask on Key panel
_keyQualifierMatteMask(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_key_qualifier_invert_matte_mask")
}

;***** End of Key mode functions *****

;***** Qualifier mode functions *****

;Knob - Increment, decrement or reset Post Filter at Page 2 of Matte Finesse on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_matteFinessePostFilter(oscType, data, msgID, hwnd){
    ChangeMatteFinessePage(2)
    
    if (data == 0){
        MoveMouseAndDoubleClick("pos_matte_finesse_2_post_filter")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_matte_finesse_2_post_filter")
        Return
    }
}

;Knob - Increment, decrement or reset Highlight at Page 2 of Matte Finesse on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_matteFinesseHighlight(oscType, data, msgID, hwnd){
    ChangeMatteFinessePage(2)
    
    if (data == 0){
        MoveMouseAndDoubleClick("pos_matte_finesse_2_highlight")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_matte_finesse_2_highlight")
        Return
    }
}

;Knob - Change the options or reset Morph Menu at Page 2 of Matte Finesse on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 20 - Step: 1 - Coarse
_matteFinesseMorphMenu(oscType, data, msgID, hwnd){
    ChangeMatteFinessePage(2)

    if (data == 0){
        MoveMouseAndClick("pos_matte_finesse_2_morph_menu")
        Sleep 10
        MoveMouseAndClick("pos_matte_finesse_2_shrink")
        _actualMatteFinesseMode := 1
        Return
    }Else if(data < 0){
        if (_actualMatteFinesseMode <= 1){
            _actualMatteFinesseMode := 4
        }Else{
            _actualMatteFinesseMode--
        }
    }Else if(data > 0){
        if (_actualMatteFinesseMode >= 4){
            _actualMatteFinesseMode := 1
        }Else{
            _actualMatteFinesseMode++
        }
    }
    
    MoveMouseAndClick("pos_matte_finesse_2_morph_menu")
    
    Switch (_actualMatteFinesseMode){
        Case "1":
            MoveMouseAndClick("pos_matte_finesse_2_shrink")
        Return
        Case "2":
            MoveMouseAndClick("pos_matte_finesse_2_grow")
        Return
        Case "3":
            MoveMouseAndClick("pos_matte_finesse_2_opening")
        Return
        Case "4":
            MoveMouseAndClick("pos_matte_finesse_2_closing")
        Return
    }
}

;Knob - Increment, decrement or reset In/Out Ratio at Page 1 of Matte Finesse on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_matteFinesseInOutRatio(oscType, data, msgID, hwnd){
    ChangeMatteFinessePage(1)
    
    if (data == 0){
        MoveMouseAndDoubleClick("pos_matte_finesse_1_in_out_ratio")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_matte_finesse_1_in_out_ratio")
        Return
    }
}

;Knob - Increment, decrement or reset Blue High Soft value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierBlueHighSoft(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER RGB")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_luminance_high_soft", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_luminance_high_soft")
        Return
    }
}

;Knob - Increment, decrement or reset Blue Low Soft value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierBlueLowSoft(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER RGB")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_luminance_low_soft", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_luminance_low_soft")
        Return
    }
}

;Knob - Increment, decrement or reset Blue High value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierBlueHigh(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER RGB")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_luminance_high", 100)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_luminance_high")
        Return
    }
}

;Knob - Increment, decrement or reset Blue Low value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierBlueLow(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER RGB")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_luminance_low", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_luminance_low")
        Return
    }
}

;Knob - Increment, decrement or reset Saturation High Soft value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierSatHighSoft(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER HSL")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_saturation_high_soft", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_saturation_high_soft")
        Return
    }
}

;Knob - Increment, decrement or reset Saturation Low Soft value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierSatLowSoft(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER HSL")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_saturation_low_soft", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_saturation_low_soft")
        Return
    }
}

;Knob - Increment, decrement or reset Saturation High value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierSatHigh(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER HSL")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_saturation_high", 100)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_saturation_high")
        Return
    }
}

;Knob - Increment, decrement or reset Saturation Low value on Qualifier HSL Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierSatLow(oscType, data, msgID, hwnd){
    CheckQualifierPanel("QUALIFIER HSL")
    
    if (data == 0){
        ResetForSpecificValue("pos_qualifier_saturation_low", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_qualifier_saturation_low")
        Return
    }
}

;Knob - Reset all Qualifier when pressing the Knob - Default Knob Sensitivity: Min: 0 - Max: 1 - Step: 1 - Coarse
_qualifierResetKnob(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndClick("pos_qualifier_reset")
        Return
    }
}

;Button - Reset all Qualifier
_qualifierReset(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_qualifier_reset")
}

;Knob - Reset Luminance on HSL when turning Left or Blue on RGB when turning right on Qualifier Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_qualifierResetLuminanceKnob(oscType, data, msgID, hwnd){
    if (data < 0){
        CheckQualifierPanel("QUALIFIER HSL")
        
        MoveMouseAndClick("pos_qualifier_luminance_reset")
        
        Return
    }Else If(data > 0){
        CheckQualifierPanel("QUALIFIER RGB")
        
        MoveMouseAndClick("pos_qualifier_luminance_reset")
        
        Return
    }
}

;Button - Reset Luminance or Blue Qualifier on Qualifier Panel (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierResetLuminance(oscType, data, msgID, hwnd){
    MoveMouseAndClick("pos_qualifier_luminance_reset")
}

;Knob - Reset Saturation on HSL when turning Left or Green on RGB when turning right on Qualifier Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_qualifierResetSaturationKnob(oscType, data, msgID, hwnd){
    if (data < 0){
        CheckQualifierPanel("QUALIFIER HSL")
        
        MoveMouseAndClick("pos_qualifier_saturation_reset")
        
        Return
    }Else If(data > 0){
        CheckQualifierPanel("QUALIFIER RGB")
        
        MoveMouseAndClick("pos_qualifier_saturation_reset")
        
        Return
    }
}

;Button - Reset Saturation or Green Qualifier on Qualifier Panel (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierResetSaturation(oscType, data, msgID, hwnd){
    MoveMouseAndClick("pos_qualifier_saturation_reset")
}

;Knob - Reset Hue on HSL when turning Left or Red on RGB when turning right on Qualifier Panel - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_qualifierResetHueKnob(oscType, data, msgID, hwnd){
    if (data < 0){
        CheckQualifierPanel("QUALIFIER HSL")
        
        MoveMouseAndClick("pos_qualifier_hue_reset")
        
        Return
    }Else If(data > 0){
        CheckQualifierPanel("QUALIFIER RGB")
        
        MoveMouseAndClick("pos_qualifier_hue_reset")
        
        Return
    }
}

;Button - Reset Hue or Red Qualifier on Qualifier Panel (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierResetHue(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_qualifier_hue_reset")
}

;Button - Create a Chroma Light Qualifier
_qualifierChromaLight(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send ^+{b}
}

;Button - Create a Six Vector Qualifier Red
_qualifierSixVectorRed(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send ^+{g}
}

;Button - Turn On/Off Luminance or Blue Qualifier on Qualifier Panel (it use the same position for both panels so the name of the object is the HSL one, but works for both HSL and RGB)
_qualifierLuminanceOnOff(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_qualifier_luminance_on_off")
}

;Button - Invert the Qualifier
_qualifierInvert(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_qualifier_invert")
}

;Button - Select the Feather Add on Qualifier panel
_qualifierFeatherAdd(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_qualifier_feather_add")
}

;Button - Select the Feather Substract on Qualifier panel
_qualifierFeatherSubstract(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_qualifier_feather_substract")
}

;Knob - Change between HSL (left) and RGB (right) panels on Qualifier - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_qualifierHSLxRGB(oscType, data, msgID, hwnd){
    if (data < 0){
        CheckQualifierPanel("QUALIFIER HSL")
        
        Return
    }Else If(data > 0){
        CheckQualifierPanel("QUALIFIER RGB")
        
        Return
    }
}

;Button - Change to Qualifier RGB panel
_qualifierRGB(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    CheckQualifierPanel("QUALIFIER RGB")
    
    Return
}

;Button - Change to Qualifier HSL panel
_qualifierHSL(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    CheckQualifierPanel("QUALIFIER HSL")
    
    Return
}

;***** End Of Qualifier mode functions *****

;***** Nodes and Scopes mode functions *****

;Button - Turn on/off Low Pass Filter on Scopes
_scopesLowPassFilter(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    if (!_scopesFixed){
        MoveMouseAndClick("pos_color_page_bts_scopes")        
    }
    
    MoveMouseAndClick("pos_scopes_dots_menu")
    
    Sleep 10
    
    MoveMouseAndClick("pos_scopes_low_pass_filter")
}

;Button - Open CIE Chromaticity Scopes
_scopesCIE(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    if (!_scopesFixed){
        MoveMouseAndClick("pos_color_page_bts_scopes")        
    }
    
    MoveMouseAndClick("pos_scopes_menu")
    
    Sleep 10
    
    MoveMouseAndClick("pos_scopes_cie")
}

;Button - Open Histogram Scopes
_scopesHistogram(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    if (!_scopesFixed){
        MoveMouseAndClick("pos_color_page_bts_scopes")        
    }
    
    MoveMouseAndClick("pos_scopes_menu")
    
    Sleep 10
    
    MoveMouseAndClick("pos_scopes_histogram")
}

;Button - Open Parade Scopes
_scopesParade(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    if (!_scopesFixed){
        MoveMouseAndClick("pos_color_page_bts_scopes")        
    }
    
    MoveMouseAndClick("pos_scopes_menu")
    
    Sleep 10
    
    MoveMouseAndClick("pos_scopes_parade")
}

;Button - Reset All Nodes Grades - Davinci Resolve default shortcut: Ctrl + Home
_resetAllNodesGrade(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{Home}
}

;Button - Extract a Node - Davinci Resolve default shortcut: E
_nodesExtract(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send {e}
}

;Button - Add a Layer Node - Davinci Resolve default shortcut: Alt + L
_nodesAddLayer(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send !{l}
}

;Button - Add a Serial Node Before the current node - Davinci Resolve default shortcut: Shift + S
_nodesAddSerialBefore(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{s}
}

;Button - Add a Serial Node - Davinci Resolve default shortcut: Alt + S
_nodesAddSerial(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send !{s}
}

;***** End of Nodes and Scopes mode functions *****

;***** Printer Lights mode functions *****

;Knob to Shortcut - Half Increment/Decrement Printer Lights Master - Davinci Resolve NON-default shortcut: Ctrl + Alt + Numpad Enter and Ctrl + Alt + Numpad Add  - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsHalfMaster(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^!{NumpadEnter}
        Return
    }Else if (data > 0){
        Send ^!{NumpadAdd}
        Return
    }
}

;Knob to Shortcut - Half Increment/Decrement Printer Lights Yellow - Davinci Resolve NON-default shortcut: Ctrl + Alt + Numpad Mult and Ctrl + Alt + Numpad 3 - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsHalfYellow(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^!{NumpadMult}
        Return
    }Else if (data > 0){
        Send ^!{Numpad3}
        Return
    }
}

;Knob to Shortcut - Half Increment/Decrement Printer Lights Magenta - Davinci Resolve NON-default shortcut: Ctrl + Alt + Numpad 0 and Ctrl + Alt + Numpad 2 - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsHalfMagenta(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^!{Numpad0}
        Return
    }Else if (data > 0){
        Send ^!{Numpad2}
        Return
    }
}

;Knob to Shortcut - Full Increment/Decrement Printer Lights Yellow - Davinci Resolve default shortcut: Numpad Dot and Numpad 3 - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsFullYellow(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send {NumpadDot}
        Return
    }Else if (data > 0){
        Send {Numpad3}
        Return
    }
}

;Knob to Shortcut - Full Increment/Decrement Printer Lights Magenta - Davinci Resolve default shortcut: Numpad 0 and Numpad 2 - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsFullMagenta(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send {Numpad0}
        Return
    }Else if (data > 0){
        Send {Numpad2}
        Return
    }
}

;***** End Of Printer Lights mode functions *****

;***** Power Windows mode functions *****

;Knob - Increment, decrement or reset Soft 1 on Power Windows Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_pwSoft1(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_power_window_soft_1", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_power_window_soft_1")
        Return
    }
}

;Knob - Increment, decrement or reset Inside Softness on Power Windows Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_pwInsideSoftness(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_power_window_inside", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_power_window_inside")
        Return
    }
}

;Knob - Increment, decrement or reset Aspect on Power Windows Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_pwAspect(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_power_window_aspect", 50)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_power_window_aspect")
        Return
    }
}

;Knob - Increment, decrement or reset Size on Power Windows Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_pwSize(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_power_window_size", 50)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_power_window_size")
        Return
    }
}

;Button - Add a node with a linear Power Window - Davinci Resolve default shortcut: ALT + Q
_pwAddNodeLinear(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send !{q}
}

;Button - Delete a Power Window on Power Windows Panel
_pwReset(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_power_window_reset")
}

;Button - Add a Polygon Power Window on Power Windows Panel
_pwAddPolygon(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_power_window_add_polygon")
}

;Button - Add a Linear Power Window on Power Windows Panel
_pwAddLinear(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_power_window_add_linear")
}

;***** End Of Power Windows mode functions *****

;***** Blur, Sharpen and Mist (BSM) mode functions *****

;Knob - Increment, decrement or reset Level of Sharpen on BSM Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_bsmLevel(oscType, data, msgID, hwnd){
    if(_currentPanel != "BSM SHARPEN")
    Return
    
    if (data == 0){
        ResetForSpecificValue("pos_bsm_level", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bsm_level")
        Return
    }
}

;Knob - Increment, decrement or reset Coring Softness of Sharpen on BSM Panel - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_bsmCoringSoftness(oscType, data, msgID, hwnd){
    if(_currentPanel != "BSM SHARPEN")
    Return
    
    if (data == 0){
        ResetForSpecificValue("pos_bsm_coring_softness", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bsm_coring_softness")
        Return
    }
}

;Knob - Increment, decrement or reset Blue channel of H/V Ratio on BSM Panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_bsmRatioB(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_bsm_ratio_b", 0.50)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bsm_ratio_b")
        Return
    }
}

;Knob - Increment, decrement or reset Green channel of H/V Ratio on BSM Panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_bsmRatioG(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_bsm_ratio_g", 0.50)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bsm_ratio_g")
        Return
    }
}

;Knob - Increment, decrement or reset Red channel of H/V Ratio on BSM Panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_bsmRatioR(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_bsm_ratio_r", 0.50)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bsm_ratio_r")
        Return
    }
}

;Button - Reset BSM
_bsmReset(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_bsm_reset")
}

;Button - Open Mist Panel on BSM Panel
_bsmMistPanel(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    ChangeBSMPanel("BSM MIST")
}

;Button - Open Sharpen Panel on BSM Panel
_bsmSharpenPanel(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    ChangeBSMPanel("BSM SHARPEN")
}

;Button - Open Blur Panel on BSM Panel
_bsmBlurPanel(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    ChangeBSMPanel("BSM BLUR")
}

;Button - Reset Radius
_bsmResetRadius(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_bsm_radius_reset")
}

;Button - Link/Unlink H/V Ratio
_bsmLinkRatio(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_bsm_ratio_link")
}

;***** End of Blur, Sharpen and Mist (BSM) mode functions *****

;***** RGB Mixer mode functions *****

;Knob - Increment, decrement or reset Blue channel of Blue Output on RGB Mixer Panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_rgbMixerBlueOutputBlue(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_rgb_mixer_blue_output_blue", 1)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_rgb_mixer_blue_output_blue")
        Return
    }
}

;Knob - Increment, decrement or reset Green channel of Blue Output on RGB Mixer Panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_rgbMixerBlueOutputGreen(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_rgb_mixer_blue_output_green", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_rgb_mixer_blue_output_green")
        Return
    }
}

;Knob - Increment, decrement or reset Red channel of Blue Output on RGB Mixer Panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_rgbMixerBlueOutputRed(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_rgb_mixer_blue_output_red", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_rgb_mixer_blue_output_red")
        Return
    }
}

;Button - Reset RGB Mixer Panel
_rgbMixerReset(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_rgb_mixer_reset")
}

;Button - Check/Uncheck Preserve Luminance Checkbox on RGB Mixer Panel
_rgbMixerPreserveLuminance(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_rgb_mixer_preserve_luminance")
}

;Button - Reset Blue Output on RGB Mixer Panel
_rgbMixerBlueOutputReset(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_rgb_mixer_blue_output_reset")
}

;Button - Invert blue with red on RGB Mixer Panel
_rgbMixerInvertBlueRed(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_rgb_mixer_blue_to_red")
}

;***** Endo Of RGB Mixer mode functions *****

;***** LOG Wheels mode functions *****

;Knob - Increment, decrement or reset Tint value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logTint(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_log_tint", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_log_tint")
        Return
    }
}

;Knob - Increment, decrement or reset Temperature value on Log panel - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_logTemperature(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_log_temperature", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_log_temperature")
        Return
    }
}

;Button - Select Color Picker on Log Panel
_logColorPicker(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_log_awb_picker")
}

;Button - Auto Balance Colors on Log Panel
_logAWB(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_log_auto_balance")
}

;Button - Reset All Log Panel
_logResetAll(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_primaries_reset")
}

;Jog - Increment (right) or decrement (left) the LOG Shadow Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstJog(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndClick("pos_log_first_wheel_reset")
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_log_first_jog")
}

;Trackball - Move up/down the trackball to move the Y axis at the LOG Shadow - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstWheelY(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndDoubleClick("pos_log_first_wheel")
        Return
    }
    
    MoveMouseAndDrag(data, "y", "pos_log_first_wheel")
}

;Trackball - Move up/down the trackball to move the X axis at the LOG Shadow - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstWheelX(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndDoubleClick("pos_log_first_wheel")
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_log_first_wheel")
}

;***** End Of Log Wheels mode functions *****

;***** Primaries Bars mode functions *****

;Knob - Increment, decrement or reset Lift Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftY(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_bars_lift_y", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bars_lift_y")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftB(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_bars_lift_b", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bars_lift_b")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftG(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_bars_lift_g", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bars_lift_g")
        Return
    }
}

;Knob - Increment, decrement or reset Lift Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsLiftR(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_bars_lift_r", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bars_lift_r")
        Return
    }
}

;Button - Reset All Bars Panel
_barsResetAll(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_primaries_reset")
}

;***** End of Primaries Bars mode functions *****

;***** Primaries Wheels mode functions *****

;Knob - Increment, decrement or reset Gain Luma value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainY(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_primaries_gain_y", 1)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_primaries_gain_y")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Blue value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainB(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_primaries_gain_b", 1)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_primaries_gain_b")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Green value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainG(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_primaries_gain_g", 1)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_primaries_gain_g")
        Return
    }
}

;Knob - Increment, decrement or reset Gain Red value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesGainR(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_primaries_gain_r", 1)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_primaries_gain_r")
        Return
    }
}

;Button - Select White Point Picker on Primaries Panel
_primariesWhitePointPicker(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_primaries_white_point_picker")
}

;Button - Select Color Picker on Primaries Panel
_primariesColorPicker(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_primaries_awb_picker")
}

;Button - Auto Balance Colors on Primaries Panel
_primariesAWB(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_primaries_auto_balance")
}

;Button - Reset All Primaries Panel
_primariesResetAll(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_primaries_reset")
}

;Button - Reset Gain Wheel on Primaries Panel
_primariesResetGain(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    MoveMouseAndClick("pos_primaries_third_wheel_reset")
}

;Knob - Increment, decrement or reset Tint value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesTint(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_primaries_tint", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_primaries_tint")
        Return
    }
}

;Knob - Increment, decrement or reset Temperature value on Primaries - Default Knob Sensitivity: Min: 0 - Max: 200 - Step: 1 - Coarse
_primariesTemperature(oscType, data, msgID, hwnd){
    if (data == 0){
        ResetForSpecificValue("pos_primaries_temp", 0)
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_primaries_temp")
        Return
    }
}

;Jog - Increment (right) or decrement (left) the Primaries Gain Jog - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesThirdJog(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndClick("pos_primaries_third_wheel_reset")
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_primaries_third_jog")
}

;Trackball - Move up/down the trackball to move the Y axis at the Primaries Gain - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesThirdWheelY(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndDoubleClick("pos_primaries_third_wheel")    
        Return
    }
    
    MoveMouseAndDrag(data, "y", "pos_primaries_third_wheel")
}

;Trackball - Move left/right the trackball to move the X axis at the Primaries Gain - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesThirdWheelX(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndDoubleClick("pos_primaries_third_wheel")
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_primaries_third_wheel")
}

;***** End of Primaries Wheels mode functions *****

;***** Color Interface Functions *****

;Button - Reset All Nodes Grade - Davinci Resolve default shortcut: Ctrl + Shift + Home
_resetAllNodesGradeAndKeepNodes(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^+{Home}
}

;Button - Reset Node Grade - Davinci Resolve default shortcut: Shift + Home
_resetNodeGrade(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{Home}
}

;Button - Go to full view (not full screen) on Color Page Preview - Davinci Resolve default shortcut: Shift + F
_fullView(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{f}
}

;Button - Toggle Image Wipe on/off on Color Page Preview - Davinci Resolve default shortcut: Ctrl + W
_colorInterfaceImageWipe(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    Send ^{w}
}

;Button - Toggle Highlight on/off on Color Page Preview - Davinci Resolve default shortcut: Shift + H
_colorInterfaceHighlight(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    Send +{h}
}

;Button - Select Node Modes 1 on Color Page
_colorInterfaceNodeMode1(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    MoveMouseAndClick("pos_color_interface_tools_node_mode_menu")
    Sleep 10
    MoveMouseAndClick("pos_color_interface_tools_node_mode_1")
}

;Button - Select Node Modes 2 on Color Page
_colorInterfaceNodeMode2(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    MoveMouseAndClick("pos_color_interface_tools_node_mode_menu")
    Sleep 10
    MoveMouseAndClick("pos_color_interface_tools_node_mode_2")
}

;Button - Select Node Modes 3 on Color Page
_colorInterfaceNodeMode3(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    MoveMouseAndClick("pos_color_interface_tools_node_mode_menu")
    Sleep 10
    MoveMouseAndClick("pos_color_interface_tools_node_mode_3")
}

;Button - Select Node Modes 4 on Color Page
_colorInterfaceNodeMode4(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    MoveMouseAndClick("pos_color_interface_tools_node_mode_menu")
    Sleep 10
    MoveMouseAndClick("pos_color_interface_tools_node_mode_4")
}

;Button - Show/Hide LUTs on Color Page
_colorInterfaceLuts(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    MoveMouseAndClick("pos_color_top_bts_luts")
}

;Button - Toogle between 2 Timeline modes on Color Page - Record A Mode or Source A Mode
_toggleTimelineThumbMode(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    ChangePage("COLOR")
    
    if (_actualTimelineThumbnailMode){
        Send ^!{c}
    }Else{
        Send ^!{a}
    }
    
    _actualTimelineThumbnailMode := !_actualTimelineThumbnailMode
}

;Button - Open Key Frame Animation window on Color Page
_openKeyFrameWindowColorPage(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    MoveMouseAndClick("pos_color_page_bts_key_frame_animation")    
}

;***** End of Color Interface Functions *****

;----- End of Color Mode Functions -----

;----- Edit Mode Functions -----

;***** Inspector Functions *****

;Button - Key Frame Zoom
_inspectorKeyFrameZoom(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    CheckIfInspector()
    
    MoveMouseAndClick("pos_inspector_zoom_keyframe")
}

;Button - Inspector Link or Unlink Zoom
_inspectorLinkUnlinkZoom(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    CheckIfInspector()
    
    MoveMouseAndClick("pos_inspector_zoom_link")
}

;Button - Reset all audio inspector
_inspectorAudioReset(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    CheckIfInspector(False)
    
    MoveMouseAndClick("pos_inspector_audio_reset")
}

;Button - Reset all transform inspector
_inspectorTransformReset(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    CheckIfInspector()
    
    MoveMouseAndClick("pos_inspector_transform_reset")
}

;Knob - Increment, decrement or reset Inspector Volume - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorAudioVolume(oscType, data, msgID, hwnd){
    CheckIfInspector(False)
    
    if (data == 0){
        MoveMouseAndClick("pos_inspector_volume_reset")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_inspector_volume")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Zoom Y - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorZoomY(oscType, data, msgID, hwnd){
    CheckIfInspector()
    
    if (data == 0){
        MoveMouseAndClick("pos_inspector_zoom_reset")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_inspector_zoom_y")
        Return
    }
}

;Knob - Increment, decrement or reset Inspector Zoom X - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_inspectorZoomX(oscType, data, msgID, hwnd){
    CheckIfInspector()
    
    if (data == 0){
        MoveMouseAndClick("pos_inspector_zoom_reset")
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_inspector_zoom_x")
        Return
    }
}

;***** End of Inspector Functions *****

;***** Edit Functions *****

;Jog - Turn left/right to step frames with clip/edit point - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_clipEditPointFrameStep(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }
    
    if (data < 0){
        Send {,}
        Return
    }Else if (data > 0){
        Send {.}
        Return
    }
}

;Jog - Turn left to go backward on timeline and right to go forward - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_moveTimeline(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }
    
    if (data < 0){
        MoveMouseToPosition("pos_timeline_time_bar")
        MouseScroll("UP", "CTRL")
        Return
    }Else if (data > 0){
        MoveMouseToPosition("pos_timeline_time_bar")
        MouseScroll("DOWN", "CTRL")
        Return
    }
}

;Jog - Turn left to zoom out and right to zoom in - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_timelineZoom(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }
    
    if (data < 0){
        Send ^{-}
        Return
    }Else if (data > 0){
        Send ^{=}
        Return
    }
}

;Knob - Change between windows on Edit Page - Can be Timeline (right) or Preview (left) - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse - Davinci Resolve Default Shortcut - Ctrl + 3 and Ctrl + 4
_changeEditActiveWindow(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^{3}
        Return
    }Else if (data > 0){
        Send ^{4}
        Return
    }
}

;Button - Open Davinci Settings - Davinci Resolve Default Shortcut: Ctrl + ,
_davinciSettings(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{,}
}

;Button - Opem Project Home - Davinci Resolve Default Shortcut: Shift + 1
_projectSelection(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{1}
}

;Button - Open Project Settings - Davinci Resolve Default Shortcut: Shift + 9
_projectSettings(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{9}
}

;Knob to Shortcut - Open or Close the Right and Left Expanders on Edit Panel - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_leftRightExpander(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        MoveMouseAndClick("pos_edit_top_bts_left_expand")
        Return
    }Else if (data > 0){
        MoveMouseAndClick("pos_edit_top_bts_right_expand")
        Return
    }
}

;Button - Open or close Right Expander
_openCloseRightExpander(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_right_expand")
}

;Button - Open or close Inspector window
_openCloseInspector(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_inspector")
}

;Button - Open or close Metadata window
_openCloseMetadata(oscType, data, msgID, hwnd){
    if(data == 0)
    Return

    MoveMouseAndClick("pos_edit_top_bts_metadata")
}

;Button - Open or close Mixer window
_openCloseMixer(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_mixer")
}

;Button - Open or close Sound Library window
_openCloseSoundLibrary(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_sound_library")
}

;Button - Open or close Edit Index window
_openCloseEditIndex(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_edit_index")
}

;Button - Open or close Effects Library window
_openCloseEffectsLibrary(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_effects_library")
}

;Button - Open or close Media Pool window
_openCloseMediaPool(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_media_pool")
    
    if (GetToggleStateByAID("UiMainWindow.bigBossWidget.widgetStack_Panel.WStackPage_Conform.m_pConformPanel.frameEditTopBar.stackedWidget.pageSingleScreenModeTools.frameEditTopBarLeftInSSM.btnEditToggleMediaPoolInSSM")){
        MoveMouseAndClick("pos_media_pool_empty_space")
    }
}

;Button - Open or close Left Expander
_openCloseLeftExpander(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_edit_top_bts_left_expand")
}

;Button to Shortcut - Add a clip to the end of timeline - Davinci Resolve default shortcut: Shift + F12
_addClipToTheEnd(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send +{F12}
}

;Button to Shortcut - Fit to Fill Clip on timeline - Davinci Resolve default shortcut: Shift + F11
_fitToFillClip(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send +{F11}
}

;Button to Shortcut - Ripple Overwrite Clip on timeline - Davinci Resolve default shortcut: Shift + F10
_rippleOverwriteClip(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send +{F10}
}

;Button to Shortcut - Replace Clip on timeline - Davinci Resolve default shortcut: F11
_replaceClip(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send {F11}
}

;Button to Shortcut - Overwrite Clip on timeline - Davinci Resolve default shortcut: F10
_overwriteClip(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send {F10}
}

;Button to Shortcut - Insert Clip on timeline - Davinci Resolve default shortcut: F9
_insertClip(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send {F8}
}

;Button to Shortcut - Select Blade tool - Davinci Resolve default shortcut: B
_bladeTool(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send {b}
}

;Button to Shortcut - Toggle Dynamic Trim tool - Davinci Resolve default shortcut: W
_dynamicTrimTool(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    send {w}
}

;Button to Shortcut - Select Trim tool - Davinci Resolve default shortcut: T
_trimTool(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    send {t}
}

;Button to Shortcut - Select Selection tool - Davinci Resolve default shortcut: A
_selectionTool(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    send {a}
}

;Knob to Shortcut - Move clips through tracks up and down - Davinci Resolve default shortcut: Alt + Up Arrow / Alt + Down Arrow - Default Knob Sensitivity: Min: 0 - Max: 8 - Step: 1 - Coarse
_altUpDown(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - Select all clips of the active track backward and forward - Davinci Resolve default shortcut: Y / Ctrl + Y - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_selectFwBwActiveTrack(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - Right to Paste Normal and Left to Paste Attributes - Davinci Resolve default shortcut: Ctrl + V and Alt + V - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
_pasteKnob(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send !{v}
        Return
    }Else if (data > 0){
        Send ^{v}
        Return
    }
}

;Knob to Shortcut - Add audio transition, video transition or both - Davinci Resolve default shortcut: Shift + T / Alt + T / Ctrl + T - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_addAVTransitions(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - Open Change Clip Speed window (left) or put clip on retime mode (right) - Davinci Resolve default shortcut: Ctrl + R / R - Default Knob Sensitivity: Min: 0 - Max: 5 - Step: 1 - Coarse
_retimeClipSpeed(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - Swap clip towards right and left - Davinci Resolve default shortcut: Ctrl + Shift + , / Ctrl + Shift + . - Default Knob Sensitivity: Min: 0 - Max: 8 - Step: 1 - Coarse
_swapClips(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - Add a mark, remove a mark and setup a mark - Davinci Resolve default shortcut: M / Alt + M / Ctrl + M - Default Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_addRemoveSetMark(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - Select (right) and deselect (left) all clips - Davinci Resolve default shortcut: Ctrl + A / Ctrl + Shift + A - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_selectDeselectAll(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - Select all clips backward (left) and forward (right) - Davinci Resolve default shortcut: Alt + Y / Ctrl + Alt + Y - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_selectForwardBackward(oscType, data, msgID, hwnd){
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

;Knob to Shortcut - In/Out (left/right) timeline or preview - Davinci Resolve default shortcut: I / O / Alt + I / Alt + O - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
_inOut(oscType, data, msgID, hwnd){
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

;Button to Shortcut - Link/Unlink clips on timeline - Davinci Resolve default shortcut: Ctrl + Alt + L
_linkUnlinkClips(oscType, data, msgID, hwnd){
    if(data == 0)
    Return

    Send ^!{l}
}

;Button to Shortcut - Select the closest edit point - Davinci Resolve default shortcut: V
_closestEditPoint(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send {v}
}

;Button to Shortcut - Select the closest clip or gap - Davinci Resolve default shortcut: Shift + V
_closestClipGap(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send +{v}
}

;Button to Shortcut - Delete all the content from the end of the clip until the playhead - Davinci Resolve default shortcut: Ctrl + Shift + ]
_delEndToPlayhead(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send ^+{]}
}

;Button to Shortcut - Delete all the content from the begin of the clip until the playhead - Davinci Resolve default shortcut: Ctrl + Shift + [
_delStartToPlayhead(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send ^+{[}
}

;Button to Shortcut - Cut all selected clips or all tracks if none is selected - Davinci Resolve default shortcut: Ctrl + B
_cutAllTimelines(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send ^{b}
}

;Button to Shortcut - Open Retime on the selected clip on Edit Mode - Davinci Resolve default shortcut: Ctrl + R
_retime(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send ^{r}
}

;Button to Shortcut - Open Retime on the selected clip on Edit Mode - Davinci Resolve default shortcut: R
_changeClipSpeed(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    Send {r}
}

;Knob - Increment or decrement Monitoring Volume or press to toggle On/Off the monitoring volume on Edit Page - Default Knob Sensitivity: Min: 0 - Max: 500 - Step: 1 - Coarse
_monitoringVolume(oscType, data, msgID, hwnd){
    if (data == 0){
        MoveMouseAndClick("pos_edit_monitoring_volume_button")
        Return
    }Else {
        MoveMouseAndDrag(data, "x", "pos_edit_monitoring_volume_bar")
        Return
    }
}

;Button - Show/Hide Timeline Stacked Tabs on Edit Mode
_timelineViewOptionsStackedTimelines(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_timeline_view_options")
    Sleep 10
    MoveMouseAndClick("pos_timeline_view_options_stacked_timelines")
    Sleep 10
    MoveMouseAndClickAddAxis("pos_timeline_view_options", 40)
}

;Button - Show/Hide Subtitle Tracks on Edit Mode
_timelineViewOptionsSubtitleTracks(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_timeline_view_options")
    Sleep 10
    MoveMouseAndClick("pos_timeline_view_options_subtitle_tracks")
    Sleep 10
    MoveMouseAndClickAddAxis("pos_timeline_view_options", 40)
}

;Button - Show/Hide Audio Waveforms on Edit Mode
_timelineViewOptionsAudioWaveforms(oscType, data, msgID, hwnd){
    if(data == 0)
    Return
    
    MoveMouseAndClick("pos_timeline_view_options")
    Sleep 10
    MoveMouseAndClick("pos_timeline_view_options_audio_waveforms")
    Sleep 10
    MoveMouseAndClickAddAxis("pos_timeline_view_options", 40)
}

;Trackball - Move left/right the trackball to navigate between the next and previous clip on timeline and press the button over Jog Wheel to Delete anything - Default Trackball Sensitivity: Min: 0 - Max: 30 - Step: 1 - Coarse
_navigateClipsLeftRight(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send ^{Left}
    }Else if (data > 0){
        Send ^{Right}        
    }
}

;Trackball - Move up/down the trackball to navigate between the clips up and down on timeline - Default Trackball Sensitivity: Min: 0 - Max: 30 - Step: 1 - Coarse
_navigateClipsUpDown(oscType, data, msgID, hwnd){
    if (data < 0){
        Send ^{Down}
    }Else if (data > 0){
        Send ^{Up}        
    }
}

;***** End of Edit Functions *****

;----- End of Edit Mode Functions -----

;----- General Functions -----

;Turn on and off all the app
_startStop(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    _start_stop_bt()
}

;Button - Play Backward - Davinci Resolve default shortcut: J
_playBackward(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send {j}
}

;Button - Play Forward - Davinci Resolve default shortcut: L
_playForward(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send {l}
}

;Jog Wheel Button - Paste attributes from other clip - Davinci Resolve default shortcut: Alt + V (it's the same function of a button but to be setted on a jog wheel button)
_pasteAttributesJogWheel(oscType, data, msgID, hwnd){
    if (data == 0)
    Send !{v}
}

;Jog Wheel Button - Copy - Davinci Resolve default shortcut: Ctrl + C (it's the same function of a button but to be setted on a jog wheel button)
_copyJogWheel(oscType, data, msgID, hwnd){
    if (data == 0)
    Send ^{c}
}

;Jog Wheel Button - Paste - Davinci Resolve default shortcut: Ctrl + V (it's the same function of a button but to be setted on a jog wheel button)
_pasteJogWheel(oscType, data, msgID, hwnd){
    if (data == 0)
    Send ^{v}
}

;Jog Wheel Button - Paste - Davinci Resolve default shortcut: Ctrl + X (it's the same function of a button but to be setted on a jog wheel button)
_cutJogWheel(oscType, data, msgID, hwnd){
    if (data == 0)
    Send ^{x}
}

;Button - Paste attributes from other clip - Davinci Resolve default shortcut: Alt + V
_pasteAttributes(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send !{v}
}

;Button - Copy - Davinci Resolve default shortcut: Ctrl + C
_copy(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{c}
}

;Button - Paste - Davinci Resolve default shortcut: Ctrl + V
_paste(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{v}
}

;Button - Paste - Davinci Resolve default shortcut: Ctrl + X
_cut(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    Send ^{x}
}

;Jog - Alternate Key + First Jog Wheel can be used to move the thumbnails to left and right in Color Page - Default Jog Sensitivity - Min. 0 - Max: 100 - Step: 1 - Coarse
_colorPageScrollThumbnails(oscType, data, msgID, hwnd){
    MoveMouseToPosition("pos_color_page_thumbnails", 0, -100)
    
    if (data == 0){
        Return
    }Else if(data < 0){
        MouseScroll("UP")
        Return
    }Else{
        MouseScroll("DOWN")
        Return
    }
}

;Jog - Alternate Key + Fourth Jog Wheel can be used to navigate between nodes in Color Page - Davinci Resolve NON-Default Shortcut: Shift + Y (Next Node) and Shift + U (Previous Node) - Default Jog Sensitivity - Min. 0 - Max: 10 - Step: 1 - Coarse
_navigateNodes(oscType, data, msgID, hwnd){
    if (data == 0){
        Send !{v}
        Return
    }Else if(data < 0){
        Send +{Y}
        Return
    }Else{
        Send +{U}
        Return
    }
}

;Enter/Exit on fullscreen mode - Davinci Resolve default shortcut: Ctrl + F
_toggleFullscreen(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{f}
}

;Save project - Davinci Resolve default shortcut: Ctrl + S
_saveProject(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send ^{s}
}

;Home (left) or End (right) - Davinci Resolve default shortcut: Home / End - Default Knob Sensitivity: Min: 0 - Max: 50 - Step: 1 - Coarse
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

;Left and right arrow on knob turn and hit the knob to enter - Davinci Resolve default shortcut: Left Arrow / Right Arrow / Enter Key - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
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

;Up and down arrow on knob turn and hit the knob to enter - Davinci Resolve default shortcut: Up Arrow / Down Arrow / Enter Key - Default Knob Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse
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

;Button on MODE SELECTION - Reset Davinci UI Layout, reset all variables to default states and put Davinci on Full Screen Mode (IMPORTANT: You have to manually put Custom Curves Edit on LINKED mode after use this function) - Davinci Resolve NON-Default Shortcut: Ctrl + F1 (Reset UI Layout) and Ctrl + F2 (Full Screen Window)
_resetDefaultState(oscType, data, msgID, hwnd){
if (data == 0)
    Return
    
    FileCopy %A_ScriptDir%\default_ini_files\windows_status.ini, %A_ScriptDir%, 1

    LoadWindowsStatus()
    
    Send ^{F1}
    Sleep 1000
    Send ^{F2}
    Sleep 1000
    
    ChangePage("EDIT")
    
    DllCall("OSC2AHK.dll\sendOscMessageString", AStr, _osc_listening_ip, UInt, _osc_listening_port, AStr, "/HubCommand", AStr, "ModeValue[2]")
}

;Button Alt + F6 - Enable/Disable All Nodes - Davinci Resolve Default Shortcut: Alt + D
_enableDisableAllNodes(oscType, data, msgID, hwnd){
    if (data == 0)
    Return

    Send !{d}
}

;Button Alt + F1 - Active Playhead A - Davinci Resolve NON-Default Shortcut: Shift + F1
_playheadA(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{F1}
}

;Button Alt + F2 - Active Playhead B - Davinci Resolve NON-Default Shortcut: Shift + F2
_playheadB(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{F2}
}

;Button Alt + F5 - Reset Playheads - Davinci Resolve NON-Default Shortcut: Shift + F5
_resetPlayheads(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send +{F5}
}

;Jog with Shortcut on button - Navigate fast through clips on Color Page - Davinci Resolve default shortcut: Up and Down Arrows - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_fastNavigateClips(oscType, data, msgID, hwnd){
    if (data == 0){
        Return
    }Else if (data < 0){
        Send {Up}
        Sleep 100
        Return
    }Else if (data > 0){
        Send {Down}
        Sleep 100
        Return
    }
}

;Button - Delete selection using Delete key - Davinci Resolve Default Shortcut: Delete
_deleteKey(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send {Delete}
}

;Button from Jog or Wheel - Delete selection using Delete key - Davinci Resolve Default Shortcut: Delete
_deleteKeyJogWheel(oscType, data, msgID, hwnd){
    Send {Delete}
}

;Button - Delete selection using Backspace key - Davinci Resolve Default Shortcut: Backspace
_backspaceKey(oscType, data, msgID, hwnd){
    if (data == 0)
    Return
    
    Send {Backspace}
}

;Button from Jog or Wheel - Delete selection using Backspace key - Davinci Resolve Default Shortcut: Backspace
_backspaceKeyJogWheel(oscType, data, msgID, hwnd){
    Send {Backspace}
}

;***** Multi-functions for Jog Wheels *****

;Jog/Knob with Shortcut on button - Navigate fast through clips on Color Page and press the jog wheel button or the knob to cut - Davinci Resolve default shortcut: Up and Down Arrows - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_fastNavigateClipsWithCut(oscType, data, msgID, hwnd){
    if (data == 0){
        _cutJogWheel(oscType, data, msgID, hwnd)
        Return
    }Else if (data < 0){
        Send {Up}
        Sleep 100
        Return
    }Else if (data > 0){
        Send {Down}
        Sleep 100
        Return
    }
}

;Trackball with shortcut on button - Move Left/Right the trackball to move the selected Hue Curves Dot on X axis and press the trackrball button to paste - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hueCurvesMoveDotXWithPaste(oscType, data, msgID, hwnd){
    if (data == 0){
        _pasteJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (_delay == True)
    Return
    
    MoveMouseAndDrag(data, "x", "NULL", True)
}

;Jog/Knob with shortcut on button - Move to select next (right) or previous (left) dot on Hue Curves Panel and press the jog wheel button or the knob to copy - Default Jog Sensitivity: Min: 0 - Max: 10 - Step: 1 - Coarse (Different of the other tools, this one doesn't change automatically the panel for hue curves, you need change the panel using one of the buttons or knobs. This is for prevent some possible bugs with the hue curves dots. But, like the other tools, this one just work when you are in the correct hue curves panel)
_hueCurvesSelectDotsWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (_delay == True)
    Return

    GetNextPreviousDot(data)
}

;Trackball with shortcut on button - Move Left/Right the trackball to move the selected Custom Curves Dot on X axis and press the trackrball button to paste - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_customCurvesMoveDotXWithPaste(oscType, data, msgID, hwnd){
    if (data == 0){
        _pasteJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (_delay == True)
    Return
    
    MoveMouseAndDrag(data, "x", "NULL", True)
}

;Jog/Knob with shortcut on button - Move to select next (right) or previous (left) dot on Custom Curves Panel and press the jog wheel button or the knob to copy - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse (Different of the other tools, this one doesn't change automatically the panel for custom curves, you need change the panel using one of the buttons or knobs. This is for prevent some possible bugs with the custom curves dots. But, like the other tools, this one just work when you are in the correct custom curves panel)
_customCurvesSelectDotsWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (_delay == True)
    Return

    GetNextPreviousDot(data)
}

;Jog/Knob with shortcut on button - Move HDR Wheels to the left or righ on HDR Panel and press the jog wheel button or the knob to copy - Default Jog/Knob Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_hdrNavigateWheelsWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }Else If(data < 0){
        MoveMouseAndClick("pos_hdr_wheels_left_arrow")
        Return
    }Else If(data > 0){
        MoveMouseAndClick("pos_hdr_wheels_right_arrow")
        Return
    }
}

;Trackball with shortcut on button - Move left/right the trackball to navigate between the next and previous clip on timeline and press the trackrball button to delete - Default Trackball Sensitivity: Min: 0 - Max: 30 - Step: 1 - Coarse
_navigateClipsLeftRightWithDelete(oscType, data, msgID, hwnd){
    if (data == 0){
        _deleteKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }Else if (data < 0){
        Send ^{Left}
    }Else if (data > 0){
        Send ^{Right}        
    }
}

;Jog/Knob with shortcut on button - Turn left to go backward on timeline and right to go forward and press the jog wheel button or the knob backspace - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_moveTimelineWithBackspace(oscType, data, msgID, hwnd){
    if (data == 0){
        _backspaceKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (data < 0){
        MoveMouseToPosition("pos_timeline_time_bar")
        MouseScroll("UP", "CTRL")
        Return
    }Else if (data > 0){
        MoveMouseToPosition("pos_timeline_time_bar")
        MouseScroll("DOWN", "CTRL")
        Return
    }
}

;Jog/Knob with shortcut on button - Turn left to zoom out and right to zoom in and press the jog wheel button or the knob to copy - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_timelineZoomWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (data < 0){
        Send ^{-}
        Return
    }Else if (data > 0){
        Send ^{=}
        Return
    }
}

;Jog/Knob with shortcut on button - Turn left to zoom out and right to zoom in and press the jog wheel button or the knob to delete - Default Jog Sensitivity: Min: 0 - Max: 6 - Step: 1 - Coarse
_timelineZoomWithDelete(oscType, data, msgID, hwnd){
    if (data == 0){
        _deleteKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (data < 0){
        Send ^{-}
        Return
    }Else if (data > 0){
        Send ^{=}
        Return
    }
}

;Trackball with shortcut on button - Move left/right the trackball to move the X axis at the second HDR Wheel and press the trackrball button to delete - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrSecondWheelXWithDelete(oscType, data, msgID, hwnd){
    if (data == 0){
        _deleteKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_hdr_second_wheel")
}

;Trackball with shortcut on button - Move left/right the trackball to move the X axis at the first HDR Wheel and press the trackrball button to paste - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_hdrFirstWheelXWithPaste(oscType, data, msgID, hwnd){
    if (data == 0){
        _pasteJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_hdr_first_wheel")
}

;Trackball with shortcut on button - Move up/down the trackball to move the X axis at the LOG Midtones and press the trackrball button to delete - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logSecondWheelXWithDelete(oscType, data, msgID, hwnd){
    if (data == 0){
        _deleteKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_log_second_wheel")
}

;Jog/Knob with shortcut on button - Increment (right) or decrement (left) the LOG Midtones Jog and press the jog wheel button or the knob to backspace - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logSecondJogWithBackspace(oscType, data, msgID, hwnd){
    if (data == 0){
        _backspaceKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_log_second_jog")
}

;Trackball with shortcut on button - Move up/down the trackball to move the X axis at the LOG Shadow and press the trackrball button to paste - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstWheelXWithPaste(oscType, data, msgID, hwnd){
    if (data == 0){
        _pasteJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_log_first_wheel")
}

;Jog/Knob with shortcut on button - Increment (right) or decrement (left) the LOG Shadow Jog and press the jog wheel button or the knob to copy - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_logFirstJogWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_log_first_jog")
}

;Jog/Knob with shortcut on button - Increment (right) or decrement (left) the Bars Gamma Jog and press the jog wheel button or the knob to backspace - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsSecondJogWithBackspace(oscType, data, msgID, hwnd){
    if (data == 0){
        _backspaceKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_bars_second_jog")
}

;Jog/Knob with shortcut on button - Increment (right) or decrement (left) the Bars Lift Jog and press the jog wheel button or the knob to copy - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_barsFirstJogWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (data == 0){
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_bars_first_jog")
    }
}

;Trackball with shortcut on button - Move left/right the trackball to move the X axis at the Primaries Gamma and press the trackrball button to delete- Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesSecondWheelXWithDelete(oscType, data, msgID, hwnd){
    if (data == 0){
        _deleteKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_primaries_second_wheel")
}

;Jog/Knob with shortcut on button - Increment (right) or decrement (left) the Primaries Gamma Jog and press the jog wheel button or the knob to backspace - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesSecondJogWithBackspace(oscType, data, msgID, hwnd){
    if (data == 0){
        _backspaceKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_primaries_second_jog")
}

;Jog/Knob with shortcut on button - Alternate Key + First Jog Wheel can be used to move the thumbnails to left and right in Color Page and press the jog wheel button or the knob to cut - Default Jog Sensitivity - Min. 0 - Max: 100 - Step: 1 - Coarse
_colorPageScrollThumbnailsWithCut(oscType, data, msgID, hwnd){
    if (data == 0){
        _cutJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseToPosition("pos_color_page_thumbnails", 0, -100)
    
    if (data < 0){
        MouseScroll("UP")
        Return
    }Else{
        MouseScroll("DOWN")
        Return
    }
}

;Jog/Knob with shortcut on button - Alternate Key + First Jog Wheel can be used to move the thumbnails to left and right in Color Page and press the jog wheel button or the knob to copy - Default Jog Sensitivity - Min. 0 - Max: 100 - Step: 1 - Coarse
_colorPageScrollThumbnailsWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseToPosition("pos_color_page_thumbnails", 0, -100)
    
    if (data < 0){
        MouseScroll("UP")
        Return
    }Else{
        MouseScroll("DOWN")
        Return
    }
}

;Trackball with shortcut on button - Move left/right the trackball to move the X axis at the Primaries Lift and press the trackrball button to paste - Default Trackball Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFirstWheelXWithPaste(oscType, data, msgID, hwnd){
    if (data == 0){
        _pasteJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    MoveMouseAndDrag(data, "x", "pos_primaries_first_wheel")
}

;Jog/Knob with shortcut on button - Increment (right) or decrement (left) the Primaries Lift Jog and press the jog wheel button or the knob to copy - Default Jog Sensitivity: Min: 0 - Max: 1000 - Step: 1 - Coarse
_primariesFirstJogWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (data == 0){
        Return
    }Else{
        MoveMouseAndDrag(data, "x", "pos_primaries_first_jog")
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Magenta and press the jog wheel button or the knob to cut - Davinci Resolve default shortcut: Ctrl + Numpad 0 and Ctrl + Numpad 2 - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterMagentaWithCut(oscType, data, msgID, hwnd){
    if (data == 0){
        _cutJogWheel(oscType, data, msgID, hwnd)
        Return
    }

    if (data < 0){
        Send ^{Numpad0}
        Return
    }Else if (data > 0){
        Send ^{Numpad2}
        Return
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Green and press the jog wheel button or the knob to backspace - Davinci Resolve default shortcut: Ctrl + Numpad 5 and Ctrl + Numpad 8 - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterGreenWithBackspace(oscType, data, msgID, hwnd){
    if (data == 0){
        _backspaceKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (data < 0){
        Send ^{Numpad5}
        Return
    }Else if (data > 0){
        Send ^{Numpad8}
        Return
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Cyan and press the jog wheel button or the knob to cut - Davinci Resolve default shortcut: Ctrl + Numpad Sub and Ctrl + Numpad 1  - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterCyanWithCut(oscType, data, msgID, hwnd){
    if (data == 0){
        _cutJogWheel(oscType, data, msgID, hwnd)
        Return
    }

    if (data < 0){
        Send ^{NumpadSub}
        Return
    }Else if (data > 0){
        Send ^{Numpad1}
        Return
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Cyan and press the jog wheel button or the knob to copy - Davinci Resolve default shortcut: Ctrl + Numpad Sub and Ctrl + Numpad 1  - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterCyanWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }

    if (data < 0){
        Send ^{NumpadSub}
        Return
    }Else if (data > 0){
        Send ^{Numpad1}
        Return
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Red and press the jog wheel button or the knob to copy - Davinci Resolve default shortcut: Ctrl + Numpad 4 and Ctrl + Numpad 7 - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterRedWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }

    if (data < 0){
        Send ^{Numpad4}
        Return
    }Else if (data > 0){
        Send ^{Numpad7}
        Return
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Green and press the jog wheel button or the knob to delete - Davinci Resolve default shortcut: Ctrl + Numpad 5 and Ctrl + Numpad 8 - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterGreenWithDelete(oscType, data, msgID, hwnd){
    if (data == 0){
        _deleteKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }
    
    if (data < 0){
        Send ^{Numpad5}
        Return
    }Else if (data > 0){
        Send ^{Numpad8}
        Return
    }
}

;Jog/Knob with Shortcut on button - Half Increment/Decrement Printer Lights Master and press the jog wheel button or the knob to backspace - Davinci Resolve NON-default shortcut: Ctrl + Alt + Numpad Enter and Ctrl + Alt + Numpad Add  - Default Knob Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsHalfMasterWithBackspace(oscType, data, msgID, hwnd){
    if (data == 0){
        _backspaceKeyJogWheel(oscType, data, msgID, hwnd)
        Return
    }Else if (data < 0){
        Send ^!{NumpadEnter}
        Return
    }Else if (data > 0){
        Send ^!{NumpadAdd}
        Return
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Red and press the jog wheel button or the knob to paste - Davinci Resolve default shortcut: Ctrl + Numpad 4 and Ctrl + Numpad 7 - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterRedWithPaste(oscType, data, msgID, hwnd){
    if (data == 0){
        _pasteJogWheel(oscType, data, msgID, hwnd)
        Return
    }

    if (data < 0){
        Send ^{Numpad4}
        Return
    }Else if (data > 0){
        Send ^{Numpad7}
        Return
    }
}

;Jog/Knob with Shortcut on button - Quarter Increment/Decrement Printer Lights Master and press the jog wheel button or the knob to copy - Davinci Resolve default shortcut: Ctrl + Numpad Enter and Ctrl + Numpad Add  - Default Jog Sensitivity: Min: 0 - Max: 100 - Step: 1 - Coarse
_printerLightsQuarterMasterWithCopy(oscType, data, msgID, hwnd){
    if (data == 0){
        _copyJogWheel(oscType, data, msgID, hwnd)
        Return
    }

    if (data < 0){
        Send ^{NumpadEnter}
        Return
    }Else if (data > 0){
        Send ^{NumpadAdd}
        Return
    }
}

;***** End of multi-functions Jog Wheels *****

;----- End of General Functions -----

;===== End of DLLCall functions =====

;===== Useful functions =====

;Run the _positionsArray to find a expecific object and return it
GetObjectOnPositionsArray(objectName){
    For index, object in _positionsArray
    if (object.var == objectName) {
        Return object
    }
}

;Run the _dotsHashsArrays to find a expecific object and return it
GetHashsText(hash){
    Switch (_actualCurvesHashs){
        Case "1":
            For index, object in _dotsHashsArray1
            if (object.var == hash) {
                Return object
            }
        Case "2":
            For index, object in _dotsHashsArray2
            if (object.var == hash) {
                Return object
            }
        Case "3":
            For index, object in _dotsHashsArray3
            if (object.var == hash) {
                Return object
            }
    }
}

;Start the timer to auto-release any tool - isDot: If it is a Dot from Custom Curves, the parameter need to be true so it will get all the dots positions again after the release
StartAutoReleaseTimer(){
    setTimer, AutoReleaseControls, %_releaseTime%
}

;Auto release the controller being used - isDot: If it is a Dot from Custom Curves, the parameter need to be true so it will get all the dots positions again after the release - isWheels: It can be used for a different time/behavior when releasing a wheel, not in use right now
AutoReleaseControls(isWheels := false){
    if !(EnterState = "U"){
        Send {Enter Up}
    }

    if !(LbuttonState = "U"){
        ReleaseAllControls()
    }
}

;Release all controlls that are being used and clear the variable
ReleaseAllControls(){
    ;Turn off Active Controller
    _activeController := "OFF"
    
    ;Release the mouse grabing
    ReleaseMouseGrabing()
    
    ;If you're mouse grabing a dot, read all the dots again after release
    if (_movingDot){
        if (_currentPanel == "CUSTOM CURVES"){
            SearchCustomCurvesDots()
        }Else{
            SearchHueCurvesDots()
        }
        
        _movingDot := false
    }
}

;Change the page on Davinci Resolve UI
ChangePage(page){
    if(_currentPage == page)
    Return
    
    Switch (page){
        Case "EDIT":
            ;Davinci Resolve default shortcut: Shift+4 - Open Edit Page
            Send +4
            
            _currentPage := "EDIT"
            
            SetPageToWindowsStatus("EDIT")
            
            SaveWindowsStatus()
            
            Sleep _changePageSleepTime
        Return
        Case "COLOR":
            ;Davinci Resolve Default Shortctut Shift+6 - Open Color Page
            ;Davinci bug makes you have to press shift+6 2 times to go to color page
            Send +6
            Send +6

            _currentPage := "COLOR"
            
            SetPageToWindowsStatus("COLOR")
            
            SaveWindowsStatus()
            
            Sleep _changePageSleepTime
        Return
    }
}

;Change the actual Hue Curves Panel being used
ChangeHueCurvesPanel(panel){
    if (_currentPanel == panel)
    Return
    
    Switch (panel){
        Case "HUEXHUE":
            _lastPanel := _currentPanel
            _currentPanel := "HUEXHUE"
            
            MoveMouseAndClick("pos_curves_buttons_huexhue_dot")
        Return
        Case "HUEXSAT":
            _lastPanel := _currentPanel
            _currentPanel := "HUEXSAT"
            
            MoveMouseAndClick("pos_curves_buttons_huexsat_dot")
        Return
        Case "HUEXLUM":
            _lastPanel := _currentPanel
            _currentPanel := "HUEXLUM"
            
            MoveMouseAndClick("pos_curves_buttons_huexlum_dot")
        Return
        Case "LUMXSAT":
            _lastPanel := _currentPanel
            _currentPanel := "LUMXSAT"
            
            MoveMouseAndClick("pos_curves_buttons_lumxsat_dot")
        Return
        Case "SATXSAT":
            _lastPanel := _currentPanel
            _currentPanel := "SATXSAT"
            
            MoveMouseAndClick("pos_curves_buttons_satxsat_dot")
        Return
        Case "SATXLUM":
            _lastPanel := _currentPanel
            _currentPanel := "SATXLUM"
            
            MoveMouseAndClick("pos_curves_buttons_satxlum_dot")
        Return
    }
}

;Change the actual Blur, Sharpen and Mist (BSM) Panel being used
ChangeBSMPanel(panel){
    if (_currentPanel == panel)
    Return
    
    Switch (panel){
        Case "BSM BLUR":
            MoveMouseAndClick("pos_bsm_blur_dot")
        Case "BSM SHARPEN":
            MoveMouseAndClick("pos_bsm_sharpen_dot")
        Case "BSM MIST":
            MoveMouseAndClick("pos_bsm_mist_dot")
    }
    
    _lastPanel := _currentPanel
    _currentPanel := panel
}

;Return a object with the window name (var) and status(1 for opened and 0 for closed)
GetWindow(windowName){
    For index, object in _editPageWindowsStatus
    if (object.var == windowName) {
        Return object
    }
}

;Set on the respective object with the window name a new status(1 for opened and 0 for closed)
SetWindowStatus(window, status){
    For index, object in _editPageWindowsStatus
    if (window == object.var) {
        object.status := status
        Return
    }
}

;Set the variable on windows_status.ini with the latest page used
SetPageToWindowsStatus(page){
    For index, object in _editPageWindowsStatus
    if (object.var == "latest_page") {
        object.status := page
        Return
    }
}

CheckIfInspector(video := True){ 
    if (!GetToggleStateByAID("UiMainWindow.bigBossWidget.widgetStack_Panel.WStackPage_Conform.m_pConformPanel.frameEditTopBar.stackedWidget.pageSingleScreenModeTools.frameEditTopBarRightInSSM.btnEditToggleInspectorInSSM")){
        MoveMouseAndClick("pos_edit_top_bts_inspector")
    }
    
    if (!video){
        if (!GetToggleStateByAID("UiMainWindow.bigBossWidget.widgetStack_Panel.WStackPage_Conform.m_pConformPanel.frameEditPageWidgetsContainer.frameEditPageInspector.widgetEditInspector.frameEditInspectorTabsContainer.btnAudio")){
            MoveMouseAndClick("pos_inspector_audio")
        }
    }Else{
        if (!GetToggleStateByAID("UiMainWindow.bigBossWidget.widgetStack_Panel.WStackPage_Conform.m_pConformPanel.frameEditPageWidgetsContainer.frameEditPageInspector.widgetEditInspector.frameEditInspectorTabsContainer.btnVideo")){
            MoveMouseAndClick("pos_inspector_video")
        }
    }
}

;Open or Close HDR Zone Window
OpenCloseHDRZone(forceOpen := False){
    if (forceOpen AND !CheckIfHDRZone()){
        if (_davinciLayoutUI == "CONDENSED"){
            MoveMouseAndClick("pos_hdr_zone_toggle")                
        }Else {
            MoveMouseAndClick("pos_hdr_open_zone")
        }
        
        Return
    }
    
    if (!forceOpen){
        if (_davinciLayoutUI == "CONDENSED"){
            MoveMouseAndClick("pos_hdr_zone_toggle")
        }Else {
            if (CheckIfHDRZone()){
            MoveMouseAndClick("pos_zone_close_zone")
            }Else {
                MoveMouseAndClick("pos_hdr_open_zone")
            }
        }   
    }
}

;Change page of the Matte Finesse from 1 to 2 and vice-versa. Saves the status on windows_status.ini over the "actual_matte_finess" variable name.
ChangeMatteFinessePage(page){
    if (_actualMatteFinessePage == page)
    Return
    
   ;Check if the layout isn't "WIDE". When is "WHIDE" there's no pages for Matte Finess so all this block is ignored
    if (_davinciLayoutUI != "WIDE"){
        object := GetWindow("actual_matte_finess")
        
        _actualMatteFinessePage := page
        
        if (page == 1){
            MoveMouseAndClick("pos_matte_finesse_1")
            
            SetWindowStatus(object.var, 0)
        }Else{
            MoveMouseAndClick("pos_matte_finesse_2")
            
            SetWindowStatus(object.var, 1)
        }
        
        SaveWindowsStatus()
    }
    
    Return
}

;Keep pressed the mouse button on top of the highlight function of each HDR Color Wheel.
CheckForHDRHighlight(data, panel, wheel){
    Switch (wheel){
        CASE "FIRST":
            if (data == 0){
                ReleaseMouseGrabing()
            }Else{
                MoveMouseAndKeepGrab("pos_hdr_first_wheel_hl")
            }
        Return
        CASE "SECOND":
            if (data == 0){
                ReleaseMouseGrabing()        
            }Else{
                MoveMouseAndKeepGrab("pos_hdr_second_wheel_hl")                
            }
        Return
        CASE "THIRD":
            if (data == 0){
                ReleaseMouseGrabing()        
            }Else{
                MoveMouseAndKeepGrab("pos_hdr_third_wheel_hl")                
            }
        Return
    }
}

CheckIfHDRZone(){
    if (GetToggleStateByAID("UiMainWindow.bigBossWidget.widgetStack_Panel.WStackPage_Color.m_pColorPanel.frameVerticalContainer.frameColorBottom.frameColorBottomToolsContainer.m_pFrameBottomMain.UiPrimaryWidgetContainer.BorderFrame.frameTabWidgetBorder.stackedWidget.colorHDRTab.colorWheelTopFrame.btnExpandWidget")){
        Return True
    }Else{
        Return False
    }
}

CheckQualifierPanel(panel){
    if(_currentPanel == panel)
    Return
    
    Switch (panel){
        CASE "QUALIFIER HSL":
            MoveMouseAndClick("pos_qualifier_hsl_dot")
        CASE "QUALIFIER RGB":
            MoveMouseAndClick("pos_qualifier_rgb_dot")
    }
    
    _lastPanel := _currentPanel
    _currentPanel := panel
}

ResetForSpecificValue(object, value){
    MoveMouseAndClick(object)
    Sleep 10
    Send %value%
    Sleep 10
    Send {Enter}
}

;Do a search looking for all dots on Custom Curves Panel
SearchCustomCurvesDots(){
    ;Sets a delay to prevent fails reading the dots
    Sleep 100
    
    ;Set a variable as true so the jog and trackball on Custom Curves are blocked for a while when reading the dots
    _delay := true
    
    ;Time counter to know how much time took to read all the dots
    ;t1:=A_TickCount, X:=Y:=""
    
    ;Get the right hash for the mode (All, Y, R, G or B) and actual resolution to be used on FindText class
    if (_actualCustomCurvesMode == "ALL" or _actualCustomCurvesMode == "Y"){
        allDots := GetHashsText("ALL").text
    }Else if(_actualCustomCurvesMode == "R"){
        allDots := GetHashsText("R").text
    }Else if(_actualCustomCurvesMode == "G"){
        allDots := GetHashsText("G").text
    }Else if(_actualCustomCurvesMode == "B"){
        allDots := GetHashsText("B").text
    }
    
    ;Variables with the the position of the top left corner and bottom right corner of the Custom Curves Graphic Panel
    topLeftX := GetObjectOnPositionsArray("pos_custom_top_left").x
    topLeftY := GetObjectOnPositionsArray("pos_custom_top_left").y
    bottomRightX := GetObjectOnPositionsArray("pos_custom_bottom_right").x
    bottomRightY := GetObjectOnPositionsArray("pos_custom_bottom_right").y
    
    ;Call FindText to search for all the dots in the Custom Curves Graphic Panel
    _customCurvesDotsArray := FindText(topLeftX, topLeftY, bottomRightX, bottomRightY, 0, 0, allDots)
    
    ;Get the selected dot if exist
    selectedDot := GetHashsText("SELECTED").text
    
    ;Call FindText to search for the selected dot in the Custom Curves Graphic Panel if exist
    tempArray := FindText(topLeftX, topLeftY, bottomRightX, bottomRightY, 0, 0, selectedDot)
    
    ;If exist a selected dot, pushes it on the _customCurvesDotArray
    if (tempArray.Length() != 0){
        _customCurvesDotsArray.push(tempArray[1])
    }

    ;Organize the array by the X position of each dot
    SortArrayByAxis(_customCurvesDotsArray)
    
    ;Reset the counter so it will start select each dot by the first one
    _customCurvesDotCounter := 1
    
    ;Default debug message
    ;MsgBox, 4096, Tip, % "Found:`t" Round(ok.MaxIndex())
    ;. "`n`nTime:`t" (A_TickCount-t1) " ms"
    ;. "`n`nPos:`t" X ", " Y
    ;. "`n`nResult:`t" (ok ? "Success !" : "Failed !")

    ;Shows every result found for debug
    ;for index, v in _customCurvesDotsArray
    ;FindText.MouseTip(_customCurvesDotsArray[index].x, _customCurvesDotsArray[index].y)    
   
    ;Set a delay time until free the controllers again
    Sleep 500
    
    ;Set a variable as false so the jog and trackball on Custom Curves can start to work after reading the dots
    _delay := false
}

;Do a search looking for all dots on Custom Curves Panel
SearchHueCurvesDots(){
    ;Sets a delay to prevent fails reading the dots
    Sleep 100

    ;Set a variable as true so the jog and trackball on Custom Curves are blocked for a while when reading the dots
    _delay := true
    
    allDots := GetHashsText("ALL").text
    
    ;Variables with the the position of the top left corner and bottom right corner of the Custom Curves Graphic Panel
    topLeftX := GetObjectOnPositionsArray("pos_hue_curves_top_left").x
    topLeftY := GetObjectOnPositionsArray("pos_hue_curves_top_left").y
    bottomRightX := GetObjectOnPositionsArray("pos_hue_curves_bottom_right").x
    bottomRightY := GetObjectOnPositionsArray("pos_hue_curves_bottom_right").y
    
    ;Call FindText to search for all the dots in the Custom Curves Graphic Panel
    _customCurvesDotsArray := FindText(topLeftX, topLeftY, bottomRightX, bottomRightY, 0, 0, allDots)
    
    ;Get the selected dot if exist
    selectedDot := GetHashsText("SELECTED").text
    
    ;Call FindText to search for the selected dot in the Custom Curves Graphic Panel if exist
    tempArray := FindText(topLeftX, topLeftY, bottomRightX, bottomRightY, 0, 0, selectedDot)
    
    ;If exist a selected dot, pushes it on the _customCurvesDotArray
    if (tempArray.Length() != 0){
        _customCurvesDotsArray.push(tempArray[1])
    }

    ;Organize the array by the X position of each dot
    SortArrayByAxis(_customCurvesDotsArray)
    
    ;Reset the counter so it will start select each dot by the first one
    _customCurvesDotCounter := 1
    
    ;Set a delay time until free the controllers again
    Sleep 500
    
    ;Set a variable as false so the jog and trackball on Custom Curves can start to work after reading the dots
    _delay := false
}

;Sort an array by the chosen axis (X or Y) positions saved on each object
SortArrayByAxis(array, axis := "X"){
    if (axis == "X"){
        loop {
            swapped := 0
            loop, % array.MaxIndex() - 1
                if (array[A_Index].x > array[A_Index + 1].x) {
                    array.InsertAt(A_Index, array[A_Index + 1])
                    array.RemoveAt(A_Index + 2)
                    swapped := 1
                }
        } until !swapped
    }Else{
        loop {
            swapped := 0
            loop, % array.MaxIndex() - 1
                if (array[A_Index].y > array[A_Index + 1].y) {
                    array.InsertAt(A_Index, array[A_Index + 1])
                    array.RemoveAt(A_Index + 2)
                    swapped := 1
                }
        } until !swapped
    }
}

;Get the next dot on Custom Curves Panel
GetNextPreviousDot(data){
    lenght := _customCurvesDotsArray.Length()

    if (data < 0){
        if (_customCurvesDotCounter == 1){
            _customCurvesDotCounter := lenght
        }Else{
            _customCurvesDotCounter--
        }
    }Else{
        if (_customCurvesDotCounter < lenght){
            _customCurvesDotCounter++
        }Else{
            _customCurvesDotCounter := 1
        }
    }

    MouseClick Left, _customCurvesDotsArray[_customCurvesDotCounter].x, _customCurvesDotsArray[_customCurvesDotCounter].y, 1, 0
}

GetToggleStateByName(name){
    window := WinExist("DaVinci Resolve")
    element := UIAutomation.ElementFromHandle(window)
    togglePattern := element.FindFirstBy("Name=" . name).GetCurrentPatternAs("Toggle")
    
    ;MsgBox % togglePattern.CurrentToggleState
    
    Return togglePattern.CurrentToggleState
}

GetToggleStateByAID(aid){
    window := WinExist("DaVinci Resolve")
    element := UIAutomation.ElementFromHandle(window)
    togglePattern := element.FindFirstBy("AutomationId=" . aid).GetCurrentPatternAs("Toggle")
    
    ;MsgBox % togglePattern.CurrentToggleState
    
    Return togglePattern.CurrentToggleState
}

;Shows the results of an array that contains var, X and Y
DisplayArray(header, array) {
	out := header "`n`n"
    
	for index, var in array
		out .= "x: " var.x "`ty: " var.y "`tvar: " var.var "`n"
	MsgBox, % out
}

;===== End of Useful functions =====

; /\ END OF FUNCTIONS /\

; \/ BUTTONS FUNCTIONS \/

;Set the name of the variable that will have a new position seted
;Start the seting variable mode (makes the software wait for the ENTER key be pressed to save the mouse position)
_start_stop_bt(){
    if (_appRunning){
        MsgBox Control Booster for Tangent Panels is paused

        Menu, Tray, Icon, %A_ScriptDir%\images\cb_paused.ico

        GuiControl,,Stop Control Booster,Start Control Booster
        
        _appRunning := false
        
        Osc2ahkAddOrRemoveListeners("remove")

        Return
    }Else{
        MsgBox Control Booster for Tangent Panels is running
        
        GuiControl,,Start Control Booster,Stop Control Booster

        _appRunning := true
        
        Osc2ahkAddOrRemoveListeners()
        
        Menu, Tray, Icon, %A_ScriptDir%\images\cb_ready.ico
        
        Return
    }
}

;Save all the actual seted positions on the position INI file
_save_positions_bt(){
   UpdateIniResScaleFile(_resolutionAndScale)
}

;Enable the last button used to save a position so you can set it again
_enable_last_button(){
    GuiControl, Enable, %_lastButtonUsed%
}

;Change the combobox for the latest resolution/scale saved in the _resolutionAndScale variable and write it on the INI file. After that, load all the positions inside the _positionsArray
_change_resolution_and_scale(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
    GuiControlGet, comboboxResolutionScale
    _resolutionAndScale := comboboxResolutionScale
    
    IniWrite, %_resolutionAndScale%, %A_ScriptDir%\resolution.ini, RESOLUTION, lastResScale
    
    LoadPositions()
    
    LoadFindTextHashs()
}

_change_davinci_layout_ui(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := ""){
    GuiControlGet, comboboxDavinciLayoutUI
    _davinciLayoutUI := comboboxDavinciLayoutUI
    
    IniWrite, %_davinciLayoutUI%, %A_ScriptDir%\resolution.ini, RESOLUTION, davinciLayoutUI
}

_change_curves_hash(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := ""){
    GuiControlGet, comboboxCurvesHashs
    _actualCurvesHashs := comboboxCurvesHashs
    
    IniWrite, %_actualCurvesHashs%, %A_ScriptDir%\resolution.ini, RESOLUTION, actualCurvesHashs
}

;Call the input Box where user will type the new resolution/scale bank name
_add_combobox_items_input_box(){
    InputBox, newResolutionItem, Add a new resolution config, Please enter the name of the resolution config. ONLY NUMBERS AND LETTERS ARE ACCEPTED so please do not use special characters or space., , 400, 180
    if (ErrorLevel){
        ;MsgBox Cancel button was pressed
        Return
    }Else {
        AddcomboboxItems(newResolutionItem)
        Return
    }
}

_set_scopes_state(){
    GuiControlGet, state, , scopesState
    
    if (state){
        _scopesFixed := 1
        
        SetWindowStatus("scopes_fixed", 1)
    }Else{
        _scopesFixed := 0
        
        SetWindowStatus("scopes_fixed", 0)
    }
    
    SaveWindowsStatus()

    Sleep 10
    
    Return
}

_set_color_warper_state(){
    GuiControlGet, state, , colorWarperState
    
    if (state){
        _colorWarperFixed := 1
        
        SetWindowStatus("color_warper_fixed", 1)
    }Else{
        _colorWarperFixed := 0
        
        SetWindowStatus("color_warper_fixed", 0)
    }
    
    SaveWindowsStatus()

    Sleep 10
    
    Return
}

_edit_osc_listen_port(){
    GuiControlGet, receivingPort, , oscReceivePort
    
    listenPort := receivingPort + 1
    
    GuiControl,, oscListenPort, %listenPort%
    
    Return
}

_set_osc_port(){
    GuiControlGet, receivingPort, , oscReceivePort
    GuiControlGet, liteningPort, , oscListenPort
    
    _osc_receiving_port := receivingPort
    _osc_listening_port := liteningPort
    
    IniWrite, %_osc_receiving_port%, %A_ScriptDir%\network_config.ini, NETWORK CONFIG, receivingPort
    IniWrite, %_osc_listening_port%, %A_ScriptDir%\network_config.ini, NETWORK CONFIG, listeningPort
    
    Reload
}

_set_new_osc_port(port){
    _osc_receiving_port := port
    _osc_listening_port := port + 1
    
    IniWrite, %_osc_receiving_port%, %A_ScriptDir%\network_config.ini, NETWORK CONFIG, receivingPort
    IniWrite, %_osc_listening_port%, %A_ScriptDir%\network_config.ini, NETWORK CONFIG, listeningPort
    
    Return
}

_set_variable_button:
    _lastButtonUsed := A_GuiControl
    _variableToSet := A_GuiControl
    _isSetingVariable := "true"
    
    GuiControl, Disable, %_variableToSet%
Return

; /\ END OF BUTTONS FUNCTIONS /\

; \/ KEY BIDINGS \/

Enter::
    if (_isSetingVariable == "false"){
        Send {Enter}
        Return
    }Else{
        ChangePositionVariable()
        Return
    }
Return

; /\ END OF KEY BIDINGS /\