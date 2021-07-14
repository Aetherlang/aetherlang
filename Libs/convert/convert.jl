convert_string(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject{String} = AetherlangObject(string(arg.dataref))
convert_str2num(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{String})::AetherlangObject{Float64} = AetherlangObject(parse(Float64, arg.dataref))
convert_str2sym(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{String})::AetherlangObject{String} = AetherlangObject(arg.dataref, true)
convert_num2int(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{F}where F<:AbstractFloat)::AetherlangObject{I}where I<:Integer = AetherlangObject(Int(trunc(arg.dataref)))

convert_namespace_modify = Namespace(
    "num2int" => AetherlangObject(convert_num2int),
    "string" => AetherlangObject(convert_string),
    "str2num" => AetherlangObject(convert_str2num),
    "str2sym" => AetherlangObject(convert_str2sym)
)
