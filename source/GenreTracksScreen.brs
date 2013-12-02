function GenreTracksScreen(genre as Object, parent="" as String) as Object
	return TrackListScreen(genre.source, { count: 40 }, genre.title, parent)
end function