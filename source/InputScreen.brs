sub InputScreen(title as String, prompt as String, secure=false as Boolean) as Object
    
    instance = {}
    instance._screen  = createScreen("Keyboard")
    
    instance._screen.addButton(1, "Continue")
    instance._screen.addButton(2, "Cancel")
    
    instance._screen.setTitle(title)
    instance._screen.setSecureText(secure)
    instance._screen.setDisplayText(prompt)

    instance.show = function()
        m._screen.show()
        while true
            msg = wait(0, m._screen.getMessagePort())
            if msg.isScreenClosed() return invalid
            if msg.isButtonPressed() then
                index = msg.getIndex()
                if index = 1 then
                    result = m._screen.getText()
                    if len(result) > 0 return result
                    ErrorDialog("No Value", "Please enter a value before moving on").show()
                elseif index = 2 then
                    return invalid
                endif
            endif
        end while
    end function

    return instance

end sub