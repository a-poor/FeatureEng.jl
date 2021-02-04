"""
"""
module FeatureEng

using Dates
using DataFrames
using CategoricalArrays

import Parameters.@with_kw
import Statistics.mean
import Statistics.std
import Statistics.norm
import Statistics.quantile

include("numeric/binning.jl")
include("numeric/transforming.jl")
include("numeric/scaling.jl")
include("numeric/interactions.jl")
include("datetime.jl")
include("categorical.jl")


export 
# General
    fit_transform!, apply_transform, 

# Numeric -- Binning
    BinFixedWidth, BinExponential, BinQuantile,
# Numeric -- Scaling
    ScaleMinMax, ScaleVariance, ScaleL2,
# Numeric -- Transforming
    transformLog, transformRoot, transformBoxCox,
# Numeric -- Interaction terms
    polynomial, 

# Categorical
    encode_onehot, encode_dummy, encode_hash,

# Datetime
    strp_datetimes, extract_datetime_features, extract_date_features, extract_time_features,
    get_month, get_weekday


end # module
