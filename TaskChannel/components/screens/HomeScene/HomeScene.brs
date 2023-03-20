 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ' listen on port 8089
    ? "[HomeScene] Init"
    m.top.backgroundColor = "0xEB1010FF"
    m.top.backgroundURI = ""
    m.screenStack = []
    'main grid screen node
    m.GridScreen = m.top.findNode("GridScreen")
    ShowScreen(m.GridScreen)
    StartDownloading()
End Function 

' Row item selected handler
Sub PlayVideoFromGrid()
    ? "[HomeScene] OnRowItemSelected"
    selectedItem = m.GridScreen.focusedContent
    
    m.videoPlayer = CreateObject("roSGNode", "Video")
    m.videoPlayer.id="videoPlayer"
    m.videoPlayer.translation="[0, 0]"
    m.videoPlayer.width="1280"
    m.videoPlayer.height="720"
    m.top.appendChild(m.videoPlayer)
    
    'init of video player and start playback
    m.videoPlayer.content = selectedItem
    'show video player
    ShowScreen(m.videoPlayer)

    m.videoPlayer.control = "play"
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.observeField("visible", "OnVideoPlayerVisibilityChange")
End Sub

Sub OnVideoPlayerStateChange()
    ? "HomeScene > OnVideoPlayerStateChange : state == ";m.videoPlayer.state
    if m.videoPlayer.state = "error" OR m.videoPlayer.state = "finished"
        'hide video player in case of error
        HideScreen(m.videoplayer)
    end if
end Sub

sub OnVideoPlayerVisibilityChange()
    'stop video playback
    if not m.videoPlayer.visible then
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
        m.top.removeChild(m.videoPlayer)
        m.videoPlayer = invalid
    end if
end sub

' if content set, focus on GridScreen
Sub OnChangeContent()
    ? "OnChangeContent "
    m.GridScreen.setFocus(true)
End Sub

' Main Remote keypress event loop
Function OnkeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    result = false
    if press
        if key = "back"
            HideTop()
            result = m.screenStack.count() <> 0
        else if key = "options"
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