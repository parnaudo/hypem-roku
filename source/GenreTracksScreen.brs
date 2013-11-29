function GenreTracksScreen(genre as Object) as Object
	instance = TrackListScreen(genre.source, { count: 40 })
	return instance
end function