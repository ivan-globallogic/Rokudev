sub startDownloading()
    'creates task node and activates it
    m.contentTask = CreateObject("roSGNode", "DownloadContent")
    m.contentTask.ObserveField("content", "load")
    m.contentTask.control = "run"
end sub

sub load() 'invoked when content is ready to be used
    m.gridScreen = m.top.findNode("gridScreen")
    'm.descriptionGridScreen = m.top.findNode("descriptionGridScreen")
    m.gridScreen.SetFocus(true)
    m.gridScreen.content = m.contentTask.content 'populate Grid with content
    'm.descriptionGridScreen.content = m.contentTask.content
end sub
