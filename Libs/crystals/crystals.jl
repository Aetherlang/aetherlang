include("Crystal.jl")
const CRYSTAL_TYPE = "crystals.crystal"
AetherlangObject(c::CrystalsCrystal) = AetherlangObject{CrystalsCrystal}(c, Ref(CRYSTAL_TYPE))

crystals_crystal(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject = AetherlangObject(CrystalsCrystal(Set([arg.dataref for arg in args])))
function crystals_add(line::Ref{UInt}, ns::Namespace, crs::AetherlangObject{CrystalsCrystal}, x::AetherlangObject)::AetherlangObject
    T::Type = Union{typeof(x.dataref), crystaltype(typeof(crs.dataref))}
    AetherlangObject(CrystalsCrystal(Set(T[crs.dataref.data..., x.dataref])))
end
function crystals_remove(line::Ref{UInt}, ns::Namespace, crs::AetherlangObject{CrystalsCrystal}, x::AetherlangObject)::AetherlangObject
    AetherlangObject(CrystalsCrystal(Set([e for e in crs.dataref.data if e != x.dataref])))
end

crystals_namespace_modify = Namespace(
    "crystal" => AetherlangObject(crystals_crystal),
    "add" => AetherlangObject(crystals_add),
    "remove" => AetherlangObject(crystals_remove)
)
