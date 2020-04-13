
#if (clipMode != clipModeNone) and (clipMode != clipModePaste)

	Shift Up::
	Ctrl Up::
	Alt Up::
	LWin Up::
	setStateReady:
		if(GDIP_IsDrawing){
			GDIP_Clean()
			GDIP_Update()
			GDIP_EndDraw()
		}

		scriptIsModifyingClipboard := false
		clipMode := clipModeNone
		tooltip
	return

#if

;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModePreview)

#Left::
#LButton::
#WheelDown::
#XButton1::
	clipMode := clipModePreview
	changeClip("+")
return

#Right::
#RButton::
#WheelUp::
#XButton2::
	clipMode := clipModePreview
	changeClip("-")
return

#Up::
#Down::
#MButton::
	clipMode := clipModePreview
	changeClip()
return

#0::
#1::
#2::
#3::
#4::
#5::
#6::
#7::
#8::
#9::
#Numpad0::
#Numpad1::
#Numpad2::
#Numpad3::
#Numpad4::
#Numpad5::
#Numpad6::
#Numpad7::
#Numpad8::
#Numpad9::
	clipMode := clipModePreview
	changeClip(substr(A_ThisHotkey, 0))
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModePaste)

#!0::
#!1::
#!2::
#!3::
#!4::
#!5::
#!6::
#!7::
#!8::
#!9::
#!Numpad0::
#!Numpad1::
#!Numpad2::
#!Numpad3::
#!Numpad4::
#!Numpad5::
#!Numpad6::
#!Numpad7::
#!Numpad8::
#!Numpad9::
	clipMode := clipModePaste
	instantPaste(substr(A_ThisHotkey, 0))
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone)

+#Enter::
+#NumpadEnter::
	showClipCreatorGUI()
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModeAdd)

+#0::
#NumpadIns::
	clipMode := clipModeAdd
	AddClipFromQuickClip(0)
return

+#1::
#NumpadEnd::
	clipMode := clipModeAdd
	AddClipFromQuickClip(1)
return

+#2::
#NumpadDown::
	clipMode := clipModeAdd
	AddClipFromQuickClip(2)
return

+#3::
#NumpadPgdn::
	clipMode := clipModeAdd
	AddClipFromQuickClip(3)
return

+#4::
#NumpadLeft::
	clipMode := clipModeAdd
	AddClipFromQuickClip(4)
return

+#5::
#NumpadClear::
	clipMode := clipModeAdd
	AddClipFromQuickClip(5)
return

+#6::
#NumpadRight::
	clipMode := clipModeAdd
	AddClipFromQuickClip(6)
return

+#7::
#NumpadHome::
	clipMode := clipModeAdd
	AddClipFromQuickClip(7)
return

+#8::
#NumpadUp::
	clipMode := clipModeAdd
	AddClipFromQuickClip(8)
return

+#9::
#NumpadPgup::
	clipMode := clipModeAdd
	AddClipFromQuickClip(9)
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModeDelete)

+!#Left::
+!#LButton::
+!#XButton1::
	clipMode := clipModeDelete
	deleteClip("+")
return

+!#Right::
+!#RButton::
+!#XButton2::
	clipMode := clipModeDelete
	deleteClip("-")
return

+!#Up::
	clipMode := clipModeDelete
	deleteClip("", false)
return

+!#Down::
+!#MButton::
	clipMode := clipModeDelete
	deleteClip("", true)
return


+!#0::
!#NumpadIns::
	clipMode := clipModeDelete
	deleteClip(0)
return

+!#1::
!#NumpadEnd::
	clipMode := clipModeDelete
	deleteClip(1)
return

+!#2::
!#NumpadDown::
	clipMode := clipModeDelete
	deleteClip(2)
return

+!#3::
!#NumpadPgdn::
	clipMode := clipModeDelete
	deleteClip(3)
return

+!#4::
!#NumpadLeft::
	clipMode := clipModeDelete
	deleteClip(4)
return

+!#5::
!#NumpadClear::
	clipMode := clipModeDelete
	deleteClip(5)
