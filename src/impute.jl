
abstract type AbstractImpute end

"""
    ImputeMedian <: AbstractImpute

[Impute](https://en.wikipedia.org/wiki/Imputation_(statistics)) missing data 
using the median value.

# Examples:

```julia-repl
julia> data = [1,2,3,4,missing,5];
julia> imp = fit_transform!(ImputeMedian(),data)
ImputeMedian
  data_median: Float64 3.0
  is_fit: Bool true
julia> apply_transform(imp,data)
6-element Array{Int64,1}:
  1
  2
  3
  4
  3
  5  
```

See also: [`ImputeMean`](@ref)
"""
@with_kw mutable struct ImputeMedian <: AbstractImpute
    data_median::Float64 = 0.0
    is_fit::Bool = false
end

"""
    fit_transform!(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Number}

Fit an `ImputeMedian` object to `data`.

See also: [`ImputeMedian`](@ref)
"""
function fit_transform!(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Union{Missing,<:Number}}
    imp.data_median = median(skipmissing(data))
    imp.is_fit = true
    imp
end

"""
    apply_transform(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Number}

Imputes missing values in `data` using a fit `ImputeMedian` object.

See also: [`ImputeMedian`](@ref)
"""
function apply_transform(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Union{Missing,<:Number}}
    if !imp.is_fit
        error("`imp` must be fit first.")
    end
    collect(Missings.replace(data,imp.data_median))
end


"""
    ImputeMean <: AbstractImpute

[Impute](https://en.wikipedia.org/wiki/Imputation_(statistics)) missing data 
using the mean value.

See also: [`ImputeMean`](@ref)
"""
@with_kw mutable struct ImputeMean <: AbstractImpute
    data_mean::Float64 = 0.0
    is_fit::Bool = false
end

"""
    fit_transform!(imp::ImputeMean, data::T) where T <: AbstractArray{<:Number}

Fit an `ImputeMean` object to `data`.

See also: [`ImputeMean`](@ref)
"""
function fit_transform!(imp::ImputeMean, data::T) where T <: AbstractArray{<:Union{Missing,<:Number}}
    imp.data_mean = mean(skipmissing(data))
    imp.is_fit = true
    imp
end

"""
    apply_transform(imp::ImputeMean, data::T) where T <: AbstractArray{<:Number}

Imputes missing values in `data` using a fit `ImputeMean` object.

See also: [`ImputeMean`](@ref)
"""
function apply_transform(imp::ImputeMean, data::T) where T <: AbstractArray{<:Union{Missing,<:Number}}
    if !imp.is_fit
        error("`imp` must be fit first.")
    end
    collect(Missings.replace(data,imp.data_mean))
end


