function TrackContent(json as Object) as Object
	releaseDate = createObject("roDateTime")
	releaseDate.fromSeconds(json.dateposted)
	return {
		id: json.itemid,
		title: json.title,
		description: json.description,
		shortDescriptionLine1: json.title,
		shortDescriptionLine2: json.artist,
		contentType: "audio",
		sdPosterUrl: json.thumb_url_large,
		hdPosterUrl: json.thumb_url_large,
		url: json.stream_pub,
		streamFormat: "mp3",
		length: json.time,
		starRating: json.loved_count,
		releaseDate: releaseDate.asDateString("short-date"),
		artist: json.artist,
		actors: json.artist,
		album: json.sitename,
		favorite: (json.ts_loved_me <> invalid)
	}
end function