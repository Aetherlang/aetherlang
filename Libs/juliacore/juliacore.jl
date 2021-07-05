juliacore_typeof(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject = AetherlangObject(string(typeof(arg.dataref)))
juliacore_eval(line::Ref{UInt}, ns::Namespace, exp::AetherlangObject)::AetherlangObject = AetherlangObject(eval(Meta.parse(exp.dataref)))

juliacore_namespace_modify = Namespace(
    "typeof" => AetherlangObject(juliacore_typeof),
    "eval" => AetherlangObject(juliacore_eval)
)
