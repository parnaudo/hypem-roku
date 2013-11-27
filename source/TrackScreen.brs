sub createTrackScreen(index as Integer, tracks as Object)
    
    audio   = AudioPlayer()
    screen  = createScreen("Springboard")
	
    audio.setContentList(tracks.getContentList()) 
    screen.setContent(tracks.getContent(index))
    screen.show()

    audio.getPlayer().setNext(index)
    setTrackScreenPlayState(2, screen, audio)

	while true
        msg = wait(0, screen.getMessagePort())
        if msg.isScreenClosed() then : return
        elseif msg.isButtonPressed() then
        	handleTrackScreenButtonPress(msg.getIndex(), msg.getData())
        elseif msg.isRemoteKeyPressed() then	
        	handleTrackScreenRemoteCommand(msg.getIndex())
        end if
    end while

end sub

sub handleTrackScreenButtonPress(index as Integer, data as Integer)
	print index; data
end sub

sub handleTrackScreenRemoteCommand(index as Integer)
	print index
end sub

sub setTrackScreenPlayState(state as Integer, screen as Object, audio as Object)
    audio.setPlayState(state)
    if (state = 2)  then
        screen.addButton(1, "Pause")
        screen.addButton(2, "Stop")
    else if (state = 1) then
        m.screen.addButton(1, "Resume")
        m.screen.addButton(2, "Stop")
    else
        m.screen.addButton(1, "Play")
    endif
end sub