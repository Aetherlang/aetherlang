# probably should be rewritten in a more fuctional way

const FILE_TYPE = "fio.file"

function AE_open(line::Ref{UInt}, ns::Namespace, filename::AetherlangObject{String}, mode::AetherlangObject{String})::AetherlangObject
    try
        AetherlangObject{IO}(open(dirname(ARGS[1])*"/"*filename.dataref, mode.dataref), Ref(FILE_TYPE))
    catch
        throw(AetherlangError("Error when opening the file $(filename.dataref) for $(mode.dataref)"))
    end
end

function AE_close(line::Ref{UInt}, ns::Namespace, file::AetherlangObject)::AetherlangObject
    close(file.dataref)
    AetherlangObject()
end

function AE_fprint(line::Ref{UInt}, ns::Namespace, file::AetherlangObject, args...)::AetherlangObject
    try
        for i in 1:length(args)-1
            write(file.dataref, string(args[i])*' ')
        end
        write(file.dataref, string(args[end]))
        AetherlangObject()
    catch
        throw(AetherlangError("Error when writing to file"))
    end
end
function AE_fprintln(line::Ref{UInt}, ns::Namespace, file::AetherlangObject, args...)::AetherlangObject
    try
        for i in 1:length(args)-1
            write(file.dataref, string(args[i])*' ')
        end
        write(file.dataref, string(args[end])*'\n')
        AetherlangObject()
    catch
        throw(AetherlangError("Error when writing to file"))
    end
end
function AE_finput(line::Ref{UInt}, ns::Namespace, file::AetherlangObject)::AetherlangObject
    AetherlangObject(readline(file.dataref))
end

fio_namespace_modify = Namespace(
    "open" => AetherlangObject(AE_open),
    "close" => AetherlangObject(AE_close),
    "fprintln" => AetherlangObject(AE_fprintln),
    "fprint" => AetherlangObject(AE_fprint),
    "finput" => AetherlangObject(AE_finput)
)
