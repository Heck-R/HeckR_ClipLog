
gosub SetupClipLog

return

;------------------------------------------------
;------------------------------------------------

SetupClipLog:

	gosub SetupClipLogFinalValues

	gosub SetupClipLogGlobalVariables

	gosub ReadConfigFile

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

	; Config/Ini file
	iniFilePath := regexreplace(A_ScriptFullPath, "\.[^.]+$",".ini")

	; Clip types
	clipTextExt := "clog"	;Text
	clipPicExt := "plog"	;Picture/Image/Bitmap
	clipBinExt := "blog"	;Binary
	clipErrorExt := "elog"	;Error

	; Clip modes
	clipModeNone := "none"
	clipModeSetting := "setting"
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

	clipFiles := []				;List of standard clip log files
	customQuickClipTableList := []			;Custom quick clip table IDs/names
	customQuickClipTablePos := 1			;Selected custom quickclip table's number/position (either an index from the custom tables list, or an indexed table. See variable: customQuickClipTableIsUsed)
	customQuickClipTableIsUsed := true		;Flag indicating the meaning of customQuickClipTablePos. true => index, false => table name

	isLogging := true						;Flag for enabling/disabling hotkeys
	scriptIsModifyingClipboard := false		;Flag for making sure only one thing is trying to modify the cliboard

return

;------------------------------------------------

ReadConfigFile:

	; Create config if necessary
	if (!FileExist(iniFilePath)) {
    	FileAppend, [settings]`n, %iniFilePath%
	}

	; Init quick clip list names
	IniRead, customQuickClipTableListString, %iniFilePath%, settings, customQuickClipTables, %A_Space%
	customQuickClipTableList := StrSplit(customQuickClipTableListString, ",", " `t")

	; Always start with default
	customQuickClipTableList.InsertAt(1, "default")

return

;------------------------------------------------

SetupClipLogFileLists:

	gosub SetupStandardClipLogFileList

return

SetupStandardClipLogFileList:
	Loop, Files, %clipLogDir%*.?log
	{
		clipFiles.Push(A_LoopFileName)
	}
return

DeleteQuickClipsOfNonexistentTables:
	fileStartingOptions := join("|", customQuickClipTableList*)
	fileMatchPattern := "^(\d|" . fileStartingOptions . ")(\d)\.(.log)$"
	
	Loop, Files, %quickClipLogDir%*
	{
		if (RegExMatch(A_LoopFileName, fileMatchPattern, matchObject) == 0)
			FileDelete, %A_LoopFileFullPath%
	}
return

;------------------------------------------------

SetupClipLogInit:

	gosub DeleteQuickClipsOfNonexistentTables

    deleteOldLogFiles()

	GDIP_SetUp()

return
