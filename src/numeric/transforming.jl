
function transformLog(data::Array, base = ℯ)
    log.(base,data)
end

function transformRoot(data::Array, index = 10)
    data .^ (1/index)
end

function transformBoxCox(data::Array, λ = 0.0)
    λ == 0 ? log.(data) : (data .^ λ .- 1) ./ λ 
end


