function BlogDirectoryScreen() as Object
	
	instance = {}
	instance._blogs = BlogListAdapter()
	instance._screen = createScreen("List")
	
	instance.updateContentList = function()
		m._screen.setContent(m._blogs.getContentList())
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
        blog = m._blogs.getContent(msg.getIndex())
        BlogTracksScreen(blog).show()
    end function

	return instance

end function