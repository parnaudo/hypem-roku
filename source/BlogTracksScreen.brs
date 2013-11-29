function BlogTracksScreen(blog as Object) as Object
	instance = TrackListScreen(blog.source, { count: 40 })
	return instance
end function