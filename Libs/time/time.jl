time_namespace_modify = Namespace(
    "time" => AetherlangObject((line::Ref{UInt}, ns::Namespace, dummy::AetherlangObject)->AetherlangObject(time()))
)
