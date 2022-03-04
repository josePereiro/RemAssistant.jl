## ----------------------------------------------------------------------------
function update_remote_backup(; loglevel = :verbose)

    ## gitlink
    repodir = _remote_backup_dir()
    remote_url = _remote_url()
    gl = GitLink(repodir, remote_url)

    ## copy/unzip local backup
    kb = _knowledgebase()
    newest = _resolve_newest_local_bk!(kb)

    if isempty(newest) 
        loglevel == :verbose && @info("No local backup detected!!!")
        return nothing
    end

    # check registered
    registered = _get_bk_registry(gl)
    if (basename(newest) in basename.(registered))
        loglevel == :verbose && @info("Nothing to update!!!", newest = basename(newest))
        return nothing
    end

    ## update remote backup
    instantiate(gl; verbose = false)
    ok_flag = GitLinks.writewdir(gl) do wdir
        unzip(newest, wdir)
        _update_bk_registry!(gl, kb)
    end
    
    if (loglevel == :verbose || loglevel == :upload) && 
        ok_flag ? 
            @info("Backup uploaded!!!", newest = basename(newest)) :
            @warn("Backup updating failed!!!", newest = basename(newest))
    end
end
