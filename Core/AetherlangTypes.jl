## Aetherlang type system
include("AetherlangExceptions.jl")
include("AetherlangPhantomCollection.jl")
include("AetherlangArrays.jl")

## A named tuple for type references
const AETH_BUILTIN_TYPES = (
    unknown="unknown", # this is a type for system types that are not builtin
    number="number",
    string="string",
    symbol="symbol",
    timepoint="timepoint",
    void="void",
    callable="function",
    collection="array", # is only used to refer to a linear collection, such as tuple or array. define other types for other collections
    phantom="phantomarray" # is only used for phantoms on linear collections of type AETH_BUILTIN_TYPES.collection. define others types for phantoms on your structures
)

## AetherlangVoid type
struct AetherlangVoid
end
function Base.show(io::IO, o::AetherlangVoid)
    print(io, "void")
end

##
struct AetherlangObject{T}
    """A container type for Aetherlang. Can contain any Aetherlang type"""
    dataref::T
    type::Ref{String}
end
function Base.show(io::IO, o::AetherlangObject)
    try
        aetherlang_show(io, o.dataref)
    catch
        print(io, o.dataref)
    end
end

AetherlangObject() = AetherlangObject{AetherlangVoid}(AetherlangVoid(), Ref(AETH_BUILTIN_TYPES.void))
AetherlangObject(n::Nothing) = AetherlangObject{AetherlangVoid}(AetherlangVoid(), Ref(AETH_BUILTIN_TYPES.void))
AetherlangObject(s::String, issymbol::Bool) = AetherlangObject{String}(s, issymbol ? Ref(AETH_BUILTIN_TYPES.symbol) : Ref(AETH_BUILTIN_TYPES.string))
AetherlangObject(s::String) = AetherlangObject(s, false)
AetherlangObject(c::T where T <: AbstractVector) = AetherlangObject{typeof(c)}(c, Ref(AETH_BUILTIN_TYPES.collection))
#AetherlangObject(c::Tuple) = AetherlangObject{typeof(c)}(c, Ref(AETH_BUILTIN_TYPES.collection))
AetherlangObject(p::AetherlangPhantomCollection) = AetherlangObject{AetherlangPhantomCollection}(p, Ref(AETH_BUILTIN_TYPES.phantom))
AetherlangObject(a::T where T<:Any) = AetherlangObject{typeof(a)}(a, Ref(AETH_BUILTIN_TYPES.unknown))
function AetherlangObject(n::T where T<:Number)
    if typeof(n) <: Int
        if n <= 127 && n >= -128
            return AetherlangObject{Int8}(Int8(n), Ref(AETH_BUILTIN_TYPES.number))
        end
    end
    AetherlangObject{typeof(n)}(n, Ref(AETH_BUILTIN_TYPES.number))
end
function AetherlangObject(f::Function)::AetherlangObject{Function}
    """Wraps a julia function into an AetherlangObject of type callable. The function needs to take a namespace (Namespace) and a list of arguments (vector of AetherlangObject) and output a single AetherlangObject"""
    AetherlangObject{Function}(f, Ref(AETH_BUILTIN_TYPES.callable))
end
AetherlangObject(b::Bool) = b ? AetherlangObject{Int8}(Int8(1), Ref(AETH_BUILTIN_TYPES.number)) : AetherlangObject()

## Namespace definition
Namespace = Dict{String, AetherlangObject{T} where T}

## Timepoint type and the corresponding constructor for AetherlangObject
struct AetherlangTimepoint
    names::Set{String} # a set of names that exist at this timepoint in given dimension
    line::UInt
end
AetherlangObject(t::AetherlangTimepoint) = AetherlangObject{AetherlangTimepoint}(t, Ref(AETH_BUILTIN_TYPES.timepoint))
function aetherlang_show(io::IO, t::AetherlangTimepoint)
    print(io, "(timepoint at line $(t.line))")
end

## AetherlangFunction type
struct AetherlangFunction
    argnames::Vector{String}
    expr::Vector{Union{String, AetherlangObject}} # vector of tokens to evaluate
end
function aetherlang_show(io::IO, f::AetherlangFunction)
    print(io, "(function _ "*join(f.argnames)*" = %body%)")
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
function aetherlang_call(f::Function, ns::Namespace, args::Vector{AetherlangObject}, line::Ref{UInt})::AetherlangObject
    try
        f(line, ns, args...) # not copy(ns) in this case
    catch e
        if typeof(e) <: AetherlangException
            throw(e)
        else
            throw(AetherlangError("Bad call of built-in function"))
        end
    end
end
AetherlangObject(f::AetherlangFunction) = AetherlangObject{AetherlangFunction}(f, Ref(AETH_BUILTIN_TYPES.callable))
