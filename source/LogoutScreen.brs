sub LogoutScreen() as Object
    return {
        show: function()
            UserSession().deauthorize().save()
        end function
    }
end sub