
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

;-------------------------------------------------------

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
#Numpad0::
	changeClip(0)
return

#1::
#Numpad1::
	changeClip(1)
return

#2::
#Numpad2::
	changeClip(2)
return

#3::
#Numpad3::
	changeClip(3)
return

#4::
#Numpad4::
	changeClip(4)
return

#5::
#Numpad5::
	changeClip(5)
return

#6::
#Numpad6::
	changeClip(6)
return

#7::
#Numpad7::
	changeClip(7)
return

#8::
#Numpad8::
	changeClip(8)
return

#9::
#Numpad9::
	changeClip(9)
return

;------------------------------------------------

#!0::
#!Numpad0::
	instantPaste(0)
return

#!1::
#!Numpad1::
	instantPaste(1)
return

#!2::
#!Numpad2::
	instantPaste(2)
return

#!3::
#!Numpad3::
	instantPaste(3)
return

#!4::
#!Numpad4::
	instantPaste(4)
return

#!5::
#!Numpad5::
	instantPaste(5)
return

#!6::
#!Numpad6::
	instantPaste(6)
return

#!7::
#!Numpad7::
	instantPaste(7)
return

#!8::
#!Numpad8::
	instantPaste(8)
return

#!9::
#!Numpad9::
	instantPaste(9)
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
^#Numpad0::
	peekQuickClip(0)
return

^#1::
^#Numpad1::
	peekQuickClip(1)
return

^#2::
^#Numpad2::
	peekQuickClip(2)
return

^#3::
^#Numpad3::
	peekQuickClip(3)
return

^#4::
^#Numpad4::
	peekQuickClip(4)
return

^#5::
^#Numpad5::
	peekQuickClip(5)
return

^#6::
^#Numpad6::
	peekQuickClip(6)
return

^#7::
^#Numpad7::
	peekQuickClip(7)
return

^#8::
^#Numpad8::
	peekQuickClip(8)
return

^#9::
^#Numpad9::
	peekQuickClip(9)
return

;------------------------------------------------

^#!0::
^#!Numpad0::
	pasteQuickClip(0)
return

^#!1::
^#!Numpad1::
	pasteQuickClip(1)
return

^#!2::
^#!Numpad2::
	pasteQuickClip(2)
return

^#!3::
^#!Numpad3::
	pasteQuickClip(3)
return

^#!4::
^#!Numpad4::
	pasteQuickClip(4)
return

^#!5::
^#!Numpad5::
	pasteQuickClip(5)
return

^#!6::
^#!Numpad6::
	pasteQuickClip(6)
return

^#!7::
^#!Numpad7::
	pasteQuickClip(7)
return

^#!8::
^#!Numpad8::
	pasteQuickClip(8)
return

^#!9::
^#!Numpad9::
	pasteQuickClip(9)
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
