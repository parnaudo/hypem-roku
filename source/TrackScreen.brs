function TrackScreen(index as Integer, tracks as Object) as Object

    instance          = {}
    instance._index   = index
    instance._tracks  = tracks
    instance._audio   = AudioPlayer()
    instance._screen  = createScreen("Springboard")
    instance._port    = instance._screen.getMessagePort()

    instance._screen.setDisplayMode("zoom-to-fill")
    instance._screen.setProgressIndicatorEnabled(true)
    instance._screen.allowNavLeft(index > 0)
    instance._screen.allowNavRewind(true)
    instance._screen.allowNavFastForward(true)
    instance._audio.setMessagePort(instance._port)

    instance.syncContent = function()
        content = m._tracks.getContent(m._index)
        if content = invalid return invalid
        m._screen.setContent(content)
        m._totalTime = content.length
        tracks = m._audio.getTracks()
        if tracks = invalid or tracks.getContentList().peek().url <> m._tracks.getContentList().peek().url then
            m._audio.setTracks(m._tracks)
            m._audio.setTrackIndex(m._index)
        elseif m._audio.getTrackIndex() <> m._index then
            m._audio.setTrackIndex(m._index)
        end if
        m.updateProgress()
        return content
    end function

    instance.setPlayState = function(state as Integer)
        m._audio.setPlayState(state)
        m._screen.clearButtons()
        if (state = m._audio.STATE_PLAY) then
            m._screen.addButton(1, "Pause")
            m._screen.addButton(2, "Stop")
        elseif (state = m._audio.STATE_PAUSE) then
            m._screen.addButton(1, "Resume")
            m._screen.addButton(2, "Stop")
        else
            m._screen.addButton(1, "Play")
        endif
    end function

    instance.show = function()
        m._screen.show()
        m.syncContent()
        m.play()
        while true
            msg = wait(1000, m._port)
            class = type(msg)
            if class = "roSpringboardScreenEvent" then
                if not m.onScreenEvent(msg) return m._index
            elseif class = "roAudioPlayerEvent" then
                m.onAudioEvent(msg)
            endif
            if m._audio.isPlaying() then
                m.updateProgress()
            endif
        end while
        return m._index
    end function

    instance.updateProgress = function()
        m._screen.setProgressIndicator(m._audio.getTimeElapsed(), m._audio.getTimeTotal())
    end function

    instance.onScreenEvent = function(msg as Object) as Boolean
        if msg.isScreenClosed() then
            return false
        elseif msg.isButtonPressed() then
            return m.onButtonPressed(msg)
        elseif msg.isRemoteKeyPressed() then    
            m.onRemoteKeyPressed(msg)
        endif
        return true
    end function

    instance.play = function()
        m.setPlayState(m._audio.STATE_PLAY)
    end function

    instance.pause = function()
        m.setPlayState(m._audio.STATE_PAUSE)
    end function

    instance.stop = function()
        m._elapsedTime = 0
        m.setPlayState(m._audio.STATE_STOP)
    end function

    instance.next = function()
        m.stop()
        m._index = m._index + 1
        if m.syncContent() = invalid then
            m._index = m._index - 1
        endif
        if m._index > 0 then
            m._screen.allowNavLeft(true)
        endif
        m.play()
    end function

    instance.prev = function()
        if m._index <= 0 then
            m._index = 0
            m._screen.allowNavLeft(false)
            return 0
        endif
        m.stop()
        m._index = m._index - 1
        m.syncContent()
        m.play()
    end function

    instance.onButtonPressed = function(msg as Object) as Boolean
        if msg.getIndex() = 1 then
            if m._audio.playState = m._audio.STATE_PLAY then
                m.pause()
            else
                m.play()
            endif
            return true
        else
            m.stop()
            return false
        endif
    end function

    instance.onRemoteKeyPressed = function(msg as Object)
        index = msg.GetIndex()
        if index = 4 then
            m.prev()
        elseif index = 5 then
            m.next()
        elseif index = 8 then
            m.rewind()
        elseif index = 9 then
            m.fastForward()
        endif
    end function

    instance.rewind = function()
        m._audio.seekTrack(-10)
        m.updateProgress()
    end function

    instance.fastForward = function()
        m._audio.seekTrack(10)
        m.updateProgress()
    end function

    instance.onAudioEvent = function(msg as Object)
        if msg.isRequestSucceeded() then
            m.next()
        endif
    end function

    return instance

end function