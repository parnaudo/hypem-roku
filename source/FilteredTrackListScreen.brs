function FilteredTrackListScreen(source as String, lists as Object, modes as Object) as Object

    instance = TrackListScreen(source, { mode: modes[0] })
    instance._modes = modes
    instance._screen.setListNames(lists)
    instance.tlOnMessage = instance.onMessage

    instance.onMessage = function(msg)
        if msg.isListFocused() return m.onListFocused(msg)
        return m.tlOnMessage(msg)
    end function

    instance.onListFocused = function(msg as Object)
        mode = m._modes[msg.getIndex()]
        m._tracks.setMode(mode)
        m.updateContentList()
        return true
    end function

    return instance

end function