sub StartDownloading()
    m.contentTask = CreateObject("roSGNode", "DownloadContent")
    m.contentTask.ObserveField("content", "Load")
    m.contentTask.control = "run"
end sub

sub Load()
    m.GridScreen.SetFocus(true)
    m.GridScreen.content = m.contentTask.content
end sub
