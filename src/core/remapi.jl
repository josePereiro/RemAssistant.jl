_remtag(t::String) = string("#[[", t, "]]")

function remtag(t::String)
    tags = _push_csv!(String[], t)
    return _remtag.(tags)
end