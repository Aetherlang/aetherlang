## io library
function io_print(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    for i in 1:length(args)-1
        print(args[i], " ")
    end
    print(args[end])
    AetherlangObject()
end

function io_println(line::Ref{UInt}, ns::Namespace, args...)::AetherlangObject
    for i in 1:length(args)-1
        print(args[i], " ")
    end
    println(args[end])
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

io_namespace_modify = Namespace(
    "print" => AetherlangObject(io_print),
    "println" => AetherlangObject(io_println),
    "input" => AetherlangObject(io_input),
    "intinput" => AetherlangObject(io_intinput),
    "floatinput" => AetherlangObject(io_floatinput)
)
