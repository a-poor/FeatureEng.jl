
"""
    polynomial(df::DataFrame, degree::T = 2) where T <: Integer

Calculate [polynomial](https://en.wikipedia.org/wiki/Polynomial_regression) interaction 
terms between columns in a `DataFrame`.

If you have a `DataFrame` with 3 columns: `x`, `y`, and `z`, you can get degree-2 
polynomial interaction terms: `x*x`, `x*y`, `x*z`, `y*y`, `y*z`, and `z*z`.

# Examples

```julia-repl
julia> using DataFrames

julia> df = DataFrame(a=1:10,b=repeat(0:1,5))
10×2 DataFrame
 Row │ a      b     
     │ Int64  Int64 
─────┼──────────────
   1 │     1      0
   2 │     2      1
   3 │     3      0
   4 │     4      1
   5 │     5      0
   6 │     6      1
   7 │     7      0
   8 │     8      1
   9 │     9      0
  10 │    10      1

julia> polynomial(df,2)
10×5 DataFrame
 Row │ a      a_a    a_b    b      b_b   
     │ Int64  Int64  Int64  Int64  Int64 
─────┼───────────────────────────────────
   1 │     1      1      0      0      0
   2 │     2      4      2      1      1
   3 │     3      9      0      0      0
   4 │     4     16      4      1      1
   5 │     5     25      0      0      0
   6 │     6     36      6      1      1
   7 │     7     49      0      0      0
   8 │     8     64      8      1      1
   9 │     9     81      0      0      0
  10 │    10    100     10      1      1

julia> polynomial(df,3)
10×9 DataFrame
 Row │ a      a_a    a_a_a  a_a_b  a_b    a_b_b  b      b_b    b_b_b 
     │ Int64  Int64  Int64  Int64  Int64  Int64  Int64  Int64  Int64 
─────┼───────────────────────────────────────────────────────────────
   1 │     1      1      1      0      0      0      0      0  0
   2 │     2      4      8      4      2      2      1      1  1
   3 │     3      9     27      0      0      0      0      0  0
   4 │     4     16     64     16      4      4      1      1  1
   5 │     5     25    125      0      0      0      0      0  0
   6 │     6     36    216     36      6      6      1      1  1
   7 │     7     49    343      0      0      0      0      0  0
   8 │     8     64    512     64      8      8      1      1  1
   9 │     9     81    729      0      0      0      0      0  0
  10 │    10    100   1000    100     10     10      1      1  1
```
"""
function polynomial(df::DataFrame, degree::T = 2) where T <: Integer
    # Check inputs
    if degree < 1
        error("`degree` must be ≥ 1")
    end
    # Build new colnames based on degree
    colnames = names(df)
    last = [[c] for c = colnames]
    new_cols = last[:]
    for _ = 1:(degree-1)
        next = [[l...,c] for l = last for c = colnames]
        append!(new_cols,next)
        last = next
    end
    # Only keep unique columns
    new_cols = Set([sort(cs) for cs = new_cols])
    new_cols = sort([[cs...] for cs = new_cols])
    # Calculate new columns
    rename_cols = cols -> join(cols,"_")
    get_cols = col_names -> (df[!,c] for c = col_names)
    mult_cols = cols -> reduce((l,r) -> l .* r, cols)
    get_mult = col_names -> mult_cols(get_cols(col_names))
    # Return the resulting dataframe
    DataFrame([
        rename_cols(c) => get_mult(c)
        for c = new_cols
    ])
end

