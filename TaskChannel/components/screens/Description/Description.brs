
Sub init()
    m.title = m.top.findNode("titleLabel")
    m.description = m.top.findNode("descriptionLabel")
    m.releaseDate  = m.top.findNode("releaseDateLabel")
End Sub

' Content change handler
Sub onContentChanged()
    item = m.top.content

    title = item.title.toStr()
    if title <> invalid then
        m.title.text = title.toStr()
    end if
    
    value = item.description
    if value <> invalid then
        if value.toStr() <> "" then
            m.description.text = value.toStr()
        else
            m.description.text = "No description"
        end if
    end if
    
    value = item.releaseDate
    if value <> invalid then
        if value <> "" then
            m.releaseDate.text = value.toStr()
        else
            m.releaseDate.text = "No release date"
        end if
    end if
End Sub
