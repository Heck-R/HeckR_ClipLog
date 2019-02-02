
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

	userClipRestoreTime := 1000

	clipSwitchOn := false
	clipCursorPos := 0
	clipFileName := ""
	clipType := ""
	userClip := true
	filePathToRead := ""

	FileList := ""
	Loop, Files, %clipLogDir%\*.?log
	{
		FileList = %FileList%%A_LoopFileName%:
		Sort, FileList, D:
	}

	clipFiles := StrSplit(FileList, ":")
	clipFiles.remove(clipFiles.length())
	FileList=


	quickClipFiles := []
	Loop, 10 {
		quickClipFiles[A_Index] := false
	}
	Loop, Files, %quickClipLogDir%\*.?log
	{
		tmpFileName := A_LoopFileName
		tmpFileName := StrSplit(tmpFileName, ".")
		tmpFileName := tmpFileName[1]
		
		quickClipFiles[tmpFileName] := true
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
		GDIP_Clean()
		GDIP_Update()
    	GDIP_EndDraw()

		clipSwitchOn := false
		userClip := true
		tooltip
	return

#if

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
	
	if(userClip == true){
		userClip := false
		
		FormatTime, clipFile ,, yyyy-MM-dd_HH-mm-ss
		clipFile=%clipFile%.%A_MSec%
		clipFileNoExt := clipFile
		
		clipTMP := ClipboardAll
		currSize := StrLen(clipTMP)

		if( clipTypeID == 2 && StrLen(clipTMP) <= 244 ) {
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

		if( prevClipTick && A_TickCount-prevClipTick < 1000 ){
			if(clipTypeID == 2 && prevSize == currSize ){
				return
			}
			else if( (prevClipType == clipErrorExt) && (clipType == clipTextExt) && (SubStr(Clipboard, 1, 12) == errorCorruptStr) ){
				return
			}
		}
		
		clipFile=%clipFile%.%clipType%

		clipFiles.Push(clipFile)
		FileAppend, %ClipboardAll%, %clipLogDir%\%clipFile%
		clipCursorPos := 0

		prevClipTick := A_TickCount
		prevClipFile := clipFile
		prevClipType := clipType
		prevSize := currSize

		userClip := true
	}
	
}



changeClip(place = ""){

	global

	if(!clipSwitchOn)
    	GDIP_StartDraw()

	clipSwitchOn := true
	
	if( clipFiles.length() == 0 ){
		ToolTip, The clipboard history is empty
		return
	}

	if( (place == "+") && (clipCursorPos < clipFiles.length()-1) )
		clipCursorPos++
	else if( (place == "-" ) && (clipCursorPos > 0) )
		clipCursorPos--
	else if place is Integer
	{
		if( (place >= 0) && (place < clipFiles.length()) )
			clipCursorPos := place
		else{
			ToolTip, No clipboard data can be found at this index
			return
		}
	}
	else{
		gosub SetBasicData
		gosub ShowClipPreview
		return
	}
	
	gosub SetBasicData
	
	filePathToRead := clipLogDir . "\" . clipFileName
	gosub ReadClipFromFile
	
	gosub ShowClipPreview

}



SetBasicData:
	clipFileName := clipFiles[clipFiles.length()-clipCursorPos]
	gosub SetClipType
return
SetClipType:
	if(InStr(clipFileName, clipPicExt) > 0)
		clipType := clipPicExt
	else if(InStr(clipFileName, clipTextExt) > 0)
		clipType := clipTextExt
	else
		clipType := clipErrorExt
return



ReadClipFromFile:
	
	userClip := false
	
	FileRead, Clipboard, *c %filePathToRead%

return



ShowClipPreview:
	
	GDIP_Clean()
	GDIP_Update()

	if(clipType == clipTextExt){
		if(StrLen(Clipboard) > 1000)
			prevStr := SubStr(Clipboard, 1 , 1000)
		else
			prevStr := Clipboard
		ToolTip %clipCursorPos%`n%prevStr%
	}
	else if(clipType == clipPicExt){
		ToolTip %clipCursorPos%

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
		ToolTip %clipCursorPos%`n%Clipboard%
	}
	

return

instantPaste(place){
	global
	
	if(userClip && place < clipFiles.length()){
		userClip := false

		clipSave := ClipboardAll
		clipCursorTmp := clipCursorPos
		clipCursorPos := place
		
		gosub SetBasicData
		filePathToRead := clipLogDir . "\" . clipFileName
		
		gosub ReadClipFromFile
		Send, ^v
		gosub waitAfterPaste

		Clipboard := clipSave
		clipCursorPos := clipCursorTmp
		gosub SetBasicData
		
		gosub waitAfterPaste
		userClip := true
	}

}

setQuickClip(place){
	global

	if( clipFiles.length() == 0 ){
		clipSwitchOn := true
		ToolTip, Can't set quick slot %place%`nThe clipboard history is empty
		return
	}

	if(quickClipFiles[place])
		FileDelete, %quickClipLogDir%\%place%.*
	else
		quickClipFiles[place] := true

	gosub SetBasicData

	sourceFile := clipLogDir . "\" . clipFileName
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
		
		userClip := false
		
		clipSave := ClipboardAll
		clipCursorTmp := clipCursorPos
		clipCursorPos := place

		if(FileExist(quickClipLogDir . "\" . place . "." . clipPicExt))
			clipType := clipPicExt
		else if(FileExist(quickClipLogDir . "\" . place . "." . clipTextExt))
			clipType := clipTextExt
		else
			clipType := clipErrorExt

		filePathToRead := quickClipLogDir . "\" . place . "." . clipType
		gosub ReadClipFromFile
		gosub ShowClipPreview

		Clipboard := clipSave
		clipCursorPos := clipCursorTmp
		gosub SetBasicData

	}
	else{
		GDIP_Clean()
		GDIP_Update()
		ToolTip, No clipboard data can be found at this index
	}

}

pasteQuickClip(place){
	global
	
	if(userClip && quickClipFiles[place]){
		userClip := false

		clipSave := ClipboardAll
		clipCursorTmp := clipCursorPos
		clipCursorPos := place

		if(FileExist(quickClipLogDir . "\" . place . "." . clipPicExt))
			clipType := clipPicExt
		else if(FileExist(quickClipLogDir . "\" . place . "." . clipTextExt))
			clipType := clipTextExt
		else
			clipType := clipErrorExt

		filePathToRead := quickClipLogDir . "\" . place . "." . clipType

		gosub ReadClipFromFile
		Send, ^v
		gosub waitAfterPaste

		Clipboard := clipSave
		clipCursorPos := clipCursorTmp
		gosub SetBasicData
		
		gosub waitAfterPaste
		userClip := true
		
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