
Function init()
 m.top.observeField("visible", "onVisibilityChange")
 m.top.observeField("focusedChild", "onFocusedChildChange")

 m.buttons      =  m.top.findNode("buttons")
 m.videoPlayer  =  m.top.findNode("videoPlayer")
 m.description  =  m.top.findNode("descriptionDetailsScreen")
 m.background   =  m.top.findNode("background")

 ' create button
 result = createObject("roArray", 1, False)
 result.push({title : "Play"})
 m.buttons.content = contentListSimpleNode(result)
End Function

' on Button press handler
Sub onItemSelected()
 ' first button is Play
 if m.top.itemSelected = 0
     m.videoPlayer.visible = true
     m.videoPlayer.setFocus(true)
     m.videoPlayer.control = "play"
     m.videoPlayer.observeField("state", "onVideoPlayerStateChange")
 end if
End Sub

' set proper focus on buttons and stops video if return from Playback to details
Sub onVideoVisibilityChange()
 if m.videoPlayer.visible = false and m.top.visible = true
     m.buttons.setFocus(true)
     m.videoPlayer.control = "stop"
 end if
End Sub

' Content change handler
Sub onContentChange()
 m.description.content   = m.top.content
 m.videoPlayer.content   = m.top.content
 m.background.uri        = m.top.content.HDGRIDPOSTERURL
End Sub

' set proper focus to buttons if Details opened and stops Video if Details closed
Sub onVisiblityChange()
 if m.top.visible = true then
     m.buttons.jumpToItem = 0
     m.buttons.setFocus(true)
 else
     m.videoPlayer.visible = false
     m.videoPlayer.control = "stop"
     m.background.uri=""
 end if
End Sub

' set proper focus to Buttons in case if return from Video PLayer
Sub onFocusedChildChange()
 if m.top.isInFocusChain() and not m.buttons.hasFocus() and not m.videoPlayer.hasFocus() then
     m.buttons.setFocus(true)
 end if
End Sub

' event handler of Video player msg
Sub onVideoPlayerStateChange()
 if m.videoPlayer.state = "error"
     ' error handling
     m.videoPlayer.visible = false
 else if m.videoPlayer.state = "playing"
     ' playback handling
 else if m.videoPlayer.state = "finished"
     m.videoPlayer.visible = false
 end if
End Sub

' Helper function convert AA to Node
Function contentListSimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
 result = createObject("roSGNode",nodeType)
 if result <> invalid
     for each itemAA in contentList
         item = createObject("roSGNode", nodeType)
         item.setFields(itemAA)
         result.appendChild(item)
     end for
 end if
 return result
End Function
