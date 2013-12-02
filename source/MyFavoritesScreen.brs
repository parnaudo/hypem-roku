function MyFavoritesScreen(parent="" as String) as Object
	return TrackListScreen("/me/favorites", invalid, "Favorite Tracks", parent)
end function