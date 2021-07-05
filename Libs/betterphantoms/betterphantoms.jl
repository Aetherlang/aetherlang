# phantomrestore index, phantomgetarray

function betterphantoms_phantomrestore(line::Ref{UInt}, ns::Namespace, ph::AetherlangObject{AetherlangPhantomCollection}, inx::AetherlangObject)::AetherlangObject
    if inx.dataref < 1 || inx.dataref > length(ph.dataref.ref)
        throw(AetherlangError("`phantomrestore` cannot restore index $(inx.dataref)"))
    end
    nph::AetherlangPhantomCollection = copy(ph.dataref)
    try
        pop!(nph.addindx, inx.dataref)
    catch
    end
    AetherlangObject(nph)
end

function betterphantoms_phantomrestore(line::Ref{UInt}, ns::Namespace, ph::AetherlangObject{AetherlangPhantomCollection})::AetherlangObject
    AetherlangObject(ph.dataref.ref)
end

betterphantoms_namespace_modify = Namespace(
    "phantomrestore" => AetherlangObject(betterphantoms_phantomrestore)
)
