
abstract type AbstractImpute end

"""
    ImputeMedian <: AbstractImpute

[Impute](https://en.wikipedia.org/wiki/Imputation_(statistics)) missing data 
using the median value.
"""
@with_kw mutable struct ImputeMedian <: AbstractImpute
    data_median::Float64 = 0.0
    is_fit::Bool = false
end

"""
    fit_transform!(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Number}

Fit an `ImputeMedian` object to `data`.
"""
function fit_transform!(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Number}
    imp.data_median = median(skipmissing(data))
    imp.is_fit = true
    imp
end

"""
    apply_transform(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Number}

Imputes missing values in `data` using a fit `ImputeMedian` object.
"""
function apply_transform(imp::ImputeMedian, data::T) where T <: AbstractArray{<:Number}
    if !imp.is_fit
        error("`imp` must be fit first.")
    end
    collect(Missings.replace(data,imp.data_median))
end


"""
ImputeMean <: AbstractImpute

[Impute](https://en.wikipedia.org/wiki/Imputation_(statistics)) missing data 
using the mean value.
"""
@with_kw mutable struct ImputeMean <: AbstractImpute
    data_mean::Float64 = 0.0
    is_fit::Bool = false
end

"""
    fit_transform!(imp::ImputeMean, data::T) where T <: AbstractArray{<:Number}

Fit an `ImputeMean` object to `data`.
"""
function fit_transform!(imp::ImputeMean, data::T) where T <: AbstractArray{<:Number}
    imp.data_mean = mean(skipmissing(data))
    imp.is_fit = true
    imp
end

"""
    apply_transform(imp::ImputeMean, data::T) where T <: AbstractArray{<:Number}

Imputes missing values in `data` using a fit `ImputeMean` object.
"""
function apply_transform(imp::ImputeMean, data::T) where T <: AbstractArray{<:Number}
    if !imp.is_fit
        error("`imp` must be fit first.")
    end
    collect(Missings.replace(data,imp.data_mean))
end


