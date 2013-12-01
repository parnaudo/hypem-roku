function ContentListAdapter(class as Function, source as String, params as Object) as Object

	instance              = {}
	instance._client      = ApiClient()
	instance._source      = source
	instance._params      = mergeObjects({}, params)
	instance._class       = class
	instance._reachedEnd  = false
	instance._contentList = []

	' decrement the page so that the first call is for the first page
	if instance._params.page <> invalid then
		instance._params.page = instance._params.page - 1
	end if

	instance.getContentCount = function() as Integer
		return m._contentList.count()
	end function

	instance.getContentListUntil = function(containsIndex) as Object
		
		' try to fetch results until we have enough to cover the index
		while not m._reachedEnd
			
			' increment the page, if we have one
			if m._params.page <> invalid then
				m._params.page = m._params.page + 1
			end if

			' fetch the page of results
			response = m._client.getJson(m._source, m._params)
			
			' end processing on error
			if response.status = "error" then
				ErrorDialog("Error", response.error_msg).show()
				exit while
			end if

			' add any results we get
			count = response.data.count()
			if count > 0 then
				m._contentList.append(arrayMap(response.data, m._class))
			end if

			' if pagination is disabled, end looping and mark as end
			if m._params.count = invalid then
				m._reachedEnd = true
				exit while
			end if

			' if we got less than we requested, end looping and mark as end
			if count < m._params.count then
				m._reachedEnd = true
				exit while
			end if

			' if we covered our index, end looping
			if m.getContentCount() > containsIndex then
				exit while
			end if

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