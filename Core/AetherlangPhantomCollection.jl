# the structure is mutable for the sake of optimization and internal needs. don't mutate your phantoms
mutable struct AetherlangPhantomCollection{T}
    """A phantom structure for basic collections"""
    ref::T
    addindx::Dict{Integer, Any}
    length::Int64
end

function Base.getindex(p::AetherlangPhantomCollection, idx::Integer)
    try
        return p.addindx[idx]
    catch
        return p.ref[idx]
    end
end

Base.length(p::AetherlangPhantomCollection) = p.length

Base.copy(p::AetherlangPhantomCollection) = AetherlangPhantomCollection(p.ref, copy(p.addindx), p.length)

function aetherlang_show(io::IO, v::AetherlangPhantomCollection)
    print(io, "(phantomarray "*join([aetherlang_repr(v[i]) for i in 1:length(v)], ' ')*")")
end
