
using DataFrames

"""
    encode_onehot(column::T[, categories::T[, prefix::String]]) where T <: AbstractArray

Converts a categorical column into a `DataFrame` of one-hot-encoded columns --
with one binary-encoded column per unique value in `column`.

# Examples

The basic version of this function makes a column for each unique
value in `column`.

```julia-repl
julia> data = [3,1,2,4];
julia> encode_onehot(data)
4×4 DataFrame
 Row │ 1      2      3      4     
     │ Bool   Bool   Bool   Bool  
─────┼────────────────────────────
   1 │ false  false   true  false
   2 │  true  false  false  false
   3 │ false   true  false  false
   4 │ false  false  false   true
```

You can also specify a prefix for each column.

```julia-repl
julia> data = [3,1,2,4];
julia> encode_onehot(data,"col_")
4×4 DataFrame
 Row │ col_1  col_2  col_3  col_4 
     │ Bool   Bool   Bool   Bool  
─────┼────────────────────────────
   1 │ false  false   true  false
   2 │  true  false  false  false
   3 │ false   true  false  false
   4 │ false  false  false   true
```

Additionally, you can specify the categories to convert to columns, 
regardless of whether it exists in `column`.

```julia-repl
julia> data = [3,1,2,4];
julia> encode_onehot(data,[1:6;],"c")
4×6 DataFrame
 Row │ c1     c2     c3     c4     c5     c6    
     │ Bool   Bool   Bool   Bool   Bool   Bool  
─────┼──────────────────────────────────────────
   1 │ false  false   true  false  false  false
   2 │  true  false  false  false  false  false
   3 │ false   true  false  false  false  false
   4 │ false  false  false   true  false  false
```

See also: [`encode_dummy`](@ref), [`encode_hash`](@ref)
"""
function encode_onehot(column::T, categories::T, prefix::String) where T <: AbstractArray
    DataFrame(Dict([
        "$(prefix)$(l)" => column .== l
        for l = categories
    ]))
end

function encode_onehot(column::T, categories::T) where T <: AbstractArray
    encode_onehot(column,categories,"")
end

function encode_onehot(column::T, prefix::String) where T <: AbstractArray
    encode_onehot(column,levels(column),prefix)
end

function encode_onehot(column::T) where T <: AbstractArray
    encode_onehot(column,levels(column),"")
end

"""
    encode_dummy(column::T[, categories::T[, prefix::String]]) where T <: AbstractArray

Same as [`encode_onehot`](@ref) except that it drops the first column (to help prevent
issues caused by [multicollinearity](https://en.wikipedia.org/wiki/Multicollinearity)).

See also: [`encode_onehot`](@ref), [`encode_hash`](@ref)
"""
function encode_dummy(column::T, categories::T, prefix::String) where T <: AbstractArray
    df = encode_onehot(column,categories,prefix)
    if length(names(df)) > 1 
        df[2:end]
    else df
    end
end

function encode_dummy(column::T, categories::T) where T <: AbstractArray
    df = encode_onehot(column,categories)
    if length(names(df)) > 1 
        df[2:end]
    else df
    end
end

function encode_dummy(column::T, prefix::String) where T <: AbstractArray
    df = encode_onehot(column,prefix)
    if length(names(df)) > 1 
        df[2:end]
    else df
    end
end

function encode_dummy(column::T) where T <: AbstractArray
    df = encode_onehot(column)
    if length(names(df)) > 1 
        df[2:end]
    else df
    end
end

"""
    encode_hash(column::T, n_cols::Int = 8, prefix::String = "c") where T <: AbstractArray

Deterministically encode categorical features with high cardinality as a 
`DataFrame` with `n_cols` columns. 

```julia-repl
julia> data = [1:100;1000;];
julia> encode_hash([1:1_000:10_000;])
10×8 DataFrame
 Row │ c1     c2     c3     c4     c5     c6     c7     c8    
     │ Int64  Int64  Int64  Int64  Int64  Int64  Int64  Int64 
─────┼────────────────────────────────────────────────────────
   1 │     1      1      1      1      1      1      1      0
   2 │     1      1      0      1      1      0      1      0
   3 │     1      0      1      0      1      1      0      1
   4 │     1      1      1      1      0      1      1      1
   5 │     1      0      0      0      0      0      1      0
   6 │     1      0      1      0      0      1      0      1
   7 │     0      1      1      0      0      1      1      1
   8 │     1      1      0      1      0      1      0      0
   9 │     0      1      0      1      0      1      1      0
  10 │     0      1      0      0      0      1      1      0
```

See also: [`encode_onehot`](@ref), [`encode_dummy`](@ref)
"""
function encode_hash(column::T, n_cols::Int = 8, prefix::String = "c") where T <: AbstractArray
    DataFrame(
        hcat(digits.(hash.(column).&(2^n_cols-1),base=2,pad=n_cols)...)',
        ["$(prefix)$(i)" for i = 1:n_cols]
    )
end


