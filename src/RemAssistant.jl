# TODO: Do backup system
module RemAssistant

import InteractiveUtils
import InteractiveUtils: clipboard

import TOML
import BibTeX
import JSON
import ArgParse

using Reexport
@reexport using StringRepFilter

    
include("configfile.jl")

include("Ref.jl")
include("bibref.jl")
include("utils.jl")

export bibrefs

include("cli/copy_bibref.jl")
include("cli/filter_bibref.jl")

export filter_bibref, copy_bibref


end
