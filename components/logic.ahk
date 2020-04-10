
deleteOldLogFiles(){
	global

    oldLogFileNum := clipFiles.count() - maxClipFileNum
    loop, %oldLogFileNum% {
        FileDelete, % clipLogDir . clipFiles[A_Index]
    }

	if(oldLogFileNum > 0){
		newClipFiles := []
		loop, %maxClipFileNum% {
			newClipFiles.Push(clipFiles[A_Index + oldLogFileNum])
		}
		clipFiles := newClipFiles
		newClipFiles := []
	}

}

;-------------------------------------------------------

deleteClipFileName(place){
	global
	return clipFiles.removeAt(clipFiles.count() - place)
}

getClipFileName(place){
	global
	return clipFiles[clipFiles.count() - place]
}

getClipFilePath(place){
	global
	return clipLogDir . getClipFileName(place)
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
		clipType := getExtension(getClipFileName(clipCursorPos))
		return true
	} else{
		return false
	}
}

calcPlace(place = ""){
	global
	
	if(place == ""){
		return clipCursorPos
	} else if(place == "+"){
		return clipCursorPos +1
	} else if(place == "-"){
		return clipCursorPos -1
	} else if place is Integer
	{
		return place
	} else{
		Throw errorWrongParameter
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

;------------------------------------------------

waitForClipboard(dataToWaitFor = false){
	global

	if(dataToWaitFor == false)
		dataToWaitFor = ClipboardAll
	tmpTime := minwaitForClipboard + (StrLen(dataToWaitFor) / divisionalForClipboardWait)
	sleep tmpTime
}

;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------

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

        deleteOldLogFiles()

		scriptIsModifyingClipboard := false
	}
	
}

;--------------------------------------------------------------------------------------------------

changeClip(place = "", force = false, showPreview = true){
	global
	
    GDIP_StartDraw()

	if( !hasClipFiles() ){
		ToolTip, %errorNoClipHistory%
		return
	}
	
	changed := false
	
	if( place == "+" ){
		changed := setClipCursorPos(clipCursorPos +1, force)
	} else if( place == "-" ){
		changed := setClipCursorPos(clipCursorPos -1, force)
	} else if place is Integer
	{
		changed := setClipCursorPos(place, force)
		if( !changed && place != clipCursorPos){
			ToolTip, %errorNoClipAtIndex%
			return
		}
	}
	
	if(changed){
		readClipFromFile(getClipFilePath(clipCursorPos))
	}

	if(showPreview){
		showClipPreview(clipCursorPos, clipType)
	}

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
		
		readClipFromFile(clipLogDir . getClipFileName(place))
		Send, ^v
		waitForClipboard()

		Clipboard := clipSave
		waitForClipboard(clipSave)
		gosub setStateReady
	}

}

deleteClip(place = "", maintainCursorPos = true){
	global
	
	placeToDelete := calcPlace(place)
	if(scriptIsModifyingClipboard == false && hasClipFile(placeToDelete)){
		scriptIsModifyingClipboard := true

		FileDelete % getClipFilePath(placeToDelete)
		deleteClipFileName(placeToDelete)
	} else{
		ToolTip, %errorNoClipAtIndex%
		return
	}

	deletedClipText := "Deleted clip: " . placeToDelete
	
	placeToMove := clipCursorPos
	if(placeToDelete <= clipCursorPos){
		if(maintainCursorPos){
			if(!hasClipFile(placeToMove))
				placeToMove--
		} else{
			placeToMove--
			if(!hasClipFile(placeToMove))
				placeToMove++
		}

		if(hasClipFile(placeToMove)){
			changeClip(placeToMove, true, false)
		} else{
			Clipboard := ""
			Tooltip % deletedClipText . "`nNo clip is left to change to"
			return
		}
	}
	
	Tooltip % deletedClipText . "`nCurrent clip: " . clipCursorPos . "`nNumber of clips remaining: " . clipFiles.Count()

}

;--------------------------------------------------------------------------------------------------

setQuickClip(place){
	global

	if( !hasClipFiles() ){
		ToolTip, %errorCantSetQSlot% %place%`n%errorNoClipHistory%
		return
	}

	if(quickClipFiles[place])
		FileDelete, %quickClipLogDir%%place%.*
	else
		quickClipFiles[place] := true

	sourceFile := getClipFilePath(clipCursorPos)
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
	
	GDIP_StartDraw()

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
		waitForClipboard()

		Clipboard := clipSave
		waitForClipboard(clipSave)
	}
	
	gosub setStateReady

}

deleteQuickClip(place){
	global

	if(quickClipFiles[place]){
		FileDelete, %quickClipLogDir%%place%.*
		quickClipFiles[place] := false
		
		ToolTip, %notifyDelQSlot% %place%
	}
}