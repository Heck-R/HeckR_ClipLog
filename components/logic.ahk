
DeleteTooOldLogFiles:

    oldLogFileNum := clipFiles.count() - maxClipFileNum
    loop, %oldLogFileNum% {
        FileDelete, % clipLogDir . clipFiles[A_Index-1]
    }

return

;-------------------------------------------------------

getClipFile(index){
	global
	return clipFiles[clipFiles.count() - index -1]
}

hasClipFiles(){
	global
	return (clipFiles.count() != 0)
}

hasClipFile(index){
	global
	return (index >= 0 && index < clipFiles.count() && index < maxClipFileNum)
}

setClipCursorPos(index, new := false){
	global
	
	if((index != clipCursorPos || new == true) && hasClipFile(index)){
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
		MsgBox, %errorCantReadClipFile%`n`nFile:`n%filePathToRead%
		FileDelete, %clipLogDir%%filePathToRead%
		Reload
	}

}

;-------------------------------------------------------

waitAfterPaste:
	tmpClip := ClipboardAll
	tmpTime := minWaitAfterPaste + (StrLen(tmpClip) / divisionalAfterPaste)
	sleep tmpTime
return

;-------------------------------------------------------
;-------------------------------------------------------

saveClipb(clipTypeID){
	global
	
	;This sleep is needed for some screen snipping tools since they modify the clipboard mltiple times, but only the last modification is the needed result, the rest are useless junk
	sleep sleepTimeBeforeSaveClip
	
	if(scriptIsModifyingClipboard == false){
		scriptIsModifyingClipboard := true
		
		FormatTime, clipFile ,, %fileTimeFormat%
		clipFile=%clipFile%.%A_MSec%
		clipFileNoExt := clipFile
		
		clipData := ClipboardAll
		clipSize := StrLen(clipData)

		if( (clipTypeID == 1) || (clipTypeID == 0) ){
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
			FileAppend, %ClipboardAll%, %clipLogDir%%clipFile%
		}
		setClipCursorPos(0, true)

		prevClipData := clipData
		prevClipSaveFile := clipFile
		prevClipType := clipType
		prevClipSize := clipSize

        gosub DeleteTooOldLogFiles

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
		ToolTip, %errorNoClipHistory%
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
		if( !changed && place != clipCursorPos){
			ToolTip, %errorNoClipAtIndex%
			return
		}
	}
	
	if(changed){
		readClipFromFile(clipLogDir . getClipFile(clipCursorPos))
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
	
	if(scriptIsModifyingClipboard == false && hasClipFile(place)){
		scriptIsModifyingClipboard := true

		clipSave := ClipboardAll
		
		readClipFromFile(clipLogDir . getClipFile(place))
		Send, ^v
		gosub waitAfterPaste

		Clipboard := clipSave
	}

}

setQuickClip(place){
	global

	if( !hasClipFiles() ){
		clipSwitchOn := true
		ToolTip, %errorCantSetQSlot% %place%`n%errorNoClipHistory%
		return
	}

	if(quickClipFiles[place])
		FileDelete, %quickClipLogDir%%place%.*
	else
		quickClipFiles[place] := true

	sourceFile := clipLogDir . getClipFile(clipCursorPos)
	destinationFile := quickClipLogDir . place . "." . clipType
	
	FileCopy, %sourceFile%, %destinationFile%, 1

	changeClip()
	ControlGetText,tmpTooltipText,,ahk_class tooltips_class32
	startOfSecondLine := InStr(tmpTooltipText, "`n")+1
	if( startOfSecondLine == 1 || StrLen(tmpTooltipText) < startOfSecondLine)
		tmpTooltipText := ""
	else
		tmpTooltipText := SubStr(tmpTooltipText, startOfSecondLine)
	Tooltip %notifySavedQSlot% %place%`n%tmpTooltipText%

}

peekQuickClip(place){
	global
	
	if(!clipSwitchOn){
		GDIP_StartDraw()
		clipSwitchOn := true
	}

	if(quickClipFiles[place]){
		scriptIsModifyingClipboard := true
		
		clipSave := ClipboardAll

		quickClipFile := quickClipLogDir . place
		quickClipType := getUniqueFileExtension(quickClipFile)

		readClipFromFile(quickClipFile . "." . quickClipType)
		showClipPreview(place, quickClipType)

		Clipboard := clipSave
	}
	else{
		GDIP_Clean()
		GDIP_Update()
		ToolTip, %place%`n%errorNoClipAtIndex%
	}

}

pasteQuickClip(place){
	global
	
	if(scriptIsModifyingClipboard == false && quickClipFiles[place]){
		scriptIsModifyingClipboard := true

		clipSave := ClipboardAll

		quickClipFile := quickClipLogDir . place
		quickClipType := getUniqueFileExtension(quickClipFile)

		readClipFromFile(quickClipFile . "." . quickClipType)
		Send, ^v
		gosub waitAfterPaste

		Clipboard := clipSave
	}

}

deleteQuickClip(place){
	global

	if(quickClipFiles[place]){
		FileDelete, %quickClipLogDir%%place%.*
		quickClipFiles[place] := false
		
		clipSwitchOn := true
		ToolTip, %notifyDelQSlot% %place%
	}
}