sub Init()
    'set the name if the fucntion in the Task node component to be executed when the state field changes to RUN
    'in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    'request the content feed from the API
    xfer = CreateObject("roUrlTransfer")
    'xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://api.ted.com/v1/talks.json?api-key=4aufvjhph9rawjrp7xv23rte&sort=newest&fields=photo_urls,images,speakers,languages,media,media_profile_uris,viewed_count,image,original_image,talks&photo_url_sizes=113x85,240x180,615x461")
    data = xfer.GetToString()
    rootChildren = []

    'parse the feed and build a tree of ContentNodes to populate the GridView
    json = ParseJson(data)
    if json <> invalid
        for each talk in json.talks
            value = json.Lookup(talk)
            if Type(value) = "roAssociativeArray" 'if parsed key value having other objects in it
                    row = {}
                    row.title = talk.name
                    row.children = []
                    for each item in value 'parse items and push them to row
                        itemData = GetItemData(item)
                        row.children.Push(itemData)
                    end for
                    rootChildren.Push(row)
            end if
        end for
        'set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.update({
            children: rootChildren
        }, true)
        ' populate content field with root content node
        ' Observe(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = contentNode
    end if
end sub

function GetItemData(video as Object) as Object
    item = {}
    'populate some standard content metadata fields to be displayed on the GridScreen
    if video.description <> invalid
        item.description = video.description
    else
        item.description = "No Description."
    end if
    item.hdPosterURL = video.photo_urls[0].url
    item.title = video.name
    item.relaseDate = video.released_at
    item.id = video.id
    item.length = video.media.duration
    return item
end function