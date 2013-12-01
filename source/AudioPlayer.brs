function AudioPlayer() as Object

	globals = getGlobalAA()

	if globals._AudioPlayer <> invalid return globals._AudioPlayer

	instance = {
		_index: -1,
		_timePlayStart: 0,
		_timePauseStart: 0,
		_timePaused: 0,
		STATE_STOP: 0,
		STATE_PAUSE: 1,
		STATE_PLAY: 2,
		playState: 0
	}

	instance.isPlaying = function() as Object
		if m.playState = m.STATE_PLAY return true
		return false
	end function

	instance.setTracks = function(tracks as Object)
		m._tracks = tracks
		m.setContentList(tracks.getContentList())
	end function

	instance.getTracks = function() as Object
		return m._tracks
	end function

	instance.getPlayer = function() as Object
		if m._player <> invalid return m._player
		m._player = createObject("roAudioPlayer")
		m._player.setLoop(0)
		m.setPlayState(m.STATE_STOP)
		return m._player
	end function

	instance.correctIndex = function()
		
		if not m.isPlaying() return m._index
		
		totalTime   = m.getTimeTotal()
		elapsedTime = m.getTimeElapsed()
		deltaTime   = elapsedTime - totalTime

		if deltaTime < 0 return m._index

		' if we get here the index is out of sync!
		while deltaTime > 0
			m._index    = m._index + 1
			totalTime   = m.getTimeTotal()
			elapsedTime = deltaTime
			deltaTime   = elapsedTime - totalTime
		end while

		m._timePlayStart  = getTime() - elapsedTime
		m._timePauseStart = 0
		m._timePaused = 0

		return m._index

	end function

	instance.setPlayState = function(newstate as Integer)
		if newstate <> m.playState then
			if newstate = m.STATE_STOP then			 ' STOPPED
				m.getPlayer().stop()
				m.playState = m.STATE_STOP
				m._timePlayStart = 0
				m._timePauseStart = 0
				m._timePaused = 0
			elseif newstate = m.STATE_PAUSE then	' PAUSED
				m.getPlayer().pause()
				m.playState = m.STATE_PAUSE
				m._timePauseStart = getTime()
			elseif newstate = m.STATE_PLAY then		' PLAYING
				if m.playstate = m.STATE_STOP then  ' STOP->START
					m.getPlayer().play()	
					m._timePlayStart = getTime()
				else 								' PAUSE->START
					m.getPlayer().resume()
					m._timePaused = m._timePaused + getTime() - m._timePauseStart
				endif
				m.playState = m.STATE_PLAY
			endif
		endif
	end function

	instance.getTimeElapsed = function() as Integer
		if m._timePlayStart <= 0 return 0
		return getTime() - m._timePaused - m._timePlayStart
	end function

	instance.getTimeTotal = function() as Integer
		if m._tracks = invalid return 0
		if m._index < 0 return 0
		return m._tracks.getContent(m._index).length
	end function

	instance.setMessagePort = function(port as Object)
		m.getPlayer().setMessagePort(port)
	end function

	instance.addContent = function(content as Object)
		m.getPlayer().addContent(content)
	end function

	instance.setTrackIndex = function(index as Integer)
		m.setPlayState(m.STATE_STOP)
		m._index = index
		m.getPlayer().setNext(index)
	end function

	instance.getTrackIndex = function() as Integer
		return m._index
	end function

	instance.seekTrack = function(relativeOffset as Integer) as Boolean
		
		if m._timePlayStart <= 0 return false

		totalTime   = m.getTimeTotal()
		elapsedTime = m.getTimeElapsed()
		offset      = elapsedTime + relativeOffset

		if offset < 0 then         : offset = 0         : endif
		if offset > totalTime then : offset = totalTime : endif

		startDelta = offset - elapsedTime
        m._timePlayStart = m._timePlayStart - startDelta
		m.getPlayer().seek(offset*1000)
		return true

	end function

	instance.setContentList = function(contentList as Object)
		m.getPlayer().setContentList(contentList)
	end function

	instance.clearContent = function()
		m.getPlayer().clearContent()
	end function

	globals._AudioPlayer = instance

	return globals._AudioPlayer

end function