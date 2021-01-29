
using Dates
using DataFrames
using CategoricalArrays


function strp_datetimes(datetimes::AbstractArray{AbstractString}, format::Union{AbstractString,DateFormat})
    if format isa String
        format = DateFormat(format)
    end
    Date.(datetimes,format=format)
end

function extract_datetime_features(datetimes::AbstractArray{DateTime})
    hcat(
        extract_day_features(datetimes),
        extract_time_features(datetimes)
    )
end

function extract_time_features(datetimes::AbstractArray{Union{Time,DateTime}})
    DataFrame(
        datetime=datetimes,
        hour=hour.(datetimes),
        minute=minute.(datetimes),
        second=(second.(datetimes) .+ millisecond.(datetimes) ./ 1e3)
    )
end

function extract_day_features(datetimes::AbstractArray{Union{Date,DateTime}})
    DataFrame(
        datetime=datetimes,
        year=year.(datetimes),
        month=get_month(datetimes),
        dayofmonth=day.(datetimes),
        dayofweek=get_dayofweek(datetimes),
        isweekend=occursin.(datetimes,("Saturday","Sunday"))
        quarter=quarterofyear.(datetimes)
    )
end

function get_month(datetimes::AbstractArray{Union{Date,DateTime}})
    categorical(
        monthname.(datetimes),
        levels=monthname.(1:12)
    )
end

function get_weekday(datetimes::AbstractArray{Union{Date,DateTime}})
    categorical(
        dayname.(datetimes),
        levels=dayname.(1:7)
    )
end

