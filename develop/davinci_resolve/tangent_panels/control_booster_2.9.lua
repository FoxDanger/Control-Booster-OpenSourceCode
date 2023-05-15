-- Control Booster - OSX 1.0
-- This softtware was originaly designed to give lots of new features for Tangent Panels controlling Davinci Resolve. But it can be used with any other Panel or MIDI controller if they have a mapper software with OSC support.
-- Developer: André Rodrigues - Media Environment
-- Website: https://souandrerodrigues.com.br/controlbooster - You can find video tutorials about how to setup and use all the functions on our website.
-- Contact: controlbooster@souandrerodrigues.com.br
-- OSx Version: 1.0

-- Features of 1.0 version:

-- Special Thanks:
-- To my wife and family (cliché but is obvious that I can't do nothing without them)
-- To Tangent for create this amazing panel!
-- To Andy Knox because he knows <3

-- Special Thanks (Windows Version):
-- To all the guys that developed AHK and made my software possible.
-- To Ludwig Frühschütz for the incredible OSC2AHK that allows the OSC communication between my software and Tangent Mapper (and other softwares with OSC Support).
-- To FeiYue for the amazing class FindText that allows my software to find images on the screen and made possible the use of the tools on Custom Curves panel.
-- To some people from AHK Forum and Facebook group that helped me with some questions that I had when I was learning the language and with some help for the software:
-- boiler (AHK Forum)
-- mikeyww (AHK Forum)
-- Ben Sacherich (AHK Facebook)
-- Daniel Oxner (AHK Facebook)
-- Jon Rees (AHK Facebook)
-- To all donators!
-- Gq Lewis
-- Ultra Mobile LLC
-- Trevor Wright
-- Ernest Savage
-- Maira Rocha Tavares

-- Special Thanks (OSx Version):
-- To Chris Hocking from Latenite Films (CommandPost creator) to all the help teaching me how to use Hammerspoon, give me a lot of help with the code and for develop the OSC support for Hammerspoon.
-- To creator and contributors of Hammerspoon.



;------------------------------------------------------------------------------------------ Software Code Start -------------------------------------------------------------------------------------------------------

-- TODO::
-- PODEMOS USAR AS VARIAVES CURRENT_PAGE, CURRENT_MODE, CURRENT_PANEL e CURRENT_TOOL para salvar a página atual (edit ou color), o modo atual (primaries, custom curves, hue curves, power windows e etc), o painel atual (paineis dentro de cada modo como por exemplo primaries wheels, bars ou log) e por fim a ferramenta atual sendo utilizada

-- \/ BEGIN OF GLOBAL VARIABLES \/

-- _appRunning -> boolean
-- Variable
-- False: App is paused / True: App is running.
_appRunning = true

-- /\ END OF GLOBAL VARIABLES /\



-- \/ BEGIN OF LOCAL VARIABLES \/

-- Load Hammerspoon Extensions:
eventtap = require("hs.eventtap")

-- Define some local variables for faster recall:
keyStroke = eventtap.keyStroke

-- listeningPort -> number
-- Variable
-- The OSC listening port.
listeningPort = 7002

-- autoReleasingTime -> number
-- Variable
-- Define a time in miliseconds to auto-release the actual tool being used.
autoReleasingTime = 0

-- changePageSleepTime -> number
-- Variable
-- Set a delay (in miliseconds) to start using tools after change a page from EDIT to COLOR and vice-versa. So, if your computer is slow, you can set a delay to prevent some bugs like change the page and change the panel without actually change the panel (you change the variable but not the panel itself, so the software will think you are in the panel without be there. This can happen because the software send the command to change the page and after that to change the panel, but if the page change be too slow, you can lose the change panel command).
changePageSleepTime = 0

-- currentPage -> string
-- Variable
-- The current DaVinci Resolve page as a string. Can be EDIT or COLOR.
currentPage = "EDIT"

-- /\ END OF LOCAL VARIABLES /\






-- \/ BEGIN OF FUNCTIONS \/

-- ===== General Functions =====

-- _startStopControlBooster(data) -> none
-- Function
-- Stop Control Booster removing all the OSC listeners
-- Start Control Booster adding all the OSC listeners
--
-- Parameters:
--  * data - A table of OSC data
--
-- Returns:
--  * None
function _startStopControlBooster(data)
	print(data)
end

-- ===== Mouse Functions =====

-- MoveMouseOnAxis(axis, action, value) -> mouse.absolutePosition()
-- Function
-- Move mouse on the X or Y axis, incrementing or reducing the determined value
--
-- Parameters:
--  * axis - "X" or "Y"
--	* value - positive int
--
-- Returns:
--  * mouse.absolutePosition() - The last position of the mouse
function MoveMouseOnAxis(axis, value)
	if axis == x then
		hs.mouse.absolutePosition({x = hs.mouse.absolutePosition().x + value, y = hs.mouse.absolutePosition().y})
	else 
		hs.mouse.absolutePosition({x = hs.mouse.absolutePosition().x, y = hs.mouse.absolutePosition().y + value})
	end

	return hs.mouse.absolutePosition()
end

-- MoveMouseToPosition(x, y) -> none
-- Function
-- Move mouse to a specific X, Y coordinate
--
-- Parameters:
--  * x - "X" coordinate
--	* y - "Y" coordinate
--
-- Returns:
--  * none
function MoveMouseToPosition(x, y)
	hs.mouse.absolutePosition({x = x, y = y})
end

-- findTool (name) -> object.x, object.y
-- Function
-- Locate a specific image on the screen and returns a object with the x and y coordinates on the center of the object
--
-- Parameters:
--  * name - The name of the image to looking for
--
-- Returns:
--  * object.x, object.y
function findTool(name)
	display.newImage("/Users/souandrerodrigues/Documents/TWB OSX/images/pos_color_page_bts_curves.png",0,0,true)


	--[[-- Carregue a imagem da ferramenta que você deseja procurar
	local toolImage = hs.image.imageFromPath("/Users/souandrerodrigues/Documents/TWB OSX/images/pos_color_page_bts_curves.png")
    
	if toolImage then
	  -- A imagem foi carregada com sucesso
	  toolImage:show()
	else
	  -- A imagem não foi carregada
	  print("Erro ao carregar imagem")
	end
--]]


	--[[-- Obtenha a área total da tela principal
	local mainScreen = screen.mainScreen()
	local screenFrame = mainScreen:fullFrame()

	-- Use a área total da tela como região de pesquisa
	local searchRegion = {x = screenFrame.x, y = screenFrame.y, w = screenFrame.w, h = screenFrame.h}
	
	-- Execute a pesquisa
	local toolPos = screen.findImage(toolImage, searchRegion, 0.9)

	-- Verifique se a ferramenta foi encontrada
	if toolPos then
	  -- Se a ferramenta foi encontrada, exiba as coordenadas x e y da imagem encontrada
	  print(string.format("Tool found at position x: %d, y: %d", toolPos.x, toolPos.y))
	else
	  -- Se a ferramenta não foi encontrada, exiba uma mensagem de erro
	  print("Tool not found")
	end--]]

--[[	local object = {
		x = 100,
		y = 100
	}

	return object--]]
end



--[[;Move mouse and click on object
MoveMouseAndClick(object){
	object := GetObjectOnPositionsArray(object)
	
	MouseClick Left, object["x"], object["y"], 1, 0
}

;Move mouse and double click on object
MoveMouseAndDoubleClick(object){
	object := GetObjectOnPositionsArray(object)
	
	MouseClick Left, object["x"], object["y"], 2, 10
}

;Move mouse and start grabing object
MoveMouseAndDrag(data, axis, objectName := "NULL", isDot := False){
	if (_activeController != objectName){
        ;Release the mouse of any other controller before start
		ReleaseAllControls()
		Sleep 10
		
        ;Setup the variable with the controller being used
		_activeController := objectName
		
		if (objectName != "NULL"){
			object := GetObjectOnPositionsArray(objectName)   
			
            ;Move mouse to the controller position
			MouseMove object.x, object.y, 0
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
	
	if (axis == "x"){
		setTimer, AutoReleaseControls, Off
		StartAutoReleaseTimer()
		
		MouseGetPos, mousePosX, mousePosY
		MouseMove mousePosX + data, mousePosY, 0
	}Else {
		setTimer, AutoReleaseControls, Off
		StartAutoReleaseTimer()
		
		MouseGetPos, mousePosX, mousePosY
		MouseMove mousePosX, mousePosY - data, 0
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
	GetKeyState, LbuttonState, LButton, P
	;test := test + 10
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
}--]]

-- ===== End of Mouse Functions =====

-- changePage(whichPage) -> boolean
-- Function
-- If DaVinci Resolve isn't on the right page we
-- change it, then return `false`.
--
-- Parameters:
--  * whichPage - "COLOR" or "EDIT"
--
-- Returns:
--  * `true` if we're on the correct page otherwise `false`
function changePage(whichPage)
	if currentPage == whichPage then
		print("HERE")

		-- We're already on the correct page so return `true`.
		return true
	end

	local pageShortcut = {
		["COLOR"] = function() keyStroke({"shift"}, "6") end,
		["EDIT"] = function() keyStroke({"shift"}, "4") end,

		print("changing page")
	}

	-- Trigger the shortcut key:
	pageShortcut[whichPage]()

	-- Update the current page:	
	currentPage = whichPage

	return true
end

-- navigateNodes(v) -> none
-- Function (JogWheel)
-- Check if we're on the Color Page, if not, change to Color Page
-- Navigate between the nodes
--
-- Parameters:
--  * data - A table of OSC data
--
-- Returns:
--  * None
function navigateNodes(data)
	print("navigateNodes function executed")

	changePage("COLOR")
	
	local variableTest = tonumber(hs.inspect(data))

	print("Data Value: ", hs.inspect(data), "\n")
	print("Data Type: ", type(hs.inspect(data)), "\n")
	print("variableTest value: ", variableTest, "\n")
	print("variableTest Type: ", type(variableTest), "\n")

	if variableTest == 1 then
		print("Enter here when the value is 1")
	else
		print("Enter here when the value is -1")
	end
end

-- primariesTemperature(v) -> none
-- Function (Knob)
-- Check if we're on the Color Page, if not, change to Color Page
-- Change the temperature value on primaries panel
--
-- Parameters:
--  * data - A table of OSC data
--
-- Returns:
--  * None
function primariesTemperature(data)
	print("primariesTemperature", "\n")
	print(data, "\n")

	MoveMouseOnAxis(x, data)

--[[	if changePage("COLOR") then
		keyStroke({"shift", "option"}, ";")		
	end--]]
end

function primariesContrast(data)
	print("primariesContrast", "\n")
	print(data, "\n")

	findTool("test")
end

-- /\ END OF FUNCTIONS /\

-- oscTriggers -> table elements -> ["OSC function name"] = function to be called
-- Table
-- All OSC triggers functions:
oscTriggers = {
	["undo"] = undo,
    ["redo"] = redo,
    ["colorPageScrollThumbnails"] = colorPageScrollThumbnails,
    ["navigateNodes"] = navigateNodes,
    ["resetDefaultState"] = resetDefaultState,
    ["enableDisableSelectedNodes"] = enableDisableSelectedNodes,
    ["bypassColorGrading"] = bypassColorGrading,
    ["playheadA"] = playheadA,
    ["playheadB"] = playheadB,
    ["playheadC"] = playheadC,
    ["playheadD"] = playheadD,
    ["resetPlayheads"] = resetPlayheads,
    ["rippleNodesToSelectedClips"] = rippleNodesToSelectedClips,
    ["fastNavigateClips"] = fastNavigateClips,
    ["deleteKey"] = deleteKey,
    ["backspaceKey"] = backspaceKey,
    ["colorInterfaceImageWipe"] = colorInterfaceImageWipe,
    ["colorInterfaceSplitScreen"] = colorInterfaceSplitScreen,
    ["colorInterfaceHighlight"] = colorInterfaceHighlight,
    ["colorInterfaceZoomView"] = colorInterfaceZoomView,
    ["colorInterfaceCursorHand"] = colorInterfaceCursorHand,
    ["colorInterfaceNodeMode1"] = colorInterfaceNodeMode1,
    ["colorInterfaceNodeMode2"] = colorInterfaceNodeMode2,
    ["colorInterfaceNodeMode3"] = colorInterfaceNodeMode3,
    ["colorInterfaceNodeMode4"] = colorInterfaceNodeMode4,
    ["colorInterfaceGallery"] = colorInterfaceGallery,
    ["colorInterfaceLuts"] = colorInterfaceLuts,
    ["colorInterfaceMediaPool"] = colorInterfaceMediaPool,
    ["colorInterfaceTimeline"] = colorInterfaceTimeline,
    ["colorInterfaceClips"] = colorInterfaceClips,
    ["colorInterfaceNodes"] = colorInterfaceNodes,
    ["colorInterfaceOpenFX"] = colorInterfaceOpenFX,
    ["colorInterfaceLightbox"] = colorInterfaceLightbox,
    ["colorInterfaceImageWipeMode"] = colorInterfaceImageWipeMode,
    ["projectSettings"] = projectSettings,
    ["projectSelection"] = projectSelection,
    ["davinciSettings"] = davinciSettings,
    ["copy"] = copy,
    ["paste"] = paste,
    ["grabStill"] = grabStill,
    ["applyGrade"] = applyGrade,
    ["fullView"] = fullView,
    ["stepFrame"] = stepFrame,
    ["previousClip"] = previousClip,
    ["nextClip"] = nextClip,
    ["resetAllNodesGradeAndKeepNodes"] = resetAllNodesGradeAndKeepNodes,
    ["resetNodeGrade"] = resetNodeGrade,
    ["playBackward"] = playBackward,
    ["stop"] = stop,
    ["playForward"] = playForward,
    ["startStop"] = startStop,
    ["resetAllNodesGrade"] = resetAllNodesGrade,
    ["enableDisableAllNodes"] = enableDisableAllNodes,
    ["deleteKeyJogWheel"] = deleteKeyJogWheel,
    ["backspaceKeyJogWheel"] = backspaceKeyJogWheel,
    ["labelNode"] = labelNode,
    ["navigateClipsUpDown"] = navigateClipsUpDown,
    ["navigateClipsLeftRightAndDelete"] = navigateClipsLeftRightAndDelete,
    ["monitoringVolume"] = monitoringVolume,
    ["timelineViewOptionsAudioWaveforms"] = timelineViewOptionsAudioWaveforms,
    ["timelineViewOptionsSubtitleTracks"] = timelineViewOptionsSubtitleTracks,
    ["timelineViewOptionsStackedTimelines"] = timelineViewOptionsStackedTimelines,
    ["matteFinessePostFilter"] = matteFinessePostFilter,
    ["matteFinesseHighlight"] = matteFinesseHighlight,
    ["matteFinesseMidtone"] = matteFinesseMidtone,
    ["qualifierChromaDarkLight"] = qualifierChromaDarkLight,
    ["qualifierChromaLight"] = qualifierChromaLight,
    ["qualifierChromaDark"] = qualifierChromaDark,
    ["qualifierSixVectorYellow"] = qualifierSixVectorYellow,
    ["qualifierSixVectorRed"] = qualifierSixVectorRed,
    ["qualifierSixVectorMagenta"] = qualifierSixVectorMagenta,
    ["qualifierSixVectorGreen"] = qualifierSixVectorGreen,
    ["qualifierSixVectorCyan"] = qualifierSixVectorCyan,
    ["qualifierSixVectorBlue"] = qualifierSixVectorBlue,
    ["qualifierResetKnob"] = qualifierResetKnob,
    ["qualifierResetLuminanceKnob"] = qualifierResetLuminanceKnob,
    ["qualifierResetSaturationKnob"] = qualifierResetSaturationKnob,
    ["qualifierResetHueKnob"] = qualifierResetHueKnob,
    ["customCurvesCopyToAll"] = customCurvesCopyToAll,
    ["customCurvesCopyToBlue"] = customCurvesCopyToBlue,
    ["customCurvesCopyToGreen"] = customCurvesCopyToGreen,
    ["customCurvesCopyToRed"] = customCurvesCopyToRed,
    ["customCurvesCopyToLum"] = customCurvesCopyToLum,
    ["customCurvesResetKnob"] = customCurvesResetKnob,
    ["customCurvesResetSoftClipKnob"] = customCurvesResetSoftClipKnob,
    ["customCurvesResetEditKnob"] = customCurvesResetEditKnob,
    ["hdrNavigateWheels"] = hdrNavigateWheels,
    ["changeClipSpeed"] = changeClipSpeed,
    ["retime"] = retime,
    ["leftRightExpander"] = leftRightExpander,
    ["dynamicTrimTool"] = dynamicTrimTool,
    ["openKeyFrameWindowColorPage"] = openKeyFrameWindowColorPage,
    ["toggleTimelineThumbMode"] = toggleTimelineThumbMode,
    ["pasteAttributesJogWheel"] = pasteAttributesJogWheel,
    ["pasteJogWheel"] = pasteJogWheel,
    ["cutJogWheel"] = cutJogWheel,
    ["copyJogWheel"] = copyJogWheel,
    ["inspectorKeyFrameTransform"] = inspectorKeyFrameTransform,
    ["inspectorKeyFrameVolume"] = inspectorKeyFrameVolume,
    ["inspectorKeyFrameYaw"] = inspectorKeyFrameYaw,
    ["inspectorKeyFrameAnchor"] = inspectorKeyFrameAnchor,
    ["inspectorKeyFramePitch"] = inspectorKeyFramePitch,
    ["inspectorKeyFramePosition"] = inspectorKeyFramePosition,
    ["inspectorKeyFrameRotation"] = inspectorKeyFrameRotation,
    ["inspectorKeyFrameZoom"] = inspectorKeyFrameZoom,
    ["motionEffectsSpatialRadius"] = motionEffectsSpatialRadius,
    ["motionEffectsSpatialMode"] = motionEffectsSpatialMode,
    ["motionEffectsMotionBlurMotionBlur"] = motionEffectsMotionBlurMotionBlur,
    ["motionEffectsMotionBlurMotionRange"] = motionEffectsMotionBlurMotionRange,
    ["motionEffectsMotionBlurMotionEstType"] = motionEffectsMotionBlurMotionEstType,
    ["motionEffectsTemporalMotionRange"] = motionEffectsTemporalMotionRange,
    ["motionEffectsTemporalMotionEstType"] = motionEffectsTemporalMotionEstType,
    ["motionEffectsTemporalFrames"] = motionEffectsTemporalFrames,
    ["motionEffectsSpatialBlend"] = motionEffectsSpatialBlend,
    ["motionEffectsSpatialChroma"] = motionEffectsSpatialChroma,
    ["motionEffectsSpatialLuma"] = motionEffectsSpatialLuma,
    ["motionEffectsTemporalBlend"] = motionEffectsTemporalBlend,
    ["motionEffectsTemporalMotion"] = motionEffectsTemporalMotion,
    ["motionEffectsTemporalChroma"] = motionEffectsTemporalChroma,
    ["motionEffectsTemporalLuma"] = motionEffectsTemporalLuma,
    ["motionEffectsReset"] = motionEffectsReset,
    ["motionEffectsMotionBlur"] = motionEffectsMotionBlur,
    ["motionEffectsSpatialResetThreshold"] = motionEffectsSpatialResetThreshold,
    ["motionEffectsSpatialResetNR"] = motionEffectsSpatialResetNR,
    ["motionEffectsTemporalResetThreshold"] = motionEffectsTemporalResetThreshold,
    ["motionEffectsTemporalResetNR"] = motionEffectsTemporalResetNR,
    ["motionEffectsSpatialLink"] = motionEffectsSpatialLink,
    ["motionEffectsTemporalLink"] = motionEffectsTemporalLink,
    ["keyQualifierOffset"] = keyQualifierOffset,
    ["keyQualifierGain"] = keyQualifierGain,
    ["keyOutputOffset"] = keyOutputOffset,
    ["keyOutputGain"] = keyOutputGain,
    ["keyInputBlurHV"] = keyInputBlurHV,
    ["keyInputBlurR"] = keyInputBlurR,
    ["keyInputOffset"] = keyInputOffset,
    ["keyInputGain"] = keyInputGain,
    ["keyReset"] = keyReset,
    ["keyQualifierKey"] = keyQualifierKey,
    ["keyQualifierMatteMask"] = keyQualifierMatteMask,
    ["keyOutputKey"] = keyOutputKey,
    ["keyInputKey"] = keyInputKey,
    ["keyInputMatteMask"] = keyInputMatteMask,
    ["matteFinessePreFilter"] = matteFinessePreFilter,
    ["matteFinesseCleanBlack"] = matteFinesseCleanBlack,
    ["matteFinesseCleanWhite"] = matteFinesseCleanWhite,
    ["matteFinesseBlurRadius"] = matteFinesseBlurRadius,
    ["matteFinesseInOutRatio"] = matteFinesseInOutRatio,
    ["matteFinesseMorphMenu"] = matteFinesseMorphMenu,
    ["matteFinesseDenoise"] = matteFinesseDenoise,
    ["matteFinesseMorphRadius"] = matteFinesseMorphRadius,
    ["matteFinesseShadow"] = matteFinesseShadow,
    ["matteFinesseBlackClip"] = matteFinesseBlackClip,
    ["matteFinesseWhiteClip"] = matteFinesseWhiteClip,
    ["qualifierBlueHighSoft"] = qualifierBlueHighSoft,
    ["qualifierBlueLowSoft"] = qualifierBlueLowSoft,
    ["qualifierBlueHigh"] = qualifierBlueHigh,
    ["qualifierBlueLow"] = qualifierBlueLow,
    ["qualifierGreenHighSoft"] = qualifierGreenHighSoft,
    ["qualifierGreenLowSoft"] = qualifierGreenLowSoft,
    ["qualifierGreenHigh"] = qualifierGreenHigh,
    ["qualifierGreenLow"] = qualifierGreenLow,
    ["qualifierRedHighSoft"] = qualifierRedHighSoft,
    ["qualifierRedLowSoft"] = qualifierRedLowSoft,
    ["qualifierRedHigh"] = qualifierRedHigh,
    ["qualifierRedLow"] = qualifierRedLow,
    ["qualifierLumHighSoft"] = qualifierLumHighSoft,
    ["qualifierLumLowSoft"] = qualifierLumLowSoft,
    ["qualifierLumHigh"] = qualifierLumHigh,
    ["qualifierLumLow"] = qualifierLumLow,
    ["qualifierSatHighSoft"] = qualifierSatHighSoft,
    ["qualifierSatLowSoft"] = qualifierSatLowSoft,
    ["qualifierSatHigh"] = qualifierSatHigh,
    ["qualifierSatLow"] = qualifierSatLow,
    ["qualifierHueSym"] = qualifierHueSym,
    ["qualifierHueSoft"] = qualifierHueSoft,
    ["qualifierHueWidth"] = qualifierHueWidth,
    ["qualifierHueCenter"] = qualifierHueCenter,
    ["qualifierReset"] = qualifierReset,
    ["qualifierResetLuminance"] = qualifierResetLuminance,
    ["qualifierResetSaturation"] = qualifierResetSaturation,
    ["qualifierResetHue"] = qualifierResetHue,
    ["qualifierLuminanceOnOff"] = qualifierLuminanceOnOff,
    ["qualifierSaturationOnOff"] = qualifierSaturationOnOff,
    ["qualifierHueOnOff"] = qualifierHueOnOff,
    ["qualifierInvert"] = qualifierInvert,
    ["qualifierFeatherAdd"] = qualifierFeatherAdd,
    ["qualifierFeatherSubstract"] = qualifierFeatherSubstract,
    ["qualifierPickerAdd"] = qualifierPickerAdd,
    ["qualifierPickerSubstract"] = qualifierPickerSubstract,
    ["qualifierPicker"] = qualifierPicker,
    ["scopesLowPassFilter"] = scopesLowPassFilter,
    ["scopesDisplayFocus"] = scopesDisplayFocus,
    ["scopesCIE"] = scopesCIE,
    ["scopesHistogram"] = scopesHistogram,
    ["scopesVectorscope"] = scopesVectorscope,
    ["scopesWaveform"] = scopesWaveform,
    ["scopesParade"] = scopesParade,
    ["resetAllNodesGrade"] = resetAllNodesGrade,
    ["nodesExtract"] = nodesExtract,
    ["nodesSplitterCombiner"] = nodesSplitterCombiner,
    ["nodesAddOutside"] = nodesAddOutside,
    ["nodesAppend"] = nodesAppend,
    ["nodesAddLayer"] = nodesAddLayer,
    ["nodesAddParallel"] = nodesAddParallel,
    ["nodesAddSerialBefore"] = nodesAddSerialBefore,
    ["nodesAddSerial"] = nodesAddSerial,
    ["printerLightsQuarterMaster"] = printerLightsQuarterMaster,
    ["printerLightsQuarterYellow"] = printerLightsQuarterYellow,
    ["printerLightsQuarterMagenta"] = printerLightsQuarterMagenta,
    ["printerLightsQuarterCyan"] = printerLightsQuarterCyan,
    ["printerLightsQuarterBlue"] = printerLightsQuarterBlue,
    ["printerLightsQuarterGreen"] = printerLightsQuarterGreen,
    ["printerLightsQuarterRed"] = printerLightsQuarterRed,
    ["printerLightsHalfMaster"] = printerLightsHalfMaster,
    ["printerLightsHalfYellow"] = printerLightsHalfYellow,
    ["printerLightsHalfMagenta"] = printerLightsHalfMagenta,
    ["printerLightsHalfCyan"] = printerLightsHalfCyan,
    ["printerLightsHalfBlue"] = printerLightsHalfBlue,
    ["printerLightsHalfGreen"] = printerLightsHalfGreen,
    ["printerLightsHalfRed"] = printerLightsHalfRed,
    ["printerLightsFullMaster"] = printerLightsFullMaster,
    ["printerLightsFullYellow"] = printerLightsFullYellow,
    ["printerLightsFullMagenta"] = printerLightsFullMagenta,
    ["printerLightsFullCyan"] = printerLightsFullCyan,
    ["printerLightsFullBlue"] = printerLightsFullBlue,
    ["printerLightsFullGreen"] = printerLightsFullGreen,
    ["printerLightsFullRed"] = printerLightsFullRed,
    ["printerLightsOnOff"] = printerLightsOnOff,
    ["pwSoft4"] = pwSoft4,
    ["pwSoft3"] = pwSoft3,
    ["pwSoft2"] = pwSoft2,
    ["pwSoft1"] = pwSoft1,
    ["pwOutsideSoftness"] = pwOutsideSoftness,
    ["pwInsideSoftness"] = pwInsideSoftness,
    ["pwOpacity"] = pwOpacity,
    ["pwRotate"] = pwRotate,
    ["pwTilt"] = pwTilt,
    ["pwPan"] = pwPan,
    ["pwAspect"] = pwAspect,
    ["pwSize"] = pwSize,
    ["pwAddNodeCurve"] = pwAddNodeCurve,
    ["pwAddNodePolygon"] = pwAddNodePolygon,
    ["pwAddNodeCircle"] = pwAddNodeCircle,
    ["pwAddNodeLinear"] = pwAddNodeLinear,
    ["pwReset"] = pwReset,
    ["pwDelete"] = pwDelete,
    ["pwShowHide"] = pwShowHide,
    ["pwAddGradient"] = pwAddGradient,
    ["pwAddCurve"] = pwAddCurve,
    ["pwAddPolygon"] = pwAddPolygon,
    ["pwAddCircle"] = pwAddCircle,
    ["pwAddLinear"] = pwAddLinear,
    ["bsmMix"] = bsmMix,
    ["bsmLevel"] = bsmLevel,
    ["bsmCoringSoftness"] = bsmCoringSoftness,
    ["bsmScalingB"] = bsmScalingB,
    ["bsmScalingG"] = bsmScalingG,
    ["bsmScalingR"] = bsmScalingR,
    ["bsmRatioB"] = bsmRatioB,
    ["bsmRatioG"] = bsmRatioG,
    ["bsmRatioR"] = bsmRatioR,
    ["bsmRadiusB"] = bsmRadiusB,
    ["bsmRadiusG"] = bsmRadiusG,
    ["bsmRadiusR"] = bsmRadiusR,
    ["bsmReset"] = bsmReset,
    ["bsmMistPanel"] = bsmMistPanel,
    ["bsmSharpenPanel"] = bsmSharpenPanel,
    ["bsmBlurPanel"] = bsmBlurPanel,
    ["bsmResetScaling"] = bsmResetScaling,
    ["bsmResetRatio"] = bsmResetRatio,
    ["bsmResetRadius"] = bsmResetRadius,
    ["bsmLinkScaling"] = bsmLinkScaling,
    ["bsmLinkRatio"] = bsmLinkRatio,
    ["bsmLinkRadius"] = bsmLinkRadius,
    ["rgbMixerBlueOutputBlue"] = rgbMixerBlueOutputBlue,
    ["rgbMixerBlueOutputGreen"] = rgbMixerBlueOutputGreen,
    ["rgbMixerBlueOutputRed"] = rgbMixerBlueOutputRed,
    ["rgbMixerGreenOutputBlue"] = rgbMixerGreenOutputBlue,
    ["rgbMixerGreenOutputGreen"] = rgbMixerGreenOutputGreen,
    ["rgbMixerGreenOutputRed"] = rgbMixerGreenOutputRed,
    ["rgbMixerRedOutputBlue"] = rgbMixerRedOutputBlue,
    ["rgbMixerRedOutputGreen"] = rgbMixerRedOutputGreen,
    ["rgbMixerRedOutputRed"] = rgbMixerRedOutputRed,
    ["rgbMixerReset"] = rgbMixerReset,
    ["rgbMixerPreserveLuminance"] = rgbMixerPreserveLuminance,
    ["rgbMixerMonochrome"] = rgbMixerMonochrome,
    ["rgbMixerBlueOutputReset"] = rgbMixerBlueOutputReset,
    ["rgbMixerGreenOutputReset"] = rgbMixerGreenOutputReset,
    ["rgbMixerRedOutputReset"] = rgbMixerRedOutputReset,
    ["rgbMixerInvertBlueRed"] = rgbMixerInvertBlueRed,
    ["rgbMixerInvertGreenBlue"] = rgbMixerInvertGreenBlue,
    ["rgbMixerInvertRedGreen"] = rgbMixerInvertRedGreen,
    ["hueCurvesDeleteActualDot"] = hueCurvesDeleteActualDot,
    ["hueCurvesMoveDotY"] = hueCurvesMoveDotY,
    ["hueCurvesMoveDotX"] = hueCurvesMoveDotX,
    ["hueCurvesSelectDots"] = hueCurvesSelectDots,
    ["hueCurvesSatXLum"] = hueCurvesSatXLum,
    ["hueCurvesSatXSat"] = hueCurvesSatXSat,
    ["hueCurvesLumXSat"] = hueCurvesLumXSat,
    ["hueCurvesHueXLum"] = hueCurvesHueXLum,
    ["hueCurvesHueXSat"] = hueCurvesHueXSat,
    ["hueCurvesHueXHue"] = hueCurvesHueXHue,
    ["hueCurvesReset"] = hueCurvesReset,
    ["hueCurvesReadDots"] = hueCurvesReadDots,
    ["hueCurvesMagenta"] = hueCurvesMagenta,
    ["hueCurvesBlue"] = hueCurvesBlue,
    ["hueCurvesCyan"] = hueCurvesCyan,
    ["hueCurvesGreen"] = hueCurvesGreen,
    ["hueCurvesYellow"] = hueCurvesYellow,
    ["hueCurvesRed"] = hueCurvesRed,
    ["hueCurvesHueSatLum"] = hueCurvesHueSatLum,
    ["hueCurvesInputHue"] = hueCurvesInputHue,
    ["customCurvesSoftClipB"] = customCurvesSoftClipB,
    ["customCurvesSoftClipG"] = customCurvesSoftClipG,
    ["customCurvesSoftClipR"] = customCurvesSoftClipR,
    ["customCurvesSoftClipAll"] = customCurvesSoftClipAll,
    ["customCurvesResetSoftClip"] = customCurvesResetSoftClip,
    ["customCurvesSoftClipHS"] = customCurvesSoftClipHS,
    ["customCurvesSoftClipLS"] = customCurvesSoftClipLS,
    ["customCurvesSoftClipHigh"] = customCurvesSoftClipHigh,
    ["customCurvesSoftClipLow"] = customCurvesSoftClipLow,
    ["customCurvesIntensityBlue"] = customCurvesIntensityBlue,
    ["customCurvesIntensityGreen"] = customCurvesIntensityGreen,
    ["customCurvesIntensityRed"] = customCurvesIntensityRed,
    ["customCurvesIntensityLum"] = customCurvesIntensityLum,
    ["customCurvesReset"] = customCurvesReset,
    ["customCurvesResetEdit"] = customCurvesResetEdit,
    ["customCurvesReadDots"] = customCurvesReadDots,
    ["customCurvesMoveDotY"] = customCurvesMoveDotY,
    ["customCurvesMoveDotX"] = customCurvesMoveDotX,
    ["customCurvesSelectDots"] = customCurvesSelectDots,
    ["customCurvesAddDefaultDots"] = customCurvesAddDefaultDots,
    ["customCurvesToggleEditableSplines"] = customCurvesToggleEditableSplines,
    ["customCurvesDeleteActualDot"] = customCurvesDeleteActualDot,
    ["customCurvesModeB"] = customCurvesModeB,
    ["customCurvesModeG"] = customCurvesModeG,
    ["customCurvesModeR"] = customCurvesModeR,
    ["customCurvesModeY"] = customCurvesModeY,
    ["customCurvesModeAll"] = customCurvesModeAll,
    ["logHue"] = logHue,
    ["logHighlight"] = logHighlight,
    ["logShadow"] = logShadow,
    ["logMidDetail"] = logMidDetail,
    ["logTint"] = logTint,
    ["logTemperature"] = logTemperature,
    ["logSaturation"] = logSaturation,
    ["logCoolBoost"] = logCoolBoost,
    ["logContrast"] = logContrast,
    ["logHighRange"] = logHighRange,
    ["logLowRange"] = logLowRange,
    ["logPivot"] = logPivot,
    ["logColorPicker"] = logColorPicker,
    ["logAWB"] = logAWB,
    ["logResetAll"] = logResetAll,
    ["logOffsetReset"] = logOffsetReset,
    ["logHighlightsReset"] = logHighlightsReset,
    ["logMidtoneReset"] = logMidtoneReset,
    ["logShadowReset"] = logShadowReset,
    ["logOffsetB"] = logOffsetB,
    ["logOffsetG"] = logOffsetG,
    ["logOffsetR"] = logOffsetR,
    ["logHighlightsB"] = logHighlightsB,
    ["logHighlightsG"] = logHighlightsG,
    ["logHighlightsR"] = logHighlightsR,
    ["logMidtoneB"] = logMidtoneB,
    ["logMidtoneG"] = logMidtoneG,
    ["logMidtoneR"] = logMidtoneR,
    ["logShadowB"] = logShadowB,
    ["logShadowG"] = logShadowG,
    ["logShadowR"] = logShadowR,
    ["logFourthJog"] = logFourthJog,
    ["logThirdJog"] = logThirdJog,
    ["logSecondJog"] = logSecondJog,
    ["logFirstJog"] = logFirstJog,
    ["logFourthWheelY"] = logFourthWheelY,
    ["logFourthWheelX"] = logFourthWheelX,
    ["logThirdWheelY"] = logThirdWheelY,
    ["logThirdWheelX"] = logThirdWheelX,
    ["logSecondWheelY"] = logSecondWheelY,
    ["logSecondWheelX"] = logSecondWheelX,
    ["logFirstWheelY"] = logFirstWheelY,
    ["logFirstWheelX"] = logFirstWheelX,
    ["barsOffsetB"] = barsOffsetB,
    ["barsOffsetG"] = barsOffsetG,
    ["barsOffsetR"] = barsOffsetR,
    ["barsGainY"] = barsGainY,
    ["barsGainB"] = barsGainB,
    ["barsGainG"] = barsGainG,
    ["barsGainR"] = barsGainR,
    ["barsGammaB"] = barsGammaB,
    ["barsGammaG"] = barsGammaG,
    ["barsGammaR"] = barsGammaR,
    ["barsGammaY"] = barsGammaY,
    ["barsLiftY"] = barsLiftY,
    ["barsLiftB"] = barsLiftB,
    ["barsLiftG"] = barsLiftG,
    ["barsLiftR"] = barsLiftR,
    ["barsWhitePointPicker"] = barsWhitePointPicker,
    ["barsBlackPointPicker"] = barsBlackPointPicker,
    ["barsColorPicker"] = barsColorPicker,
    ["barsAWB"] = barsAWB,
    ["barsResetAll"] = barsResetAll,
    ["barsResetOffset"] = barsResetOffset,
    ["barsResetGain"] = barsResetGain,
    ["barsResetGamma"] = barsResetGamma,
    ["barsResetLift"] = barsResetLift,
    ["barsLumMix"] = barsLumMix,
    ["barsMidDetail"] = barsMidDetail,
    ["barsHue"] = barsHue,
    ["barsSaturation"] = barsSaturation,
    ["barsHighlight"] = barsHighlight,
    ["barsShadow"] = barsShadow,
    ["barsCoolBoost"] = barsCoolBoost,
    ["barsPivot"] = barsPivot,
    ["barsContrast"] = barsContrast,
    ["barsTint"] = barsTint,
    ["barsTemperature"] = barsTemperature,
    ["primariesOffsetB"] = primariesOffsetB,
    ["primariesOffsetG"] = primariesOffsetG,
    ["primariesOffsetR"] = primariesOffsetR,
    ["primariesGainY"] = primariesGainY,
    ["primariesGainB"] = primariesGainB,
    ["primariesGainG"] = primariesGainG,
    ["primariesGainR"] = primariesGainR,
    ["primariesGammaB"] = primariesGammaB,
    ["primariesGammaG"] = primariesGammaG,
    ["primariesGammaR"] = primariesGammaR,
    ["primariesGammaY"] = primariesGammaY,
    ["primariesLiftY"] = primariesLiftY,
    ["primariesLiftB"] = primariesLiftB,
    ["primariesLiftG"] = primariesLiftG,
    ["primariesLiftR"] = primariesLiftR,
    ["primariesWhitePointPicker"] = primariesWhitePointPicker,
    ["primariesBlackPointPicker"] = primariesBlackPointPicker,
    ["primariesColorPicker"] = primariesColorPicker,
    ["primariesAWB"] = primariesAWB,
    ["primariesResetAll"] = primariesResetAll,
    ["primariesResetOffset"] = primariesResetOffset,
    ["primariesResetGain"] = primariesResetGain,
    ["primariesResetGamma"] = primariesResetGamma,
    ["primariesResetLift"] = primariesResetLift,
    ["primariesLumMix"] = primariesLumMix,
    ["primariesMidDetail"] = primariesMidDetail,
    ["primariesHue"] = primariesHue,
    ["primariesSaturation"] = primariesSaturation,
    ["primariesHighlight"] = primariesHighlight,
    ["primariesShadow"] = primariesShadow,
    ["primariesCoolBoost"] = primariesCoolBoost,
    ["primariesPivot"] = primariesPivot,
    ["primariesContrast"] = primariesContrast,
    ["primariesTint"] = primariesTint,
    ["primariesTemperature"] = primariesTemperature,
    ["primariesFourthJog"] = primariesFourthJog,
    ["primariesThirdJog"] = primariesThirdJog,
    ["primariesSecondJog"] = primariesSecondJog,
    ["primariesFirstJog"] = primariesFirstJog,
    ["primariesFourthWheelY"] = primariesFourthWheelY,
    ["primariesFourthWheelX"] = primariesFourthWheelX,
    ["primariesThirdWheelY"] = primariesThirdWheelY,
    ["primariesThirdWheelX"] = primariesThirdWheelX,
    ["primariesSecondWheelY"] = primariesSecondWheelY,
    ["primariesSecondWheelX"] = primariesSecondWheelX,
    ["primariesFirstWheelY"] = primariesFirstWheelY,
    ["primariesFirstWheelX"] = primariesFirstWheelX,
    ["hdrZoneFalloff"] = hdrZoneFalloff,
    ["hdrZoneMaxRange"] = hdrZoneMaxRange,
    ["hdrShowHideSpecular"] = hdrShowHideSpecular,
    ["hdrShowHideHighlight"] = hdrShowHideHighlight,
    ["hdrShowHideLight"] = hdrShowHideLight,
    ["hdrShowHideShadow"] = hdrShowHideShadow,
    ["hdrShowHideDark"] = hdrShowHideDark,
    ["hdrShowHideBlack"] = hdrShowHideBlack,
    ["hdrTurnOnOffSpecular"] = hdrTurnOnOffSpecular,
    ["hdrTurnOnOffHighlight"] = hdrTurnOnOffHighlight,
    ["hdrTurnOnOffLight"] = hdrTurnOnOffLight,
    ["hdrTurnOnOffShadow"] = hdrTurnOnOffShadow,
    ["hdrTurnOnOffDark"] = hdrTurnOnOffDark,
    ["hdrTurnOnOffBlack"] = hdrTurnOnOffBlack,
    ["hdrFourthWheelReset"] = hdrFourthWheelReset,
    ["hdrThirdWheelReset"] = hdrThirdWheelReset,
    ["hdrSecondWheelReset"] = hdrSecondWheelReset,
    ["hdrFirstWheelReset"] = hdrFirstWheelReset,
    ["hdrThirdWheelHL"] = hdrThirdWheelHL,
    ["hdrSecondWheelHL"] = hdrSecondWheelHL,
    ["hdrFirstWheelHL"] = hdrFirstWheelHL,
    ["hdrResetZone"] = hdrResetZone,
    ["hdrResetColor"] = hdrResetColor,
    ["hdrResetAll"] = hdrResetAll,
    ["hdrWheelsRight"] = hdrWheelsRight,
    ["hdrWheelsLeft"] = hdrWheelsLeft,
    ["hdrZoneSpecular"] = hdrZoneSpecular,
    ["hdrZoneHighlight"] = hdrZoneHighlight,
    ["hdrZoneLight"] = hdrZoneLight,
    ["hdrZoneShadow"] = hdrZoneShadow,
    ["hdrZoneDark"] = hdrZoneDark,
    ["hdrZoneBlack"] = hdrZoneBlack,
    ["hdrZoneOpenClose"] = hdrZoneOpenClose,
    ["hdrBlackOffset"] = hdrBlackOffset,
    ["hdrMD"] = hdrMD,
    ["hdrPivot"] = hdrPivot,
    ["hdrContrast"] = hdrContrast,
    ["hdrHue"] = hdrHue,
    ["hdrTint"] = hdrTint,
    ["hdrTemperature"] = hdrTemperature,
    ["hdrFourthWheelSaturation"] = hdrFourthWheelSaturation,
    ["hdrFourthWheelExposure"] = hdrFourthWheelExposure,
    ["hdrThirdWheelSaturation"] = hdrThirdWheelSaturation,
    ["hdrThirdWheelExposure"] = hdrThirdWheelExposure,
    ["hdrSecondWheelSaturation"] = hdrSecondWheelSaturation,
    ["hdrSecondWheelExposure"] = hdrSecondWheelExposure,
    ["hdrFirstWheelSaturation"] = hdrFirstWheelSaturation,
    ["hdrFirstWheelExposure"] = hdrFirstWheelExposure,
    ["jogHDRFourthWheel"] = jogHDRFourthWheel,
    ["hdrFalloffThirdWheel"] = hdrFalloffThirdWheel,
    ["hdrFalloffSecondWheel"] = hdrFalloffSecondWheel,
    ["hdrFalloffFirstWheel"] = hdrFalloffFirstWheel,
    ["hdrFourthWheelY"] = hdrFourthWheelY,
    ["hdrFourthWheelX"] = hdrFourthWheelX,
    ["hdrThirdWheelY"] = hdrThirdWheelY,
    ["hdrThirdWheelX"] = hdrThirdWheelX,
    ["hdrSecondWheelY"] = hdrSecondWheelY,
    ["hdrSecondWheelX"] = hdrSecondWheelX,
    ["hdrFirstWheelY"] = hdrFirstWheelY,
    ["hdrFirstWheelX"] = hdrFirstWheelX,
    ["inspectorLinkUnlinkZoom"] = inspectorLinkUnlinkZoom,
    ["inspectorAudioReset"] = inspectorAudioReset,
    ["inspectorTransformReset"] = inspectorTransformReset,
    ["inspectorAudioVolume"] = inspectorAudioVolume,
    ["inspectorFlip"] = inspectorFlip,
    ["inspectorYaw"] = inspectorYaw,
    ["inspectorAnchorPointY"] = inspectorAnchorPointY,
    ["inspectorAnchorPointX"] = inspectorAnchorPointX,
    ["inspectorPitch"] = inspectorPitch,
    ["inspectorPositionY"] = inspectorPositionY,
    ["inspectorPositionX"] = inspectorPositionX,
    ["inspectorRotationAngle"] = inspectorRotationAngle,
    ["inspectorZoomY"] = inspectorZoomY,
    ["inspectorZoomX"] = inspectorZoomX,
    ["goToInspectorWindow"] = goToInspectorWindow,
    ["inOut"] = inOut,
    ["clipEditPointFrameStep"] = clipEditPointFrameStep,
    ["moveTimeline"] = moveTimeline,
    ["timelineZoom"] = timelineZoom,
    ["enterEditMode"] = enterEditMode,
    ["changeEditActiveWindow"] = changeEditActiveWindow,
    ["openCloseRightExpander"] = openCloseRightExpander,
    ["openCloseInspector"] = openCloseInspector,
    ["openCloseMetadata"] = openCloseMetadata,
    ["openCloseMixer"] = openCloseMixer,
    ["openCloseSoundLibrary"] = openCloseSoundLibrary,
    ["openCloseEditIndex"] = openCloseEditIndex,
    ["openCloseEffectsLibrary"] = openCloseEffectsLibrary,
    ["openCloseMediaPool"] = openCloseMediaPool,
    ["openCloseLeftExpander"] = openCloseLeftExpander,
    ["addClipToTheEnd"] = addClipToTheEnd,
    ["fitToFillClip"] = fitToFillClip,
    ["rippleOverwriteClip"] = rippleOverwriteClip,
    ["replaceClip"] = replaceClip,
    ["overwriteClip"] = overwriteClip,
    ["insertClip"] = insertClip,
    ["bladeTool"] = bladeTool,
    ["trimTool"] = trimTool,
    ["selectionTool"] = selectionTool,
    ["altUpDown"] = altUpDown,
    ["leftRightEnter"] = leftRightEnter,
    ["upDownEnter"] = upDownEnter,
    ["selectFwBwActiveTrack"] = selectFwBwActiveTrack,
    ["homeEnd"] = homeEnd,
    ["cut"] = cut,
    ["addAVTransitions"] = addAVTransitions,
    ["retimeClipSpeed"] = retimeClipSpeed,
    ["swapClips"] = swapClips,
    ["selectDeselectAll"] = selectDeselectAll,
    ["selectForwardBackward"] = selectForwardBackward,
    ["addRemoveSetMark"] = addRemoveSetMark,
    ["saveProject"] = saveProject,
    ["toggleFullscreen"] = toggleFullscreen,
    ["pasteAttributes"] = pasteAttributes,
    ["linkUnlinkClips"] = linkUnlinkClips,
    ["pasteKnob"] = pasteKnob,
    ["closestEditPoint"] = closestEditPoint,
    ["closestClipGap"] = closestClipGap,
    ["delEndToPlayhead"] = delEndToPlayhead,
    ["delStartToPlayhead"] = delStartToPlayhead,
    ["cutAllTimelines"] = cutAllTimelines,
}

-- \/ BEGIN OF OSC SERVER \/

-- Setup a new OSC Server:
oscServer = hs.osc.newServer(listeningPort)

-- Setup a callback for the OSC Server:
oscServer:callback(function(obj, addressParts, arguments)

	-- Check if the first part of the address is part of our OSC Triggers table:
	local message = addressParts and addressParts[1]
	if oscTriggers[message] then
		-- We only care about the first argument		
		local firstArgument = arguments and arguments[1]
		
		-- If it is, we trigger that function:
		oscTriggers[message](firstArgument)
	else
		-- Print a debug message:
		print(string.format([[
			Unknown OSC Message Received:
			 - obj: %s
			 - addressParts: %s
			 - arguments: %s
		]], obj, hs.inspect(addressParts), hs.inspect(arguments))) 
	end
end)

-- Start the OSC Server:
oscServer:start()

-- /\ END OF OSC SERVER /\
