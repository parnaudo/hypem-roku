function BlogContent(json as Object) as Object
	return {
		source: "/blogs/" + json.siteid.tostr() + "/tracks",
		title: json.sitename,
		description: json.description,
		shortDescriptionLine1: json.sitename,
		shortDescriptionLine2: json.followers.tostr() + " Followers",
		contentType: "audio",
		sdPosterUrl: json.blog_image,
		hdPosterUrl: json.blog_image,
		starRating: json.followers
	}
end function