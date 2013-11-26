function ApiClient() as Object

	if m._instance <> invalid then
		return m._instance
	end if

	m._instance = {

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
						error_msg: "Unexpected Error"
					}
				end if
				if msg.getInt() = 1 then
					code = msg.getResponseCode()
					if code < 0 or code > 399 then
						return {
							status: "error",
							error_msg: msg.getFailureReason()
						}
					else
						return parseJson(msg.getString())
					end if
				end if
			end while
			return {
				status: "error",
				error_msg: "Unable to connect to server"
			}
		end function

		getTracks: function(params as Object)
			params = mergeObjects({ page: 1, count: 40, mode: "all" }, params)
			return m.getJson("/tracks", params)
		end function

	}

	return m._instance

end function