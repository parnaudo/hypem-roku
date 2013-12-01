function UserFriendListAdapter(username as String) as Object
	username = createObject("roUrlTransfer").escape(username)
	return ContentListAdapter(UserContent, "/users/" + username + "/friends", invalid)
end function