function update_remote_backup_cli(argv=ARGS)

    # read ARGS
    argset = ArgParse.ArgParseSettings()
    ArgParse.@add_arg_table! argset begin
        "--force", "-f"
            help = "The search pattern (It will be evaluated as a julia expression)"
            action = :store_true
    end

    parsed_args = ArgParse.parse_args(argv, argset)
    force = parsed_args["force"]

    # update
    update_remote_backup(;force, loglevel = :verbose)

    return nothing
end

