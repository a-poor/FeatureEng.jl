
import Statistics
import Parameters.@with_kw

##### BinFixedWidth #####

@with_kw mutable struct BinFixedWidth
    n_bins::Integer = 10; @assert n_bins > 0
    data_min::Union{Float64,Missing} = missing
    data_span::Union{Float64,Missing} = missing
    bin_width::Union{Float64,Missing} = missing
    is_fit::Bool = false
end

function fit!(bin::BinFixedWidth, data::AbstractArray{<:Real})
    bin.data_min = minimum(data)
    bin.data_span = maximum(data) - bin.data_min
    bin.bin_width = bin.data_span / bin.n_bins
    bin.is_fit = true
    bin
end

function transform(bin::BinFixedWidth, data::AbstractArray{<:Real})
    if !bin.is_fit | bin.data_min === missing | \
        bin.data_span === missing | bin.bin_width === missing
        error("`bin` hasn't been fit.")
    end
    ceil.(Int,(data .- bin.data_min) ./ bin.bin_width)
end

##### BinExponential #####

@with_kw mutable struct BinExponential
end

function fit!(bin::BinExponential, data::AbstractArray{<:Real})
    
    bin.is_fit = true
    bin
end

function transform(bin::BinExponential, data::AbstractArray{<:Real})
    if !bin.is_fit
        error("`bin` hasn't been fit.")
    end
    [findlast(q -> n < q, bin.quantiles) for n = data]
end

##### BinQuantile #####

@with_kw mutable struct BinQuantile
    n_bins::Integer = 10; @assert n_bins > 0
    quantiles::Union{Array{Float64},Missing} = missing
    is_fit::Bool = false

    BinQuantile(n_bins,quantiles,is_fit) = (
        n_bins > 1 ? 
        new(n_bins,quantiles,is_fit) : 
        throw(DomainError(n_bins,"n_bins must be > 1"))
    )
end

function fit!(bin::BinQuantile, data::AbstractArray{<:Real})
    bin.quantiles = Statistics.quantile(
        data,
        0:( 1 / (n_bins-1) ):1
    )
    bin.is_fit = true
    bin
end

function transform(bin::BinQuantile, data::AbstractArray{<:Real})
    if !bin.is_fit | bin.quantiles === missing
        error("`bin` hasn't been fit.")
    end
    [findlast(q -> n < q, bin.quantiles) for n = data]
end

