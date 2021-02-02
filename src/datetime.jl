
using Dates
using DataFrames
using CategoricalArrays

"""
    strp_datetimes(datetimes::T, format::Union{String,DateFormat} = "y-m-d H:M:S") where T <: AbstractArray{<:AbstractString}

Convert an array of timestamps and to an array of `DateTime` objects.

Any of the strings it's unable to parse, will be replaced with `missing`.

# Examples

```julia-repl
julia> date_strings = [
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "abcdefg"
    ];
julia> strp_datetimes(date_strings)
3-element Array{Union{Missing, DateTime},1}:
 2021-01-27T14:03:25
 1999-10-05T01:13:43
 missing
```
"""
function strp_datetimes(datetimes::T, format::Union{String,DateFormat} = "y-m-d H:M:S") where T <: AbstractArray{<:AbstractString}
    if format isa String
        format = DateFormat(format)
    end
    broadcast(
        s::String -> begin
            try
                DateTime(s,format)
            catch e
                if e isa ArgumentError
                    missing
                else
                    rethrow(e)
                end
            end
        end,
        datetimes
    )
end

"""
    extract_datetime_features(datetimes::T) where T <: AbstractArray{<:DateTime}

Extract a `DataFrame` of features from an array of `DateTime` objects.
Features extracted:

* `year`: Year from `datetime`
* `month`: Month from `datetime`
* `dayofmonth`: Day of the month (0-31)
* `dayofweek`: Day of the week (ordered)
* `isweekend`: Is `datetime` a weekend?
* `quarter`: The quarter from datetimes
* `hour`: Hour of the day from `datetime`
* `minute`: Minute from `datetime`
* `second`: Second from `datetime`
* `isAM`: Is time AM (vs PM)?

The same as the following:
```julia-repl
julia>  hcat(
    extract_date_features(datetimes),
    extract_time_features(datetimes)
    )
```

# Examples

```julia-repl
julia> data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
julia> extract_datetime_features(data)
3×10 DataFrame
 Row │ year   month    dayofmonth  dayofweek  isweekend  quarter  hour   minut ⋯
     │ Int64  Cat…     Int64       Cat…       Bool       Int64    Int64  Int64 ⋯
─────┼──────────────────────────────────────────────────────────────────────────
   1 │  2021  January          27  Wednesday      false        1     14        ⋯
   2 │  1999  October           5  Tuesday        false        4      1      1
   3 │  2010  June             11  Friday         false        2     11
                                                               3 columns omitted
```

See also: [`extract_date_features`](@ref), [`extract_time_features`](@ref)
"""
function extract_datetime_features(datetimes::T) where T <: AbstractArray{<:DateTime}
    hcat(
        extract_date_features(datetimes),
        extract_time_features(datetimes)
    )
end

"""
    extract_time_features(datetimes::T) where T <: AbstractArray{<:Union{Time,DateTime}}

Extract a `DataFrame` of features from an array of `DateTime` or `Time` objects.
Features extracted:

* `hour`: Hour of the day from `datetime`
* `minute`: Minute from `datetime`
* `second`: Second from `datetime`
* `isAM`: Is time AM (vs PM)?

# Examples

```julia-repl
julia> data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
julia> extract_time_features(data)
3×4 DataFrame
 Row │ hour   minute  second   isAM  
     │ Int64  Int64   Float64  Bool  
─────┼───────────────────────────────
   1 │    14       3     25.0  false
   2 │     1      13     43.0   true
   3 │    11       0      0.0   true
```

See also: [`extract_datetime_features`](@ref), [`extract_date_features`](@ref)
"""
function extract_time_features(datetimes::T) where T <: AbstractArray{<:Union{Time,DateTime}}
    DataFrame(
        hour=hour.(datetimes),
        minute=minute.(datetimes),
        second=(second.(datetimes) .+ millisecond.(datetimes) ./ 1e3),
        isAM=hour.(datetimes) .< 12
    )
end

"""
    extract_date_features(datetimes::T) where T <: AbstractArray{<:Union{Date,DateTime}}

Extract a `DataFrame` of features from an array of `DateTime` or `Date` objects.
Features extracted:

* `year`: Year from `datetime`
* `month`: Month from `datetime`
* `dayofmonth`: Day of the month (1-31)
* `dayofweek`: Day of the week (ordered)
* `isweekend`: Is `datetime` a weekend?
* `quarter`: The quarter from datetimes

# Examples

```julia-repl
julia> data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
julia> extract_date_features(data)
3×6 DataFrame
 Row │ year   month    dayofmonth  dayofweek  isweekend  quarter 
     │ Int64  Cat…     Int64       Cat…       Bool       Int64   
─────┼───────────────────────────────────────────────────────────
   1 │  2021  January          27  Wednesday      false        1
   2 │  1999  October           5  Tuesday        false        4
   3 │  2010  June             11  Friday         false        2
```

See also: [`extract_datetime_features`](@ref), [`extract_time_features`](@ref)
"""
function extract_date_features(datetimes::T) where T <: AbstractArray{<:Union{Date,DateTime}}
    DataFrame(
        year=year.(datetimes),
        month=get_month(datetimes),
        dayofmonth=day.(datetimes),
        dayofweek=get_weekday(datetimes),
        isweekend=broadcast(
            d -> d ∈ ("Saturday","Sunday"),
            get_weekday(datetimes)
        ),
        quarter=quarterofyear.(datetimes)
    )
end

"""
    get_month(datetimes::T) where T <: AbstractArray{<:Union{Date,DateTime}}

Return an ordered `CategoricalArray` of month names extracted from `datetimes`.

# Examples:

```julia-repl
julia> data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
julia> get_month(data)
3-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "January"
 "October"
 "June"
```

See also: [`extract_datetime_features`](@ref), [`extract_date_features`](@ref), [`get_weekday`](@ref)
"""
function get_month(datetimes::T) where T <: AbstractArray{<:Union{Date,DateTime}}
    categorical(
        monthname.(datetimes),
        levels=monthname.(1:12)
    )
end

"""
    get_weekday(datetimes::T) where T <: AbstractArray{<:Union{Date,DateTime}}

Return an ordered `CategoricalArray` of weekday names extracted from `datetimes`.

# Examples:

```julia-repl
julia> data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
julia> get_weekday(data)
3-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "Wednesday"
 "Tuesday"
 "Friday"
```

See also: [`extract_datetime_features`](@ref), [`extract_date_features`](@ref), [`get_weekday`](@ref)
"""
function get_weekday(datetimes::T) where T <: AbstractArray{<:Union{Date,DateTime}}
    categorical(
        dayname.(datetimes),
        levels=dayname.(1:7)
    )
end

