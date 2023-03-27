sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    xfer = CreateObject("roUrlTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://api.ted.com/v1/talks.json?api-key=4aufvjhph9rawjrp7xv23rte&sort=newest&fields=photo_urls,images,speakers,languages,media,media_profile_uris,viewed_count,image,original_image,talks&photo_url_sizes=113x85,240x180,615x461")
    'set up a root ContentNode
    m.parentNode = CreateObject("roSGNode", "ContentNode")
    'first and second child for the row of talks
    m.childNode1 = m.parentNode.createChild("ContentNode")
    m.childNode2 = m.parentNode.createChild("ContentNode")

    json = ParseJson(xfer.GetToString())

    'retrieving data for talks
    if json <> invalid
        for each element in json.talks 'element is assoc array that contains talk
          if element.talk <> invalid
           var = element.talk
           rowChild = CreateObject("roSGNode", "ContentNode") 'creating items for row
           rowChild.Title = var.name
           rowChild.Description = var.description
           rowChild.ReleaseDate = var.released_at

            if var.media_profile_uris <> invalid then
             var2 = var.media_profile_uris
           
             if var2.DoesExist("internal") then  
               var3 = var2.internal
                if var3.DoesExist("2500k") then
                  rowChild.Url = var3.Lookup("2500k").uri
                elseif var3.DoesExist("transcript") then
                  rowChild.Url = var3.transcript.uri
                 end if
               endif

             end if 

            if var.photo_urls[2].url <> invalid then
              rowChild.HDGRIDPOSTERURL = var.photo_urls[2].url
            end if
           m.childNode1.appendChild(rowChild)
        end if
        end for
    end if

'retrieving data for playlists    
xfer.SetUrl("https://api.ted.com/v1/playlists.json?api-key=4aufvjhph9rawjrp7xv23rte")

json = ParseJson(xfer.GetToString())

if json <> invalid
    for each element in json.playlists 'element is a assoc array that contains play list
      if element.playlist <> invalid then
       var = element.playlist
       playlistItem = CreateObject("roSGNode", "ContentNode") 'creating node for each item for the row 
       playlistItem.Title = var.title
       playlistItem.Description = var.description
       playlistItem.ReleaseDate = var.created_at
       playlistItem.HDGRIDPOSTERURL = "pkg:/images/icon_focus_hd.png"
      m.childNode2.appendChild(playlistItem)
      end if
    end for
end if
m.top.content = m.parentNode
end sub
