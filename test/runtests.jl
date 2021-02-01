
using Test
using FeatureEng

using Dates
using DataFrames

println("Running tests...")
println("Meep. Morp.")


@testset "Numeric" begin

    @testset "Scaling" begin
        data = [ 1:100; ]
        scale = fit_transform!(ScaleMinMax(),data)
        transformed = apply_transform(scale,data)
        @test minimum(transformed) == 0.0
        @test maximum(transformed) == 1.0

        data = [ 0, 5, 10 ]
        scale = fit_transform!(ScaleVariance(),data)
        transformed = apply_transform(scale,data)
        @test transformed == [-1.,0.,1.]

        data = [ 0, 0, 2^.5, 2^.5 ]
        scale = fit_transform!(ScaleL2(),data)
        transformed = apply_transform(scale,data)
        @test transformed == data ./ sum(data .^ 2) ^ .5

    end

    @testset "Transforming" begin
        @testset "Log Transform" begin
            data = ℯ .^ [ 1:10; ]
            @test isapprox(transformLog(data), [1:10;])

            for base = [ℯ,2,10]
                data = base .^ [ 1:10; ]
                @test isapprox(transformLog(data,base), [1:10;])
            end
        end

        @testset "Root Transform" begin
            for base = [ℯ,2,10]
                data = [1:10;] .^ base
                @test isapprox(transformRoot(data,base), [1:10;])
            end
        end

        @testset "BoxCox Transform" begin
            data = [ 1:10; ]

            @test isapprox(transformBoxCox(data,0.0), log.(data))
            @test isapprox(transformBoxCox(data,1.0), [ 0:9; ])
            
        end
    end

    @testset "Binning" begin
    end

    @testset "Interaction" begin
        df = DataFrame(
            x = 1:10,
            y = repeat([0,1],5)
        )
        col_names = ["x","x_x","x_y","y","y_y"]
        res = polynomial(df)
    end
end

@testset "Categorical" begin
    @testset "One-Hot Encoding" begin
        data = [3,1,2,4]
        @test encode_onehot(data) == DataFrame(Dict(
            "1" => [0,1,0,0],
            "2" => [0,0,1,0],
            "3" => [1,0,0,0],
            "4" => [0,0,0,1]
        ))
        @test encode_onehot(data,"col_") == DataFrame(Dict(
            "col_1" => [0,1,0,0],
            "col_2" => [0,0,1,0],
            "col_3" => [1,0,0,0],
            "col_4" => [0,0,0,1]
        ))
        @test encode_onehot(data,[1:6;]) == DataFrame(Dict(
            "1" => [0,1,0,0],
            "2" => [0,0,1,0],
            "3" => [1,0,0,0],
            "4" => [0,0,0,1],
            "5" => [0,0,0,0],
            "6" => [0,0,0,0]
        ))
        @test encode_onehot(data,[1:6;],"col_") == DataFrame(Dict(
            "col_1" => [0,1,0,0],
            "col_2" => [0,0,1,0],
            "col_3" => [1,0,0,0],
            "col_4" => [0,0,0,1],
            "col_5" => [0,0,0,0],
            "col_6" => [0,0,0,0],
        ))
        @test encode_onehot(["dog","cat","dog"]) == DataFrame(Dict(
            "cat" => [0,1,0],
            "dog" => [1,0,1]
        ))
    end

    @testset "Dummy Encoding" begin
    end

    @testset "Hash Encoding" begin
        data = [1:100:1000;]
        @test size(encode_hash(data,4)) == (10,4)
        @test encode_hash(data,4) == encode_hash(data,4)
    end
end

@testset "Datetime" begin
    @testset "Parse DateTime Strings" begin
        date_strings = [
            "2021-01-27 14:03:25",
            "1999-10-05 01:13:43",
            "abcdefg"
        ]
        datetimes = [
            DateTime(2021,1,27,14,03,25),
            DateTime(1999,10,5,1,13,43),
            missing
        ]
        @test all(a === b for (a,b) = zip(
            strp_datetimes(date_strings), datetimes))
    end
    @testset "Get Date Features" begin
        data = [
            DateTime(2021,1,27,14,3,25),
            DateTime(1999,10,5,1,13,43),
            DateTime(2010,6,12,11,0,0)
        ]
        @test extract_date_features(data) == DataFrame(
            year=[2021,1999,2010],
            month=["January","October","June"],
            dayofmonth=[27,5,12],
            dayofweek=["Wednesday","Tuesday","Saturday"],
            isweekend=[0,0,1],
            quarter=[1,4,2]
        )
    end
    @testset "Get Time Features" begin
        data = [
            DateTime(2021,1,27,14,3,25),
            DateTime(1999,10,5,1,13,43),
            DateTime(2010,6,12,11,0,0)
        ]
        @test extract_time_features(data) == DataFrame(
            hour=[14,1,11],
            minute=[3,13,0],
            second=[25.,43.,0.],
            isAM=[0,1,1]
        )
    end
    @testset "Get Date Features" begin
        data = [
            DateTime(2021,1,27,14,3,25),
            DateTime(1999,10,5,1,13,43),
            DateTime(2010,6,12,11,0,0)
        ]
        @test extract_datetime_features(data) == DataFrame(
            year=[2021,1999,2010],
            month=["January","October","June"],
            dayofmonth=[27,5,12],
            dayofweek=["Wednesday","Tuesday","Saturday"],
            isweekend=[0,0,1],
            quarter=[1,4,2],
            hour=[14,1,11],
            minute=[3,13,0],
            second=[25.,43.,0.],
            isAM=[0,1,1]
        )
    end
end


