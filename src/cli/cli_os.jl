# This should be run at all cli top function
function _run_cli_os()
    try
        # backup
        update_remote_backup(;force = false, loglevel = :upload)
    catch ignored; end
end