function ArtistTracksScreen(artist as String) as Object
	artist = createObject("roUrlTransfer").escape(artist)
	return TrackListScreen("/artists/" + artist + "/tracks", { count: 40 })
end function