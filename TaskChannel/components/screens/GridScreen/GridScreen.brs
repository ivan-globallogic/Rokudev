
Function init()
    m.top.observeField("focusedChild", "onFocusedChildChange")
    m.top.observeField("visible", "onVisibleChange")

    m.rowList      =  m.top.findNode("rowList")
    m.description  =  m.top.findNode("descriptionGridScreen")
End Function

' set proper focus to RowList in case if return from Details Screen
Sub onFocusedChildChange()
    if m.top.isInFocusChain() and not m.rowList.hasFocus() then
        m.rowList.setFocus(true)
    end if
End Sub

' handler of focused item in RowList
Sub onItemFocused()
    itemFocused = m.top.itemFocused
    if itemFocused.Count() = 2 then
        focusedContent = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])

        if focusedContent <> invalid then
            m.top.focusedContent = focusedContent
            m.description.content = focusedContent
        end if

    end if
End Sub

' when grid gets focused, transfer focus to the rowlist
Sub onVisibleChange()
    if m.top.visible = true then
        m.rowList.setFocus(true)
    end if
End Sub
