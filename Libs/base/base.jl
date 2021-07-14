## base library
function AE_aetherwait(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    for arg in args
        if !haskey(ether, arg.dataref)
            line[] -= 1
            return AetherlangObject()
        end
    end
    AetherlangObject()
end
function AE_aetherdel(line::Ref{UInt}, ns::Namespace, name::AetherlangObject)::AetherlangObject
    if !haskey(ether, name.dataref)
        throw(AetherlangError("Name `aether.$token` is not defined"))
    end
    pop!(ether, name.dataref)
    AetherlangObject()
end
function AE_aetherclear(line::Ref{UInt}, ns::Namespace, dummy::AetherlangObject)::AetherlangObject
    global ether = Namespace()
    AetherlangObject()
end
function AE_aethersize(line::Ref{UInt}, ns::Namespace, dummy::AetherlangObject)::AetherlangObject
    AetherlangObject(length(ether))
end
function AE_dimwait(line::Ref{UInt}, ns::Namespace, dimname::AetherlangObject)::AetherlangObject
    if dimname.dataref == ns["dimname"]
        throw(AetherlangError("`dimwait` cannot wait for dimension it is called from"))
    end
    for i in 1:length(dimensions)
        if dimensions[i].name == dimname.dataref
            line[] -= 1
            return AetherlangObject()
        end
    end
    AetherlangObject()
end
function AE_do(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    o::AetherlangObject = AetherlangObject()
    nns::Namespace = copy(ns)
    for arg in args
        o = aetherlang_eval!(arg.dataref, nns, line)
    end
    return o
end
function AE_until(line::Ref{UInt}, ns::Namespace, cond::AetherlangObject, act::AetherlangObject)::AetherlangObject
    o::AetherlangObject = AetherlangObject()
    while aetherlang_eval!(cond.dataref, copy(ns), line).type[] === AETH_BUILTIN_TYPES.void
        o = aetherlang_eval!(act.dataref, copy(ns), line)
    end
    return o
end
function AE_for(line::Ref{UInt}, ns::Namespace, argname::AetherlangObject, bound::AetherlangObject, act::AetherlangObject)::AetherlangObject
    o::AetherlangObject = AetherlangObject()
    varname::String = argname.dataref
    if haskey(ns, varname)
        throw(AetherlangError("Trying to redefine a local dimensional constant `$varname` of type "*ns[varname].type[]))
    end
    nns::Namespace = copy(ns)
    for i in 1:length(bound.dataref)
        nns[varname] = AetherlangObject(bound.dataref[i])
        o = aetherlang_eval!(act.dataref, nns, line)
    end
    return o
end
function AE_gotime(line::Ref{UInt}, ns::Namespace, timepoint::AetherlangObject{AetherlangTimepoint})::AetherlangObject
    for (name, obj) in ns
        if !(name in timepoint.dataref.names)
            pop!(ns, name)
        end
    end
    line[] = timepoint.dataref.line
    AetherlangObject()
end
function AE_exists(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject
    name::String = arg.dataref
    if length(name)>7&&"aether."==name[1:7]
        return haskey(ether, name[8:end]) ? AetherlangObject{Int8}(Int8(1), Ref{String}(AETH_BUILTIN_TYPES.number)) : AetherlangObject()
    end
    haskey(ns, name) ? AetherlangObject{Int8}(Int8(1), Ref{String}(AETH_BUILTIN_TYPES.number)) : AetherlangObject()
end
function AE_set(line::Ref{UInt}, ns::Namespace, _name::AetherlangObject, value::AetherlangObject)::AetherlangObject
    name::String = _name.dataref
    if length(name)>7&&"aether."==name[1:7]
        # aether.NAME = EXP
        if value.type[] === AETH_BUILTIN_TYPES.timepoint
            throw(AetherlangError("Definition of timepoints in aether is forbidden"))
        end
        ether[name[8:end]] = value
    else
        # NAME = EXP
        if haskey(ns, name)
            throw(AetherlangError("Trying to redefine a local dimensional constant `$(tokens[1])` of type "*s[name].type[]))
        end
        ns[name] = value
    end
    return value
end
function AE_include(line::Ref{UInt}, ns::Namespace, argpath::AetherlangObject)::AetherlangObject
    # may not work well yet
    path::String = dirname(ARGS[1])*"/"*argpath.dataref # remember that ARGS[1] is a file name
    try
        open(path, "r") do file
            lines::Vector{String} = readcodelines(file)
            for l in lines
                aetherlang_eval!(l, ns, Ref{UInt}(0))
            end
        end
    catch
        throw(AetherlangError("Including from path \"$(path)\" went wrong. Only put definitions in included files."))
    end
    AetherlangObject()
end
AE_call(line::Ref{UInt}, ns::Namespace, fn::AetherlangObject, args::AetherlangObject)::AetherlangObject = aetherlang_call(fn.dataref, ns, AetherlangObject[AetherlangObject(args.dataref[i]) for i in 1:length(args.dataref)], line)
function AE_lambda(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    AetherlangObject(AetherlangFunction([arg.dataref for arg in args[1:end-1]], String[args[end].dataref]))
end
AE_if(line::Ref{UInt}, ns::Namespace, cond::AetherlangObject, act::AetherlangObject)::AetherlangObject = cond.type[] !== AETH_BUILTIN_TYPES.void ? aetherlang_eval!(act.dataref, copy(ns), line) : AetherlangObject()
AE_if(line::Ref{UInt}, ns::Namespace, cond::AetherlangObject, act1::AetherlangObject, act2::AetherlangObject)::AetherlangObject = cond.type[] !== AETH_BUILTIN_TYPES.void ? aetherlang_eval!(act1.dataref, copy(ns), line) : aetherlang_eval!(act2.dataref, copy(ns), line)
AE_timepoint(line::Ref{UInt}, ns::Namespace, dummy::AetherlangObject)::AetherlangObject = AetherlangObject(AetherlangTimepoint(Set(keys(ns)), line[]))
AE_typeof(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject = AetherlangObject(args[1].type[], true)

## arithmetics definition
AE_plus(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject = AetherlangObject(sum([arg.dataref for arg in args]))
AE_minus(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject{T where T<:Integer}, arg2::AetherlangObject{T where T<:Integer})::AetherlangObject{Int64} = AetherlangObject(Int64(arg1.dataref)-arg2.dataref, Ref(AETH_BUILTIN_TYPES.number))
AE_minus(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject) = AetherlangObject(arg1.dataref-arg2.dataref, Ref(AETH_BUILTIN_TYPES.number))
AE_minus(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject = AetherlangObject(-arg.dataref)
AE_prod(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject = AetherlangObject(prod([arg.dataref for arg in args]))
AE_div(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)::AetherlangObject = AetherlangObject(arg1.dataref/arg2.dataref)
## logic operators
function AE_eq(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    for i in 1:length(args)-1
        if args[i].dataref != args[i+1].dataref || args[i].type[] != args[i+1].type[]
            return AetherlangObject()
        end
    end
    AetherlangObject{Int8}(Int8(1), Ref{String}(AETH_BUILTIN_TYPES.number))
end
AE_not(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject = arg.type[] !== AETH_BUILTIN_TYPES.void ? AetherlangObject() : AetherlangObject{Int8}(Int8(1), Ref{String}(AETH_BUILTIN_TYPES.number))
AE_less(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)::AetherlangObject = arg1.dataref < arg2.dataref ? AetherlangObject{Int8}(Int8(1), Ref{String}(AETH_BUILTIN_TYPES.number)) : AetherlangObject()
AE_more(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)::AetherlangObject = arg1.dataref > arg2.dataref ? AetherlangObject{Int8}(Int8(1), Ref{String}(AETH_BUILTIN_TYPES.number)) : AetherlangObject()
AE_or(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)::AetherlangObject = (arg1.type[] !== AETH_BUILTIN_TYPES.void || arg2.type[] !== AETH_BUILTIN_TYPES.void) ? AetherlangObject{Int8}(Int8(1), Ref{String}(AETH_BUILTIN_TYPES.number)) : AetherlangObject()

## collections
AE_collect(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject = AetherlangObject([args[argi].dataref for argi in 1:length(args)])
AE_len(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject)::AetherlangObject = AetherlangObject(length(coll.dataref))
AE_get(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject, idx::AetherlangObject)::AetherlangObject = AetherlangObject(getindex(coll.dataref, idx.dataref))
AE_first(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject)::AetherlangObject = AetherlangObject(getindex(coll.dataref, 1))
AE_last(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject)::AetherlangObject = AetherlangObject(getindex(coll.dataref, length(coll.dataref)))
function AE_push(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject, value::AetherlangObject)::AetherlangObject
    arr = [coll.dataref[i] for i in 1:length(coll.dataref)]
    push!(arr, value.dataref)
    return AetherlangObject(arr)
end
function AE_removeat(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject, index::AetherlangObject)::AetherlangObject
    arr = [coll.dataref[i] for i in 1:length(coll.dataref)]
    deleteat!(arr, index.dataref)
    return AetherlangObject(arr)
end
function AE_emplace(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject, indx::AetherlangObject, value::AetherlangObject)::AetherlangObject
    err::AetherlangError = AetherlangError("emplace can only be used on instances of type `$(AETH_BUILTIN_TYPES.collection)` or `$(AETH_BUILTIN_TYPES.phantom)` with integer indexes")
    if !(typeof(indx.dataref) <: Integer)
        throw(err)
    end
    if coll.type[] !== AETH_BUILTIN_TYPES.collection && coll.type[] !== AETH_BUILTIN_TYPES.phantom
        throw(err)
    end
    if length(coll.dataref) < indx.dataref || indx.dataref < 1
        throw(AetherlangError("emplace: index $(indx.dataref) out of range"))
    end
    AetherlangObject([(i == indx.dataref ? value.dataref : coll.dataref[i]) for i in 1:length(coll.dataref)])
end
function AE_contains(line::Ref{UInt}, ns::Namespace, value::AetherlangObject, _coll::AetherlangObject)::AetherlangObject
    # returns index or void
    AetherlangObject(indexin(value.dataref, _coll.dataref)[1])
end

## phantoms
function AE_phantomemplace(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject, indx::AetherlangObject, value::AetherlangObject)::AetherlangObject
    err::AetherlangError = AetherlangError("phantomemplace can only be used on instances of type `$(AETH_BUILTIN_TYPES.collection)` or `$(AETH_BUILTIN_TYPES.phantom)` with integer indexes")
    if !(typeof(indx.dataref) <: Integer)
        throw(err)
    end
    if coll.type[] === AETH_BUILTIN_TYPES.phantom
        ph::AetherlangPhantomCollection = copy(coll.dataref)
        ph.addindx[indx.dataref] = value.dataref
        return AetherlangObject(ph)
    elseif coll.type[] !== AETH_BUILTIN_TYPES.collection
        throw(err)
    elseif length(coll.dataref) < indx.dataref || indx.dataref < 1
        throw(AetherlangError("phantomemplace: index $(indx.dataref) out of range"))
    end
    AetherlangObject(AetherlangPhantomCollection(coll.dataref, Dict{Integer, Any}(indx.dataref => value.dataref), length(coll.dataref)))
end
function AE_phantompush(line::Ref{UInt}, ns::Namespace, coll::AetherlangObject, value::AetherlangObject)::AetherlangObject
    if coll.type[] == AETH_BUILTIN_TYPES.phantom
        ph::AetherlangPhantomCollection = copy(coll.dataref)
        ph.length += 1
        ph.addindx[ph.length] = value.dataref
        return AetherlangObject(ph)
    elseif coll.type[] !== AETH_BUILTIN_TYPES.collection
        throw(AetherlangError("phantompush can only be used on instances of type `$(AETH_BUILTIN_TYPES.collection)` or `$(AETH_BUILTIN_TYPES.phantom)` with integer indexes"))
    end
    AetherlangObject(AetherlangPhantomCollection(coll.dataref, Dict{Integer, Any}(length(coll.dataref)+1 => value.dataref), length(coll.dataref)+1))
end

## namespace modifier
base_namespace_modify = Namespace(
    "aetherwait" => AetherlangObject(AE_aetherwait),
    "aetherdel" => AetherlangObject(AE_aetherdel),
    "aetherclear" => AetherlangObject(AE_aetherclear),
    "aethersize" => AetherlangObject(AE_aethersize),
    "dimwait" => AetherlangObject(AE_dimwait),
    "include" => AetherlangObject(AE_include),
    "set" => AetherlangObject(AE_set),
    "lambda" => AetherlangObject(AE_lambda),
    "typeof" => AetherlangObject(AE_typeof),
    "call" => AetherlangObject(AE_call),
    "do" => AetherlangObject(AE_do),
    "exists?" => AetherlangObject(AE_exists),
    "timepoint" => AetherlangObject(AE_timepoint),
    "gotime" => AetherlangObject(AE_gotime),
    "if" => AetherlangObject(AE_if),
    "until" => AetherlangObject(AE_until),
    "for" => AetherlangObject(AE_for),
    "equal?" => AetherlangObject(AE_eq),
    "not" => AetherlangObject(AE_not),
    "or" => AetherlangObject(AE_not),
    "collect" => AetherlangObject(AE_collect),
    "len" => AetherlangObject(AE_len),
    "get" => AetherlangObject(AE_get),
    "push" => AetherlangObject(AE_push),
    "emplace" => AetherlangObject(AE_emplace),
    "removeat" => AetherlangObject(AE_removeat),
    "contains?" => AetherlangObject(AE_contains),
    "first" => AetherlangObject(AE_first),
    "last" => AetherlangObject(AE_last),
    "phantomemplace" => AetherlangObject(AE_phantomemplace),
    "phantompush" => AetherlangObject(AE_phantompush),
    "<" => AetherlangObject(AE_less),
    ">" => AetherlangObject(AE_more),
    "+" => AetherlangObject(AE_plus),
    "-" => AetherlangObject(AE_minus),
    "*" => AetherlangObject(AE_prod),
    "/" => AetherlangObject(AE_div)
)
# duplicates
base_namespace_modify["arr"] = base_namespace_modify["array"] = base_namespace_modify["collect"]
base_namespace_modify["fst"] = base_namespace_modify["first"]
base_namespace_modify["phemp"] = base_namespace_modify["phantomemplace"]
base_namespace_modify["emp"] = base_namespace_modify["emplace"]
base_namespace_modify["phpush"] = base_namespace_modify["phantompush"]
base_namespace_modify["in?"] = base_namespace_modify["contains?"]
base_namespace_modify["eq"] = base_namespace_modify["eq?"] = base_namespace_modify["equal?"]
