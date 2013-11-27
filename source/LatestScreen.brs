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
        if msg.isListItemFocused() then
            limit = tracks.getContentCount()
            if index >= (limit-3) then
                screen.setContentList(tracks.getContentListUntil(limit))
            end if
        elseif msg.isListItemSelected() then
        	index = TrackScreen(index, tracks).show()
            screen.setFocusedListItem(index)
            screen.setContentList(tracks.getContentList())
        elseif msg.isListSelected() then
        	mode = config.listModes[msg.getIndex()]
        	tracks.setMode(mode)
        	screen.setContentList(tracks.getContentList())
        elseif msg.isScreenClosed() then
        	continue = false
        end if
    end while

end sub