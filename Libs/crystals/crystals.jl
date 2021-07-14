include("Crystal.jl")
include("PhantomCrystal.jl")
const CRYSTAL_TYPE = "crystals.crystal"
const PHANTOMCRYSTAL_TYPE = "crystals.phantomcrystal"
AetherlangObject(c::CrystalsCrystal) = AetherlangObject{CrystalsCrystal}(c, Ref(CRYSTAL_TYPE))

AE_crystal(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject = AetherlangObject(CrystalsCrystal(Set([arg.dataref for arg in args])))
function AE_add(line::Ref{UInt}, ns::Namespace, crs::AetherlangObject{CrystalsCrystal}, x::AetherlangObject)::AetherlangObject
    T::Type = Union{typeof(x.dataref), crystaltype(typeof(crs.dataref))}
    AetherlangObject(CrystalsCrystal(Set(T[crs.dataref.data..., x.dataref])))
end
function AE_remove(line::Ref{UInt}, ns::Namespace, crs::AetherlangObject{CrystalsCrystal}, x::AetherlangObject)::AetherlangObject
    AetherlangObject(CrystalsCrystal(Set([e for e in crs.dataref.data if e != x.dataref])))
end

crystals_namespace_modify = Namespace(
    "crystal" => AetherlangObject(AE_crystal),
    "add" => AetherlangObject(AE_add),
    "remove" => AetherlangObject(AE_remove)
)
