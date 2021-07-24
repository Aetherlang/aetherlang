## Describes how dimensions of interpretation work

mutable struct Dimension
    startline::UInt
    current_line::UInt
    endline::UInt
    namespace::Namespace
    name::String
    busy::Bool
    isritual::Bool
end
Dimension(cl::I where I<:Integer, el::I where I<:Integer, ns::Namespace, name::String) = Dimension(cl, cl, el, ns, name, false, false)
Ritual(cl::I where I<:Integer, el::I where I<:Integer, ns::Namespace, name::String) = Dimension(cl, cl, el, ns, name, false, true)

function dimension_forward!(dim::Dimension)::Nothing
    try
        refline::Ref{UInt} = Ref{UInt}(dim.current_line)
        aetherlang_eval!(lines[dim.current_line], dim.namespace, refline)
        dim.current_line = refline[]+1
        if (dim.current_line > dim.endline && dim.isritual)
            dim.current_line = dim.startline;
        elseif dim.current_line > dim.endline || dim.current_line < dim.startline
            global tofinish
            push!(tofinish, dim.name)
        end
    catch e
        aetherlang_print_exception(e, lines[dim.current_line], dim.name) # also exits
    end
    dim.busy = false; # is set to true in Interpreter.jl
    nothing
end
