function UserSession() as Object

	globals = getGlobalAA()
	if globals._UserSession <> invalid return globals._UserSession

	instance = {}
	instance._username     = invalid
	instance._access_token = invalid

	instance.isLoggedIn = function()
		if m._username = invalid or m._access_token = invalid return false
		return true
	end function

	instance.load = function()
		section = m.getRegistrySection()
		if section.exists("username") then
			m._username = section.read("username")
		endif
		if section.exists("access_token") then
			m._access_token = section.read("access_token")
		endif
	end function

	instance.save = function()
		section = m.getRegistrySection()
		if m._username <> invalid then
			section.write("username", m._username)
		elseif section.exists("username")
			section.delete("username")
		endif
		if m._access_token <> invalid then
			section.write("access_token", m._access_token)
		elseif section.exists("access_token")
			section.delete("access_token")
		endif
		section.flush()
	end function

	instance.getUserName = function() as Object
		return m._username
	end function

	instance.getAccessToken = function() as Object
		return m._access_token
	end function

	instance.getRegistrySection = function() as Object
		return createObject("roRegistrySection", "Session")
	end function

	instance.authorize = function(json as Object) as Object
		m._username     = json.username
		m._access_token = json.hm_token
		return m
	end function

	instance.deauthorize = function() as Object
		m._username     = invalid
		m._access_token = invalid
		return m
	end function

	globals._UserSession = instance
	return globals._UserSession

end function