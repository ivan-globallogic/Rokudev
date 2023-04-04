sub init()
  'this function is called when control is set to "run"
   m.top.functionName = "getContent"
end sub

sub getContent()
    'setting data url
    xfer = CreateObject("roUrlTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://api.ted.com/v1/talks.json?api-key=4aufvjhph9rawjrp7xv23rte&sort=newest&fields=photo_urls,images,speakers,languages,media,media_profile_uris,viewed_count,image,original_image,talks&photo_url_sizes=113x85,240x180,615x461")

    'creating root ContentNode and its children for rows
    m.parentNode = CreateObject("roSGNode", "ContentNode")
    m.childNode1 = m.parentNode.createChild("ContentNode")
    m.childNode2 = m.parentNode.createChild("ContentNode")

    'retrieving data for talks
    json = parseJson(xfer.GetToString())
    if json <> invalid
      settingTalksRowContent(json)
    end if

    'retrieving data for playlists    
    xfer.SetUrl("https://api.ted.com/v1/playlists.json?api-key=4aufvjhph9rawjrp7xv23rte")
    json = parseJson(xfer.GetToString())
    if json <> invalid
      settingPlaylistsRowContent(json)
    end if

    'populating the Content field with retrieved data
    m.top.content = m.parentNode
end sub

sub settingTalksRowContent(json as Object)
  for each element in json.talks 'element is assoc array that contains talk
    if element.talk <> invalid
     talk = element.talk
     rowChild = CreateObject("roSGNode", "ContentNode") 'creating items for row
     rowChild.update(
      {
        Title: talk.name
        Description: talk.name
        ReleaseDate: talk.released_at
      }
      )

     'retrieving url stream 
      if talk.media_profile_uris <> invalid then
        uris = talk.media_profile_uris     
        if uris.DoesExist("internal") then  
          videoUrl = uris.internal
          if videoUrl.DoesExist("2500k") then
            rowChild.Url = videoUrl.Lookup("2500k").uri
          elseif videoUrl.DoesExist("transcript") then
            rowChild.Url = videoUrl.transcript.uri
          end if
        end if
      end if 

      if talk.photo_urls[1].url <> invalid then
        rowChild.HDGRIDPOSTERURL = talk.photo_urls[1].url
      end if

      m.childNode1.appendChild(rowChild)
   end if
 end for
end sub

sub settingPlaylistsRowContent(json as Object)
  for each element in json.playlists 'element is a assoc array that contains playlist
    if element.playlist <> invalid then
     playlist = element.playlist
     playlistItem = CreateObject("roSGNode", "ContentNode") 'creating node for each item in the row
     playlistItem.update(
      {
        Title: playlist.title
        Description: playlist.description
        ReleaseDate: playlist.create_at
        HDGridPosterURL: "pkg:/images/icon_focus_hd.png"
      }
      )
     m.childNode2.appendChild(playlistItem)
    end if
  end for
end sub
