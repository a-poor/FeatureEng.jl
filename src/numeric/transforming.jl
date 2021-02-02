
"""
    transformLog(data::T, base::Real = ℯ) where T <: AbstractArray{<: Number}

Log transform `data` using log-base, `base`.

# Examples:

```julia-repl
julia> data = [0:5;];

julia> transformLog(data)
6-element Array{Float64,1}:
 -Inf
   0.0
   0.6931471805599453
   1.0986122886681098
   1.3862943611198906
   1.6094379124341003

julia> transformLog(data,2)
6-element Array{Float64,1}:
 -Inf
   0.0
   1.0
   1.5849625007211563
   2.0
   2.321928094887362

```

See also: [`transformRoot`](@ref), [`transformBoxCox`](@ref)
"""
function transformLog(data::T, base::Real = ℯ) where T <: AbstractArray{<: Number}
    log.(base,data)
end

"""
    transformRoot(data::T, index::Real = 10) where T <: AbstractArray{<: Number}

Root transform `data` using root index, `index`.

# Examples:

```julia-repl
julia> data = [0:5;];

julia> transformRoot(data)
6-element Array{Float64,1}:
 0.0
 1.0
 1.0717734625362931
 1.1161231740339044
 1.148698354997035
 1.174618943088019

julia> transformRoot(data,2)
6-element Array{Float64,1}:
 0.0
 1.0
 1.4142135623730951
 1.7320508075688772
 2.0
 2.23606797749979
```

See also: [`transformLog`](@ref), [`transformBoxCox`](@ref)
"""
function transformRoot(data::T, index::Real = 10) where T <: AbstractArray{<: Number}
    data .^ (1/index)
end

"""
    transformBoxCox(data::T, λ::Real = 0.0) where T <: AbstractArray{<: Number}

[Box-Cox power transformation](https://en.wikipedia.org/wiki/Power_transform#Box%E2%80%93Cox_transformation)
following the following function:

```math
y_i^{(\\lambda)} = \\left\\{\\begin{matrix}
\\frac{y_i^\\lambda - 1}{\\lambda} & \\mathrm{if} \\lambda \\neq  0, \\\\ 
\\mathrm{ln} y_i & \\mathrm{if} \\lambda = 0, 
\\end{matrix}\\right.
```

# Examples:

```julia-repl
julia> data = [0:5;];

julia> transformBoxCox(data)
6-element Array{Float64,1}:
 -Inf
   0.0
   0.6931471805599453
   1.0986122886681098
   1.3862943611198906
   1.6094379124341003

julia> transformBoxCox(data,.1)
6-element Array{Float64,1}:
 -10.0
   0.0
   0.7177346253629313
   1.1612317403390437
   1.486983549970351
   1.7461894308801895

julia> transformBoxCox(data,1)
6-element Array{Float64,1}:
 -1.0
  0.0
  1.0
  2.0
  3.0
  4.0
```

See also: [`transformLog`](@ref), [`transformRoot`](@ref)
"""
function transformBoxCox(data::T, λ::Real = 0.0) where T <: AbstractArray{<: Number}
    λ == 0 ? log.(data) : (data .^ λ .- 1) ./ λ 
end


