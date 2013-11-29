function ContentListAdapter(class as Function, source as String, params as Object) as Object

	instance              = {}
	instance._client      = ApiClient()
	instance._source      = source
	instance._params      = mergeObjects({ page: 1 }, params)
	instance._class       = class
	instance._contentList = []

	instance.getContentCount = function() as Integer
		return m._contentList.count()
	end function

	instance.getContentListUntil = function(containsIndex) as Object
		while m.getContentCount() <= containsIndex
			response = m._client.getJson(m._source, m._params)
			if response.status = "error" then
				ErrorDialog("Error", response.error_msg).show()
			end if
			if m._params.count <> invalid and response.data.count() < m._params.count then 
				return m._contentList
			end if
			m._params.page = m._params.page + 1
			m._contentList.append(arrayMap(response.data, m._class))
		end while
		return m._contentList
	end function

	instance.getContentList = function() as Object
		return m.getContentListUntil(0)
	end function

	instance.getContent = function(index as Integer) as Object
		return m.getContentListUntil(index).getEntry(index)
	end function

	instance.clearContentList = function()
		m._contentList = []
		m._params.page = 1
	end function

	return instance

end function