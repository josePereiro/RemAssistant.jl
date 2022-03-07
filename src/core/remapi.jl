_remtag(t::String) = isempty(t) ? "" : string("#[[", camel_alphanumeric(t), "]]")

function remtag(t::String)
    isempty(t) && return ""
    tags = _push_csv!(String[], t)
    return length(tags) == 1 ? _remtag(first(tags)) : _remtag.(tags)
end

_remref(t::String) = string("[[", camel_alphanumeric(t), "]]")
remref(t::String) = _remref(t)