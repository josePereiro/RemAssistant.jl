# TODO: Do backup system
module RemAssistant

import InteractiveUtils
import InteractiveUtils: clipboard

import TOML
import BibTeX
import JSON
import ArgParse
import ZipFile

using OrderedCollections
using GitLinks
using Dates

using Reexport
@reexport using StringRepFilter

include("core/Ref.jl")
include("core/bib2rem.jl")
include("core/bibref.jl")
include("core/configfile.jl")
include("core/knowledgebase.jl")
include("core/remapi.jl")
include("core/remdepot.jl")
include("core/remote_backup.jl")
include("core/utils.jl")

export config_file

include("api/bibrefs.jl")
include("api/update_remote_backup.jl")

include("cli/cli_os.jl")
include("cli/copy_bibref.jl")
include("cli/filter_bibref.jl")
include("cli/update_remote_backup.jl")

export bibrefs
export filter_bibref, copy_bibref

end # module
