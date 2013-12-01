function UserTracksScreen(user as Object) as Object
	return TrackListScreen(user.source, { count: 40 })
end function