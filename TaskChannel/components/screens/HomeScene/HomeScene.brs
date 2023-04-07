
Function init()
    m.screenStack = []
    m.gridScreen = m.top.findNode("GridScreen")
    m.detailsScreen = m.top.findNode("DetailsScreen")
    startDownloading()
    showScreen(m.gridScreen)
End Function 

' Row item selected handler
Function onRowItemSelected()
    hideScreen(m.gridScreen)
    m.detailsScreen.content = m.gridScreen.focusedContent
    m.detailsScreen.setFocus(true)
    showScreen(m.detailsScreen)
End Function

' if content set, focus on GridScreen
Sub onChangeContent()
    m.gridScreen.setFocus(true)
End Sub

Function onkeyEvent(key, press) as Boolean
    handled = false
    if press then
        if key = "back" then
        
          ' if Details opened
            if m.gridScreen.visible = false and m.detailsScreen.videoPlayerVisible = false then
              hideScreen(m.detailsScreen)
              showScreen(m.gridScreen)
              m.gridScreen.setFocus(true)
              handled = true
            else if m.gridScreen.visible = false and m.detailsScreen.videoPlayerVisible = true
              m.detailsScreen.videoPlayerVisible = false
              handled = true
            end if

            if handled = false then
             hideTop()
             handled = m.screenStack.count() <> 0
            end if

         end if
    end if
    return handled
End Function

Sub showScreen(node)
    prev = m.screenStack.peek()
    if prev <> invalid then
        prev.visible = false
    end if
    node.visible = true
    node.setFocus(true)
    m.screenStack.push(node)
End Sub

Sub hideTop()
    hideScreen(invalid)
end Sub

Sub hideScreen(node as Object)
    if node = invalid OR (m.screenStack.peek() <> invalid AND m.screenStack.peek().isSameNode(node)) then
        last = m.screenStack.pop()
        last.visible = false
        
        prev = m.screenStack.peek()
        if prev <> invalid then
            prev.visible = true
            prev.setFocus(true)
        end if
    end if
End Sub
