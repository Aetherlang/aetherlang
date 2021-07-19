function random_сsrand(line::Ref{UInt}, ns::Namespace, seed::AetherlangObject)::AetherlangObject{AetherlangVoid}
    ccall(:srand, Cvoid, (Int32,), seed.dataref)
    AetherlangObject()
end

function AE_choose(line::Ref{UInt}, ns::Namespace, arr::AetherlangObject)::AetherlangObject
    AetherlangObject(arr.dataref[rand(1:length(arr.dataref))])
end

function AE_shuffled(line::Ref{UInt}, ns::Namespace, arr::AetherlangObject)::AetherlangObject
    a = [arr.dataref[i] for i in 1:length(arr.dataref)]
    for i in 1:length(a)
        q::Int = rand(1:length(a))
        a[i], a[q] = a[q], a[i]
    end
    AetherlangObject(a)
end

random_namespace_modify = Namespace(
    "c.srand" => AetherlangObject(random_сsrand),
    "c.rand" => AetherlangObject((line::Ref{UInt}, ns::Namespace, dummy::AetherlangObject)->AetherlangObject(ccall(:rand, Int32, ()))),
    "choose" => AetherlangObject(AE_choose),
    "shuffled" => AetherlangObject(AE_shuffled)
)
