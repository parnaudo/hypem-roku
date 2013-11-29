sub NavigationScreen() as Object
    
    content = [
        {
            title: "Latest",
            screen: LatestTracksScreen
        },
        {
            title: "Popular",
            screen: PopularTracksScreen
        },
        {
            title: "Genres",
            screen: GenreDirectoryScreen
        },
        {
            title: "Blog Directory",
            screen: BlogDirectoryScreen
        }
    ]

    instance = {}
    instance._content = content
    instance._screen  = createScreen("List")
    instance._screen.setTitle("The Hype Machine")
    instance._screen.setContent(content)

	instance.show = function()
        m._screen.show()
        while true
            msg = wait(0, m._screen.getMessagePort())
            if msg.isScreenClosed() return 0
            if msg.isListItemSelected() then
                content = m._content[msg.getIndex()]
                content.screen().show()
            end if
        end while
    end function

    return instance

end sub