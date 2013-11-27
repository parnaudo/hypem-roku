function AudioPlayer() as Object

	if m._AudioPlayer <> invalid then
		return m._AudioPlayer
	endif

	getPlayer = function() as Object
		if m._player <> invalid return m._player
		m._player = createObject("roAudioPlayer")
		m.setPlayState(m.STATE_STOP)
		m._player.setLoop(0)
		return m._player
	end function

	setPlayState = function(newstate as Integer)
		if newstate <> m.playState then
			if newstate = m.STATE_STOP then			 ' STOPPED
				m.getPlayer().stop()
				m.playState = m.STATE_STOP
			else if newstate = m.STATE_PAUSE then		' PAUSED
				m.getPlayer().pause()
				m.playState = m.STATE_PAUSE
			else if newstate = m.STATE_PLAY then		' PLAYING
				if m.playstate = m.STATE_STOP
					m.getPlayer().play()	' STOP->START
				else
					m.getPlayer().resume()	' PAUSE->START
				endif
				m.playState = m.STATE_PLAY
			endif
		end if
	end function

	setMessagePort = function(port as Object)
		m.getPlayer().setMessagePort(port)
	end function

	addContent = function(content as Object)
		m.getPlayer().addContent(content)
	end function

	selectTrack = function(index as Integer)
		m.getPlayer().setNext(index)
	end function

	seekTrack = function(offset as Integer)
		m.getPlayer().seek(offset*1000)
	end function

	setContentList = function(contentList as Object)
		m.getPlayer().setContentList(contentList)
	end function

	clearContent = function()
		m.getPlayer().clearContent()
	end function

	m._AudioPlayer = {
		STATE_STOP: 0,
		STATE_PAUSE: 1,
		STATE_PLAY: 2,
		playState: 0,
		getPlayer: getPlayer,
		addContent: addContent,
		selectTrack: selectTrack,
		seekTrack: seekTrack,
		setContentList: setContentList,
		clearContent: clearContent,
		setMessagePort: setMessagePort,
		setPlayState: setPlayState,
	}

	return m._AudioPlayer

end function