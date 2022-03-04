## ----------------------------------------------------------------------------
# utils
const _CLEAR_BIBTEX_ENTRY_STRIP_SET = ['{', '}', '\n', ' ', ',', ';']
const _alphanum_str = "a-zA-Z0-9"
const _punct_str = "\\,\\-\\;\\:\\."
const _reg1 = Regex("[$_punct_str]{2}")
const _reg2 = Regex("\\s{2}")
const _reg3 = Regex("[^$(_alphanum_str)$(_punct_str)/\\s]")

function _clear_bibtex_entry(str::AbstractString)

    str = strip(str, _CLEAR_BIBTEX_ENTRY_STRIP_SET)
    str = replace(str, "\n" => "")
    
    _till_unchanged() do 
        str = replace(str, _reg1 => ",")
        str = replace(str, _reg2 => " ")
        for c in ",;:."
            str = replace(str, " $c" => c)
        end
        str = replace(str, _reg3 => "")
        return str
    end
    return str
end

## ----------------------------------------------------------------------------
function _till_unchanged(f!::Function; n = 100)
    ret = f!()
    ret0 = ret
    for i in 1:n
        ret = f!()
        (ret0 == ret) && return ret
    end
    return ret
end

## ----------------------------------------------------------------------------
function _push_csv!(col, str::AbstractString)
    vals = split(str, ",", keepempty = false)
    for vali in vals
        push!(col, strip(vali))
    end
    return col
end

function _push_csv!(col, str::AbstractString, strs::AbstractString...)
    _push_csv!(col, str)
    for stri in strs
        _push_csv!(col, stri)
    end
    return col
end

## ----------------------------------------------------------------------------
function _doi_to_url(doi::AbstractString)
    if startswith(doi, "http")
        return doi 
    elseif startswith(doi, "doi.org")
        return string("https://", doi)
    elseif startswith(doi, r"\d{1,10}\.\d{3,20}")
        return string("https://doi.org/", doi)
    end
    return ""
end