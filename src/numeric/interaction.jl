
import DataFrames

function interactions(df::DataFrame, degree::T where T <: Integer = 2)
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
    # Calculate new columns
    rename_cols = cols -> join(cols,"_")
    get_cols = col_names -> (df[c] for c = col_names)
    mult_cols = cols -> reduce((l,r) -> l .* r, cols)
    get_mult = col_names -> mult_cols(get_cols(col_names))
    # Return the resulting dataframe
    DataFrame([
        rename_cols(c) => get_mult(c)
        for c = new_cols
    ])
end

