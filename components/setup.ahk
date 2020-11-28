
gosub SetupClipLog

return

;------------------------------------------------
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
;------------------------------------------------

SetupClipLogDirectories:

    gosub SetupClipLogDirectoriesPaths

    gosub SetupClipLogDirectoriesCreateMissingOnes
	
return

SetupClipLogDirectoriesPaths:

	mainDir=%A_ScriptDir%\log\
	logDir=%mainDir%%A_ComputerName%\
	clipLogDir=%logDir%clipLogDir\
	quickClipLogDir=%logDir%quickClipLogDir\

return

SetupClipLogDirectoriesCreateMissingOnes:

	if !FileExist(mainDir)
		FileCreateDir %mainDir%
	if !FileExist(logDir)
		FileCreateDir %logDir%
	if !FileExist(clipLogDir)
		FileCreateDir %clipLogDir%
	if !FileExist(quickClipLogDir)
		FileCreateDir %quickClipLogDir%

return

;------------------------------------------------

SetupClipLogFinalValues:

	clipTextExt := "clog"
	clipPicExt := "plog"
	clipBinExt := "blog"
	clipErrorExt := "elog"

	clipModeNone := "none"
	clipModePreview := "preview"
	clipModePaste := "paste"
	clipModeAdd := "add"
	clipModeDelete := "delete"

	clipModePaused := "paused"

	fileTimeFormat := "yyyy-MM-dd_HH-mm-ss"

	minwaitForClipboard := 50
	sleepTimeBeforeSaveClip := 100
	divisionalForClipboardWait := 20000
    maxClipFileNum := 1000

return

;------------------------------------------------

SetupClipLogMessages:

    errorCantReadClipFile := "Can't read the file for some reason`nIn order to avoid further problems the file gets deleted and the script restarts"
	errorCantSetQSlot := "Can't set quick slot"
	errorCorruptStr := "Corrupt file"
	errorImageCopyStr := "Something went wrong while copying the image"
	errorNoClipAtIndex := "No clipboard data can be found at this index"
	errorNoClipHistory := "The clipboard history is empty"
	errorNoSuchTypeStr := "The file is of an unkown type"
	errorTypeStr := "Corrupt file`nCan't determine the type of the data"
	errorWrongParameter := "The passed parameter is not valid"
	
	warningBinClipType := "The clip is of an unknown binary type / clipboard format`nIt may not display correctly"

	notifyDelQSlot := "Deleted quick slot"
	notifySavedQSlot := "Clip saved to quick slot"
	notifySavedHSlot := "Clip saved to the history"

return

;------------------------------------------------

SetupClipLogGlobalVariables:

	clipMode := clipModeNone
	clipCursorPos := 0
	clipType := ""
	clipSize := 0
	
	prevClipFile := ""
	prevClipData := ""
	prevClipType := ""
	prevClipSize := 0

	isLogging := true
	scriptIsModifyingClipboard := false

return

;------------------------------------------------

SetupClipLogFileLists:

	clipFiles := []
	Loop, Files, %clipLogDir%*.?log
	{
		clipFiles.Push(A_LoopFileName)
	}


	quickClipFiles := []
	Loop, 10 {
		quickClipFiles[A_Index] := false
	}
	Loop, Files, %quickClipLogDir%*.?log
	{
		tmpFileName := StrSplit(A_LoopFileName, ".")[1]
		quickClipFiles[tmpFileName] := true
	}

return

;------------------------------------------------

SetupClipLogInit:

    deleteOldLogFiles()

	GDIP_SetUp()

return
