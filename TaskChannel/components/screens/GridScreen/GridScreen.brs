 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ? "[GridScreen] Init"
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.top.observeField("visible", "onVisibleChange")

    m.rowList       =   m.top.findNode("RowList")
    m.description   =   m.top.findNode("Description")

End Function

' set proper focus to RowList in case if return from Details Screen
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.rowList.hasFocus() then
        m.rowList.setFocus(true)
    end if
End Sub

' handler of focused item in RowList
Sub OnItemFocused()
    itemFocused = m.top.itemFocused
    ? ">> GridScreen > OnItemFocused"; itemFocused

    'When an item gains the key focus, set to a 2-element array, 
    'where element 0 contains the index of the focused row, 
    'and element 1 contains the index of the focused item in that row.
    if itemFocused.Count() = 2 then
        'get content node by index from grid 
        focusedContent = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])

        if focusedContent <> invalid then
            'set focused content to top interface
            m.top.focusedContent = focusedContent
            
            'set content to description node
            m.Description.content = focusedContent
            
            'set background wallpaper
            'm.Background.uri = focusedContent.hdBackgroundImageUrl
        end if
    end if
End Sub

' when grid gets focused, transfer focus to the rowlist
Sub onVisibleChange()
    if m.top.visible = true then
        m.rowList.setFocus(true)
    end if
End Sub