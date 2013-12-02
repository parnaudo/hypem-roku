function FullDescriptionScreen(content as Object) as Object
	
	instance = {}
	instance._screen = createScreen("Paragraph")

	instance._screen.setTitle("Track Details")
    instance._screen.addHeaderText(content.title)
    instance._screen.addParagraph(content.FullDescription)
    instance._screen.addParagraph("For more, visit " + content.postUrl)
    instance._screen.addButton(1, "Return")

	instance.show = function()
		m._screen.show()
		while true
			msg = wait(0, m._screen.getMessagePort())
	        if msg.isButtonPressed() then
	            return true
	        elseif msg.isScreenClosed() then
	            return false
	        endif
		end while
	end function

	return instance

end function