function ApiClient() as Object

	if m._ApiClient <> invalid then
		return m._ApiClient
	end if

	m._ApiClient = {

		_session: UserSession(),

		getConfig: function()
			if m._config = invalid then
				m._config = ReadJsonFile("config/iphone")
			end if
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
			end if
			return m._transport
		end function

		setAuthParams: function(params as Object)
			config = m.getConfig()
			auth = { key: config.key }
			if m._session.isLoggedIn() then
				auth.hm_token = m._session.getAccessToken()
			end if
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
			end if
		end function

		getJson: function(path as String, params as Object) as Object
			params = m.setAuthParams(params)
			url = m.getUrl(path, params)
			transport = m.getTransport()
			transport.setUrl(url)
			print "GET ";url
			started = transport.asyncGetToString()
			while started
				msg = wait(0, transport.getMessagePort())
				if msg.getInt() = 1 then
					return m.onTransferComplete(msg)
				end if
			end while
			return m.onTransferFailed()
		end function

		postJson: function(path as String, params as Object) as Object
			url       = m.getUrl(path, invalid)
			transport = m.getTransport()
			params    = m.setAuthParams(params)
			request   = escapeQuery(transport, params)
			print "POST ";url;" ";request
			transport.setUrl(url)
			started = transport.asyncPostFromString(request)
			while started
				msg = wait(0, transport.getMessagePort())
				if msg.getInt() = 1 then
					return m.onTransferComplete(msg)
				end if
			end while
			return m.onTransferFailed()
		end function

		onTransferComplete: function(msg as Object) as Object
			
			response = msg.getString()
			'print " > ";response

			data = parseJson(response)
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
			end if
			
			return {
				status: "ok",
				data: data
			}

		end function

	}

	return m._ApiClient

end function