math_namespace_modify = Namespace(
    "sin" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)->AetherlangObject(sin(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "cos" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)->AetherlangObject(cos(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "tan" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)->AetherlangObject(tan(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "cot" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)->AetherlangObject(cot(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "mean" => AetherlangObject((line::Ref{UInt}, ns::Namespace, args...)->AetherlangObject(sum([arg.dataref for arg in args])/length(args)), Ref(AETH_BUILTIN_TYPES.callable)),
    "pow" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)->AetherlangObject(arg1.dataref^arg2.dataref), Ref(AETH_BUILTIN_TYPES.callable)),
    "sqrt" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject)->AetherlangObject(sqrt(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "div" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)->AetherlangObject(arg1.dataref//arg2.dataref), Ref(AETH_BUILTIN_TYPES.callable)),
    "mod" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)->AetherlangObject(arg1.dataref%arg2.dataref), Ref(AETH_BUILTIN_TYPES.callable)),
    "pi" => AetherlangObject(pi),
    "eul" => AetherlangObject(exp(1)),
    "exp" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)->AetherlangObject(exp(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "ln" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)->AetherlangObject(log(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "log" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg1::AetherlangObject, arg2::AetherlangObject)->AetherlangObject(log(arg1.dataref, arg2.dataref)), Ref(AETH_BUILTIN_TYPES.callable)),
    "lg" => AetherlangObject((line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)->AetherlangObject(log10(arg.dataref)), Ref(AETH_BUILTIN_TYPES.callable))
)
math_namespace_modify["%"] = math_namespace_modify["mod"]