return

+!#6::
!#NumpadRight::
	clipMode := clipModeDelete
	deleteClip(6)
return

+!#7::
!#NumpadHome::
	clipMode := clipModeDelete
	deleteClip(7)
return

+!#8::
!#NumpadUp::
	clipMode := clipModeDelete
	deleteClip(8)
return

+!#9::
!#NumpadPgup::
	clipMode := clipModeDelete
	deleteClip(9)
return

#if

;------------------------------------------------
;------------------------------------------------

#if (clipMode == clipModeNone)

+^#Enter::
+^#NumpadEnter::
	showClipCreatorGUI(true)
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModeAdd)

+^#0::
^#NumpadIns::
	clipMode := clipModeAdd
	setQuickClip(0)
return

+^#1::
^#NumpadEnd::
	clipMode := clipModeAdd
	setQuickClip(1)
return

+^#2::
^#NumpadDown::
	clipMode := clipModeAdd
	setQuickClip(2)
return

+^#3::
^#NumpadPgdn::
	clipMode := clipModeAdd
	setQuickClip(3)
return

+^#4::
^#NumpadLeft::
	clipMode := clipModeAdd
	setQuickClip(4)
return

+^#5::
^#NumpadClear::
	clipMode := clipModeAdd
	setQuickClip(5)
return

+^#6::
^#NumpadRight::
	clipMode := clipModeAdd
	setQuickClip(6)
return

+^#7::
^#NumpadHome::
	clipMode := clipModeAdd
	setQuickClip(7)
return

+^#8::
^#NumpadUp::
	clipMode := clipModeAdd
	setQuickClip(8)
return

+^#9::
^#NumpadPgup::
	clipMode := clipModeAdd
	setQuickClip(9)
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModePreview)

^#0::
^#1::
^#2::
^#3::
^#4::
^#5::
^#6::
^#7::
^#8::
^#9::
^#Numpad0::
^#Numpad1::
^#Numpad2::
^#Numpad3::
^#Numpad4::
^#Numpad5::
^#Numpad6::
^#Numpad7::
^#Numpad8::
^#Numpad9::
	clipMode := clipModePreview
	peekQuickClip(substr(A_ThisHotkey, 0))
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModePaste)

^#!0::
^#!1::
^#!2::
^#!3::
^#!4::
^#!5::
^#!6::
^#!7::
^#!8::
^#!9::
^#!Numpad0::
^#!Numpad1::
^#!Numpad2::
^#!Numpad3::
^#!Numpad4::
^#!Numpad5::
^#!Numpad6::
^#!Numpad7::
^#!Numpad8::
^#!Numpad9::
	clipMode := clipModePaste
	pasteQuickClip(substr(A_ThisHotkey, 0))
return

#if

;------------------------------------------------

#if (clipMode == clipModeNone) or (clipMode == clipModeDelete)

+^#!0::
^#!NumpadIns::
	clipMode := clipModeDelete
	deleteQuickClip(0)
return

+^#!1::
^#!NumpadEnd::
	clipMode := clipModeDelete
	deleteQuickClip(1)
return

+^#!2::
^#!NumpadDown::
	clipMode := clipModeDelete
	deleteQuickClip(2)
return

+^#!3::
^#!NumpadPgdn::
	clipMode := clipModeDelete
	deleteQuickClip(3)
return

+^#!4::
^#!NumpadLeft::
	clipMode := clipModeDelete
	deleteQuickClip(4)
return

+^#!5::
^#!NumpadClear::
	clipMode := clipModeDelete
	deleteQuickClip(5)
return

+^#!6::
^#!NumpadRight::
	clipMode := clipModeDelete
	deleteQuickClip(6)
return

+^#!7::
^#!NumpadHome::
	clipMode := clipModeDelete
	deleteQuickClip(7)
return

+^#!8::
^#!NumpadUp::
	clipMode := clipModeDelete
	deleteQuickClip(8)
return

+^#!9::
^#!NumpadPgup::
	clipMode := clipModeDelete
	deleteQuickClip(9)
return

#if
