## AetherlangFunction type
struct AetherlangFunction
    argnames::Vector{String}
    expr::Vector{Union{String, AetherlangObject}} # vector of tokens to evaluate
end
function aetherlang_show(io::IO, f::AetherlangFunction)
    print(io, "(function _ "*join(f.argnames, ' ')*" = [body])")
end
function aetherlang_call(f::AetherlangFunction, ns::Namespace, args::Vector{AetherlangObject}, line::Ref{UInt})::AetherlangObject
    global ether
    fns = copy(ns) # copy(ns) in this case
    if length(args) < length(f.argnames)
        throw(AetherlangError("Not enough arguments"))
    end
    for i in 1:length(f.argnames)
        fns[f.argnames[i]] = args[i]
    end
    fns["oargs"] = AetherlangObject([arg.dataref for arg in args[length(f.argnames)+1:end]])
    aetherlang_eval!(f.expr, fns, line)
end
AetherlangObject(f::AetherlangFunction) = AetherlangObject{AetherlangFunction}(f, Ref(AETH_BUILTIN_TYPES.callable))

## Wrapping Julia functions
function AetherlangObject(f::Function)::AetherlangObject{Function}
    """Wraps a julia function into an AetherlangObject of type callable. The function needs to take a namespace (Namespace) and a list of arguments (vector of AetherlangObject) and output a single AetherlangObject"""
    AetherlangObject{Function}(f, Ref(AETH_BUILTIN_TYPES.callable))
end
function aetherlang_show(io::IO, f::Function)
    print(io, "(julia.function "*string(f)*" [args] = [body])")
end
function aetherlang_call(f::Function, ns::Namespace, args::Vector{AetherlangObject}, line::Ref{UInt})::AetherlangObject
    try
        f(line, ns, args...) # not copy(ns) in this case
    catch e
        if typeof(e) <: AetherlangException
            throw(e)
        else
            throw(AetherlangError("Bad call of built-in function: "*string(e)))
        end
    end
end
