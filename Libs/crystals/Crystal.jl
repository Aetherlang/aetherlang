struct CrystalsCrystal{T}
    data::Set{T}
end
function Base.show(io::IO, cr::CrystalsCrystal)
    print(io, "(crystals.crystal "*join([aetherlang_repr(x) for x in cr.data], ' ')*")")
end

# overload indexin to make `contains?` from base lib work
Base.indexin(v, cr::CrystalsCrystal)::Vector{Union{Nothing, Int64}} = v in cr.data ? [1] : [nothing]
# overload length to make `len` from base lib work
Base.length(cr::CrystalsCrystal)::Int = length(cr.data)

crystaltype(::Type{CrystalsCrystal{T}}) where {T} = T
