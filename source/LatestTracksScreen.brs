function LatestTracksScreen(parent="" as String) as Object
	lists = ["All Tracks", "Freshest", "No Remixes", "Only Remixes"]
	modes = ["all", "fresh", "noremix", "remix"]
	return FilteredTrackListScreen("/tracks", lists, modes, "Latest Tracks", parent)
end function