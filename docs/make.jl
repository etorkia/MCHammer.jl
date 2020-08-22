#clearconsole()
push!(LOAD_PATH,"../src")
using Pkg
using Dates
using DataFrames
using Documenter, DocumenterTools
using Distributions, Statistics, StatsBase
using MCHammer
using Gadfly, Compose, Cairo

makedocs(
sitename="MCHammer.jl",
modules =[MCHammer],
pages = Any[
"Home" => "index.md",
"User Manual" => Any[
    "Simulation Functions" => "manual/1_functions.md",
    "Charting & Analyzing" => "manual/2_charts.md",
    "Time-Series Functions" => "manual/3_time_series.md",
],
"Tutorials" => Any[
    "My First Model" => "tutorials/1_first_model.md",
    "Correlating Inputs" => "tutorials/2_Correlated_Model.md",
    "Simulated CashFlow Model" => "tutorials/3_NPV_testmodel.md",
],
"Import / Export Data" => "manual/4_moving_results.md"
],

format = Documenter.HTML(
    # Use clean URLs, unless built as a "local" build
    prettyurls = !("local" in ARGS),
    canonical = "https://etorkia.github.io/MCHammer.jl/",
    assets = ["assets/favicon.ico"],
    analytics = "UA-3913053-5",
),

authors = "Eric Torkia, Technology Partnerz and contributors",
doctest = true,
source  = "src",
build   = "build",
clean   = true,
repo = "github.com/etorkia/MCHammer.jl")

# deploydocs(
#     target="build",
#     repo = "github.com/etorkia/MCHammer.jl.git",
#     branch = "gh-pages",
#     devbranch="master"
#     # versions = ["latest" => "v^", "v1.4"]
# )

deploydocs(repo = "github.com/etorkia/MCHammer.jl.git")
