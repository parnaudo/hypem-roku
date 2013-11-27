function AudioPlayer() as Object

	if m._AudioPlayer <> invalid then
		return m._AudioPlayer
	endif

	getPlayer = function() as Object
		if m._player <> invalid return m._player
		player = createObject("roAudioPlayer")
		port = createObject("roMessagePort")
		player.setMessagePort(port)
		player.setLoop(0)
		m._player = player
		m.setPlayState(0)
		return player
	end function

	setPlayState = function(newstate as Integer)
		if newstate <> m.playState then
			if newstate = 0 then			 ' STOPPED
				m.getPlayer().stop()
				m.playState = 0
			else if newstate = 1 then		' PAUSED
				m.getPlayer().pause()
				m.playState = 1
			else if newstate = 2 then		' PLAYING
				if m.playstate = 0
					m.getPlayer().play()	' STOP->START
				else
					m.getPlayer().resume()	' PAUSE->START
				endif
				m.playState = 2
			endif
		end if
	end function

	addContent = function(content as Object)
		m.getPlayer().addContent(content)
	end function

	setContentList = function(contentList as Object)
		m.getPlayer().setContentList(contentList)
	end function

	clearContent = function()
		m.getPlayer().clearContent()
	end function

	getMessage = function(timeout as Integer, escape as String) As Object
		while true
	    	msg = wait(timeout, m.getPlayer().getMessagePort())
		    if type(msg) = "roAudioPlayerEvent" return msg
		    if type(msg) = escape return msg
		    if type(msg) = "Invalid" return msg
		end while
	end function

	m._AudioPlayer = {
		playState: 0,
		getPlayer: getPlayer,
		getMessage: getMessage,
		addContent: addContent,
		setContentList: setContentList,
		clearContent: clearContent,
		setPlayState: setPlayState,
	}

	return m._AudioPlayer

end function