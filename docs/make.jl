push!(LOAD_PATH,"../src/")

using Documenter, FeatureEng

makedocs(
    modules = [FeatureEng],
    sitename="FeatureEng.jl Docs",
    authors="Austin Poor",
    clean=true,
    debug=true,
    pages=[
        "index.md"
    ],
    repo   = "github.com/a-poor/FeatureEng.jl.git",
)

deploydocs(
    root   = dirname(abspath(PROGRAM_FILE)),
    # target = "build",
    repo   = "github.com/a-poor/FeatureEng.jl.git",
    # branch = "gh-pages",
    # deps   = nothing | <Function>,
    # make   = nothing | <Function>,
    devbranch = "main",
    devurl = "dev",
    # versions = ["stable" => "v^", "v#.#", devurl => devurl],
    # versions = ["stable" => "v^", "v#.#"],
    push_preview    = true,
    # repo_previews   = repo,
    # branch_previews = branch,
)

