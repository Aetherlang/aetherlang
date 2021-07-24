## Aetherlang interpreter exceptions and errors

# NOTE THAT AetherlangException IS NOT A SUBTYPE OF Exception
abstract type AetherlangException end

struct AetherlangError <: AetherlangException
    message::String
end

function aetherlang_print_exception(e, line::Vector{String}, dimname::String)
    print("\n\n"*(typeof(e) <: AetherlangException ? e.message : repr(e))*"\nAETHERLANG ERROR AT LINE:\n\t"*join(line, ' ')*"\n(COMMENTS REMOVED)\nIN DIMENSION "*dimname*'\n')
    exit()
end
