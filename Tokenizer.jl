## A tool for tokenizing aetherlang expressions

function aetherlang_tokenize(code::String)::Vector{String}
    """Tokenizes an expression, returns Vector{String}. Also makes everything except strings lowercase."""
    tokens::Vector{String} = []
    p_count::UInt = 0     # opened parentheses count
    quotes::Bool = false  # whether '\"' was opened
    special::Bool = false # whether there was a '\\' found inside a string literal
    token::String = ""
    for c::Char in code
        if isspace(c) && p_count == 0 && !quotes
            if token != ""; push!(tokens, token); end
            token = ""
        else
            if c == '\"' && (!quotes || (quotes && !special))
                quotes = !quotes
            elseif c == '(' && !quotes
                p_count += 1
            elseif c == ')' && !quotes
                p_count -= 1
            end
            token *= quotes ? c : lowercase(c)
        end
        special = c == '\\' && quotes
    end
    if quotes || special || p_count != 0
        throw(AetherlangError("Missing closing character. Use '\\' when splitting a line into two:\n(F X X \\\n\tX X)"))
    end
    if token != ""
        push!(tokens, token)
    end
    tokens
end
