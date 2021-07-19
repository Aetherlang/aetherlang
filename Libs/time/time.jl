time_namespace_modify = Namespace(
    "time" => AetherlangObject((line::Ref{UInt}, ns::Namespace, dummy::AetherlangObject)->AetherlangObject(time())),
    "c.time" => AetherlangObject((line::Ref{UInt}, ns::Namespace, n::AetherlangObject)->AetherlangObject(ccall(:time, (UInt64), (Int,), n.dataref)))
)
