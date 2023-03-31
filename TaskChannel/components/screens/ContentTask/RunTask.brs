sub startDownloading()
    'creates task node and activates it
    m.contentTask = CreateObject("roSGNode", "DownloadContent")
    m.contentTask.ObserveField("content", "load")
    m.contentTask.control = "run"
end sub

sub load() 'invoked when content is ready to be use
    m.gridScreen = m.top.findNode("GridScreen")
    m.gridScreen.SetFocus(true)
    m.gridScreen.content = m.contentTask.content 'populate Gris with content
end sub
