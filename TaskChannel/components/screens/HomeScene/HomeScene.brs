
Function init()
    m.screenStack = []
    m.grid_screen = m.top.findNode("gridScreen")
    m.details_screen = m.top.findNode("detailsScreen")
    startDownloading()
    showScreen(m.grid_screen)
End Function 

' Row item selected handler
Function onRowItemSelected()
    hideScreen(m.grid_screen)
    m.details_screen.content = m.grid_screen.focusedContent
    m.details_screen.setFocus(true)
    showScreen(m.details_screen)
End Function

' if content set, focus on GridScreen
Sub onChangeContent()
    ? "OnChangeContent "
    m.grid_screen.setFocus(true)
End Sub

Function onkeyEvent(key, press) as Boolean
    handled = false
    if press
        if key = "back" then
        
          ' if Details opened
            if m.grid_screen.visible = false and m.details_screen.videoPlayerVisible = false
              hideScreen(m.details_screen)
              showScreen(m.grid_screen)
              m.grid_screen.setFocus(true)
              handled = true
            else if m.grid_screen.visible = false and m.details_screen.videoPlayerVisible = true
              m.details_screen.videoPlayerVisible = false
              handled = true
            end if

            if handled = false
             hideTop()
             handled = m.screenStack.count() <> 0
            end if

         end if
    end if
    return handled
End Function

Sub showScreen(node)
    prev = m.screenStack.peek()
    if prev <> invalid
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
    if node = invalid OR (m.screenStack.peek() <> invalid AND m.screenStack.peek().isSameNode(node)) 
        last = m.screenStack.pop()
        last.visible = false
        
        prev = m.screenStack.peek()
        if prev <> invalid
            prev.visible = true
            prev.setFocus(true)
        end if
    end if
End Sub
