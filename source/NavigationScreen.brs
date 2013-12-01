sub NavigationScreen() as Object
    
    instance = {}
    instance._session = UserSession()
    instance._audio   = AudioPlayer()
    instance._screen  = createScreen("List")

    instance.updateContent = function()
        
        m._content = []

        if (m._audio.isPlaying()) then
            m._content.push({
                title: "Now Playing",
                screen: NowPlayingScreen
            })
        endif
        
        if (m._session.isLoggedIn()) then
            m._content.append([{
                title: "My Feed",
                screen: MyFeedScreen
            },{
                title: "Favorites",
                screen: MyFavoritesScreen
            },{
                title: "Friends",
                screen: MyFriendsScreen
            }])
        endif

        m._content.append([{
            title: "Latest",
            screen: LatestTracksScreen
        },{
            title: "Popular",
            screen: PopularTracksScreen
        },{
            title: "Blog Directory",
            screen: BlogDirectoryScreen
        },{
            title: "Genres",
            screen: GenreDirectoryScreen
        }])

        if (m._session.isLoggedIn()) then
            m._content.push({
                title: "Log Out"
                screen: LogoutScreen
            })
        else
            m._content.push({
                title: "Log In"
                screen: LoginScreen
            })
        endif

        m._screen.setContent(m._content)

    end function

    instance.show = function()
        m._screen.show()
        m.updateContent()
        while true
            msg = wait(0, m._screen.getMessagePort())
            if msg.isScreenClosed() return 0
            if msg.isListItemSelected() then
                content = m._content[msg.getIndex()]
                content.screen().show()
                m.updateContent()
            endif
        end while
    end function

    return instance

end sub