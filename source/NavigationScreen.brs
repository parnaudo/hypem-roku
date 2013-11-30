sub NavigationScreen() as Object
    
    instance = {}
    instance._session = UserSession()
    instance._audio   = AudioPlayer()
    instance._screen  = createScreen("List")

    instance.getCurrentContent = function()
        if (m._audio.playState = m.STATE_PLAY) then
            return [{
                title: "Now Playing",
                screen: invalid
            }]
        end if
        return []
    end function

    instance.getBasicContent = function()
        return [
            {
                title: "Latest",
                screen: LatestTracksScreen
            },
            {
                title: "Popular",
                screen: PopularTracksScreen
            },
            {
                title: "Blog Directory",
                screen: BlogDirectoryScreen
            },
            {
                title: "Genres",
                screen: GenreDirectoryScreen
            }
        ]
    end function

    instance.getSessionContent = function()
        if (m._session.isLoggedIn()) then
            return [{
                title: "Log Out"
                screen: LogoutScreen
            }]
        else
            return [{
                title: "Log In"
                screen: LoginScreen
            }]
        end if
    end function

    instance.updateContent = function()
        m._content = m.getCurrentContent()
        m._content.append(m.getBasicContent())
        m._content.append(m.getSessionContent())
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
            end if
        end while
    end function

    return instance

end sub