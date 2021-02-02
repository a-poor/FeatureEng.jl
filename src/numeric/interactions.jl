
import DataFrames.DataFrame


"""
    polynomial(df::DataFrame, degree::T = 2) where T <: Integer

Calculate [polynomial](https://en.wikipedia.org/wiki/Polynomial_regression) interaction 
terms between columns in a `DataFrame`.

If you have a `DataFrame` with 3 columns: `x`, `y`, and `z`, you can get degree-2 
polynomial interaction terms: `x*x`, `x*y`, `x*z`, `y*y`, `y*z`, and `z*z`.

# Examples

```@repl
using DataFrames
df = DataFrame(a=1:10,b=repeat(0:1,5))
polynomial(df,2)
polynomial(df,3)
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

