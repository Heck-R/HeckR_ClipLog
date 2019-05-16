
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
	clipErrorExt := "elog"

	fileTimeFormat := "yyyy-MM-dd_HH-mm-ss"

	minWaitAfterPaste := 50
	sleepTimeBeforeSaveClip := 100
	divisionalAfterPaste := 20000
    maxClipFileNum := 1000

return

;------------------------------------------------

SetupClipLogMessages:

	errorCorruptStr := "Corrupt file"
	errorImageCopyStr := "Something went wrong while copying the image"
	errorTypeStr := "Corrupt file`nCan't determine the type of the data"
	errorNoSuchTypeStr := "The file is of an unkown type"
    errorCantReadClipFile := "Can't read the file for some reason`nIn order to avoid further problems the file gets deleted and the script restarts"
	errorNoClipAtIndex := "No clipboard data can be found at this index"
	errorNoClipHistory := "The clipboard history is empty"
	errorCantSetQSlot := "Can't set quick slot"

	notifyDelQSlot := "Deleted quick slot"
	notifySavedQSlot := "Clip saved to quick slot"

return

;------------------------------------------------

SetupClipLogGlobalVariables:

	clipSwitchOn := false
	clipCursorPos := 0
	clipType := ""
	clipSize := 0
	
	prevClipFile := ""
	prevClipData := ""
	prevClipType := ""
	prevClipSize := 0
	
	scriptIsModifyingClipboard := false

return

;------------------------------------------------

SetupClipLogFileLists:

	clipFiles := []
	Loop, Files, %clipLogDir%*.?log
	{
		clipFiles[A_Index-1] := A_LoopFileName
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

    gosub DeleteTooOldLogFiles

	GDIP_SetUp()

return
