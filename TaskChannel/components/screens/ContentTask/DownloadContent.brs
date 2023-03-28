sub init()
  'this function is called when control is set to "run"
   m.top.functionName = "getContent"
end sub

sub getContent()
    xfer = CreateObject("roUrlTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://api.ted.com/v1/talks.json?api-key=4aufvjhph9rawjrp7xv23rte&sort=newest&fields=photo_urls,images,speakers,languages,media,media_profile_uris,viewed_count,image,original_image,talks&photo_url_sizes=113x85,240x180,615x461")
    'set up a root ContentNode
    m.parentNode = CreateObject("roSGNode", "ContentNode")
    'first and second child for the rows
    m.childNode1 = m.parentNode.createChild("ContentNode")
    m.childNode2 = m.parentNode.createChild("ContentNode")

    json = parseJson(xfer.GetToString())

    'retrieving data for talks
    if json <> invalid
        for each element in json.talks 'element is assoc array that contains talk
          if element.talk <> invalid
           talk = element.talk
           rowChild = CreateObject("roSGNode", "ContentNode") 'creating items for row
           rowChild.Title = talk.name
           rowChild.Description = talk.description
           rowChild.ReleaseDate = talk.released_at

            if talk.media_profile_uris <> invalid then
              uris = talk.media_profile_uris
           
             if uris.DoesExist("internal") then  
               videoUrl = uris.internal
                if videoUrl.DoesExist("2500k") then
                  rowChild.Url = videoUrl.Lookup("2500k").uri
                elseif videoUrl.DoesExist("transcript") then
                  rowChild.Url = videoUrl.transcript.uri
                 end if
               endif

             end if 

            if talk.photo_urls[2].url <> invalid then
              rowChild.HDGRIDPOSTERURL = talk.photo_urls[2].url
            end if
           m.childNode1.appendChild(rowChild)
        end if
        end for
    end if

'retrieving data for playlists    
xfer.SetUrl("https://api.ted.com/v1/playlists.json?api-key=4aufvjhph9rawjrp7xv23rte")

json = parseJson(xfer.GetToString())

if json <> invalid
    for each element in json.playlists 'element is a assoc array that contains playlist
      if element.playlist <> invalid then
       playlist = element.playlist
       playlistItem = CreateObject("roSGNode", "ContentNode") 'creating node for each item in the row 
       playlistItem.title = playlist.title
       playlistItem.description = playlist.description
       playlistItem.releaseDate = playlist.created_at
       playlistItem.HDGRIDPOSTERURL = "pkg:/images/icon_focus_hd.png"
      m.childNode2.appendChild(playlistItem)
      end if
    end for
end if
m.top.content = m.parentNode
end sub
