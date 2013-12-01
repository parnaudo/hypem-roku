function TrackListScreen(source as String, params as Object) as Object

    instance = {}
    instance._tracks = TrackListAdapter(source, params)
    instance._screen = createScreen("Poster")
    instance._screen.setListStyle("arced-square")
    instance._screen.setListDisplayMode("zoom-to-fill")
	
    instance.show = function()
        m._screen.show()
        m.updateContentList()
        continue = true
        while continue
            msg = wait(0, m._screen.getMessagePort())
            continue = m.onMessage(msg)
        end while
    end function

    instance.onMessage = function(msg as Object) as Boolean
        if msg.isListItemFocused() then
            return m.onListItemFocused(msg)
        elseif msg.isListItemSelected() then
            return m.onListItemSelected(msg)    
        elseif msg.isScreenClosed() then
            return false
        end if
        return true
    end function

    instance.onListItemFocused = function(msg as Object) as Boolean
        limit = m._tracks.getContentCount()
        if msg.getIndex() >= (limit-3) then ' infinite scroll
            m.updateContentListUntil(limit)
        end if
        return true
    end function

    instance.updateContentList = function()
        m.updateContentListUntil(0)
    end function

    instance.updateContentListUntil = function(index)
        m._screen.setContentList(m._tracks.getContentListUntil(index))
    end function

    instance.onListItemSelected = function(msg as Object) as Boolean
        index = TrackScreen(msg.getIndex(), m._tracks).show()
        m.updateContentListUntil(index)
        m._screen.setFocusedListItem(index)
        return true
    end function

    return instance

end function