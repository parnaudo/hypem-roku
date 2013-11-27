sub createChannelScreen()
	config = readJsonFile("config/channel.screen")
    screen = createScreen(config.screen)
	screen.setContentList(config.contentList)
    screen.setListStyle(config.listStyle)
	screen.show()
	while true
        msg = wait(0, screen.getMessagePort())
        if msg.isScreenClosed() then : return
        elseif msg.isListItemSelected() then
        	content = config.contentList[msg.getIndex()]
            if content.screen = "LatestScreen" then
                createLatestScreen()
            end if
        end if
    end while
end sub