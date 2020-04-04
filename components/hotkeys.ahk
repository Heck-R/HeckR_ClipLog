
#if clipSwitchOn

	Ctrl Up::
	LWin Up::
	Alt Up::
	setStateReady:
		GDIP_Clean()
		GDIP_Update()
    	GDIP_EndDraw()

		clipSwitchOn := false
		scriptIsModifyingClipboard := false
		tooltip
	return

#if

;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------

#Left::
#LButton::
#WheelDown::
#XButton1::
	changeClip("+")
return

#Right::
#RButton::
#WheelUp::
#XButton2::
	changeClip("-")
return

#Up::
#Down::
#MButton::
	changeClip()
return

;------------------------------------------------

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
	changeClip(substr(A_ThisHotkey, 0))
return

;------------------------------------------------

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
	instantPaste(substr(A_ThisHotkey, 0))
return

;------------------------------------------------
;------------------------------------------------

+^#0::
^#NumpadIns::
	setQuickClip(0)
return

+^#1::
^#NumpadEnd::
	setQuickClip(1)
return

+^#2::
^#NumpadDown::
	setQuickClip(2)
return

+^#3::
^#NumpadPgdn::
	setQuickClip(3)
return

+^#4::
^#NumpadLeft::
	setQuickClip(4)
return

+^#5::
^#NumpadClear::
	setQuickClip(5)
return

+^#6::
^#NumpadRight::
	setQuickClip(6)
return

+^#7::
^#NumpadHome::
	setQuickClip(7)
return

+^#8::
^#NumpadUp::
	setQuickClip(8)
return

+^#9::
^#NumpadPgup::
	setQuickClip(9)
return

;------------------------------------------------

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
	peekQuickClip(substr(A_ThisHotkey, 0))
return

;------------------------------------------------

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
	pasteQuickClip(substr(A_ThisHotkey, 0))
return

;------------------------------------------------

+^#!0::
^#!NumpadIns::
	deleteQuickClip(0)
return

+^#!1::
^#!NumpadEnd::
	deleteQuickClip(1)
return

+^#!2::
^#!NumpadDown::
	deleteQuickClip(2)
return

+^#!3::
^#!NumpadPgdn::
	deleteQuickClip(3)
return

+^#!4::
^#!NumpadLeft::
	deleteQuickClip(4)
return

+^#!5::
^#!NumpadClear::
	deleteQuickClip(5)
return

+^#!6::
^#!NumpadRight::
	deleteQuickClip(6)
return

+^#!7::
^#!NumpadHome::
	deleteQuickClip(7)
return

+^#!8::
^#!NumpadUp::
	deleteQuickClip(8)
return

+^#!9::
^#!NumpadPgup::
	deleteQuickClip(9)
return
