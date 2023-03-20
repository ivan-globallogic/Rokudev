
sub Main()
    screen = CreateObject("roSGScreen")
    scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()

    while true
        msg = wait(0, port)
        print "------------------"
        print "Message is "; msg
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
end sub

