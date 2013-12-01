function UserContent(json as Object) as Object
	rut = createObject("roUrlTransfer")
	return {
		source: "/users/" + rut.escape(json.username)  + "/favorites",
		title: json.username,
		description: json.profile_url,
		shortDescriptionLine1: json.fullname,
		shortDescriptionLine2: json.location,
		contentType: "series",
		sdPosterUrl: json.userpic,
		hdPosterUrl: json.userpic,
		sdBackgroundImageUrl: json.userpic,
		hdBackgroundImageUrl: json.userpic,
		starRating: json.followers
	}
end function