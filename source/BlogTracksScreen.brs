function BlogTracksScreen(blog as Object, parent="" as String) as Object
	instance = TrackListScreen(blog.source, { count: 40 }, blog.title, parent)
	return instance
end function