
gosub SetupClipLog

return

;------------------------------------------------
;------------------------------------------------

SetupClipLog:

	gosub SetupClipLogFinalValues

	gosub SetupClipLogGlobalVariables

	gosub PrepareHelpText

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
	clipModeHelp := "help"
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
    maxClipFileNum := 1000		; How many clips are preserved at most (read from config)

	; Messages
    errorCantReadClipFile := "Can't read the file for some reason`nIn order to avoid further problems the file gets deleted and the script restarts"
	errorCantSetQSlot := "Can't set quick slot"
	errorCorruptStr := "Corrupt file"
	errorImageCopyStr := "Something went wrong while copying the image"
	errorNoClipAtIndex := "No clipboard data can be found at this index"
	errorNoClipHistory := "The clipboard history is empty"
	errorNoSuchTypeStr := "The file is of an unkown type"
	errorTypeStr := "Corrupt file`nCan't determine the type of the data"
	errorWrongConfigValue := "The provided value in the configuration file is not formatted properly"
	errorWrongParameter := "The passed parameter is not valid"
	
	warningBinClipType := "The clip is of an unknown binary type / clipboard format`nIt may not display correctly"

	notifyDelQSlot := "Deleted quick slot"
	notifyNoDelQSlot := "Nothing to delete at quick slot"
	notifySavedQSlot := "Clip saved to quick slot"
	notifySavedHSlot := "Clip saved to the history"

	; Help text
	; Helping regex replace: "- \*\*(.*)\*\*: ?(.*[^ ])" => "hotkeyHelpData["history"].Push(["$1", "$2"])"
	hotkeyHelpData := {}

	hotkeyHelpData["0_General"] := []
	hotkeyHelpData["1_StandardClip"] := []
	hotkeyHelpData["2_QuickClip"] := []

	hotkeyHelpData["0_General"].Push(["Win + Shift + L", "Turns on/off the logging of the clipboard and the other hotkeys of this script"])
	hotkeyHelpData["0_General"].Push(["Win + H", "Shows a helping tooltip about all of the availbale hotkeys"])

	hotkeyHelpData["1_StandardClip"].Push(["Win + (LeftArrow / LeftClick / MouseForward / ScrollDown)", "Go one position back in the history"])
	hotkeyHelpData["1_StandardClip"].Push(["Win + (RightArrow / RightClick / MouseBackward / ScrollUp)", "Go one position forward in the history"])
	hotkeyHelpData["1_StandardClip"].Push(["Win + (UpArrow / DownArrow / MiddleMouseButton)", "Only show the preview of the current clip"])
	hotkeyHelpData["1_StandardClip"].Push(["Win + <Any number>", "Go to the clip with the number pressed"])
	hotkeyHelpData["1_StandardClip"].Push("")
	hotkeyHelpData["1_StandardClip"].Push(["Win + Alt + <Any number>", "Instantly paste the clip from the history without changing the content on the clipboard"])
	hotkeyHelpData["1_StandardClip"].Push("")
	hotkeyHelpData["1_StandardClip"].Push(["Win + Shift + Enter", "A small window pops up, where you can enter some text you wish to save to the history"])
	hotkeyHelpData["1_StandardClip"].Push(["Win + Shift + <Any number>", "Add the quickClip indexed with the pressed number (if it exists) to the history and put it on the clipboard"])
	hotkeyHelpData["1_StandardClip"].Push("")
	hotkeyHelpData["1_StandardClip"].Push(["Win + Shift + Alt + (LeftArrow / LeftClick / MouseForward)", "Delete the older neighbour of the currently selected clip (if it exists)"])
	hotkeyHelpData["1_StandardClip"].Push(["Win + Shift + Alt + (RightArrow / RightClick / MouseBackward)", "Delete the younger neighbour of the currently selected clip (if it exists)"])
	hotkeyHelpData["1_StandardClip"].Push(["Win + Shift + Alt + (DownArrow / UpArrow / MiddleMouseButton)", "Delete the currently selected clip (if there is one selected)"])
	hotkeyHelpData["1_StandardClip"].Push(["Win + Shift + Alt + <Any number>", "Delete the clip with the same index as the number which is being pressed (if it exists)"])

	hotkeyHelpData["2_QuickClip"].Push(["Shift + Alt + <Any number>", "Change to the associated quick clip table"])
	hotkeyHelpData["2_QuickClip"].Push(["Shift + Alt + Tab", "Step through the named quick clip tables"])
	hotkeyHelpData["2_QuickClip"].Push("")
	hotkeyHelpData["2_QuickClip"].Push(["Win + Shift + Ctrl + <Any number>", "Save the current clipboard data to the quick clip at the position of the number you pressed"])
	hotkeyHelpData["2_QuickClip"].Push(["Win + Shift + Ctrl + Enter", "A small window pops up, where you can enter some text you wish to save to one of the quickClip slots"])
	hotkeyHelpData["2_QuickClip"].Push(["Win + Shift + Ctrl + Alt + <Any number>", "Delete the clipboard data to the the quick clip at the position of the number you pressed"])
	hotkeyHelpData["2_QuickClip"].Push(["Win + Ctrl + <Any number>", "Open a preview of the quock clip at the position of the number you pressed"])
	hotkeyHelpData["2_QuickClip"].Push(["Win + Ctrl + Alt + <Any number>", "Instant paste the quck clip at the position of the number you pressed"])
return

PrepareHelpText:

	hotkeyHelpText := "Hotkey help"

	for category, data in hotkeyHelpData {
		hotkeyHelpText .= "`n`n"
		hotkeyHelpText .= category . ":"

		for index, textArr in data {
			hotkeyHelpText .= "`n"

			if (!IsObject(textArr)) {
				continue
			}

			hotkeyHelpText .= "- "
			hotkeyHelpText .= textArr[1] . ": " . textArr[2]
		}
	}

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
	customQuickClipTableList := []			;Custom quick clip table IDs/names (read from config)
	customQuickClipTablePos := 1			;Selected custom quickclip table's number/position (either an index from the custom tables list, or an indexed table. See variable: customQuickClipTableIsUsed)
	customQuickClipTableIsUsed := true		;Flag indicating the meaning of customQuickClipTablePos. true => index, false => table name

	isLogging := true						;Flag for enabling/disabling hotkeys

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

	; Read custom history size
	IniRead, maxNumberOfClipFilesIniValue, %iniFilePath%, settings, maxNumberOfClipFiles, %A_Space%
	if (maxNumberOfClipFilesIniValue != "") {
		if maxNumberOfClipFilesIniValue is Integer
		{
			maxClipFileNum := maxNumberOfClipFilesIniValue
		} else {
			MsgBox % errorWrongConfigValue . "`nValue of 'maxNumberOfClipFiles' must be an integer, but it was '" . maxNumberOfClipFilesIniValue . "'`n`nThe program terminates..."
			ExitApp
		}
	}
	
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
