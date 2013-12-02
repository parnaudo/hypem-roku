function TrackContent(json as Object) as Object
	releaseDate = createObject("roDateTime")
	releaseDate.fromSeconds(json.dateposted)
	categories = [json.sitename]
	if json.via_user <> invalid then
		categories.push("Loved By " + json.via_user)
	endif
	return {
		id: json.itemid,
		title: json.title,
		description: truncateText(json.description, 200),
		fullDescription: truncateText(json.description, 250),
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
		categories: categories,
		postUrl: json.posturl,
		favorite: (json.ts_loved_me <> invalid)
	}
end function