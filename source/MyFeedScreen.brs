function MyFeedScreen() as Object
	lists = ["All Tracks", "My Friends", "Blogs"]
	modes = ["all", "friends", "blogs"]
	return FilteredTrackListScreen("/me/feed", lists, modes)
end function