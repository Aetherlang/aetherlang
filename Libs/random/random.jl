function random_srand(line::Ref{UInt}, ns::Namespace, seed::AetherlangObject)::AetherlangObject{AetherlangVoid}
    ccall(:srand, Cvoid, (Int32,), seed.dataref)
    AetherlangObject()
end

random_namespace_modify = Namespace(
    "c.srand" => AetherlangObject(random_srand),
    "c.rand" => AetherlangObject((line::Ref{UInt}, ns::Namespace, dummy::AetherlangObject)->AetherlangObject(ccall(:rand, Int32, ())))
)
