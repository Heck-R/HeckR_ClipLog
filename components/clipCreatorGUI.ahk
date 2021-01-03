
showClipCreatorGUI(createAsQuickClip = false){
    global

    Gui New
    Gui +Resize MinSize240x176
    Gui Font, s11
    Gui Add, Text, hWndhTxtText x0 y4 w240 h20 +0x1, Enter the clipboard content
    Gui Font
    Gui Add, Edit, hWndhEdtValue x8 y24 w224 h108 vEditContent -Wrap
    Gui Add, Button, hWndhBtnOk x8 y144 w80 h24 gOkClick, OK
    Gui Add, Button, hWndhBtnCancel x96 y144 w80 h24 gCancelClick, Cancel
    if (createAsQuickClip) {
        Gui Font, s10
        Gui Add, DropDownList, hWndhDDLItems x200 y144 w32 vQuickClipSlot, 0||1|2|3|4|5|6|7|8|9
        Gui Font
    }

    Gui Show, w240 h176, Clip Creator
    Return

    GuiSize:
        if (A_EventInfo == 1) {
            Return
        }

        AutoXYWH("w*", hTxtText)
        AutoXYWH("wh*", hEdtValue)
        AutoXYWH("y", hBtnOk)
        AutoXYWH("y", hBtnCancel)

        if (createAsQuickClip)
            AutoXYWH("xy", hDDLItems)
    Return

    OkClick:
        GuiControlGet EditContent
        GuiControlGet QuickClipSlot

        if QuickClipSlot is Integer
        {
            setQuickClip(QuickClipSlot, EditContent)
        } else {
            Clipboard := EditContent
        }
        
        Gui Destroy
    Return

    CancelClick:
    GuiEscape:
    GuiClose:
        Gui Destroy
    Return
}
