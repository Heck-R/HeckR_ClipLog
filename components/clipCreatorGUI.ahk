
showClipCreatorGUI(createAsQuickClip = false) {
    global

    CLIP_EDIT_WIDTH := CREATOR_GUI_WIDTH - 2*GUI_GAP_SIZE
    CLIP_EDIT_HEIGHT := CREATOR_GUI_HEIGHT - GUI_INPUT_LINE_HEIGHT - 3*GUI_GAP_SIZE

    CONTROLS_Y := CREATOR_GUI_HEIGHT - GUI_INPUT_LINE_HEIGHT - GUI_GAP_SIZE
    
    ADD_BUTTON_WIDTH := 80

    CANCEL_BUTTON_WIDTH := 80
    CANCEL_BUTTON_X := ADD_BUTTON_WIDTH + 2*GUI_GAP_SIZE

    QUICK_CLIP_DROP_DOWN_WIDTH := 32
    QUICK_CLIP_DROP_DOWN_X := CREATOR_GUI_WIDTH - QUICK_CLIP_DROP_DOWN_WIDTH - GUI_GAP_SIZE

    MIN_WIDTH := ADD_BUTTON_WIDTH + CANCEL_BUTTON_WIDTH + QUICK_CLIP_DROP_DOWN_WIDTH + 4*GUI_GAP_SIZE
    MIN_HEIGHT := 3*GUI_INPUT_LINE_HEIGHT + 3*GUI_GAP_SIZE

    Gui ClipCreator:New
    Gui ClipCreator:+Resize MinSize%MIN_WIDTH%x%MIN_HEIGHT%
    Gui ClipCreator:Font, s11
    Gui ClipCreator:Add, Edit, hWndhClipCreatorClipContentEdit x%GUI_GAP_SIZE% y%GUI_GAP_SIZE% w%CLIP_EDIT_WIDTH% h%CLIP_EDIT_HEIGHT% vEditContent -Wrap VScroll HScroll
    Gui ClipCreator:Add, Button, hWndhClipCreatorOkButton x%GUI_GAP_SIZE% y%CONTROLS_Y% w%ADD_BUTTON_WIDTH% h%GUI_INPUT_LINE_HEIGHT% gClipCreatorOkClick, &Add
    Gui ClipCreator:Add, Button, hWndhClipCreatorCancelButton x%CANCEL_BUTTON_X% y%CONTROLS_Y% w%CANCEL_BUTTON_WIDTH% h%GUI_INPUT_LINE_HEIGHT% gClipCreatorCancelClick, &Cancel
    if (createAsQuickClip) {
        Gui ClipCreator:Font, s10
        Gui ClipCreator:Add, DropDownList, hWndhDDLItems x%QUICK_CLIP_DROP_DOWN_X% y%CONTROLS_Y% w%QUICK_CLIP_DROP_DOWN_WIDTH% vQuickClipSlot, 0||1|2|3|4|5|6|7|8|9
        Gui ClipCreator:Font
    }
    
    ; Load default GUI control values
    Gui ClipCreator:Submit, NoHide

    Gui ClipCreator:Show, x%CREATOR_GUI_X% y%CREATOR_GUI_Y% w%CREATOR_GUI_WIDTH% h%CREATOR_GUI_HEIGHT%, Clip Creator
}

;------------------------------------------------
; Events

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
