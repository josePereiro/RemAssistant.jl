## ----------------------------------------------------------------------------

const _BIB_PATHS_CONFIG_KEY = "bibs"

function bibtex_paths()
    config = read_configfile()
    bibs = get(config, _BIB_PATHS_CONFIG_KEY, "")
    return (bibs isa String) ? [bibs] : bibs
end

function _read_bibtex(path)
    str = read(path, String)
    _, dict = BibTeX.parse_bibtex(str)
    return dict
end

function _bookbib_to_Ref(dict::AbstractDict)

    ref = Ref()

    # add fields
    set_bibkey!(ref, get(dict, "bibkey", ""))
    set_authors!(ref, get(dict, "author", ""))
    set_year!(ref, get(dict, "year", ""))
    set_title!(ref, get(dict, "title", ""))
    set_doi!(ref, get(dict, "doi", ""))
    set_keywords!(ref, get(dict, "keywords", ""))
    set_abstract!(ref, get(dict, "abstract", ""))
    set_refdict!(ref, dict)
    
    return ref
end

function _format_BOOKBIB!(_BOOKBIB)

    # clear content
    for (bibkey, dict) in _BOOKBIB

        # doi
        if haskey(dict, "doi")
            doistr = _doi_to_url(dict["doi"])
            !isempty(doistr) && (dict["doi"] = doistr)
        end

        # add bibkeys into dicts
        dict["bibkey"] = bibkey

        for (key, val) in dict
            key == "doi" && continue
            dict[key] = _clear_bibtex_entry(val)
        end
    end
end

function _bibrefs(bibs::Vector{<:AbstractString})
    
    _BOOKBIB = Dict{String, Any}()
    for path in bibs
        dict = _read_bibtex(path)

        merge!(_BOOKBIB, dict)
    end
    _format_BOOKBIB!(_BOOKBIB)

    # return 
    refs = Dict{String, Ref}()
    for (bibkey, dict) in _BOOKBIB
        refs[bibkey] = _bookbib_to_Ref(dict)
    end
    refs
end
_bibrefs(bib::AbstractString) = _bibrefs([bib])

