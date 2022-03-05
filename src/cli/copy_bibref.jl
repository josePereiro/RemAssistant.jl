function copy_bibref(argv=ARGS)

    # read ARGS
    argset = ArgParse.ArgParseSettings()
    ArgParse.@add_arg_table! argset begin
        "bibkey"
            help = "The entry identifier"
            arg_type = String
            required = true
    end

    parsed_args = ArgParse.parse_args(argv, argset)
    bibkey = parsed_args["bibkey"]

    # get ref
    ref = get(bibrefs(), bibkey) do
        error("'", bibkey, "' not found")
    end

    # create rem
    rem = """
    $(bibkey) $(join(remtag(ref.keywords), " ")) #[[Document]] #[[ReadReport]] #[[Header]]
        Meta
            $(ref.title) #[[title]]
            $(ref.authors) #[[authors]]
            $(ref.year) #[[issued]]
            $(ref.doi) #[[doi]]

        Abstract
            $(ref.abstract) #[[abstract]]

    """
    println("Rem at clipboard")
    println(rem)
    
    clipboard(rem)

    return nothing
end
