push!(LOAD_PATH,"../src/")

using Documenter, FeatureEng

makedocs(
    sitename="FeatureEng"
)

deploydocs(
    root   = dirname(abspath(PROGRAM_FILE)),
    target = "build",
    repo   = "github.com/a-poor/FeatureEng.jl.git",
    branch = "gh-pages",
    # deps   = nothing | <Function>,
    # make   = nothing | <Function>,
    devbranch = "main",
    devurl = "dev",
    # versions = ["stable" => "v^", "v#.#", devurl => devurl],
    versions = ["stable" => "v^", "v#.#"],
    push_preview    = false,
    # repo_previews   = repo,
    # branch_previews = branch,
)

