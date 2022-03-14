
showClipSearchGUI() {
    global

    Gui ClipSearch:New
    Gui ClipSearch:+Resize
    Gui ClipSearch:Font, s11
    Gui ClipSearch:Add, Edit, hWndhClipSearchEdit vSearchRegex x8 y8 w569 h21
    Gui ClipSearch:Add, Button, hWndhClipSearchButton x584 y7 w80 h23 gClipSearchUpdateListView, &Search
    Gui ClipSearch:Add, ListView, hWndhClipSearchListView gClipSearchListViewEvent x8 y40 w657 h357 +Grid -Multi -HScroll -VScroll -0x200000 +LV0x4000, Index|Clip File|Content
    SendMessage 0x1501, 1, "Search",, ahk_id %hClipSearchEdit% ; EM_SETCUEBANNER

    Gui ClipSearch:Show, w671 h405, Window
}

;------------------------------------------------
; Events

ClipSearchGuiSize() {
    global

    If (A_EventInfo == 1)
        return

    AutoXYWH("w*", hClipSearchEdit)
    AutoXYWH("x", hClipSearchButton)
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
    global ClipSearchListView
    global clipMode
    global clipModeNone
    global clipModeSearch
    global clipTextExt
    global SearchRegex

    clipMode := clipModeSearch

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
            LV_Add("", A_Index-1, getClipFileName(A_Index-1), Clipboard)
    }
    setClipboardFromDataWithoutLogging(backupClipData)
    
    ; Auto adjust column width
    Loop, 3
        LV_ModifyCol(A_Index, "AutoHdr")
    
    clipMode := clipModeNone
}

ClipSearchGuiEscape:
ClipSearchGuiClose:
    ; Exit from searching mode if closed
    if (clipMode == clipModeSearch)
        clipMode := clipModeNone
    
    Gui ClipSearch:Destroy
return
