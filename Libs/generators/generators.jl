function generators_range(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)::AetherlangObject
    AetherlangObject(arg1.dataref:arg2.dataref, Ref{String}(AETH_BUILTIN_TYPES.collection))
end
function generators_range(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject, arg3::AetherlangObject)::AetherlangObject
    AetherlangObject(arg1.dataref:arg2.dataref:arg3.dataref, Ref{String}(AETH_BUILTIN_TYPES.collection))
end
function generators_gencoll(line::Ref{UInt}, ns::Namespace, exp::AetherlangObject, var::AetherlangObject, coll::AetherlangObject)::AetherlangObject
    v::Vector = []
    nns::Namespace = copy(ns)
    for i in 1:length(coll.dataref)
        nns[var.dataref] = AetherlangObject(coll.dataref[i])
        push!(v, aetherlang_eval!(exp.dataref, nns, Ref{UInt}(0)).dataref)
    end
    AetherlangObject(v)
end
function generators_gencoll(line::Ref{UInt}, ns::Namespace, exp::AetherlangObject, var::AetherlangObject, coll::AetherlangObject, cond::AetherlangObject)::AetherlangObject
    v::Vector = []
    nns::Namespace = copy(ns)
    for i in 1:length(coll.dataref)
        nns[var.dataref] = AetherlangObject(coll.dataref[i])
        if aetherlang_eval!(cond.dataref, nns, Ref{UInt}(0)).type[] !== AETH_BUILTIN_TYPES.void
            push!(v, aetherlang_eval!(exp.dataref, nns, Ref{UInt}(0)).dataref)
        end
    end
    AetherlangObject(v)
end
function generators_gencoll(line::Ref{UInt}, ns::Namespace, exp::AetherlangObject, var::AetherlangObject, coll::AetherlangObject, cond::AetherlangObject, otherwise_exp::AetherlangObject)::AetherlangObject
    v::Vector = []
    nns::Namespace = copy(ns)
    for i in 1:length(coll.dataref)
        nns[var.dataref] = AetherlangObject(coll.dataref[i])
        if aetherlang_eval!(cond.dataref, nns, Ref{UInt}(0)).type[] !== AETH_BUILTIN_TYPES.void
            push!(v, aetherlang_eval!(exp.dataref, nns, Ref{UInt}(0)).dataref)
        else
            push!(v, aetherlang_eval!(otherwise_exp.dataref, nns, Ref{UInt}(0)).dataref)
        end
    end
    AetherlangObject(v)
end

generators_namespace_modify = Namespace(
    "range" => AetherlangObject(generators_range),
    "gencoll" => AetherlangObject(generators_gencoll)
)
generators_namespace_modify["rng"] = generators_namespace_modify["range"]
