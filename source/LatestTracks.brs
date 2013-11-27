function LatestTracks()
	
	if m._LatestTracks <> invalid return m._LatestTracks

	_client      = ApiClient()
	_params      = { mode: "all", page: 1, count: 40 }
	_contentList = []

	getContentCount = function()
		return m._contentList.count()
	end function

	getContentListUntil = function(containsIndex)
		while m.getContentCount() <= containsIndex
			tracks = m._client.getTracks(m._params)
			if tracks.status = "error" then 
				ErrorDialog("Error", tracks.error_msg).show()
			end if
			if tracks.data.count() < m._params.count return m._contentList
			m._params.page = m._params.page + 1
			m._contentList.append(TrackContentList(tracks.data))
		end while
		return m._contentList
	end function

	getContentList = function()
		return m.getContentListUntil(0)
	end function

	getContent = function(index as Integer)
		return m.getContentListUntil(index).getEntry(index)
	end function

	clearContentList = function()
		m._contentList = []
		m._params.page = 1
	end function

	setMode = function(mode as String)
		if m._params.mode = mode return 0
		m._params.mode = mode
		m.clearContentList()
	end function

	setSize = function(size as Integer)
		if m._params.size = size return 0
		m._params.size = size
		m.clearContentList()
	end function

	m._LatestTracks = {
		_contentList: _contentList,
		_client: _client,
		_params: _params,
		setMode: setMode,
		setSize: setSize,
		getContent: getContent,
		getContentList: getContentList,
		getContentCount: getContentCount,
		clearContentList: clearContentList,
		getContentListUntil: getContentListUntil
	}

	return m._LatestTracks

end function