
using Dates
using DataFrames
using CategoricalArrays

"""
    strp_datetimes(datetimes::T, format::Union{String,DateFormat} = "y-m-d H:M:S") where T <: AbstractArray{<:AbstractString}

Convert an array of timestamps and to an array of `DateTime` objects.

Any of the strings it's unable to parse, will be replaced with `missing`.

# Examples

```@repl
date_strings = [
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "abcdefg"
    ];
strp_datetimes(date_strings)
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
```@repl
hcat(
    extract_date_features(datetimes),
    extract_time_features(datetimes)
    )
```

# Examples

```@repl
data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
extract_datetime_features(data)
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

```@repl
data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
extract_time_features(data)
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

```@repl
data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
extract_date_features(data)
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

```@repl
data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
get_month(data)
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

```@repl
data = strp_datetimes([
    "2021-01-27 14:03:25",
    "1999-10-05 01:13:43",
    "2010-06-11 11:00:00"
]);
get_weekday(data)
```

See also: [`extract_datetime_features`](@ref), [`extract_date_features`](@ref), [`get_weekday`](@ref)
"""
function get_weekday(datetimes::T) where T <: AbstractArray{<:Union{Date,DateTime}}
    categorical(
        dayname.(datetimes),
        levels=dayname.(1:7)
    )
end

