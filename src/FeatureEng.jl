module FeatureEng

export 
# Numeric -- Binning
    BinFixedWidth, BinExponential, BinQuantile, fit!, transform
# Numeric -- Scaling
# Numeric -- Transforming

# Categorical

# Datetime
    strp_datetimes, extract_datetime_features, extract_day_features, extract_time_features

# Text -- 

include("numeric/binning.jl")
include("numeric/transforming.jl")
include("numeric/scaling.jl")
include("datetime.jl")
include("categorical.jl")
# include("test/.jl")

end # module
