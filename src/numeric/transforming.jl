
"""
    transformLog(data::T, base::Real = ℯ) where T <: AbstractArray{<: Number}

Log transform `data` using log-base, `base`.

# Examples:

```@repl
data = [0:5;];
transformLog(data)
transformLog(data,2)
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

```@repl
data = [0:5;];
transformRoot(data)
transformRoot(data,2)
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

```@repl
data = [0:5;];
transformBoxCox(data)
transformBoxCox(data,.1)
transformBoxCox(data,1)
```

See also: [`transformLog`](@ref), [`transformRoot`](@ref)
"""
function transformBoxCox(data::T, λ::Real = 0.0) where T <: AbstractArray{<: Number}
    λ == 0 ? log.(data) : (data .^ λ .- 1) ./ λ 
end


