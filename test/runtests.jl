
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
end

@testset "Datetime" begin
end

@testset "Text" begin
end


