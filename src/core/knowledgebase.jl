## ----------------------------------------------------------------------------

const _KBASE_CONFIG_KEY = "knowledgebase"

function _knowledgebase()::String
    config = read_configfile()
    kb = get(config, _KBASE_CONFIG_KEY, "")
    return kb
end
