function ApiClient() as Object

	globals = getGlobalAA()
	if globals._ApiClient <> invalid return globals._ApiClient

	globals._ApiClient = {

		_session: UserSession(),

		getConfig: function()
			if m._config = invalid then
				m._config = ReadJsonFile("config/iphone")
			endif
			return m._config
		end function

		getTransport: function()
			if m._transport = invalid then
				port = createObject("roMessagePort")
				m._transport = createObject("roUrlTransfer")
				m._transport.setMessagePort(port)
				m._transport.retainBodyOnError(true)
				m._transport.setCertificatesFile("common:/certs/ca-bundle.crt")
				m._transport.initClientCertificates()
			endif
			return m._transport
		end function

		setAuthParams: function(params as Object)
			config = m.getConfig()
			auth = { key: config.key }
			if m._session.isLoggedIn() then
				auth.hm_token = m._session.getAccessToken()
			endif
			return mergeObjects(auth, params)
		end function

		getUrl: function(path as String, params as Object) as String
			config = m.getConfig()
			transport = m.getTransport()
			if params <> invalid then
				query  = escapeQuery(transport, params)
				return config.host + path + "?" + query
			else 
				return config.host + path
			endif
		end function

		getJson: function(path as String, params as Object) as Object
			msg = m.get(path, params)
			if msg = invalid return m.onJsonFailed()
			return m.onJsonComplete(msg)
		end function

		postJson: function(path as String, params as Object) as Object
			msg = m.post(path, params)
			if msg = invalid return m.onJsonFailed()
			return m.onJsonComplete(msg)
		end function

		post: function(path as String, params as Object) as Object
			url       = m.getUrl(path, m.setAuthParams({}))
			transport = m.getTransport()
			params    = m.setAuthParams(params)
			request   = escapeQuery(transport, params)
			print "POST ";url;" ";request
			transport.setUrl(url)
			started = transport.asyncPostFromString(request)
			while started
				msg = wait(0, transport.getMessagePort())
				if msg.getInt() = 1 then
					return msg
				endif
			end while
			return invalid
		end function

		get: function(path as String, params as Object) as Object
			params = m.setAuthParams(params)
			url = m.getUrl(path, params)
			transport = m.getTransport()
			transport.setUrl(url)
			print "GET ";url
			started = transport.asyncGetToString()
			while started
				msg = wait(0, transport.getMessagePort())
				if msg.getInt() = 1 then
					return msg
				endif
			end while
			return invalid
		end function

		onJsonComplete: function(msg as Object) as Object
			
			data = parseJson(msg.getString())
			if type(data) = "roAssociativeArray" return data

			code = msg.getResponseCode()
			if code < 0 or code > 399 then
				error = msg.getFailureReason()
				return {
					status: "error",
					error_code: code,
					error_msg: msg.getFailureReason(),
					data: []
				}
			endif
			
			return {
				status: "ok",
				data: data
			}

		end function

		onJsonFailed: function() as Object
			return {
				status: "error",
				error_msg: "Unable to connect to service",
				data: []
			}
		end function

	}

	return globals._ApiClient

end function