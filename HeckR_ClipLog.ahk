
#include <GDIP_All>
#include <GDIPHelper>

;-------------------------------------------------------

#SingleInstance Force
#MaxHotkeysPerInterval 2000

;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------

AutoTrim, Off
CoordMode, Mouse, Screen
OnClipboardChange("saveClipb")

;-------------------------------------------------------

GDIP_SetUp()

;-------------------------------------------------------

gosub SetupClipLab

;-------------------------------------------------------
;-------------------------------------------------------


SetupClipLab:

	mainDir=%A_ScriptDir%\log
	logDir=%mainDir%\%A_ComputerName%
	clipLogDir=%logDir%\clipLogDir
	quickClipLogDir=%logDir%\quickClipLogDir

	if !FileExist(mainDir)
		FileCreateDir %mainDir%
	if !FileExist(logDir)
		FileCreateDir %logDir%
	if !FileExist(clipLogDir)
		FileCreateDir %clipLogDir%
	if !FileExist(quickClipLogDir)
		FileCreateDir %quickClipLogDir%

	clipTextExt := "clog"
	clipPicExt := "plog"
	clipErrorExt := "elog"

	errorCorruptStr := "Corrupt file"
	errorImageCopyStr := "Something went wrong while copying the image"
	errorTypeStr := "Corrupt file`nCan't determine the type of the data"
	errorNoSuchTypeStr := "The file is of an unkown type"

	userClipRestoreTime := 1000

	clipSwitchOn := false
	clipCursorPos := 0
	clipType := ""
	clipSize := 0
	
	prevClipData := ""
	prevClipType := ""
	prevClipSize := 0
	
	scriptIsModifyingClipboard := false


	clipFiles := []
	Loop, Files, %clipLogDir%\*.?log
	{
		clipFiles[A_Index-1] := A_LoopFileName
	}


	quickClipFiles := []
	Loop, 10 {
		quickClipFiles[A_Index] := false
	}
	Loop, Files, %quickClipLogDir%\*.?log
	{
		tmpFileName := StrSplit(A_LoopFileName, ".")[1]
		quickClipFiles[tmpFileName] := true
	}
	
	if(hasClipFiles()){
		readClipFromFile(clipLogDir . "\" . getClipFile(clipCursorPos))
		clipType := getExtension(getClipFile(clipCursorPos))
	}

return

;-------------------------------------------------------

#Left::changeClip("+")
#Right::changeClip("-")
#Up::changeClip()
#Down::changeClip()

#0::
#Numpad0::
	changeClip(0)
return

#1::
#Numpad1::
	changeClip(1)
return

#2::
#Numpad2::
	changeClip(2)
return

#3::
#Numpad3::
	changeClip(3)
return

#4::
#Numpad4::
	changeClip(4)
return

#5::
#Numpad5::
	changeClip(5)
return

#6::
#Numpad6::
	changeClip(6)
return

#7::
#Numpad7::
	changeClip(7)
return

#8::
#Numpad8::
	changeClip(8)
return

#9::
#Numpad9::
	changeClip(9)
return

;-----------------------

#!0::
#!Numpad0::
	instantPaste(0)
return

#!1::
#!Numpad1::
	instantPaste(1)
return

#!2::
#!Numpad2::
	instantPaste(2)
return

#!3::
#!Numpad3::
	instantPaste(3)
return

#!4::
#!Numpad4::
	instantPaste(4)
return

#!5::
#!Numpad5::
	instantPaste(5)
return

#!6::
#!Numpad6::
	instantPaste(6)
return

#!7::
#!Numpad7::
	instantPaste(7)
return

#!8::
#!Numpad8::
	instantPaste(8)
return

#!9::
#!Numpad9::
	instantPaste(9)
return

;-----------------------
;-----------------------

+^#0::
^#NumpadIns::
	setQuickClip(0)
return

+^#1::
^#NumpadEnd::
	setQuickClip(1)
return

+^#2::
^#NumpadDown::
	setQuickClip(2)
return

+^#3::
^#NumpadPgdn::
	setQuickClip(3)
return

+^#4::
^#NumpadLeft::
	setQuickClip(4)
return

+^#5::
^#NumpadClear::
	setQuickClip(5)
return

+^#6::
^#NumpadRight::
	setQuickClip(6)
return

+^#7::
^#NumpadHome::
	setQuickClip(7)
return

+^#8::
^#NumpadUp::
	setQuickClip(8)
return

+^#9::
^#NumpadPgup::
	setQuickClip(9)
return

;-----------------------

^#0::
^#Numpad0::
	peekQuickClip(0)
return

^#1::
^#Numpad1::
	peekQuickClip(1)
return

^#2::
^#Numpad2::
	peekQuickClip(2)
return

^#3::
^#Numpad3::
	peekQuickClip(3)
return

^#4::
^#Numpad4::
	peekQuickClip(4)
return

^#5::
^#Numpad5::
	peekQuickClip(5)
return

^#6::
^#Numpad6::
	peekQuickClip(6)
return

^#7::
^#Numpad7::
	peekQuickClip(7)
return

^#8::
^#Numpad8::
	peekQuickClip(8)
return

^#9::
^#Numpad9::
	peekQuickClip(9)
return

;-----------------------

^#!0::
^#!Numpad0::
	pasteQuickClip(0)
return

^#!1::
^#!Numpad1::
	pasteQuickClip(1)
return

^#!2::
^#!Numpad2::
	pasteQuickClip(2)
return

^#!3::
^#!Numpad3::
	pasteQuickClip(3)
return

^#!4::
^#!Numpad4::
	pasteQuickClip(4)
return

^#!5::
^#!Numpad5::
	pasteQuickClip(5)
return

^#!6::
^#!Numpad6::
	pasteQuickClip(6)
return

^#!7::
^#!Numpad7::
	pasteQuickClip(7)
return

^#!8::
^#!Numpad8::
	pasteQuickClip(8)
return

^#!9::
^#!Numpad9::
	pasteQuickClip(9)
return

;-----------------------

+^#!0::
^#!NumpadIns::
	deleteQuickClip(0)
return

+^#!1::
^#!NumpadEnd::
	deleteQuickClip(1)
return

+^#!2::
^#!NumpadDown::
	deleteQuickClip(2)
return

+^#!3::
^#!NumpadPgdn::
	deleteQuickClip(3)
return

+^#!4::
^#!NumpadLeft::
	deleteQuickClip(4)
return

+^#!5::
^#!NumpadClear::
	deleteQuickClip(5)
return

+^#!6::
^#!NumpadRight::
	deleteQuickClip(6)
return

+^#!7::
^#!NumpadHome::
	deleteQuickClip(7)
return

+^#!8::
^#!NumpadUp::
	deleteQuickClip(8)
return

+^#!9::
^#!NumpadPgup::
	deleteQuickClip(9)
return

;-------------------------------------------------------

#if clipSwitchOn

	Ctrl Up::
	LWin Up::
	Alt Up::
	setStateReady:
		GDIP_Clean()
		GDIP_Update()
    	GDIP_EndDraw()

		clipSwitchOn := false
		scriptIsModifyingClipboard := false
		tooltip
	return

#if

;-------------------------------------------------------

getClipFile(index){
	global
	return clipFiles[clipFiles.count() - index -1]
}

hasClipFiles(){
	global
	return (clipFiles.count() != 0)
}

setClipCursorPos(index, new := false){
	global
	
	if((index != clipCursorPos || new == true) && index >= 0 && index < clipFiles.count()){
		clipCursorPos := index
		clipType := getExtension(getClipFile(clipCursorPos))
		return true
	} else{
		return false
	}
}

getExtension(fileName){
	fileNameArr := StrSplit(fileName, ".")
	return fileNameArr[fileNameArr.MaxIndex()]
}

getUniqueFileExtension(extLessFileWithPath){
	Loop, Files, %extLessFileWithPath%.*
	{
		return getExtension(A_LoopFileName)
	}
}

readClipFromFile(filePathToRead){
	global
	scriptIsModifyingClipboard = true
	
	try {
		FileRead, Clipboard, *c %filePathToRead%
	} catch e {
		MsgBox, Can't read the file for some reason\nIn order to avoid further problems the file gets deleted and the script restarts
		FileDelete, %clipLogDir%\%prevClipFile%
		Reload
	}

}

;-------------------------------------------------------

waitAfterPaste:
	tmpClip := ClipboardAll
	tmpTime := 50 + (StrLen(tmpClip) / 20000)
	sleep tmpTime
return

;-------------------------------------------------------
;-------------------------------------------------------

saveClipb(clipTypeID){
	global
	
	;This sleep is needed for some screen snipping tools since they modify the clipboard mltiple times, but only the last modification is the needed result, the rest are useless junk
	sleep 100
	
	if(scriptIsModifyingClipboard == false){
		scriptIsModifyingClipboard := true
		
		FormatTime, clipFile ,, yyyy-MM-dd_HH-mm-ss
		clipFile=%clipFile%.%A_MSec%
		clipFileNoExt := clipFile
		
		clipData := ClipboardAll
		clipSize := StrLen(clipData)

		if( clipTypeID == 2 && StrLen(clipData) <= 244 ) {
			clipType=%clipErrorExt%
			Clipboard := errorCorruptStr . "`n" . errorImageCopyStr
		}
		else if( (clipTypeID == 1) || (clipTypeID == 0) ){
			clipType=%clipTextExt%
		}
		else if(clipTypeID == 2){
			clipType=%clipPicExt%
		}
		else {
			clipType=%clipErrorExt%
			Clipboard := errorCorruptStr . "`n" . errorTypeStr
		}

		differentFromLastData := true
		if(hasClipFiles() && clipType == prevClipType && clipSize == prevClipSize ){
			if clipData = %prevClipData%
				differentFromLastData := false
		}
		
		if(differentFromLastData == true){
			clipFile=%clipFile%.%clipType%

			clipFiles.Push(clipFile)
			FileAppend, %ClipboardAll%, %clipLogDir%\%clipFile%
		}
		setClipCursorPos(0, true)

		prevClipData := clipData
		prevClipSaveFile := clipFile
		prevClipType := clipType
		prevClipSize := clipSize

		scriptIsModifyingClipboard := false
	}
	
}



changeClip(place = ""){
	global
	
	if(!clipSwitchOn){
    	GDIP_StartDraw()
		clipSwitchOn := true
	}

	if( !hasClipFiles() ){
		ToolTip, The clipboard history is empty
		return
	}
	
	prevClipFile := getClipFile(clipCursorPos)
	
	changed := false
	
	if( place == "+" ){
		changed := setClipCursorPos(clipCursorPos +1, false)
	} else if( place == "-" ){
		changed := setClipCursorPos(clipCursorPos -1)
	} else if place is Integer
	{
		changed := setClipCursorPos(place)
		if( !changed ){
			ToolTip, No clipboard data can be found at this index
			return
		}
	}
	
	if(changed){
		readClipFromFile(clipLogDir . "\" . getClipFile(clipCursorPos))
	}

	showClipPreview(clipCursorPos, clipType)

}


showClipPreview(tooltipIndex, cType){
	global

	GDIP_Clean()
	GDIP_Update()

	if(cType == clipTextExt){
		if(StrLen(Clipboard) > 1000)
			prevStr := SubStr(Clipboard, 1 , 1000)
		else
			prevStr := Clipboard
		ToolTip %tooltipIndex%`n%prevStr%
	}
	else if(cType == clipPicExt){
		ToolTip %tooltipIndex%

		clipPicBitmap := Gdip_CreateBitmapFromClipboard()
		
		picW := Gdip_GetImageWidth(clipPicBitmap)
		picH := Gdip_GetImageHeight(clipPicBitmap)

		if( (picW*4 > A_ScreenWidth) || (picH*4 > A_ScreenHeight) ){
			screenRatio := A_ScreenWidth / A_ScreenHeight
			picRatio := picW / picH

			if(picRatio > screenRatio)
				scaleClipPic := A_ScreenWidth / picW / 4
			else
				scaleClipPic := A_ScreenWidth / picH / 4
				
			clipPicW := scaleClipPic * picW
			clipPicH := scaleClipPic * picH
		} else{
			clipPicW := picW
			clipPicH := picH
		}

		MouseGetPos, xPos, yPos
		
		Gdip_DrawImage(G, clipPicBitmap, -leftMostPoint+xPos+16, -topMostPoint+yPos+16, clipPicW, clipPicH)
		GDIP_Update()
	}
	else{
		ToolTip %errorNoSuchTypeStr%
	}
	
}

instantPaste(place){
	global
	
	if(scriptIsModifyingClipboard == false && place >= 0 && place < clipFiles.count()){
		scriptIsModifyingClipboard := true

		clipSave := ClipboardAll
		
		readClipFromFile(clipLogDir . "\" . getClipFile(place))
		Send, ^v
		gosub waitAfterPaste

		Clipboard := clipSave
		
		gosub waitAfterPaste
		scriptIsModifyingClipboard := false
	}

}

setQuickClip(place){
	global

	if( !hasClipFiles() ){
		clipSwitchOn := true
		ToolTip, Can't set quick slot %place%`nThe clipboard history is empty
		return
	}

	if(quickClipFiles[place])
		FileDelete, %quickClipLogDir%\%place%.*
	else
		quickClipFiles[place] := true

	sourceFile := clipLogDir . "\" . getClipFile(clipCursorPos)
	destinationFile := quickClipLogDir . "\" . place . "." . clipType
	
	FileCopy, %sourceFile%, %destinationFile%, 1

	changeClip()
	ControlGetText,tmpTooltipText,,ahk_class tooltips_class32
	startOfSecondLine := InStr(tmpTooltipText, "`n")+1
	if( startOfSecondLine == 1 || StrLen(tmpTooltipText) < startOfSecondLine)
		tmpTooltipText := ""
	else
		tmpTooltipText := SubStr(tmpTooltipText, startOfSecondLine)
	Tooltip Clip saved to quick slot %place%`n%tmpTooltipText%

}

peekQuickClip(place){
	global
	
	if(!clipSwitchOn)
		GDIP_StartDraw()
	clipSwitchOn := true

	if(quickClipFiles[place]){
		scriptIsModifyingClipboard := true
		
		clipSave := ClipboardAll

		quickClipFile := quickClipLogDir . "\" . place
		quickClipType := getUniqueFileExtension(quickClipFile)

		readClipFromFile(quickClipLogDir . "\" . place . "." . quickClipType)
		showClipPreview(place, quickClipType)

		Clipboard := clipSave

	}
	else{
		GDIP_Clean()
		GDIP_Update()
		ToolTip, %place%`nNo clipboard data can be found at this index
	}

}

pasteQuickClip(place){
	global
	
	if(scriptIsModifyingClipboard == false && quickClipFiles[place]){
		scriptIsModifyingClipboard := true

		clipSave := ClipboardAll

		quickClipFile := quickClipLogDir . "\" . place
		quickClipType := getUniqueFileExtension(quickClipFile)

		readClipFromFile(quickClipLogDir . "\" . place . "." . quickClipFile)
		Send, ^v
		gosub waitAfterPaste

		Clipboard := clipSave
		
		gosub waitAfterPaste

		scriptIsModifyingClipboard := false
	}

}

deleteQuickClip(place){
	global

	if(quickClipFiles[place]){
		FileDelete, %quickClipLogDir%\%place%.*
		quickClipFiles[place] := false
		
		clipSwitchOn := true
		ToolTip, Deleted quick slot %place%
	}
}