
gosub SetupClipLog

return

;------------------------------------------------
;------------------------------------------------

SetupClipLog:

	gosub SetupClipLogFinalValues

	gosub SetupClipLogGlobalVariables

	gosub SetupClipLogDirectories

	gosub SetupClipLogFileLists

	gosub SetupClipLogInit

return

;------------------------------------------------
;------------------------------------------------

SetupClipLogDirectories:

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

	; Directory paths
	mainDir=%A_ScriptDir%\log\					;Main directory for logging
	logDir=%mainDir%%A_ComputerName%\			;Computer specific directory for logging (for compatibility with cloud file sync)
	clipLogDir=%logDir%clipLogDir\				;Standard clip log directory
	quickClipLogDir=%logDir%quickClipLogDir\	;Quick clip logging directory 

	; Clip types
	clipTextExt := "clog"	;Text
	clipPicExt := "plog"	;Picture/Image/Bitmap
	clipBinExt := "blog"	;Binary
	clipErrorExt := "elog"	;Error

	; Clip modes
	clipModeNone := "none"
	clipModePreview := "preview"
	clipModePaste := "paste"
	clipModeAdd := "add"
	clipModeDelete := "delete"

	clipModePaused := "paused"

	; Formats
	fileTimeFormat := "yyyy-MM-dd_HH-mm-ss"

	; Times / boundaries
	minwaitForClipboard := 50
	sleepTimeBeforeSaveClip := 100
	divisionalForClipboardWait := 20000
    maxClipFileNum := 1000

	; Messages
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

	clipMode := clipModeNone	;Storing current clip mode for context sensitive hotkeys
	clipCursorPos := 0			;Selected clip's number/position
	clipType := ""				;Current clip type
	clipSize := 0				;Current clip size
	
	prevClipData := ""		;Previous clip data for avoiding duplications
	prevClipType := ""		;Previous clip type for avoiding duplications
	prevClipSize := 0		;Previous clip type for avoiding duplications

	clipFiles := []							;List of standard clip log files
	quickClipFiles := []					;List of quick clip log files

	isLogging := true						;Flag for enabling/disabling hotkeys
	scriptIsModifyingClipboard := false		;Flag for making sure only one thing is trying to modify the cliboard

return

;------------------------------------------------

SetupClipLogFileLists:

	;Reading clips
	Loop, Files, %clipLogDir%*.?log
	{
		clipFiles.Push(A_LoopFileName)
	}

	; Reading quick clips
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
