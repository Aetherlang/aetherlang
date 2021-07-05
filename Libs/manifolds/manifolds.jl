include("Manifold.jl")
const MANIFOLD_TYPE = "manifolds.manifold"
AetherlangObject(m::ManifoldsManifold) = AetherlangObject{ManifoldsManifold}(m, Ref{String}(MANIFOLD_TYPE))

function manifolds_manifold(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    exp::Vector{Token} = Token[(haskey(ns, t) ? ns[t] : t) for t::String in aetherlang_tokenize(args[end].dataref[2:end-1])]
    AetherlangObject(ManifoldsManifold([args[argi].dataref for argi in 1:(length(args)-1)], exp))
end

# make manifold slicing
function manifolds_section(line::Ref{UInt}, ns::Namespace, m::AetherlangObject, args...)::AetherlangObject
    if length(args) % 2 != 0
        throw(AetherlangError("Wrong number of arguments given to manifolds.section"))
    end
    nm::ManifoldsManifold = deepcopy(m.dataref)
    i::Int = 1
    while i <= length(args)
        popat!(nm.vars, indexin([args[i].dataref], nm.vars)[1])
        nm.exp = Token[t==args[i].dataref ? args[i+1] : t for t in nm.exp]
        i += 2
    end
    AetherlangObject(nm)
end

# overload from base
function base_contains(line::Ref{UInt}, ns::Namespace, args::AetherlangObject, m::AetherlangObject{ManifoldsManifold})::AetherlangObject
    nns::Namespace = copy(ns)
    for i::Int in 1:length(m.dataref.vars)
        nns[m.dataref.vars[i]] = AetherlangObject(args.dataref[i])
    end
    aetherlang_eval!(m.dataref.exp, nns, Ref{UInt}(0))
end

manifolds_namespace_modify = Namespace(
    "manifold" => AetherlangObject(manifolds_manifold),
    "section" => AetherlangObject(manifolds_section)
)
