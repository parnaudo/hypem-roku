sub SearchScreen() as Object
    
    instance = {}

    instance.search = function(query as String)
        lists = ["Newest", "Most Favorites", "Most Reblogs"]
        sorts = ["date", "loved", "posted"]
        SortedTrackListScreen("/tracks", lists, sorts).show()
    end function

    instance.show = function()
        query = InputScreen("Enter your search below").show()
        if query <> invalid then
            m.search(query)
        endif
    end function

    return instance

end sub