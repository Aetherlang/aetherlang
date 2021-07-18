mutable struct ManifoldsManifold
    vars::Vector{String}
    exp::Vector{Token} # replace with a vector of unified tokens/values when inline eval is ready
end

function Base.show(io::IO, m::ManifoldsManifold)
    print(io, "(manifolds.manifold of "*join(m.vars, ' ')*")")
end
