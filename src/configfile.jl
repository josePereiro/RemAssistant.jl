## ------------------------------------------------------------------
# USER CONFIG
_rbook_toml_name() = ".RemAssistant.toml"
config_file() = joinpath(homedir(), _rbook_toml_name())

function read_configfile()
    cfile = config_file()
    isfile(cfile) ? TOML.parsefile(cfile) : Dict()
end
