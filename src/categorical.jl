
using DataFrames
import Parameters.@with_kw

function encode_onehot(column::AbstractArray{Any})
    DataFrame([
        l => column .== l
        for l = levels(column)
    ])
end

function encode_dummy(column::AbstractArray{Any})
    df = encode_onehot(column)
    col_names = names(df)
    df[2:end]
end

