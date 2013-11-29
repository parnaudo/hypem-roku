function BlogDirectoryScreen() as Object
	
	instance = {}
	instance._blogs = BlogListAdapter()
	instance._screen = createScreen("Poster")
	instance._screen.setListStyle("arced-square")
    instance._screen.setListDisplayMode("zoom-to-fill")
	instance._screen.setContentList(instance._blogs.getContentList())

	instance.show = function()
		m._screen.show()
		while true
			msg = wait(0, m._screen.getMessagePort())
	        if msg.isListItemSelected() then
	            m.onListItemSelected(msg)
	        elseif msg.isScreenClosed() then
	            return false
	        end if
		end while
	end function

	instance.onListItemSelected = function(msg as Object)
        blog = m._blogs.getContent(msg.getIndex())
        BlogTracksScreen(blog).show()
    end function

	return instance

end function