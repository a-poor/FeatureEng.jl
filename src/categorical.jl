
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

function encode_hash(column::AbstractArray{Any}, n_cols::Int = 16)
    DataFrame(
        hcat(digits.(hash.(column).&(2^n_cols-1),base=2,pad=n_cols)...)',
        ["c$i" for i = 1:n_cols]
    )
end


# function encode_bin_count(column::AbstractArray)
# end

