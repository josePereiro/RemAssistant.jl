## ----------------------------------------------------------------------------
# remote bk
const _REMOTE_BK_URL_CONFIG_KEY = "remote_url"

function _remote_url()::String
    config = read_configfile()
    url = get(config, _REMOTE_BK_URL_CONFIG_KEY, "")
    return url
end

_remote_backup_dir() = joinpath(assistant_dir(), "remote")

## ----------------------------------------------------------------------------
# bk registry

_bk_registry_dir(gl::GitLink) = joinpath(repo_dir(gl), "registry")

function _get_bk_registry(gl::GitLink)
    rdir = _bk_registry_dir(gl)
    isdir(rdir) ? readdir(rdir) : String[]
end

function _addto_bk_registry!(gl::GitLink, bk::String)
    rfile = joinpath(_bk_registry_dir(gl), basename(bk))
    mkpath(dirname(rfile))
    touch(rfile)
    return rfile
end

_clear_bk_registry!(gl::GitLink) = rm(_bk_registry_dir(gl); force = true, recursive = true)

function _update_bk_registry!(gl::GitLink, kb::String)

    lbk_dir = local_backups_dir(kb)
    !isdir(lbk_dir) && error("local backup dir not found: '$(lbk_dir)'")

    for file in readdir(lbk_dir)
        !endswith(file, ".zip") && continue
        _addto_bk_registry!(gl, file)
        _addto_bk_registry!(gl, _to_ascii(file))
    end

    _get_bk_registry(gl)
end

## ----------------------------------------------------------------------------
function _copy_tagged_release_action(repodir)
    srcfile = joinpath(pkgdir(RemAssistant), ".github", "workflows", "tagged-release.yml")
    destfile = joinpath(repodir, ".github", "workflows", "tagged-release.yml")
    mkpath(dirname(destfile))
    cp(srcfile, destfile; force = true)
    return destfile
end

## ----------------------------------------------------------------------------
# TODO: add 'run_git' at GitLinks
function _tag_backup!(gl::GitLink)
    lock(gl) do
        cd(repo_dir(gl)) do
            tagname = string("v", Dates.format(today(), "yyyy.m.d")) # this might comply semver regex
            try;
                p = run(`git tag $(tagname)`; wait = false)
                wait(p)
            catch ignored end
            try;
                p = run(`git push origin $(tagname)`; wait = false)
                wait(p)
            catch ignored end
        end
    end
end

## ----------------------------------------------------------------------------
_to_ascii(str) = replace(str, !isascii => "")

function _is_registered(newest, registered)
    findfirst(
        isequal(_to_ascii(basename(newest))), 
        _to_ascii.(basename.(registered))
    ) !== nothing
end

## ----------------------------------------------------------------------------
function _update_remote_backup(bkdir, remote_url; 
        force = false, loglevel = :verbose
    )

    ## gitlink
    gl = GitLink(bkdir, remote_url)

    ## copy/unzip local backup
    kb = _knowledgebase()
    newest = _resolve_newest_local_bk!(kb)

    # log
    if isempty(newest) 
        loglevel == :verbose && @info("No local backup detected!!!")
        return nothing
    end

    # check registered
    registered = _get_bk_registry(gl)
    is_registered = _is_registered(newest, registered)
    if !force && is_registered
        loglevel == :verbose && @info("Nothing to update!!!", newest = basename(newest), force, is_registered)
        return nothing
    end

    ## update remote backup
    instantiate(gl; verbose = false)
    ok_flag = GitLinks.writewdir(gl) do wdir
        unzip(newest, wdir)
        _copy_tagged_release_action(wdir)
        _update_bk_registry!(gl, kb)
    end

    ## Add tag
    _tag_backup!(gl)
    
    ## log
    if (loglevel == :verbose || loglevel == :upload)
        ok_flag ? 
            @info("Backup uploaded!!!", newest = basename(newest), force, is_registered) :
            @warn("Backup updating failed!!!", newest = basename(newest), force, is_registered)
    end
end
