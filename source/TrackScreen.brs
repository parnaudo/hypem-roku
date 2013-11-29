function TrackScreen(index as Integer, tracks as Object) as Object

    instance = {}
    instance.elapsedTime = 0
    instance.totalTime   = 0
    instance.index   = index
    instance.tracks  = tracks
    instance.audio   = AudioPlayer()
    instance.screen  = createScreen("Springboard")
    instance.port    = instance.screen.getMessagePort()

    instance.syncContent = function()
        content = m.tracks.getContent(m.index)
        if content = invalid return invalid
        counter = m.tracks.getContentCount()
        m.screen.setContent(content)
        m.totalTime = content.length
        m.updateProgress()
        if counter <> m.tracks.getContentCount() then
            m.syncTracks()
        end if
        m.audio.selectTrack(m.index)
        return content
    end function

    instance.setPlayState = function(state as Integer)
        m.audio.setPlayState(state)
        m.screen.clearButtons()
        if (state = m.audio.STATE_PLAY) then
            m.screen.addButton(1, "Pause")
            m.screen.addButton(2, "Stop")
        else if (state = m.audio.STATE_PAUSE) then
            m.screen.addButton(1, "Resume")
            m.screen.addButton(2, "Stop")
        else
            m.screen.addButton(1, "Play")
        endif
    end function

    instance.show = function()
        m.screen.show()
        m.play()
        while true
            msg = wait(1000, m.port)
            if type(msg) = "roSpringboardScreenEvent" then
                if not m.onScreenEvent(msg) return m.index
            else if type(msg) = "roAudioPlayerEvent" then
                m.onAudioEvent(msg)
            end if
            if m.audio.playState = m.audio.STATE_PLAY then
                m.updateProgress()
            end if
        end while
        return m.index
    end function

    instance.updateProgress = function()
        m.elapsedTime = m.elapsedTime + 1
        m.screen.setProgressIndicator(m.elapsedTime, m.totalTime)
    end function

    instance.syncTracks = function()
        m.audio.setContentList(m.tracks.getContentList()) 
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
        m.setPlayState(m.audio.STATE_PLAY)
    end function

    instance.pause = function()
        m.setPlayState(m.audio.STATE_PAUSE)
    end function

    instance.stop = function()
        m.elapsedTime = 0
        m.setPlayState(m.audio.STATE_STOP)
    end function

    instance.next = function()
        m.stop()
        m.index = m.index + 1
        if m.syncContent() = invalid then
            m.index = m.index - 1
        endif
        if m.index > 0 then
            m.screen.allowNavLeft(true)
        end if
        m.play()
    end function

    instance.prev = function()
        if m.index <= 0 then
            m.index = 0
            m.screen.allowNavLeft(false)
            return 0
        end if
        m.stop()
        m.index = m.index - 1
        m.syncContent()
        m.play()
    end function

    instance.onButtonPressed = function(msg as Object) as Boolean
        if msg.GetIndex() = 1 then
            if m.audio.playState = m.audio.STATE_PLAY then
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
        if m.elapsedTime > 10 then
            m.elapsedTime = m.elapsedTime - 10
        else
            m.elapsedTime = 0
        end if
        m.audio.seekTrack(m.elapsedTime)
    end function

    instance.fastForward = function()
        if m.elapsedTime < (m.totalTime-10) then
            m.elapsedTime = m.elapsedTime + 10
        else
            m.elapsedTime = m.totalTime
        end if
        m.audio.seekTrack(m.elapsedTime)
    end function

    instance.onAudioEvent = function(msg as Object)
        if msg.isRequestSucceeded() then
            m.next()
        end if
    end function

    instance.screen.setProgressIndicatorEnabled(true)
    instance.screen.allowNavLeft(index > 0)
    instance.screen.allowNavRewind(true)
    instance.screen.allowNavFastForward(true)

    instance.audio.setMessagePort(instance.port)
    instance.syncTracks()
    instance.syncContent()

    return instance

end function