function LatestTracks()
	
	client = ApiClient()
	params = { mode: "all", page: 1, count: 40 }

	if m._LatestTracks <> invalid return m._LatestTracks

	getContentList = function()
		if m.contentList <> invalid return m.contentList
		tracks = m.client.getTracks(m.params)
		m.contentList = TrackContentList(tracks)
		return m.contentList 
	end function

	getContent = function(index as Integer)
		return m.getContentList().getEntry(index)
	end function

	setMode = function(mode as String)
		if params.mode = mode return 0
		m.contentList = invalid
		params.page = 1
	end function

	m._LatestTracks = {
		contentList: invalid,
		client: client,
		params: params,
		setMode: setMode,
		getContentList: getContentList,
		getContent: getContent
	}

	return m._LatestTracks

end function