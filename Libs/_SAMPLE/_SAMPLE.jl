# sample library (unusable) that shows you how to code up your own Aetherlang libraries in Julia.
# NOTE that for your library to be installed it should be _SAMPLE_namespace_modifyin the "Libs" folder in a folder named exactly as your library and have a .jl file named exactly as your library.
# NOTE that for a library to be observable from Aetherlang, its name should be in all-lowercase style. this library's name is uppercase on purpose.

const TYPE = "_SAMPLE.type" # in case your library defines some types,
                            # you need to create constant strings representing this type in Aetherlang type system.
                            # this string is used when calling (typeof obj)

# constructor for AetherlangObject of your type
AetherlangObject(arg::MyType) = AetherlangObject{MyType}(arg, Ref(TYPE))

# all functions defined for Aetherlang use should have either the AE_ prefix or the specific prefix named exactly as your library (_SAMPLE_ in this case).
function AE_sample_function(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    # you can specify the number of arguments if needed instead of using args...
    # NOTE: arguments come as AetherlangObjects. use arg.dataref unwrap data. use arg.type[] to get a string representing object's type in Aetherlang
    # NOTE: you are provided with mutable arguments line::Ref{UInt} and ns::Namespace but please don't change them, as it would ruin the paradigm and some features may not work properly
    #=
    CODE
    =#
    AetherlangObject()
end

_SAMPLE_namespace_modify = Namespace(
    "name_of_the_function" => AetherlangObject(AE_sample_function)
)
