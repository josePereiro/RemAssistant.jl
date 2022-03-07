function _bibtorem(bibkey::AbstractString)
    
    # get ref
    ref = get(bibrefs(), bibkey) do
        error("'", bibkey, "' not found")
    end

    # create rem
    tags = join([remtag(ref.keywords)..., remtag("Document"), remtag("Stub"), remtag("Read Report"), remtag("Read Report")])
    remname = string(bibkey, tags)
        # Meta
            title = _if_nonempty(ref.title, string("\t\t", ref.title, remtag("Title")))
            authors = _if_nonempty(ref.authors, string("\t\t", ref.authors, remtag("Authors")))
            year = _if_nonempty(ref.year, string("\t\t", remref(ref.year), remtag("Issued")))
            doi = _if_nonempty(ref.doi, string("\t\t", ref.doi, remtag("DOI")))
        # Abstract
            abstract = _if_nonempty(ref.abstract, string("\t\t", ref.abstract, remtag("Abstract")))
        # Files
            files = filter(_getfiles(ref)) do path
                endswith(path, ".pdf")
            end
            pdfs = _if_nonempty(files, 
                string(
                    "\t\t_pdfs:_", 
                    remtag("Edit Later"),
                    "\n\t\t\t", 
                    join(files, "\n\t\t\t")
                )
            )

    
    return join(
        [
            remname, 
                "\tMeta", 
                    title,
                    authors,
                    year,
                    doi,
                    pdfs,
                "\tAbstract", 
                    abstract
        ]
        , "\n"
    )
end