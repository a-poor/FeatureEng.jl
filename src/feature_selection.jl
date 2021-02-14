
"""
    variance_threshold(df::DataFrame, threshold::Float64 = 0.0)

Filter out columns in `df` with variance less than `threshold`.
"""
function variance_threshold(df::DataFrame, threshold::Float64 = 0.0)
    numeric_cols = [n for n = names(df) if eltype(df[n]) <: Number]
    df[[
        c for c = numeric_cols if var(df[c]) >= threshold
    ]]
end

