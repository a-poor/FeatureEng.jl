
import Base.push!

# Data Structs

struct Transform
    name::String
    fn::Function
end

struct Pipeline
    transforms::Vector{Transform}
end

# Pipeline Helper Functions

function push!(p::Pipeline,t::Transform)
    push!(p.transforms,t)
end

function select_cols(df::DataFrame, colnames::Vector{String})
end

function add_columns(df::DataFrame, new_col::Vector)
end

function add_columns(df::DataFrame, new_cols::DataFrame)
end

function apply_transforms(p::Pipeline, data::DataFrame)
end
