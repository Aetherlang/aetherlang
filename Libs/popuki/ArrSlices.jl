struct ArrSlice
    arr
    beg::Int
    fin::Int
end

# overload indexin to make `contains?` from base lib work
function Base.indexin(v, s::ArrSlice)::Vector{Union{Nothing, Int64}}
    i = indexin(v, s.arr)[1]
    (i == nothing || i < s.beg || i > s.fin) ? [nothing] : [i-s.beg+1]
end
# overload length to make `len` from base lib work
Base.length(s::ArrSlice)::Int = s.fin-s.beg+1
# getindex
function Base.getindex(s::ArrSlice, indx::Int)
    i::Int = indx+s.beg-1
    i > s.fin && throw(AetherlangError("Array index $i out of range"))
    s.arr[i]
end

function aetherlang_show(io::IO, v::ArrSlice)
    print(io, "(popuki.arrslice "*join([aetherlang_repr(v[i]) for i in 1:length(v)], ' ')*")")
end
