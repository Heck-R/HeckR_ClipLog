
gosub SetupClipLog

;------------------------------------------------

SetupClipLog:

	gosub SetupClipLogDirectories

	gosub SetupClipLogFinalValues

	gosub SetupClipLogMessages

	gosub SetupClipLogGlobalVariables

	gosub SetupClipLogFileLists

	gosub SetupClipLogInit

return

;------------------------------------------------

SetupClipLogDirectories:

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
	
return

SetupClipLogFinalValues:

	clipTextExt := "clog"
	clipPicExt := "plog"
	clipErrorExt := "elog"

	fileTimeFormat := "yyyy-MM-dd_HH-mm-ss"

	userClipRestoreTime := 1000
	minWaitAfterPaste := 50
	divisionalAfterPaste := 20000
	sleepTimeBeforeSaveClip := 100

return

SetupClipLogMessages:

	errorCorruptStr := "Corrupt file"
	errorImageCopyStr := "Something went wrong while copying the image"
	errorTypeStr := "Corrupt file`nCan't determine the type of the data"
	errorNoSuchTypeStr := "The file is of an unkown type"
	errorNoClipAtIndex := "No clipboard data can be found at this index"
	errorNoClipHistory := "The clipboard history is empty"
	errorCantSetQSlot := "Can't set quick slot"

	notifyDelQSlot := "Deleted quick slot"
	notifySavedQSlot := "Clip saved to quick slot"

return

SetupClipLogGlobalVariables:

	clipSwitchOn := false
	clipCursorPos := 0
	clipType := ""
	clipSize := 0
	
	prevClipData := ""
	prevClipType := ""
	prevClipSize := 0
	
	scriptIsModifyingClipboard := false

return

SetupClipLogFileLists:

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

return

SetupClipLogInit:
	
	if(hasClipFiles()){
		readClipFromFile(clipLogDir . "\" . getClipFile(clipCursorPos))
		clipType := getExtension(getClipFile(clipCursorPos))
	}

	GDIP_SetUp()

return
