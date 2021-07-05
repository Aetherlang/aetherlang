function aetherlang_eval!(tokens::Vector{Token}, namespace::Namespace, line::Ref{UInt})::AetherlangObject
    """Evaluates a line of code (as tokens), returns the result as AetherlangObject{T}"""
    # one token evaluation
    if length(tokens) == 1
        if typeof(tokens[1]) != String
            return tokens[1]
        end
        token::String = tokens[1]
        # ritual/endrit evaluation
        if token == "ritual"
            ritname::String = "rit#"*string(line[])
            endrit::UInt = line[]
            while !("endrit" == lines[endrit][1])
                endrit += 1
                if (endrit > length(lines))
                    throw(AetherlangError("Line `endrit` not found"))
                end
            end
            push!(rituals, Dimension(line[]+1, UInt(endrit-1), setindex!(copy(namespace), AetherlangObject(ritname), "ritname"), ritname))
            line[] = endrit
        elseif token[1] == '(' && token[end] == ')'
            # if one token and parentheses, remove them and re-eval
            return aetherlang_eval!(token[2:end-1], namespace, line)
        elseif token[1] == ':'
            return AetherlangObject(token[2:end], true)
        elseif token[1] == '\"' || isdigit(token[1]) || (token[1] == '-' && length(token)>1 && isdigit(token[2]))
            # try evaluating as a literal
            return AetherlangObject(eval(Meta.parse(token)))
        else
            # get from the namespace
            try
                return length(token)>7&&"aether."==token[1:7] ? ether[token[8:end]] : namespace[token]
            catch
                throw(AetherlangError("Name `$token` is not defined"))
            end
        end
    # A = X expression evaluation
    elseif tokens[2] == "="
        o::AetherlangObject = AetherlangObject()
        if length(tokens[1])>7&&"aether."==tokens[1][1:7]
            # aether.NAME = EXP
            o = ether[tokens[1][8:end]] = aetherlang_eval!(tokens[3:end], namespace, line)
            if o.type[] == AETH_BUILTIN_TYPES.timepoint
                throw(AetherlangError("Definition of timepoints in aether is forbidden"))
            end
        else
            # NAME = EXP
            if haskey(namespace, tokens[1])
                throw(AetherlangError("Trying to redefine a local dimensional constant `$(tokens[1])` of type "*namespace[tokens[1]].type[]))
            end
            o = namespace[tokens[1]] = aetherlang_eval!(tokens[3:end], namespace, line)
        end
        return o
    # dim X/enddim X evaluation
    elseif length(tokens) == 2 && tokens[1] == "dim"
        enddim::UInt = line[]
        while !("enddim" == lines[enddim][1] && tokens[2] == lines[enddim][2])
            enddim += 1
            if (enddim > length(lines))
                throw(AetherlangError("Line `enddim $(tokens[2])` not found"))
            end
        end
        push!(dimensions, Dimension(line[]+1, UInt(enddim-1), setindex!(copy(namespace), AetherlangObject(tokens[2]), "dimname"), tokens[2]))
        line[] = enddim
    # declaring a function
    elseif tokens[1] == "function"
        # try
        fname::String = tokens[2]
        eqsign::UInt = findfirst(t->t=="=", tokens)
        body::Vector{Union{String, AetherlangObject}} = Union{String, AetherlangObject}[]
        for t in tokens[eqsign+1:end]
            try
                push!(body, aetherlang_eval!(t, namespace, Ref{UInt}(0)))
            catch
                push!(body, t)
            end
        end
        f::AetherlangObject = AetherlangObject(AetherlangFunction(tokens[3:eqsign-1], body))
        if length(fname)>7&&"aether."==fname[1:7]
            ether[fname[8:end]] = f
        else
            if haskey(namespace, fname)
                throw(AetherlangError("Trying to redefine a local dimensional constant `$fname` of type "*namespace[tokens[1]].type[]))
            end
            namespace[fname] = f
        end
        return f
    # calling a function evaluation
    else
        callable::AetherlangObject = aetherlang_eval!(tokens[1], namespace, line)
        if callable.type[] != AETH_BUILTIN_TYPES.callable
            throw(AetherlangError("Object `$(tokens[1])` is not of type callable"))
        end
        return aetherlang_call(callable.dataref, namespace, Vector{AetherlangObject}([aetherlang_eval!(t, namespace, line) for t in tokens[2:end]]), line)
    end
    AetherlangObject()
end

function aetherlang_eval!(token::AetherlangObject, namespace::Namespace, line::Ref{UInt})::AetherlangObject
    """Evaluates an existing token, returns the same AetherlangObject as given"""
    token
end

function aetherlang_eval!(code::Vector{String}, namespace::Namespace, line::Ref{UInt})::AetherlangObject
    """Evaluates a line of code as string tokens, returns the result as AetherlangObject{T}"""
    aetherlang_eval!(Token[code...], namespace, line)
end

function aetherlang_eval!(code::String, namespace::Namespace, line::Ref{UInt})::AetherlangObject
    """Evaluates a line of code, returns the result as AetherlangObject{T}"""
    aetherlang_eval!(aetherlang_tokenize(code), namespace, line)
end
