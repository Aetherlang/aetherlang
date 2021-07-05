## Aetherlang interpreter exceptions and errors

# NOTE THAT AetherlangException IS NOT A SUBTYPE OF Exception
abstract type AetherlangException end

struct AetherlangError <: AetherlangException
    message::String
end

function aetherlang_print_exception(e, line::Vector{String}, dimname::String)
    print("\n\n")
    if typeof(e) <: Exception; print("JuliaException: "); end
    println(e)
    println("\nAETHERLANG ERROR AT LINE:\n\t"*join(line, ' '))
    println("(COMMENTS REMOVED)")
    println("IN DIMENSION "*dimname)
    exit()
end
