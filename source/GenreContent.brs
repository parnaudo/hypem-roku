function GenreContent(json as Object) as Object
	return {
		url: "/blogs/" + json.siteid + "/tracks",
		title: json.sitename,
		description: json.description,
		shortDescriptionLine1: json.sitename,
		shortDescriptionLine2: json.region_name,
		contentType: "series",
		sdPosterUrl: json.blog_image,
		hdPosterUrl: json.blog_image,
		sdBackgroundImageUrl: json.blog_image,
		hdBackgroundImageUrl: json.siteurl,
		starRating: json.followers
	}
end function