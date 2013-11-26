sub createLatestScreen()

	client = ApiClient()
	config = readJsonFile("config/latest.screen")
	screen = createScreen(config.screen)

	getTracks = function(screen, client, params as Object) as Object
		tracks = client.getTracks(params)
		if type(tracks) = "roAssociativeArray" then
			screen.showMessage(tracks.error_msg)
			return invalid
		else
			tracks = arrayMap(tracks, Track)
			screen.setContentList(tracks)
			return tracks
		end if
	end function

	screen.setListStyle(config.listStyle)
	tracks = getTracks(screen, client, invalid)
	screen.show()

	while tracks <> invalid
        msg = wait(0, screen.getMessagePort())
        if msg.isListItemSelected() then
        	track = tracks[msg.getIndex()]
        	createTrackScreen(track)
        elseif msg.isListSelected() then
        	mode = config.listModes[msg.getIndex()]
        	tracks = getTracks(screen, client, { mode: mode })
        elseif msg.isScreenClosed() then
        	continue = false
        end if
    end while

end sub