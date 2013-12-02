function UserTracksScreen(user as Object, parent="" as String) as Object
	return TrackListScreen(user.source, { count: 40 }, user.title, parent)
end function