
Function Init()
    ? "[HomeScene] Init"
    m.screenStack = []
    m.GridScreen = m.top.findNode("GridScreen")
    m.detailsScreen = m.top.findNode("DetailsScreen")
    StartDownloading()
    ShowScreen(m.GridScreen)
End Function 

' Row item selected handler
Function OnRowItemSelected()
    HideScreen(m.GridScreen)
    m.detailsScreen.content = m.gridScreen.focusedContent
    m.detailsScreen.setFocus(true)
    ShowScreen(m.DetailsScreen)
End Function

' if content set, focus on GridScreen
Sub OnChangeContent()
    ? "OnChangeContent "
    m.GridScreen.setFocus(true)
End Sub

Function OnkeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    result = false
    if press
        if key = "back" then
        
        ' if Details opened
          if m.gridScreen.visible = false and m.detailsScreen.videoPlayerVisible = false
            HideScreen(m.detailsScreen)
            ShowScreen(m.gridScreen)
            m.gridScreen.setFocus(true)
            result = true
          else if m.gridScreen.visible = false and m.detailsScreen.videoPlayerVisible = true
            m.detailsScreen.videoPlayerVisible = false
            result = true
          end if

          if result = false
           HideTop()
           result = m.screenStack.count() <> 0
           else if key = "options"
           end if
          end if

        ? "key == ";key
    end if
    return result
End Function

Sub ShowScreen(node)
    prev = m.screenStack.peek()
    if prev <> invalid
        prev.visible = false
    end if
    node.visible = true
    node.setFocus(true)
    m.screenStack.push(node)
End Sub

Sub HideTop()
    HideScreen(invalid)
end Sub

Sub HideScreen(node as Object)
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
