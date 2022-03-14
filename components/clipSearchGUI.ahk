
showClipSearchGUI() {
    WINDOW_WIDTH := 500
    WINDOW_HEIGHT := 300
    GAP_SIZE := 8
    LINE_HEIGHT := 24

    CANCEL_BUTTON_WIDTH := 80
    CANCEL_BUTTON_X := WINDOW_WIDTH - CANCEL_BUTTON_WIDTH - GAP_SIZE

    SEARCH_BUTTON_WIDTH := 80
    SEARCH_BUTTON_X := CANCEL_BUTTON_X - SEARCH_BUTTON_WIDTH - GAP_SIZE

    SEARCH_EDIT_WIDTH := WINDOW_WIDTH - (WINDOW_WIDTH - SEARCH_BUTTON_X) - 2*GAP_SIZE

    CLIP_LIST_X := GAP_SIZE
    CLIP_LIST_Y := LINE_HEIGHT + 2*GAP_SIZE
    CLIP_LIST_WIDTH := WINDOW_WIDTH - 2*GAP_SIZE
    CLIP_LIST_HEIGHT := WINDOW_HEIGHT - LINE_HEIGHT - 3*GAP_SIZE

    Gui ClipSearch:New
    Gui ClipSearch:+Resize
    Gui ClipSearch:Font, s11
    Gui ClipSearch:Add, Edit,       hWndhClipSearchEdit         vSearchRegex                    x%GAP_SIZE%         y%GAP_SIZE%     w%SEARCH_EDIT_WIDTH%    h%LINE_HEIGHT%
    Gui ClipSearch:Add, Button,     hWndhClipSearchButton       gClipSearchUpdateListView       x%SEARCH_BUTTON_X%  y%GAP_SIZE%     w%SEARCH_BUTTON_WIDTH%  h%LINE_HEIGHT%,     &Search
    Gui ClipSearch:Add, Button,     hWndhClipSearchCancelButton gClipSearchCancelUpdateListView x%CANCEL_BUTTON_X%  y%GAP_SIZE%     w%CANCEL_BUTTON_WIDTH%  h%LINE_HEIGHT%,     &Cancel
    Gui ClipSearch:Add, ListView,   hWndhClipSearchListView     gClipSearchListViewEvent        x%GAP_SIZE%         y%CLIP_LIST_Y%  w%CLIP_LIST_WIDTH%      h%CLIP_LIST_HEIGHT%  +Grid -Multi -HScroll -VScroll -0x200000 +LV0x4000, Index|Clip File|Content
    ;SendMessage 0x1501, 1, "Search",, ahk_id %hClipSearchEdit% ; EM_SETCUEBANNER

    ClipSearchGUIApplyIdleMode()

    Gui ClipSearch:Show, w%WINDOW_WIDTH% h%WINDOW_HEIGHT%, Clip Search
}

;------------------------------------------------
; Events

ClipSearchGuiSize() {
    global

    If (A_EventInfo == 1)
        return

    AutoXYWH("w*", hClipSearchEdit)
    AutoXYWH("x", hClipSearchButton)
    AutoXYWH("x", hClipSearchCancelButton)
    AutoXYWH("wh*", hClipSearchListView)
}

ClipSearchListViewEvent(hwnd, eventType, row) {
    global clipLogDir

    if (eventType != "DoubleClick")
        return
    
    LV_GetText(clipFileToLoad, row, 2)
    getClipFromFile(clipLogDir . clipFileToLoad, tmpClipData)
    Clipboard := tmpClipData
}

ClipSearchUpdateListView() {
    global 

    clipMode := clipModeSearch
    ClipSearchGUIApplySearchMode()

    ; Ensure that the right list view is being poked
    Gui ClipSearch:Default
    Gui ClipSearch:ListView, ClipSearchListView

    Gui ClipSearch:Submit, NoHide

    ; Clear list
    LV_Delete()
    
    backupClipData := ClipboardAll
    Loop, % 950 { ;clipFiles.count()
        ; Stop if canceled
        if (clipMode == clipModeNone)
            break
        
        setClipboardFromFileWithoutLogging(getClipFilePath(A_Index-1))
        if (getExtension(getClipFileName(A_Index-1)) == clipTextExt && RegExMatch(Clipboard, SearchRegex) > 0)
            LV_Add("", A_Index-1, SubStr(getClipFileName(A_Index-1), 1, 13), Clipboard)
    }
    setClipboardFromDataWithoutLogging(backupClipData)
    
    ; Auto adjust column width
    Loop, 3
        LV_ModifyCol(A_Index, "AutoHdr")
    
    ClipSearchGUIApplyIdleMode()
    clipMode := clipModeNone
}

ClipSearchCancelUpdateListView() {
    global
    clipMode := clipModeNone
}

ClipSearchGuiEscape:
ClipSearchGuiClose:
    ; Exit from searching mode if closed
    if (clipMode == clipModeSearch)
        clipMode := clipModeNone
    
    Gui ClipSearch:Destroy
return

;------------------------------------------------
; Utils

ClipSearchGUIApplyIdleMode() {
    global
    GuiControl, Enable, %hClipSearchEdit%
    GuiControl, Enable, %hClipSearchButton%
    GuiControl, Disable, %hClipSearchCancelButton%

    GuiControl, , %hClipSearchButton%, &Search
}

ClipSearchGUIApplySearchMode() {
    global
    GuiControl, Disable, %hClipSearchEdit%
    GuiControl, Disable, %hClipSearchButton%
    GuiControl, Enable, %hClipSearchCancelButton%

    GuiControl, , %hClipSearchButton%, &Searching...
}
