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
            eval("create" + content.screen + "()")
        end if
    end while
end sub