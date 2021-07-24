## Reading the file
function readcodelines(io::IO)::Vector{String}
    """Reads the entire code. Returns an array of strings. Also removes comments and connects lines split with '\\'"""
    function readcodeline(io::IO)::String
        line::String = string(strip(readline(io)))
        comment = findfirst("@", line)
        if comment != nothing #&& comment != 1
            line = line[1:comment[1]-1]
        end
        if line == "" #|| comment == 1
            return ""
        end
        if line[end] == '\\'
            if (eof(io))
                throw(ErrorException("Error when reading the file '\\' at the end of file"))
            end
            line = line[1:end-1]*' '*readcodeline(io)
        end
        line
    end
    lines::Array{String, 1} = []
    while !eof(io)
        line::String = readcodeline(io)
        if line != ""
            push!(lines, line)
        end
    end
    lines
end

##
include("Core/AetherlangCore.jl"); Token = Union{String, AetherlangObject}
include("Tokenizer.jl")
include("InterpretationDimensions.jl")
include("LibUse.jl")
include("Eval.jl")

if length(ARGS) < 1
    println("No file provided for interpretation (ARGS[1] was empty). Aetherlang does not support interactive mode.")
    exit()
end
try
    open(ARGS[1], "r") do file
        global lines = [aetherlang_tokenize(l) for l in readcodelines(file)]
    end
catch e
    aetherlang_print_exception(e, ["__"], "__")
    exit()
end

ether = Namespace()
mainnamespace = Namespace(
    "void" => AetherlangObject(),
    "use" => AetherlangObject(lib_use),
    "true" => AetherlangObject(1),
    "dimname" => AetherlangObject("main")
)
## Main loop (Dimension execution)
tofinish   = Set{String}() # contains names of dimensions and rituals to finish
dimensions = Dimension[]
rituals    = Dimension[]
push!(dimensions, Dimension(1, length(lines), mainnamespace, "main"))
@async while length(dimensions)>0
    print("") # io crutchfix??
    for i in 1:length(rituals)
        i > length(rituals) && break
        if rituals[i].name in tofinish
            pop!(tofinish, rituals[i].name)
            deleteat!(rituals, i)
        else
            if !rituals[i].busy
                rituals[i].busy = true
                @async dimension_forward!(rituals[i])
            end
        end
    end
end
while length(dimensions) > 0
    print("") # io crutchfix??
    global dimensions
    for i in 1:length(dimensions)
        i > length(dimensions) && break
        if dimensions[i].name in tofinish
            pop!(tofinish, dimensions[i].name)
            deleteat!(dimensions, i)
        else
            if !dimensions[i].busy
                dimensions[i].busy = true
                @async dimension_forward!(dimensions[i])
            end
        end
    end
end
