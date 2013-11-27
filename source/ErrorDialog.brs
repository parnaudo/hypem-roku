function ErrorDialog(title as String, text as String) as Object
	
	instance = {}
	instance.port = createObject("roMessagePort")
	instance.dialog = createObject("roMessageDialog")

	instance.dialog.setMessagePort(instance.port)
	instance.dialog.enableBackButton(true)
	instance.dialog.setTitle(title)
	instance.dialog.setText(text)
	instance.dialog.addButton(1, "OK")

	instance.show = function()
		m.dialog.show()
		while true
			msg = wait(0, m.port)
			index = msg.GetIndex()
			if msg.isScreenClosed() or msg.isButtonPressed()
	        	return 0
	        end if
		end while
	end function

	return instance


end function