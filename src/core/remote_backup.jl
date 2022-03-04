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
    end

    _get_bk_registry(gl)
end

