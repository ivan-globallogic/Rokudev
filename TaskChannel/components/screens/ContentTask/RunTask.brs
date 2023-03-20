sub StartDownloading()
    m.contentTask = CreateObject("roSGNode", "DownloadContent")
    m.contentTask.ObserveField("content", "Load")
    m.contentTask.control = "run"
end sub

sub Load() 'invoked when content is ready to be used
    m.GridScreen.SetFocus(true) 'set focus to GridScreen
    m.GridScreen.content = m.contentTask.content 'populate GridScreen with content
end sub