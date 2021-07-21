function aetherlang_show(io::IO, v::Vector)
    print(io, "(arr "*join([string(x) for x in v], ' ')*")")
end
