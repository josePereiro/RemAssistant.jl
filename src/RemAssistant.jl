module RemAssistant

import InteractiveUtils
import InteractiveUtils: clipboard

import TOML
import BibTeX
import JSON
import ArgParse
    
include("configfile.jl")

include("Ref.jl")
include("bibref.jl")
include("utils.jl")

export bibrefs

end
