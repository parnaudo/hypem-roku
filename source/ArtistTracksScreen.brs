function ArtistTracksScreen(artist as String, parent="" as String) as Object
	artist = createObject("roUrlTransfer").escape(artist)
	return TrackListScreen("/artists/" + artist + "/tracks", { count: 40 }, artist, parent)
end function