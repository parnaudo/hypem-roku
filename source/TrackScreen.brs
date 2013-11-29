function TrackScreen(index as Integer, tracks as Object) as Object

    instance = {}
    instance._elapsedTime = 0
    instance._totalTime   = 0
    instance._index   = index
    instance._tracks  = tracks
    instance._audio   = AudioPlayer()
    instance._screen  = createScreen("Springboard")
    instance._port    = instance._screen.getMessagePort()

    instance.syncContent = function()
        content = m._tracks.getContent(m._index)
        if content = invalid return invalid
        counter = m._tracks.getContentCount()
        m._screen.setContent(content)
        m._totalTime = content.length
        m.updateProgress()
        if counter <> m._tracks.getContentCount() then
            m.syncTracks()
        end if
        m._audio.selectTrack(m._index)
        return content
    end function

    instance.setPlayState = function(state as Integer)
        m._audio.setPlayState(state)
        m._screen.clearButtons()
        if (state = m._audio.STATE_PLAY) then
            m._screen.addButton(1, "Pause")
            m._screen.addButton(2, "Stop")
        else if (state = m._audio.STATE_PAUSE) then
            m._screen.addButton(1, "Resume")
            m._screen.addButton(2, "Stop")
        else
            m._screen.addButton(1, "Play")
        endif
    end function

    instance.show = function()
        m._screen.show()
        m.play()
        while true
            msg = wait(1000, m._port)
            class = type(msg)
            if class = "roSpringboardScreenEvent" then
                if not m.onScreenEvent(msg) return m._index
            else if class = "roAudioPlayerEvent" then
                m.onAudioEvent(msg)
            else if class = "Invalid" and m._audio.playState = m._audio.STATE_PLAY then
                m.updateProgress()
            end if
        end while
        return m._index
    end function

    instance.updateProgress = function()
        m._elapsedTime = m._elapsedTime + 1
        m._screen.setProgressIndicator(m._elapsedTime, m._totalTime)
    end function

    instance.syncTracks = function()
        m._audio.setContentList(m._tracks.getContentList()) 
    end function

    instance.onScreenEvent = function(msg as Object) as Boolean
        if msg.isScreenClosed() then
            return m.onScreenClosed(msg)
        elseif msg.isButtonPressed() then
            return m.onButtonPressed(msg)
        elseif msg.isRemoteKeyPressed() then    
            m.onRemoteKeyPressed(msg)
        end if
        return true
    end function

    instance.onScreenClosed = function(msg as Object) as Boolean
        m.stop()
        return false
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
        end if
        m.play()
    end function

    instance.prev = function()
        if m._index <= 0 then
            m._index = 0
            m._screen.allowNavLeft(false)
            return 0
        end if
        m.stop()
        m._index = m._index - 1
        m.syncContent()
        m.play()
    end function

    instance.onButtonPressed = function(msg as Object) as Boolean
        if msg.GetIndex() = 1 then
            if m._audio.playState = m._audio.STATE_PLAY then
                m.pause()
            else
                m.play()
            end if
            return true
        else
            m.stop()
            return false
        end if
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
        end if
    end function

    instance.rewind = function()
        if m._elapsedTime > 10 then
            m._elapsedTime = m._elapsedTime - 10
        else
            m._elapsedTime = 0
        end if
        m._audio.seekTrack(m._elapsedTime)
    end function

    instance.fastForward = function()
        if m._elapsedTime < (m._totalTime-10) then
            m._elapsedTime = m._elapsedTime + 10
        else
            m._elapsedTime = m._totalTime
        end if
        m._audio.seekTrack(m._elapsedTime)
    end function

    instance.onAudioEvent = function(msg as Object)
        if msg.isRequestSucceeded() then
            m.next()
        end if
    end function

    instance._screen.setProgressIndicatorEnabled(true)
    instance._screen.allowNavLeft(index > 0)
    instance._screen.allowNavRewind(true)
    instance._screen.allowNavFastForward(true)

    instance._audio.setMessagePort(instance._port)
    instance.syncTracks()
    instance.syncContent()

    return instance

end function