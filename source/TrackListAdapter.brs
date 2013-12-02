function TrackListAdapter(source as String, params as Object) as Object

	params   = mergeObjects({ count: 40, page: 1 }, params)
	instance = ContentListAdapter(TrackContent, source, params)
	
	instance.setMode = function(mode as String)
		if m._params.mode = mode return 0
		m._params.mode = mode
		m.clearContentList()
	end function

	instance.setSort = function(sort as String)
		if m._params.sort = sort return 0
		m._params.sort = sort
		m.clearContentList()
	end function

	return instance

end function