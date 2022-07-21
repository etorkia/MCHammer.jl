using Dates
using DataFrames
using Distributions, Statistics, StatsBase
using Gadfly
using Documenter,Test, DocumenterTools
using MCHammer, Compose, Cairo, Fontconfig

#remember to change directory to \docs

cd("Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\docs")

function DoIt()

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
end

@testset "MCHammer" begin

    doctest(MCHammer; manual = true)

end
