## Describes how dimensions of interpretation work

mutable struct Dimension
    startline::UInt
    current_line::UInt
    endline::UInt
    namespace::Namespace
    name::String
end
Dimension(cl::I where I<:Integer, el::I where I<:Integer, ns::Namespace, name::String) = Dimension(cl, cl, el, ns, name)

function dimension_forward!(dim::Dimension)::Nothing
    #try
        refline::Ref{UInt} = Ref{UInt}(dim.current_line)
        aetherlang_eval!(lines[dim.current_line], dim.namespace, refline)
        dim.current_line = refline[]+1
    #catch e
    #   aetherlang_print_exception(e, lines[dim.current_line], dim.name) # also exits
    #end
    print() # I don't why but it just doesn't work without this print and exists with "ERROR: LoadError: MethodError: convert(::Type{Union{}}, ::UInt64) is ambiguous."
end
