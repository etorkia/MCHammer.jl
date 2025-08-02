push!(LOAD_PATH,"../src")
#push!(LOAD_PATH, joinpath(@__DIR__, ".."))
using Dates
using DataFrames
using Distributions, Statistics, StatsBase
using Plots, StatsPlots, GraphRecipes
using Documenter,Test, DocumenterTools,Revise
using MCHammer, Logging, LoggingExtras, Documenter

# Create a file logger that writes to "doc_errors.log"
file_logger = LoggingExtras.FileLogger("doc_errors.log")
global_logger(file_logger)

#include("Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\src\\MCHammer.jl")

#remember to change directory to \docs

cd("Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\docs")
#cd("Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer")

function DoIt()

    makedocs(
    sitename="MCHammer.jl",
    authors = "Eric Torkia and contributors",
    warnonly = true,
    format = Documenter.HTML(size_threshold = 1_000_000_000),
    doctest = false,
    checkdocs = :export,
    source  = "src",
    build   = "local",
    modules =[MCHammer],
    pages = Any[
    "Home" => "index.md",
    "User Manual" => Any[
        "Monte-Carlo Simulation" => "manual/1_functions.md",
        "Distribution Fitting" => "manual/distribution_fitting.md",
        "Charting & Analyzing" => "manual/2_charts.md",
        "Time-Series Functions" => Any[
            "Random & Probability Methods"     => "manual/3_time_series.md",
            "Exponential Smoothing" => "manual/ExponentialSmoothing.md",
            "Learning Curves Models" => "manual/LearningCurves.md"
            ],
                
    ],
    "Tutorials" => Any[
        "My First Model" => "tutorials/1_first_model.md",
        "Correlating Inputs" => "tutorials/2_Correlated_Model.md",
        "Simulated CashFlow Model" => "tutorials/3_NPV_testmodel.md",
    ],
    "Import / Export Data" => "manual/4_moving_results.md"
    ])
end


#use this first to test all the doctests first
#= @testset "MCHammer" begin
    
    doctest(MCHammer; manual = true)
    
end =#

#Build Local Docs



DoIt()