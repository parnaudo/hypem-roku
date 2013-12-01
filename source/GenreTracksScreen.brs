function GenreTracksScreen(genre as Object) as Object
	return TrackListScreen(genre.source, { count: 40 })
end function