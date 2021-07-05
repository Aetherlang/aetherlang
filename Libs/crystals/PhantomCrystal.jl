# unused file

struct CrystalsPhantomCrystal{T}
    data::Set{T}
    rm::Set{T}
    add::Set{T}
end
function Base.show(io::IO, cr::CrystalsPhantomCrystal{T}) where T
    s::Set{T} = union(setdiff(cr.data, cr.rm), cr.add)
    print(io, "crystals.phantomcrystal: ")
    for x in s
        print(io, repr(x)*' ')
    end
end
