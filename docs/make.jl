push!(LOAD_PATH, joinpath(@__DIR__, "..", "src"))
using Pkg
using Documenter
using MCHammer

makedocs(
    sitename = "MCHammer.jl",
    modules = [MCHammer],
    warnonly = true,
    format = Documenter.HTML(size_threshold = 1_000_000_000),
    pages = Any[
        "Home" => "index.md",
        "User Manual" => Any[
            "Monte-Carlo Simulation" => "manual/1_functions.md",
            "Distribution Fitting" => "manual/distribution_fitting.md",
            "Charting & Analyzing" => "manual/2_charts.md",
            "Time-Series Functions" => Any[
                "Random & Probability Methods" => "manual/3_time_series.md",
                "Exponential Smoothing" => "manual/ExponentialSmoothing.md",
                "Learning Curves Models" => "manual/LearningCurves.md"
            ]
        ],
        "Tutorials" => Any[
            "My First Model" => "tutorials/1_first_model.md",
            "Correlating Inputs" => "tutorials/2_Correlated_Model.md",
            "Simulated CashFlow Model" => "tutorials/3_NPV_testmodel.md"
        ],
        "Import / Export Data" => "manual/4_moving_results.md"
    ],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://etorkia.github.io/MCHammer.jl/",
        assets = ["assets/favicon.ico"],
        analytics = "UA-3913053-5"
    ),
    authors = "Eric Torkia and contributors",
    doctest = true,
    source = "src",
    build = "build",
    clean = true,
    repo = "github.com/etorkia/MCHammer.jl"
)

deploydocs(
    target = "local",
    repo = "github.com/etorkia/MCHammer.jl.git",
    branch = "gh-pages",
    devbranch = "master",
    versions = ["stable" => "v^", "v#.#"]
)
