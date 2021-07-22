function aetherlang_repr(x)
    try
        return sprint(aetherlang_show, x)
    catch
        return repr(x)
    end
end
function Base.indexin(s1::String, s2::String)
    """returns positions of elements of s1 in s2."""
    indexin([c for c in s1], [c for c in s2])
end
function aetherlang_show(io::IO, c::Char)
    print(io, "\""*c*"\"")
end
