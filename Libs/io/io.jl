## io library
function io_print(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    print(join([string(arg) for arg in args], ' '))
    AetherlangObject()
end

function io_println(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    io_print(line, ns, args..., '\n')
    AetherlangObject()
end

function io_input(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject
    print(arg.dataref)
    AetherlangObject(readline())
end

function io_intinput(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject
    print(arg.dataref)
    AetherlangObject(parse(Int, readline()))
end

function io_floatinput(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject
    print(arg.dataref)
    AetherlangObject(parse(Float64, readline()))
end

function io_autoinput(line::Ref{UInt}, ns::Namespace, arg::AetherlangObject)::AetherlangObject
    print(arg.dataref)
    s::String = readline()
    try
        return AetherlangObject(parse(Int, s))
    catch
        try
            return AetherlangObject(parse(Float64, s))
        catch
            return AetherlangObject(s)
        end
    end
    AetherlangObject()
end

io_namespace_modify = Namespace(
    "print" => AetherlangObject(io_print),
    "println" => AetherlangObject(io_println),
    "input" => AetherlangObject(io_input),
    "intinput" => AetherlangObject(io_intinput),
    "floatinput" => AetherlangObject(io_floatinput),
    "autoinput" => AetherlangObject(io_autoinput)
)
