const TYPE = "_SAMPLE.type" # in case your library defines some types,
                            # you need to create constant strings representing this type in Aetherlang type system.
                            # this string is used when calling (typeof obj)

# constructor for AetherlangObject of your type
AetherlangObject(arg::MyType) = AetherlangObject{MyType}(arg, Ref(TYPE))

function _SAMPLE_sample_function(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    # you can specify the number of arguments if needed instead of using args...
    # NOTE: arguments come as AetherlangObjects. use arg.dataref unwrap data. use arg.type[] to get a string representing object's type in Aetherlang
    # NOTE: you are provided with mutable arguments line::Ref{UInt} and ns::Namespace but please don't change them, as it would ruin the paradigm and some features may not work properly
    #=
    CODE
    =#
    AetherlangObject()
end

_SAMPLE_namespace_modify = Namespace(
    "name_of_the_function" => AetherlangObject(_SAMPLE_sample_function)
)
