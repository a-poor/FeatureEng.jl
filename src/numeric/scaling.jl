
abstract type AbstractScale end

"""
ScaleMinMax <: AbstractScale
"""
@with_kw mutable struct ScaleMinMax <: AbstractScale
    data_min::Float64 = 0.0
    data_max::Float64 = 1.0
    is_fit::Bool = false
end

"""
"""
function fit_transform!(scale::ScaleMinMax, data::T) where T <: AbstractArray{<:Real}
    scale.data_min = minimum(Float64,data)
    scale.data_max = maximum(Float64,data)
    scale.is_fit = true
    scale
end

"""
"""
function apply_transform(scale::ScaleMinMax, data::T) where T <: AbstractArray{<:Real}
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    span = scale.data_max - scale.data_min
    (data .- scale.data_min) ./ span
end

"""
ScaleVariance  <: AbstractScale
"""
@with_kw mutable struct ScaleVariance  <: AbstractScale
    data_mean::Float64 = 0.0
    data_std::Float64 = 1.0
    is_fit::Bool = false
end

"""
"""
function fit_transform!(scale::ScaleVariance, data::T) where T <: AbstractArray{<:Real}
    scale.data_mean = mean(data)
    scale.data_std = std(data)
    scale.is_fit = true
    scale
end

"""
"""
function apply_transform(scale::ScaleVariance, data::T) where T <: AbstractArray{<:Real}
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    (data .- scale.data_mean) ./ scale.data_std
end

"""
ScaleL2 <: AbstractScale
"""
@with_kw mutable struct ScaleL2 <: AbstractScale
    data_norm::Float64 = 1.0
    is_fit::Bool = false
end

"""
"""
function fit_transform!(scale::ScaleL2, data::T) where T <: AbstractArray{<:Real}
    scale.data_norm = norm(data)
    scale.is_fit = true
    scale
end

"""
"""
function apply_transform(scale::ScaleL2, data::T) where T <: AbstractArray{<:Real}
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    data ./ scale.data_norm
end

