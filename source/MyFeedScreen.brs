function MyFeedScreen(parent="" as String) as Object
	lists = ["All Tracks", "My Friends", "Blogs"]
	modes = ["all", "friends", "blogs"]
	return FilteredTrackListScreen("/me/feed", lists, modes, "My Feed", parent)
end function