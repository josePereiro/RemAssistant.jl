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
        "--files", "-f"
            help = "Signal to include source files"
            action = :store_true
    end

    parsed_args = ArgParse.parse_args(argv, argset)
    bibkey = parsed_args["bibkey"]
    add_pdfs = parsed_args["files"]

    rem = _bibtorem(bibkey; add_pdfs)

    println("Rem at clipboard")
    println(rem)
    
    clipboard(rem)

    return nothing
end
