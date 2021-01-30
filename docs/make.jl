push!(LOAD_PATH,"../src/")

using Documenter, FeatureEng

makedocs(
    modules = [FeatureEng],
    sitename="FeatureEng",
    pages=[
        "index.md"
    ]
)

deploydocs(
    root   = dirname(abspath(PROGRAM_FILE)),
    target = "build",
    repo   = "github.com/a-poor/FeatureEng.jl.git",
    branch = "gh-pages",
    # deps   = nothing | <Function>,
    # make   = nothing | <Function>,
    devbranch = "dev",
    devurl = "dev",
    # versions = ["stable" => "v^", "v#.#", devurl => devurl],
    versions = ["stable" => "v^", "v#.#"],
    push_preview    = true,
    # repo_previews   = repo,
    # branch_previews = branch,
)

