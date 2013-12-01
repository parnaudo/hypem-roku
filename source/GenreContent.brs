function GenreContent(json as Object) as Object
	urlencoder = createObject("roUrlTransfer")
	return {
		source: "/tags/" + urlencoder.escape(json.tag_name) + "/tracks",
		title: json.tag_name,
		contentType: "audio"
	}
end function