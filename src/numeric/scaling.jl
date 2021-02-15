
abstract type AbstractScale end

"""
    ScaleMinMax <: AbstractScale

Scales the input data using minimum and maximum values. 
Aka [rescaling](https://en.wikipedia.org/wiki/Feature_scaling#Rescaling_(min-max_normalization)).

See also: [`ScaleVariance`](@ref), [`ScaleL2`](@ref)
"""
@with_kw mutable struct ScaleMinMax <: AbstractScale
    data_min::Float64 = 0.0
    data_max::Float64 = 1.0
    is_fit::Bool = false
end

"""
    fit_transform!(scale::ScaleMinMax, data::T) where T <: AbstractArray{<:Number}

Fit a `ScaleMinMax` object to `data`.
"""
function fit_transform!(scale::ScaleMinMax, data::T) where T <: AbstractArray{<:Number}
    scale.data_min = minimum(Float64,data)
    scale.data_max = maximum(Float64,data)
    scale.is_fit = true
    scale
end

"""
    apply_transform(scale::ScaleMinMax, data::T) where T <: AbstractArray{<:Number}

Scale `data` using a fit `ScaleMinMax` object.
"""
function apply_transform(scale::ScaleMinMax, data::T) where T <: AbstractArray{<:Number}
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    span = scale.data_max - scale.data_min
    (data .- scale.data_min) ./ span
end

"""
    ScaleVariance  <: AbstractScale

Scale the input data using 
[standardization](https://en.wikipedia.org/wiki/Feature_scaling#Standardization_(Z-score_Normalization)).
"""
@with_kw mutable struct ScaleVariance  <: AbstractScale
    data_mean::Float64 = 0.0
    data_std::Float64 = 1.0
    is_fit::Bool = false
end

"""
    fit_transform!(scale::ScaleVariance, data::T) where T <: AbstractArray{<:Number}

Fit a `ScaleVariance` object to `data`.
"""
function fit_transform!(scale::ScaleVariance, data::T) where T <: AbstractArray{<:Number}
    scale.data_mean = mean(data)
    scale.data_std = std(data)
    scale.is_fit = true
    scale
end

"""
    apply_transform(scale::ScaleVariance, data::T) where T <: AbstractArray{<:Number}

Scale `data` using a fit `ScaleVariance` object.
"""
function apply_transform(scale::ScaleVariance, data::T) where T <: AbstractArray{<:Number}
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    (data .- scale.data_mean) ./ scale.data_std
end

"""
    ScaleL2 <: AbstractScale

Scales the input data using the data's norm. 
Aka [scaling to unit length](https://en.wikipedia.org/wiki/Feature_scaling#Scaling_to_unit_length).
"""
@with_kw mutable struct ScaleL2 <: AbstractScale
    data_norm::Float64 = 1.0
    is_fit::Bool = false
end

"""
    fit_transform!(scale::ScaleL2, data::T) where T <: AbstractArray{<:Number}

Fit a `ScaleL2` object to `data`.
"""
function fit_transform!(scale::ScaleL2, data::T) where T <: AbstractArray{<:Number}
    scale.data_norm = norm(data)
    scale.is_fit = true
    scale
end

"""
    apply_transform(scale::ScaleL2, data::T) where T <: AbstractArray{<:Number}

Scale `data` using a fit `ScaleL2` object.
"""
function apply_transform(scale::ScaleL2, data::T) where T <: AbstractArray{<:Number}
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    data ./ scale.data_norm
end

