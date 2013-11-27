sub createLatestScreen()

	tracks = LatestTracks()
	config = readJsonFile("config/latest.screen")
	screen = createScreen(config.screen)

	screen.setListStyle(config.listStyle)
	screen.setContentList(tracks.getContentList())
	screen.show()

	while true
        msg = wait(0, screen.getMessagePort())
        index = msg.getIndex()
        if msg.isListItemSelected() then
        	createTrackScreen(index, tracks)
        elseif msg.isListSelected() then
        	mode = config.listModes[msg.getIndex()]
        	tracks.setMode(mode)
        	screen.setContentList(tracks.getContentList())
        elseif msg.isScreenClosed() then
        	continue = false
        end if
    end while

end sub