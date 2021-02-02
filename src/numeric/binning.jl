
import Statistics
import Parameters.@with_kw

##### BinFixedWidth #####

"""
"""
@with_kw mutable struct BinFixedWidth
    n_bins::Integer = 10; @assert n_bins > 0
    data_min::Union{Float64,Missing} = missing
    data_span::Union{Float64,Missing} = missing
    bin_width::Union{Float64,Missing} = missing
    is_fit::Bool = false
end

"""
"""
function fit_transform!(bin::BinFixedWidth, data::AbstractArray{<:Real})
    bin.data_min = minimum(data)
    bin.data_span = maximum(data) - bin.data_min
    bin.bin_width = bin.data_span / bin.n_bins
    bin.is_fit = true
    bin
end

"""
"""
function apply_transform(bin::BinFixedWidth, data::AbstractArray{<:Real})
    if !bin.is_fit | bin.data_min === missing | \
        bin.data_span === missing | bin.bin_width === missing
        error("`bin` hasn't been fit.")
    end
    ceil.(Int,(data .- bin.data_min) ./ bin.bin_width)
end


##### BinQuantile #####

"""
"""
@with_kw mutable struct BinQuantile
    n_bins::Integer = 10; @assert n_bins > 0
    quantiles::Union{Array{Float64},Missing} = missing
    is_fit::Bool = false
end

"""
"""
function fit_transform!(bin::BinQuantile, data::AbstractArray{<:Real})
    bin.quantiles = Statistics.quantile(
        data,
        0:( 1 / (n_bins-1) ):1
    )
    bin.is_fit = true
    bin
end

"""
"""
function apply_transform(bin::BinQuantile, data::AbstractArray{<:Real})
    if !bin.is_fit | bin.quantiles === missing
        error("`bin` hasn't been fit.")
    end
    [findlast(q -> n < q, bin.quantiles) for n = data]
end


