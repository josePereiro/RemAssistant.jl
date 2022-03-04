function filter_bibref(argv=ARGS)

    # read ARGS
    argset = ArgParse.ArgParseSettings()
    ArgParse.@add_arg_table! argset begin
        "patter"
            help = "The search pattern (It will be evaluated as a julia expression)"
            arg_type = String
            required = true
    end

    parsed_args = ArgParse.parse_args(argv, argset)
    patter = parsed_args["patter"]

    # search and print
    parsed = []
    try
        for sub in split(patter, ",")
            push!(parsed, eval(Meta.parse(sub)))
        end
    catch
        parsed = [patter]
    end
    
    @info("Pattern evaluated to", parsed)
    
    found = filter_match(values(bibrefs()), parsed...)

    @info(string("Found ", length(found), " ref(s)"))
    for ref in found
        println(ref)
    end

    return nothing
end

