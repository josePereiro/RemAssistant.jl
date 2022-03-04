remdepot() = joinpath(homedir(), "remnote")
knowledgebase_dir(kb::String) = joinpath(remdepot(), kb)

assistant_dir() = joinpath(remdepot(), "RemAssistant")

local_backups_dir(kb::String) = joinpath(remdepot(), kb, "backups")

function _resolve_newest_local_bk!(kb::String)
    
    # find newest
    lbk_dir = local_backups_dir(kb)
    !isdir(lbk_dir) && error("local backup dir not found: '$(lbk_dir)'")

    newest = ""
    for file in readdir(lbk_dir; join = true)
        !endswith(file, ".zip") && continue
        if mtime(newest) < mtime(file)
            newest = file
        end
    end
    
    return newest
end
