function TrackList(source as String, params as Object) as Object

	instance              = {}
	instance._client      = ApiClient()
	instance._source      = source
	instance._params      = mergeObjects({ page: 1, count: 40 }, params)
	instance._contentList = []

	instance.getContentCount = function()
		return m._contentList.count()
	end function

	instance.getContentListUntil = function(containsIndex)
		while m.getContentCount() <= containsIndex
			tracks = m._client.getJson(m._source, m._params)
			if tracks.status = "error" then 
				ErrorDialog("Error", tracks.error_msg).show()
			end if
			if tracks.data.count() < m._params.count return m._contentList
			m._params.page = m._params.page + 1
			m._contentList.append(TrackContentList(tracks.data))
		end while
		return m._contentList
	end function

	instance.getContentList = function()
		return m.getContentListUntil(0)
	end function

	instance.getContent = function(index as Integer)
		return m.getContentListUntil(index).getEntry(index)
	end function

	instance.clearContentList = function()
		m._contentList = []
		m._params.page = 1
	end function

	instance.setMode = function(mode as String)
		if m._params.mode = mode return 0
		m._params.mode = mode
		m.clearContentList()
	end function

	instance.setSize = function(size as Integer)
		if m._params.size = size return 0
		m._params.size = size
		m.clearContentList()
	end function

	return instance

end function