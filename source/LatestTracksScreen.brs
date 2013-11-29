function LatestTracksScreen() as Object
	lists = ["All Tracks", "Freshest", "No Remixes", "Only Remixes"]
	modes = ["all", "fresh", "noremix", "remix"]
	return FilteredTrackListScreen("/tracks", lists, modes)
end function