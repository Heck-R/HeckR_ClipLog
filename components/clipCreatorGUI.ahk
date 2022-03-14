
showClipCreatorGUI(createAsQuickClip = false) {
    global

    Gui ClipCreator:New
    Gui ClipCreator:+Resize MinSize240x176
    Gui ClipCreator:Font, s11
    Gui ClipCreator:Add, Text, hWndhClipCreatorInstructionText x0 y4 w240 h20 +0x1, Enter the clipboard content
    Gui ClipCreator:Font
    Gui ClipCreator:Add, Edit, hWndhClipCreatorClipContentEdit x8 y24 w224 h108 vEditContent -Wrap VScroll HScroll
    Gui ClipCreator:Add, Button, hWndhClipCreatorOkButton x8 y144 w80 h24 gClipCreatorOkClick, OK
    Gui ClipCreator:Add, Button, hWndhClipCreatorCancelButton x96 y144 w80 h24 gClipCreatorCancelClick, Cancel
    if (createAsQuickClip) {
        Gui ClipCreator:Font, s10
        Gui ClipCreator:Add, DropDownList, hWndhDDLItems x200 y144 w32 vQuickClipSlot, 0||1|2|3|4|5|6|7|8|9
        Gui ClipCreator:Font
    }
    
    ; Load default GUI control values
    Gui ClipCreator:Submit, NoHide

    Gui ClipCreator:Show, w240 h176, Clip Creator
}

ClipCreatorGuiSize() {
    global

    if (A_EventInfo == 1)
        return

    AutoXYWH("w*", hClipCreatorInstructionText)
    AutoXYWH("wh*", hClipCreatorClipContentEdit)
    AutoXYWH("y", hClipCreatorOkButton)
    AutoXYWH("y", hClipCreatorCancelButton)

    if QuickClipSlot is Integer
        AutoXYWH("xy", hDDLItems)
}

ClipCreatorOkClick() {
    global
    
    Gui ClipCreator:Submit, NoHide

    if QuickClipSlot is Integer
    {
        setQuickClip(QuickClipSlot, EditContent)
    } else {
        Clipboard := EditContent
    }
    
    Gui ClipCreator:Destroy
}

ClipCreatorCancelClick:
ClipCreatorGuiEscape:
ClipCreatorGuiClose:
    Gui ClipCreator:Destroy
return
