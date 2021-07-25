# POPular Utils KIt

include("ArrSlices.jl")
const ENDLISTTOKEN = "popuki.endlisttoken"

function AE_filter(line::Ref{UInt}, ns::Namespace, predicate::AetherlangObject, collection::AetherlangObject)::AetherlangObject
    arr = []
    for i in 1:length(collection.dataref)
        aetherlang_call(predicate.dataref, ns, AetherlangObject[AetherlangObject(collection.dataref[i])], line).type[] !== AETH_BUILTIN_TYPES.void && push!(arr, collection.dataref[i])
    end
    AetherlangObject(arr)
end
function AE_map(line::Ref{UInt}, ns::Namespace, f::AetherlangObject, collection::AetherlangObject)::AetherlangObject
    arr = []
    for i in 1:length(collection.dataref)
        push!(arr, aetherlang_call(f.dataref, ns, AetherlangObject[AetherlangObject(collection.dataref[i])], line).dataref)
    end
    AetherlangObject(arr)
end
function AE_reduce(line::Ref{UInt}, ns::Namespace, f::AetherlangObject, collection::AetherlangObject)::AetherlangObject
    x = collection.dataref[1]
    for i in 1:length(collection.dataref)
        x = aetherlang_call(f.dataref, ns, AetherlangObject[AetherlangObject(x), AetherlangObject(collection.dataref[i])], line).dataref
    end
    AetherlangObject(x)
end
function AE_startlist(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    if args[end].type[] !== ENDLISTTOKEN
        throw(AetherlangError("No matching \"]\" found in popuki.AE_startlist expression"))
    end
    AetherlangObject([args[i].dataref for i in 1:length(args)-1])
end
function AE_arrslice(line::Ref{UInt}, ns::Namespace, arr::AetherlangObject, ind1::AetherlangObject, ind2::AetherlangObject)::AetherlangObject
    # :end token works in ind2
    if ind2.dataref == "end"
        ind2 = AetherlangObject(length(arr.dataref))
    end
    if ind1.dataref == 1 && ind2.dataref == length(arr.dataref)
        return arr
    end
    AetherlangObject(ArrSlice(arr.dataref, ind1.dataref, ind2.dataref), Ref(AETH_BUILTIN_TYPES.collection))
end
function AE_arrslicerestore(line::Ref{UInt}, ns::Namespace, arrs::AetherlangObject)::AetherlangObject
    if typeof(arrs.dataref) == ArrSlice
        return AetherlangObject(arrs.dataref.arr)
    end
    arrs
end
function AE_arrslicebounds(line::Ref{UInt}, ns::Namespace, arrs::AetherlangObject)::AetherlangObject
    if typeof(arrs.dataref) != ArrSlice
        return AetherlangObject()
    end
    AetherlangObject([arrs.dataref.beg, arrs.dataref.fin])
end
function AE_eleq(line::Ref{UInt}, ns::Namespace, coll1::AetherlangObject, coll2::AetherlangObject)::AetherlangObject
    """can compare phantoms, arrays, and slices element-wise regardless of their actual type"""
    if length(coll1.dataref) != length(coll2.dataref)
        return AetherlangObject()
    end
    l::Int = length(coll1.dataref)
    for i in 1:l
        if coll1.dataref[i] != coll2.dataref[i]
            return AetherlangObject()
        end
    end
    AetherlangObject(1)
end



popuki_namespace_modify = Namespace(
    "]" => AetherlangObject{String}("end", Ref(ENDLISTTOKEN)),
    "[" => AetherlangObject(AE_startlist),
    "[]" => AetherlangObject(Bool[]),
    "filter" => AetherlangObject(AE_filter),
    "map" => AetherlangObject(AE_map),
    "reduce" => AetherlangObject(AE_reduce),
    "arrslice" => AetherlangObject(AE_arrslice),
    "arrslicerestore" => AetherlangObject(AE_arrslicerestore),
    "arrslicebounds" => AetherlangObject(AE_arrslicebounds),
    "elementsequal?" => AetherlangObject(AE_eleq)
)
popuki_namespace_modify["eleq?"] = popuki_namespace_modify["elementsequal?"]
