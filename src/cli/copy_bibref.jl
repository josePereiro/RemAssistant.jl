function copy_bibref_cli(argv=ARGS)

    # os
    _run_cli_os()

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

    rem = _bibtorem(bibkey)

    println("Rem at clipboard")
    println(rem)
    
    clipboard(rem)

    return nothing
end
