push!(LOAD_PATH, joinpath(@__DIR__, "..", "src"))
using Pkg
Pkg.develop(path=".")

Pkg.add("Documenter")
Pkg.add("DocumenterTools")
Pkg.add("Distributions")
Pkg.add("DataFrames")
Pkg.add("DataFramesMeta")
Pkg.add("CSV")
Pkg.add("IterableTables")
Pkg.add("StatsBase")
Pkg.add("StatsAPI")
Pkg.add("StatsPlots")
Pkg.add("TimeSeries")
Pkg.add("Dates")
Pkg.add("Plots")
Pkg.add("GraphRecipes")
Pkg.add("HypothesisTests")
Pkg.add("LinearAlgebra")
Pkg.add("Statistics")
Pkg.add("Random")
Pkg.add("Printf")

using Documenter, MCHammer
using Plots
gr()
ENV["GKSwstype"] = "nul" 


@info "Using MCHammer from" pathof(MCHammer)

makedocs(
    sitename = "MCHammer.jl",
    modules = [MCHammer],
    repo = Remotes.GitHub("etorkia", "MCHammer.jl"),
    warnonly = true,
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
        analytics = "UA-3913053-5",
        example_size_threshold = 3_000_000_000,
        size_threshold = 700 * 1024
    ),
    authors = "Eric Torkia and contributors",
    doctest = true,
    source = "src",
    build = "build",
    clean = true,
    checkdocs = :exports
    )

deploydocs(
    target = "local",
    repo = "github.com/etorkia/MCHammer.jl.git",
    branch = "gh-pages",
    devbranch = "master",
    versions = ["stable" => "v^", "v#.#"]
)
