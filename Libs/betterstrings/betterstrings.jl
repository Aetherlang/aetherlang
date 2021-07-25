function betterstrings_strjoin(line::Ref{UInt}, ns::Namespace, arr::AetherlangObject, sep::AetherlangObject=AetherlangObject(""))::AetherlangObject
    AetherlangObject(join([arr.dataref[i] for i in 1:length(arr.dataref)], sep.dataref))
end
function betterstrings_strsplit(line::Ref{UInt}, ns::Namespace, str::AetherlangObject, sep::AetherlangObject=AetherlangObject(" "))::AetherlangObject
    AetherlangObject(split(str.dataref, sep.dataref))
end
function betterstrings_charemplace(line::Ref{UInt}, ns::Namespace, str::AetherlangObject, indx::AetherlangObject, char::AetherlangObject)::AetherlangObject
    if length(char.dataref) > 1
        throw(AetherlangError("$(repr(char.dataref)) is not a single character"))
    end
    if indx.dataref == 1
        return AetherlangObject(char.dataref*str.dataref[2:end])
    elseif indx.dataref == length(str.dataref)
        return AetherlangObject(str.dataref[1:end-1]*char.dataref)
    end
    AetherlangObject(str.dataref[1:indx.dataref-1]*char.dataref*str.dataref[indx.dataref+1:end])
end
betterstrings_tolowercase(line::Ref{UInt}, ns::Namespace, str::AetherlangObject)::AetherlangObject = AetherlangObject(lowercase(str.dataref))
betterstrings_touppercase(line::Ref{UInt}, ns::Namespace, str::AetherlangObject)::AetherlangObject = AetherlangObject(uppercase(str.dataref))
function betterstrings_digit(line::Ref{UInt}, ns::Namespace, str::AetherlangObject)::AetherlangObject
    for c in str.dataref
        if !isdigit(c)
            return AetherlangObject()
        end
    end
    AetherlangObject(1)
end
function betterstrings_punct(line::Ref{UInt}, ns::Namespace, str::AetherlangObject)::AetherlangObject
    for c in str.dataref
        if !ispunct(c)
            return AetherlangObject()
        end
    end
    AetherlangObject(1)
end
function betterstrings_printable(line::Ref{UInt}, ns::Namespace, str::AetherlangObject)::AetherlangObject
    for c in str.dataref
        if !isprint(c)
            return AetherlangObject()
        end
    end
    AetherlangObject(1)
end
function betterstrings_whitespace(line::Ref{UInt}, ns::Namespace, str::AetherlangObject)::AetherlangObject
    for c in str.dataref
        if !isspace(c)
            return AetherlangObject()
        end
    end
    AetherlangObject(1)
end

betterstrings_namespace_modify = Namespace(
    "strjoin" => AetherlangObject(betterstrings_strjoin),
    "strsplit" => AetherlangObject(betterstrings_strsplit),
    "charemplace" => AetherlangObject(betterstrings_charemplace),
    "tolowercase" => AetherlangObject(betterstrings_tolowercase),
    "touppercase" => AetherlangObject(betterstrings_touppercase),
    "digit?" => AetherlangObject(betterstrings_digit),
    "punct?" => AetherlangObject(betterstrings_punct),
    "printable?" => AetherlangObject(betterstrings_printable),
    "whitespace?" => AetherlangObject(betterstrings_whitespace)
)
betterstrings_namespace_modify["charemp"] = betterstrings_namespace_modify["charemplace"]
