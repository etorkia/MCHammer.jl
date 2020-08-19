#clearconsole()
push!(LOAD_PATH,"../src")
# using Pkg
# Pkg.add("Documenter")
 #Pkg.add("DocumenterTools")
# Pkg.add("Distributions")
# Pkg.add("StatsBase")
# Pkg.add("Statistics")
# Pkg.add("Dates")
# Pkg.add("MCHammer")
# Pkg.add("DataFrames")
# Pkg.add("Gadfly")

using Dates
using DataFrames
using Documenter#, DocumenterTools
using Distributions, Statistics, StatsBase
using MCHammer
using Gadfly

# makedocs(
# sitename="MCHammer.jl",
# modules =[MCHammer, Documenter, DocumenterTools, Distributions, StatsBase, Statistics, Dates, DataFrames, Gadfly],
#
# pages = Any[
# "Home" => "index.md"
# "User Manual" => Any[
#     "Simulation Functions" => "manual/1_functions.md"
#     "Charting & Analyzing" => "manual/2_charts.md"
#     "Time-Series Functions" => "manual/3_time_series.md"
# ],
#
# "Tutorials" => Any[
#     "My First Model" => "tutorials/1_first_model.md"
#     "Correlating Inputs" => "2_Correlated_Model.md"
#     "Simulated CashFlow Model" => "3_NPV_testmodel.md"
# ],
#
# "Import / Export Data" => "manual/4_moving_results.md"
# ]
#
#
# format = Documenter.HTML(
#     # Use clean URLs, unless built as a "local" build
#     prettyurls = !("local" in ARGS),
#     canonical = "https://etorkia.github.io/MCHammer.jl/1.3/",
#     assets = ["assets/favicon.ico"],
#     analytics = "UA-3913053-5",
# ),
#
# authors = "Eric Torkia, Technology Partnerz and contributors",
# doctest = true,
# source  = "src",
# build   = "build",
# clean   = true,
# repo = "github.com/etorkia/MCHammer.jl")
#
# deploydocs(
#     target="build",
#     repo = "github.com/etorkia/MCHammer.jl.git",
#     branch = "gh-pages",
#     devbranch="master",
#     versions = ["stable" => "v^", "v0.1.5"]
# )

#Literate.markdown("examples/NPV_testmodel.jl", "docs/src/tutorials"; documenter=true)


#Local build
#cd("Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\docs\\src")
using Documenter,Test, DocumenterTools
using MCHammer

makedocs(
sitename="MCHammer.jl",
source  = "src",
build   = "local",
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
])


@testset "MCHammer" begin

    doctest(MCHammer; manual = true)

end
