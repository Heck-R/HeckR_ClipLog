
deleteOldLogFiles() {
	global

    oldLogFileNum := clipFiles.count() - maxClipFileNum
    loop, %oldLogFileNum% {
        FileDelete, % clipLogDir . clipFiles[A_Index]
    }

	if (oldLogFileNum > 0) {
		newClipFiles := []
		loop, %maxClipFileNum% {
			newClipFiles.Push(clipFiles[A_Index + oldLogFileNum])
		}
		clipFiles := newClipFiles
		newClipFiles := []
	}
}

;-------------------------------------------------------

deleteClipFileName(place) {
	global
	return clipFiles.removeAt(clipFiles.count() - place)
}

getClipFileName(place) {
	global
	return clipFiles[clipFiles.count() - place]
}

getClipFilePath(place) {
	global
	return clipLogDir . getClipFileName(place)
}

hasClipFiles() {
	global
	return (clipFiles.count() != 0)
}

hasClipFile(index) {
	global
	return (index >= 0 && index < clipFiles.count() && index < maxClipFileNum)
}

setClipCursorPos(index, force := false) {
	global
	
	if ((index != clipCursorPos || force == true) && hasClipFile(index)) {
		clipCursorPos := index
		clipType := getExtension(getClipFileName(clipCursorPos))
		return true
	} else {
		return false
	}
}

calcPlace(place = "") {
	global
	
	if (place == "") {
		return clipCursorPos
	} else if (place == "+") {
		return clipCursorPos +1
	} else if (place == "-") {
		return clipCursorPos -1
	} else if place is Integer
	{
		return place
	} else {
		Throw errorWrongParameter
	}
}

getExtension(fileName) {
	fileNameArr := StrSplit(fileName, ".")
	return fileNameArr[fileNameArr.MaxIndex()]
}

getUniqueFileExtension(extLessFilePath) {
	Loop, Files, %extLessFilePath%.*
	{
		return getExtension(A_LoopFileName)
	}
}

getCurrentCustomQuickClipBase() {
	global
	return customQuickClipTableIsUsed ? customQuickClipTableList[customQuickClipTablePos] : customQuickClipTablePos
}

getQuickClipCurrentSlotString(index) {
	global
	return getCurrentCustomQuickClipBase() . " - " . index
}

quickClipExists(index) {
	global

	fileAttributes := FileExist(quickClipLogDir . getCurrentCustomQuickClipBase() . index . ".?log")
	return (fileAttributes != "")
}

getFullPathOfQuickClip(place) {
	global

	quickClipFile := quickClipLogDir . getCurrentCustomQuickClipBase() . place
	quickClipType := getUniqueFileExtension(quickClipFile)

	return quickClipFile . "." . quickClipType
}

