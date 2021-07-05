## definition of the only built-in function in Aetherlang - USE
function lib_use(line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2=AetherlangObject(""))::AetherlangObject
    lib::String = arg1.dataref
    include("Libs/"*lib*"/"*lib*".jl")
    nsmod::Namespace = eval(Meta.parse("$(lib)_namespace_modify"))
    prefix::String = arg2.dataref
    for (name, obj) in nsmod
        _fullname::String = prefix*name
        if !haskey(ns, _fullname)
            ns[_fullname] = obj
        else
            throw(AetherlangError("Library `$lib` tries to redefine an existing name `$_fullname`. Use prefix"))
        end
    end
    AetherlangObject()
end
