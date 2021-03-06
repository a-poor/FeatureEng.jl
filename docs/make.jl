push!(LOAD_PATH,"../src/")

using Documenter, FeatureEng

makedocs(
    modules = [FeatureEng],
    sitename="FeatureEng.jl",
    authors="Austin Poor",
    clean=true,
    # debug=true,
    pages=[
        "index.md",
        "Manual" => "manual.md",
        "Examples" => "examples.md",
    ],
    repo   = "github.com/a-poor/FeatureEng.jl.git",
)

deploydocs(
    # root   = dirname(abspath(PROGRAM_FILE)),
    # target = "build",
    repo   = "github.com/a-poor/FeatureEng.jl.git",
    # branch = "gh-pages",
    # deps   = nothing | <Function>,
    # make   = nothing | <Function>,
    devbranch = "main",
    # devurl = "",
    # versions = ["stable" => "v^", "v#.#", devurl => devurl],
    versions = ["stable" => "v^", "v#.#", "latest" => "v^"],
    # push_preview    = true,
    # repo_previews   = repo,
    # branch_previews = branch,
)

