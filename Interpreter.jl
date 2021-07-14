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
catch
    println("Error when reading the file. Probably no such file or directory.")
    exit()
end

ether = Namespace()
mainnamespace = Namespace(
    "void" => AetherlangObject(),
    "use" => AetherlangObject(lib_use),
    "true" => AetherlangObject(1),
    "dimname" => AetherlangObject("main")
)
## Main loop
dimensions = Dimension[]
rituals    = Dimension[]
push!(dimensions, Dimension(1, length(lines), mainnamespace, "main"))
while length(dimensions) > 0
    global dimensions, rituals
    @sync begin
        for i in 1:length(dimensions)
            i > length(dimensions) && break
            if dimensions[i].current_line <= dimensions[i].endline
                @async dimension_forward!(dimensions[i])
            else
                deleteat!(dimensions, i)
            end
        end
        for i in 1:length(rituals)
            i > length(rituals) && break
            if rituals[i].current_line <= rituals[i].endline
                @async dimension_forward!(rituals[i])
            else
                rituals[i].current_line = rituals[i].startline
            end
        end
    end
end