getClipFromFile(filePath, ByRef variableToSet) {
	global

	try {
		FileRead, variableToSet, *c %filePath%
	} catch e {
		MsgBox, %errorCantReadClipFile%`n`nFile:`n%filePath%
		Reload
	}
}

setClipboardFromDataWithoutLogging(data) {
	global
	
	OnClipboardChange("saveClipb", 0)
	Clipboard := data
	OnClipboardChange("saveClipb")
}

setClipboardFromFileWithoutLogging(filePath) {
	global
	
	getClipFromFile(filePath, clipFileData)
	setClipboardFromDataWithoutLogging(clipFileData)
}

;------------------------------------------------

waitForClipboard(dataToWaitFor = false) {
	global

	if (dataToWaitFor == false)
		dataToWaitFor := ClipboardAll
	tmpTime := minwaitForClipboard + (StrLen(dataToWaitFor) / divisionalForClipboardWait)
	sleep tmpTime
}

;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------

saveClipb(clipTypeID) {
	global
	
	if (saveClipbRunning) {
		return
	}
	saveClipbRunning := true


	;This sleep is needed for some screen snipping tools since they modify the clipboard mltiple times, but only the last modification is the needed result, the rest are useless junk
	sleep sleepTimeBeforeSaveClip
	
	FormatTime, clipFile ,, %fileTimeFormat%
	clipFile=%clipFile%.%A_MSec%
	clipFileNoExt := clipFile
	
	clipData := ClipboardAll
	clipSize := StrLen(clipData)

	if ( (clipTypeID == 1) || (clipTypeID == 0) ) {
		; Clipboard data is either empty (0) or text (1)
		clipType := clipTextExt
	}
	else if (clipTypeID == 2) {
		; Set clipType based on it being a bitmap (2 ~ CF_BITMAP / image data) or not
		clipType := DllCall("IsClipboardFormatAvailable", "Uint", 2) ? clipPicExt : clipBinExt
	}
	else {
		clipType=%clipErrorExt%
		Clipboard := errorCorruptStr . "`n" . errorTypeStr
	}

	differentFromLastData := true
	if (hasClipFiles() && clipType == prevClipType && clipSize == prevClipSize ) {
		if clipData = %prevClipData%
			differentFromLastData := false
	}
	
	if (differentFromLastData == true) {
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

	
	saveClipbRunning := false
}

;--------------------------------------------------------------------------------------------------

changeClip(place = "", force = false, showPreview = true) {
	global
	
	if (changeClipRunning) {
		return
	}
	changeClipRunning := true


	if (!hasClipFiles()) {
		if (showPreview) {
			ToolTip % errorNoClipHistory
		}

		changeClipRunning := false
		return
	}
	
	changed := false
	
	if ( place == "+" ) {
		changed := setClipCursorPos(clipCursorPos +1, force)
	} else if ( place == "-" ) {
		changed := setClipCursorPos(clipCursorPos -1, force)
	} else if (place == "" && force) {
		changed := setClipCursorPos(clipCursorPos, force)
	} else if place is Integer
	 {
		changed := setClipCursorPos(place, force)
		if ( !changed && place != clipCursorPos) {
			ToolTip % errorNoClipAtIndex
			return
		}
	}
	
	if (changed) {
		setClipboardFromFileWithoutLogging(getClipFilePath(clipCursorPos))
	}

	if (showPreview) {
		showClipPreview(clipCursorPos, clipType)
	}


	changeClipRunning := false
}

showClipPreview(tooltipHeader, cType) {
	global
	
	if (showClipPreviewRunning) {
		return
	}
	showClipPreviewRunning := true


    GDIP_StartDraw()

	GDIP_Clean()
	GDIP_Update()

	; Variable to store preview text in
	tooltipText := ""

	if (cType == clipTextExt) {
		tooltipText := Clipboard
	}
	else if (cType == clipBinExt) {
		; Read the binary file as raw, so it can be shown as text
		FileRead, binClipContent, % getClipFilePath(clipCursorPos)
		; Remove NUL characters from the binary data, to prevent AutoHotkey to truncate it
		noNulBinClipContent := RegExReplace(binClipContent, "\0" , "")

		tooltipText := warningBinClipType . "`n"
		tooltipText .= "(Clipboard format IDs: [" . join(",", getClipFormatIDs()*) . "])`n`n"
		tooltipText .= "Content:`n"
		tooltipText .= noNulBinClipContent
	}
	else if (cType == clipPicExt) {
		clipPicBitmap := Gdip_CreateBitmapFromClipboard()
		
		picW := Gdip_GetImageWidth(clipPicBitmap)
		picH := Gdip_GetImageHeight(clipPicBitmap)

		if ( (picW*4 > A_ScreenWidth) || (picH*4 > A_ScreenHeight) ) {
			screenRatio := A_ScreenWidth / A_ScreenHeight
			picRatio := picW / picH

			if (picRatio > screenRatio)
				scaleClipPic := A_ScreenWidth / picW / 4
			else
				scaleClipPic := A_ScreenWidth / picH / 4
				
			clipPicW := scaleClipPic * picW
			clipPicH := scaleClipPic * picH
		} else {
			clipPicW := picW
			clipPicH := picH
		}

		MouseGetPos, xPos, yPos
		
		Gdip_DrawImage(GDIP_Graphics, clipPicBitmap, GDIP_DesktopPos(xPos+16, "x"), GDIP_DesktopPos(yPos+16, "y"), clipPicW, clipPicH)
		GDIP_Update()
	}
	else {
		tooltipText := errorNoSuchTypeStr
	}

	; Add header if provided
	if (tooltipHeader != "")
		tooltipText := tooltipHeader . (tooltipText == "" ? "" : "`n" . tooltipText)

	; Cut off the end of the tooltip text if it is too long
	if (StrLen(tooltipText) > 1000)
		tooltipText := SubStr(tooltipText, 1 , 1000)
	
	ToolTip % tooltipText

	
	showClipPreviewRunning := false
}

instantPaste(place) {
	global
	
	if (instantPasteRunning) {
		return
	}
	instantPasteRunning := true
	

	if (hasClipFile(place)) {
		clipSave := ClipboardAll
		
		setClipboardFromFileWithoutLogging(getClipFilePath(place))
		Send, ^v
		waitForClipboard()

		setClipboardFromDataWithoutLogging(clipSave)

		gosub setStateReady
	}


	instantPasteRunning := false
}

AddClipFromQuickClip(quickClipIndex) {
	global
	
	if (AddClipFromQuickClipRunning) {
		return
	}
	AddClipFromQuickClipRunning := true


	if (!quickClipExists(quickClipIndex)) {
		ToolTip % errorNoClipAtIndex . " (" . getQuickClipCurrentSlotString(quickClipIndex) . ")"
		return
	}


	quickClipPath := getFullPathOfQuickClip(quickClipIndex)
	getClipFromFile(quickClipPath, clipFileData)
	Clipboard := clipFileData
	
	peekQuickClip(quickClipIndex, notifySavedHSlot)
	

	AddClipFromQuickClipRunning := false
}

deleteClip(place = "", maintainCursorPos = false) {
	global
	
	if (deleteClipRunning) {
		return
	}
	deleteClipRunning := true

	
	placeToDelete := calcPlace(place)
	if (!hasClipFile(placeToDelete)) {
		ToolTip % errorNoClipAtIndex . " (" . place . ")"
		return
	}


	FileDelete % getClipFilePath(placeToDelete)
	deleteClipFileName(placeToDelete)

	deletedClipText := "Deleted clip: " . placeToDelete
	
	placeToMove := clipCursorPos
	if (placeToDelete <= clipCursorPos) {
		if (maintainCursorPos) {
			if (!hasClipFile(placeToMove))
				placeToMove--
		} else {
			placeToMove--
			if (!hasClipFile(placeToMove))
				placeToMove++
		}

		if (hasClipFile(placeToMove)) {
			changeClip(placeToMove, true, false)
		} else {
			setClipboardFromDataWithoutLogging("")

			Tooltip % deletedClipText . "`nNo clip is left to change to"
			return
		}
	}
	
	Tooltip % deletedClipText . "`nCurrent clip: " . clipCursorPos . "`nNumber of clips remaining: " . clipFiles.Count()


	deleteClipRunning := false
}

;--------------------------------------------------------------------------------------------------

setQuickClipTable(place := "") {
	global

	if (place == "") {
		if (customQuickClipTableIsUsed) {
			customQuickClipTablePos := Mod(customQuickClipTablePos, customQuickClipTableList.MaxIndex()) + 1
		} else {
			customQuickClipTableIsUsed := true
			customQuickClipTablePos := 1
		}
	} else {
		customQuickClipTableIsUsed := false
		customQuickClipTablePos := place
	}

	ToolTip % "Quick clip table: " . getCurrentCustomQuickClipBase()
}

setQuickClip(place, dataToUse = false) {
	global
	
	if (setQuickClipRunning) {
		return
	}
	setQuickClipRunning := true

	; Making sure, the clip is loaded
	changeClip("", true, false)

	if (!hasClipFiles() && dataToUse == false) {
		ToolTip % errorCantSetQSlot . " (" . getQuickClipCurrentSlotString(place) . ")`n" . errorNoClipHistory

		setQuickClipRunning := false
		return
	}

	if (quickClipExists(place))
		FileDelete, % quickClipLogDir . getCurrentCustomQuickClipBase() . place ".*"

	if (dataToUse == false) {
		sourceFile := getClipFilePath(clipCursorPos)
		destinationFile := quickClipLogDir . getCurrentCustomQuickClipBase() . place . "." . clipType
		
		FileCopy, %sourceFile%, %destinationFile%, 1
		
		previewHeader = %notifySavedQSlot% %place%
		showClipPreview(previewHeader, clipType)
	} else {
		destinationFile := quickClipLogDir . getCurrentCustomQuickClipBase() . place . "." . clipTextExt

		clipSave := ClipboardAll
		Clipboard := dataToUse
		FileAppend, %ClipboardAll%, %destinationFile%
		setClipboardFromDataWithoutLogging(clipSave)
	}


	setQuickClipRunning := false
}

peekQuickClip(place, customHeader = "") {
	global
	
	if (peekQuickClipRunning) {
		return
	}
	peekQuickClipRunning := true

	
	GDIP_StartDraw()

	if (quickClipExists(place)) {
		clipSave := ClipboardAll

		quickClipPath := getFullPathOfQuickClip(place)
		setClipboardFromFileWithoutLogging(quickClipPath)

		previewHeader := getQuickClipCurrentSlotString(place)
		if (customHeader != "")
			previewHeader := customHeader
		showClipPreview(previewHeader, getExtension(quickClipPath))

		setClipboardFromDataWithoutLogging(clipSave)
	}
	else {
		GDIP_Clean()
		GDIP_Update()
		ToolTip % getQuickClipCurrentSlotString(place) . "`n" . errorNoClipAtIndex
	}


	peekQuickClipRunning := false
}

pasteQuickClip(place) {
	global
	
	if (pasteQuickClipRunning) {
		return
	}
	pasteQuickClipRunning := true
	

	if (quickClipExists(place)) {
		clipSave := ClipboardAll

		quickClipPath := getFullPathOfQuickClip(place)
		setClipboardFromFileWithoutLogging(quickClipPath)
		Send, ^v
		waitForClipboard()

		setClipboardFromDataWithoutLogging(clipSave)
	}
	
	gosub setStateReady


	pasteQuickClipRunning := false
}

deleteQuickClip(place) {
	global
	
	if (deleteQuickClipRunning) {
		return
	}
	deleteQuickClipRunning := true


	if (quickClipExists(place)) {
		FileDelete, % quickClipLogDir . getCurrentCustomQuickClipBase() . place . ".*"
		
		ToolTip % notifyDelQSlot . ": " . getQuickClipCurrentSlotString(place)
	} else {
		ToolTip % notifyNoDelQSlot . ": " . getQuickClipCurrentSlotString(place)
	}

	
	deleteQuickClipRunning := false
}
