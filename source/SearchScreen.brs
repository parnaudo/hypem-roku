sub SearchScreen(parent="" as String) as Object
    
    instance = InputScreen("Search Tracks", "Enter your search below")
    instance._parent = parent

    instance.search = function(query as String)
        lists = ["Newest", "Most Favorites", "Most Reblogs"]
        sorts = ["date", "loved", "posted"]
        QueryTrackListScreen("/tracks", query, lists, sorts, m._parent).show()
    end function

    instance.ishow = instance.show
    instance.show = function()
        while true
            query = m.ishow()
            if query = invalid return false
            m.search(query)
        end while
    end function

    return instance

end sub