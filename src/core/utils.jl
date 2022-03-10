## ----------------------------------------------------------------------------
# utils
const _CLEAR_BIBTEX_ENTRY_STRIP_SET = ['{', '}', '\n', ' ', ',', ';']
const _alphanum_str = "a-zA-Z0-9"
const _punct_str = "\\,\\-\\;\\:\\."
const _reg1 = Regex("[$_punct_str]{2}")
const _reg2 = Regex("\\s{2}")
const _reg3 = Regex("[^$(_alphanum_str)$(_punct_str)/\\s]")

function _clear_bibtex_entry(str::AbstractString)

    str = strip(str, _CLEAR_BIBTEX_ENTRY_STRIP_SET)
    str = replace(str, "\n" => "")
    
    _till_unchanged() do 
        str = replace(str, _reg1 => ",")
        str = replace(str, _reg2 => " ")
        for c in ",;:."
            str = replace(str, " $c" => c)
        end
        str = replace(str, _reg3 => "")
        return str
    end
    return str
end

## ----------------------------------------------------------------------------
function _till_unchanged(f!::Function; n = 100)
    ret = f!()
    ret0 = ret
    for i in 1:n
        ret = f!()
        (ret0 == ret) && return ret
    end
    return ret
end

## ----------------------------------------------------------------------------
function _push_csv!(col, str::AbstractString)
    vals = split(str, ",", keepempty = false)
    for vali in vals
        push!(col, strip(vali))
    end
    return col
end

function _push_csv!(col, str::AbstractString, strs::AbstractString...)
    _push_csv!(col, str)
    for stri in strs
        _push_csv!(col, stri)
    end
    return col
end

## ----------------------------------------------------------------------------
# zip
# function zip(srcfile, destfile = string(srcfile, ".zip"))
#     zdir = ZipFile.Writer(srcfile) 
#     for (root, dirs, files) in walkdir(destfile)
#         for file in files
#             filepath = joinpath(root, file)
#             f = open(filepath, "r")
#             content = read(f, String)
#             close(f)
#             zf = ZipFile.addfile(zdir, basename(filepath));
#             write(zf, content)
#         end
#     end
#     close(zdir)
# end

function zip(srcfile, destfile = string(srcfile, ".tar.gz"))
    # p = run(`zip -r $(destfile) $(srcfile)`; wait = false)
    p = run(`tar -zcvf $(destfile) $(srcfile)`; wait = false)
    wait(p)
    return destfile
end


function unzip(srcfile, destfile = replace(srcfile, r".zip$" => ""))
    fileFullPath = isabspath(srcfile) ?  srcfile : joinpath(pwd(),srcfile)
    basePath = dirname(fileFullPath)
    outPath = (destfile == "" ? basePath : (isabspath(destfile) ? destfile : joinpath(pwd(),destfile)))
    isdir(outPath) ? "" : mkdir(outPath)
    zarchive = ZipFile.Reader(fileFullPath)
    for f in zarchive.files
        fullFilePath = joinpath(outPath,f.name)
        if (endswith(f.name,"/") || endswith(f.name,"\\"))
            mkdir(fullFilePath)
        else
            write(fullFilePath, read(f))
        end
    end
    close(zarchive)
end


## ----------------------------------------------------------------------------
function _dirsize(dir)
    size = 0
    for (root, dirs, files) in walkdir(dir)
        for file in files
            filepath = joinpath(root, file)
            size += filesize(filepath)    
        end
    end
    return size
end

_filesize(path) = isdir(path) ? _dirsize(path) : filesize(path)

## ----------------------------------------------------------------------------
function _doi_to_url(doi::AbstractString)
    if startswith(doi, "http")
        return doi 
    elseif startswith(doi, "doi.org")
        return string("https://", doi)
    elseif startswith(doi, r"\d{1,10}\.\d{3,20}")
        return string("https://doi.org/", doi)
    end
    return ""
end

function camel_alphanumeric(str)
    strs = split(str, r"[^a-zA-Z0-9]"; keepempty = false)
    join(uppercasefirst.(strs), " ")
end

function _if_nonempty(f::Function, str, dflt = "")
    isempty(str) ? dflt : f(str)
end
_if_nonempty(str, val, dflt = "") = _if_nonempty((x) -> val, str, dflt)

## ----------------------------------------------------------------------------
function _hash_file(file::AbstractString)
    h = hash("")
    !isfile(file) && return h

    open(file) do io
        for byte in read(io)
            h = hash(byte, h)
        end
    end
    return h
end