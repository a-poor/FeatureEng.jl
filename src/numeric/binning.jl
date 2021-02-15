
abstract type AbstractBin end

##### BinFixedWidth #####

"""
    BinFixedWidth <: AbstractBin

Bin continuous data into `n_bins` discrete bins -- each with
equal widths. Read more [here](https://en.wikipedia.org/wiki/Data_binning).

See also: [`BinQuantile`](@ref)
"""
@with_kw mutable struct BinFixedWidth <: AbstractBin
    n_bins::Integer = 10; @assert n_bins > 0
    data_min::Union{Float64,Missing} = missing
    data_span::Union{Float64,Missing} = missing
    bin_width::Union{Float64,Missing} = missing
    is_fit::Bool = false
end

"""
    fit_transform!(bin::BinFixedWidth, data::T) where T <: AbstractArray{<:Number}

Fit a `BinFixedWidth` object to `data`.

See also: [`BinFixedWidth`](@ref)
"""
function fit_transform!(bin::BinFixedWidth, data::T) where T <: AbstractArray{<:Number}
    bin.data_min = minimum(data)
    bin.data_span = maximum(data) - bin.data_min
    bin.is_fit = true
    bin
end

"""
    apply_transform(bin::BinFixedWidth, data::T) where T <: AbstractArray{<:Number}

Bin `data` using a fit `BinFixedWidth` object.

See also: [`BinFixedWidth`](@ref)
"""
function apply_transform(bin::BinFixedWidth, data::T) where T <: AbstractArray{<:Number}
    if (
        !bin.is_fit | 
        (bin.data_min === missing) |
        (bin.data_span === missing) | 
        (bin.bin_width === missing)
    )
        error("`bin` hasn't been fit.")
    end
    rescaled = (data .- bin.data_min) ./ bin.data_span .* (1-1e-10)
    floor.(Int, rescaled ./ (1 / bin.n_bins))
end


##### BinQuantile #####

"""
    BinQuantile <: AbstractBin

Bin continuous data into `n_bins` discrete bins -- using the training
data's quantiles. Read more [here](https://en.wikipedia.org/wiki/Data_binning).

See also: [`BinFixedWidth`](@ref)
"""
@with_kw mutable struct BinQuantile <: AbstractBin
    n_bins::Integer = 10; @assert n_bins > 0
    quantiles::Union{Array{Float64},Missing} = missing
    is_fit::Bool = false
end

"""
    fit_transform!(bin::BinQuantile, data::T) where T <: AbstractArray{<:Number}

Fit a `BinQuantile` object to `data`.

See also: [`BinQuantile`](@ref)
"""
function fit_transform!(bin::BinQuantile, data::T) where T <: AbstractArray{<:Number}
    bin.quantiles = quantile(
        data,
        0:( 1 / (n_bins-1) ):1
    )
    bin.is_fit = true
    bin
end

"""
    apply_transform(bin::BinQuantile, data::T) where T <: AbstractArray{<:Number}

Bin `data` using a fit `BinQuantile` object.

See also: [`BinQuantile`](@ref)
"""
function apply_transform(bin::BinQuantile, data::T) where T <: AbstractArray{<:Number}
    if !bin.is_fit | (bin.quantiles === missing)
        error("`bin` hasn't been fit.")
    end
    [findlast(q -> n < q, bin.quantiles) for n = data]
end


