# TODO: Do backup system
module RemAssistant

import InteractiveUtils
import InteractiveUtils: clipboard

import TOML
import BibTeX
import JSON
import ArgParse
import ZipFile

using GitLinks

using Reexport
@reexport using StringRepFilter

include("core/Ref.jl")
include("core/bibref.jl")
include("core/configfile.jl")
include("core/knowledgebase.jl")
include("core/remapi.jl")
include("core/remdepot.jl")
include("core/remote_backup.jl")
include("core/utils.jl")

export config_file

include("cli/bibref.jl")
include("cli/copy_bibref.jl")
include("cli/filter_bibref.jl")
include("cli/update_remote_backup.jl")

export bibrefs
export filter_bibref, copy_bibref

function __init__()
    # backup
    try; update_remote_backup(;loglevel = :upload)
        catch ignored; end
end

end # module
