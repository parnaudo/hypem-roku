function TrackContent(json as Object) as Object
	releaseDate = createObject("roDateTime")
	releaseDate.fromSeconds(json.dateposted)
	return {
		title: json.title,
		description: json.description,
		shortDescriptionLine1: json.title,
		contentType: "audio",
		sdPosterUrl: json.thumb_url_large,
		hdPosterUrl: json.thumb_url_large,
		sdBackgroundImageUrl: json.thumb_url_large,
		hdBackgroundImageUrl: json.thumb_url_large,
		url: json.stream_pub,
		streamFormat: "mp3",
		length: json.time,
		starRating: json.loved_count,
		releaseDate: releaseDate.asDateString("short-date"),
		artist: json.artist,
		album: json.sitename
	}
end function