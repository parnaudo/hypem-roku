function SortedTrackListScreen(source as String, lists as Object, sorts as Object) as Object

    instance = TrackListScreen(source, { sort: sorts[0] })
    instance._sorts = sorts
    instance._screen.setListNames(lists)
    instance.tlOnMessage = instance.onMessage

    instance.onMessage = function(msg)
        if msg.isListFocused() return m.onListFocused(msg)
        return m.tlOnMessage(msg)
    end function

    instance.onListFocused = function(msg as Object)
        sort = m._sorts[msg.getIndex()]
        m._tracks.setSort(sort)
        m.updateContentList()
        return true
    end function

    return instance

end function