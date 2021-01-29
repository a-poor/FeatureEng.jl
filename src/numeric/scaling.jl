
import Parameters.@with_kw
import Statistics.mean
import Statistics.std
import Statistics.norm

@with_kw mutable struct ScaleMinMax
    data_min::Float64 = 0.0
    data_max::Float64 = 1.0
    is_fit::Bool = false
end

function fit!(scale::ScaleMinMax, data::AbstractArray{<:Real})
    scale.data_min = minimum(Float64,data)
    scale.data_max = maximum(Float64,data)
    scale.is_fit = true
    scale
end

function transform(scale::ScaleMinMax, data::AbstractArray{<:Real})
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    span = scale.data_max - scale.data_min
    (data .- scale.data_min) ./ span
end

@with_kw mutable struct ScaleVariance
    data_mean::Float64 = 0.0
    data_std::Float64 = 1.0
    is_fit::Bool = false
end

function fit!(scale::ScaleVariance, data::AbstractArray{<:Real})
    scale.data_mean = mean(data)
    scale.data_std = std(data)
    scale.is_fit = true
    scale
end

function transform(scale::ScaleVariance, data::AbstractArray{<:Real})
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    (data .- scale.data_mean) ./ scale.data_std
end

@with_kw mutable struct ScaleL2
    data_norm::Float64 = 1.0
    is_fit::Bool = false
end

function fit!(scale::ScaleL2, data::AbstractArray{<:Real})
    scale.data_norm = norm(data)
    scale.is_fit = true
    scale
end

function transform(scale::ScaleL2, data::AbstractArray{<:Real})
    if !scale.is_fit
        error("`scale` hasn't been fit")
    end
    data ./ scale.data_norm
end

