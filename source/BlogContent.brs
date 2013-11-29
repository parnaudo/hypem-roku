function BlogContent(json as Object) as Object
	return {
		source: "/blogs/" + json.siteid.tostr() + "/tracks",
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