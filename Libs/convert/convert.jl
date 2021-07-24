convert_string(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject{String} = AetherlangObject(string(arg))
convert_str2num(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{String})::AetherlangObject{Float64} = AetherlangObject(parse(Float64, arg.dataref))
convert_str2sym(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{String})::AetherlangObject{String} = AetherlangObject(arg.dataref, true)
convert_num2int(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{F}where F<:AbstractFloat)::AetherlangObject{I}where I<:Integer = AetherlangObject(Int(trunc(arg.dataref)))
function convert_char2int(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{String})::AetherlangObject
    if length(arg.dataref) > 1
        throw(AetherlangError("char2num can only operate on strings of length 1"))
    end
    AetherlangObject(Int(arg.dataref[1]))
end
function convert_int2char(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject{I}where I<:Integer)::AetherlangObject
    AetherlangObject(Char(arg.dataref))
end

convert_namespace_modify = Namespace(
    "num2int" => AetherlangObject(convert_num2int),
    "string" => AetherlangObject(convert_string),
    "str2num" => AetherlangObject(convert_str2num),
    "str2sym" => AetherlangObject(convert_str2sym),
    "char2int" => AetherlangObject(convert_char2int),
    "int2char" => AetherlangObject(convert_int2char)
)
