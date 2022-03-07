## ------------------------------------------------------------------
mutable struct Ref
    title::String
    bibkey::String
    year::String
    doi::String
    authors::String
    keywords::String
    abstract::String
    refdict::Dict

    Ref() = new("", "", "", "", "", "", "", Dict())
end

## ------------------------------------------------------------------
# Meta

get_refdict(r::Ref) = getproperty(r, :refdict)
set_refdict!(r::Ref, dict::AbstractDict) = setproperty!(r, :refdict, dict)

get_bibkey(r::Ref) = getproperty(r, :bibkey)
set_bibkey!(r::Ref, key::AbstractString) = setproperty!(r, :bibkey, strip(key))

get_year(r::Ref) = getproperty(r, :year)
set_year!(r::Ref, year::AbstractString) = setproperty!(r, :year, strip(year))

get_title(r::Ref) = getproperty(r, :title)
set_title!(r::Ref, title::AbstractString) = setproperty!(r, :title, strip(title))

get_doi(r::Ref) = getproperty(r, :doi)
set_doi!(r::Ref, doi::AbstractString) = setproperty!(r, :doi, _doi_to_url(doi))

get_keywords(r::Ref) = getproperty(r, :keywords)
set_keywords!(r::Ref, keywords::AbstractString) = setproperty!(r, :keywords, strip(keywords))

get_authors(r::Ref) = getproperty(r, :authors)
set_authors!(r::Ref, authors::AbstractString) = setproperty!(r, :authors, strip(authors))

get_abstract(r::Ref) = getproperty(r, :abstract)
set_abstract!(r::Ref, abstract::AbstractString) = setproperty!(r, :abstract, strip(abstract))

## ------------------------------------------------------------------
# Base
function Base.show(io::IO, r::Ref)
    print(io, "Ref")
    for meta in [:title, :bibkey, :authors, :year, :doi]
        val = getproperty(r, meta)
        isempty(val) && continue
        print(io, "\n - ", meta, ": \"", val, "\"")
    end
end

## ------------------------------------------------------------------
# Dict API
Base.getindex(r::Ref, keys...) = getindex(get_refdict(r), keys...)
Base.get(r::Ref, key, default) = get(get_refdict(r), key, default)