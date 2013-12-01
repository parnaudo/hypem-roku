sub LoginScreen() as Object
    
    instance = {}

    instance.login = function(username, password)
        client = ApiClient()
        params = {}
        device = createObject("roDeviceInfo")
        params.username  = username
        params.password  = password
        params.device_id = device.getDeviceUniqueId()
        response = client.postJson("/get_token", params)
        if response.status = "error" then
            ErrorDialog("Unable to Log In", response.error_msg).show()
        else
            UserSession().authorize(response).save()
        endif
    end function

    instance.show = function()
        username = InputScreen("Please enter your Hype Machine username").show()
        if username <> invalid then
            password = InputScreen("Please enter your Hype Machine password", true).show()
            if password <> invalid then
                m.login(username, password)
            endif
        endif
    end function

    return instance

end sub