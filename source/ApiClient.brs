function ApiClient() as Object

	if m._ApiClient <> invalid then
		return m._Api_Client
	end if

	m._ApiClient = {

		getConfig: function()
			if m._config = invalid then
				m._config = ReadJsonFile("config/api.client")
			end if
			return m._config
		end function

		getTransport: function()
			if m._transport = invalid then
				port = createObject("roMessagePort")
				m._transport = createObject("roUrlTransfer")
				m._transport.setMessagePort(port)
				m._transport.SetCertificatesFile("common:/certs/ca-bundle.crt")
				m._transport.InitClientCertificates()
			end if
			return m._transport
		end function

		getUrl: function(path as String, params as Object) as String
			config = m.getConfig()
			transport = m.getTransport()
			params = mergeObjects({ key: config.key }, params)
			query  = escapeQuery(transport, params)
			return config.host + path + "?" + query
		end function

		getJson: function(path as String, params as Object) as Object
			url = m.getUrl(path, params)
			transport = m.getTransport()
			transport.setUrl(url)
			started = transport.asyncGetToString()
			while started
				msg = wait(0, transport.getMessagePort())
				if msg.getInt() < 1 then
					return {
						status: "error",
						error_msg: "Unexpected Error",
						data: []
					}
				end if
				if msg.getInt() = 1 then
					code = msg.getResponseCode()
					if code < 0 or code > 399 then
						return {
							status: "error",
							error_msg: msg.getFailureReason(),
							data: []
						}
					else
						data = parseJson(msg.getString())
						if type(data) <> "roArray" return data
						return {
							status: "ok",
							data: data
						}
					end if
				end if
			end while
			return {
				status: "error",
				error_msg: "Unable to connect to server",
				data: []
			}
		end function

		getTracks: function(params as Object) as Object
			params = mergeObjects({ page: 1, count: 40, mode: "all" }, params)
			return m.getJson("/tracks", params)
		end function

	}

	return m._ApiClient

end function