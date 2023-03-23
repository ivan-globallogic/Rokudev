sub Init()
    'set the name so the fucntion in the Task node component to be executed when the state field changes to RUN
    'in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    'request the content feed from the API
    xfer = CreateObject("roUrlTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://api.ted.com/v1/talks.json?api-key=4aufvjhph9rawjrp7xv23rte&sort=newest&fields=photo_urls,images,speakers,languages,media,media_profile_uris,viewed_count,image,original_image,talks&photo_url_sizes=113x85,240x180,615x461")
    'set up a root ContentNode to represent rowList on the GridScreen
    m.parentNode = CreateObject("roSGNode", "ContentNode")
    'first child for the row of talks
    m.childNode1 = m.parentNode.createChild("ContentNode")
    'second child for the row of talks
    m.childNode2 = m.parentNode.createChild("ContentNode")

    'parse the feed and build a tree of ContentNodes to populate the GridView
    json = ParseJson(xfer.GetToString())

    'taking the data needed for the talks row
    if json <> invalid
        'a=1
        for each element in json.talks 'element is assoc array, element = talk
           rowChild = CreateObject("roSGNode", "ContentNode") 'creating items for row
           rowChild.Title = element.talk.name
           rowChild.Description = element.talk.description
           rowChild.ReleaseDate = element.talk.released_at
           '?"count: "; a; " ,mpc je tip: "; Type(element.talk.media_profile_uris)
           'a = a+1

           if element.talk.media_profile_uris.DoesExist("internal") then  
              if element.talk.media_profile_uris.internal.DoesExist("2500k") then
                rowChild.Url = element.talk.media_profile_uris.internal.Lookup("2500k").uri
              elseif element.talk.media_profile_uris.internal.DoesExist("transcript") then
                rowChild.Url = element.talk.media_profile_uris.internal.transcript.uri
              end if
           end if 

          if element.talk.photo_urls[2].url <> invalid then
            rowChild.HDGRIDPOSTERURL = element.talk.photo_urls[2].url
          end if
          m.childNode1.appendChild(rowChild)
        end for
        'm.top.content = contentNode
    end if

'retrieving data for playlists    
xfer.SetUrl("https://api.ted.com/v1/playlists.json?api-key=4aufvjhph9rawjrp7xv23rte")

json = ParseJson(xfer.GetToString())
if json <> invalid
    for each element in json.playlists 'element is assoc array, element = playlist
       rowChild = CreateObject("roSGNode", "ContentNode") 'creating node for each item for the row 
       rowChild.Title = element.playlist.title
       rowChild.Description = element.playlist.description
       rowChild.ReleaseDate = element.playlist.created_at
       rowChild.HDGRIDPOSTERURL = "pkg:/images/icon_focus_hd.png"
      m.childNode2.appendChild(rowChild)
    end for
end if
m.top.content = m.parentNode
end sub