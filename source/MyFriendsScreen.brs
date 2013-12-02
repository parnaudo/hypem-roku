function MyFriendsScreen() as Object
	
	instance = {}
	instance._friends = UserFriendListAdapter(UserSession().getUserName())
	instance._screen = createScreen("Poster")
	
	instance._screen.setListStyle("arced-square")
    instance._screen.setListDisplayMode("zoom-to-fill")
	instance._screen.setBreadcrumbEnabled(true)
	instance._screen.setBreadcrumbText("", "My Friends")

	instance.updateContentList = function()
		m._screen.setContentList(m._friends.getContentList())
	end function

	instance.show = function()
		m._screen.show()
		m.updateContentList()
		while true
			msg = wait(0, m._screen.getMessagePort())
	        if msg.isListItemSelected() then
	            m.onListItemSelected(msg)
	        elseif msg.isScreenClosed() then
	            return false
	        endif
		end while
	end function

	instance.onListItemSelected = function(msg as Object)
        user = m._friends.getContent(msg.getIndex())
        UserTracksScreen(user, "My Friends").show()
    end function

	return instance

end function