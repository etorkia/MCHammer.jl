module mc_hammer

#MC Hammer is a Monte-Carlo Tool Kit for quickly building risk and decisision analysis

using Distributions
using StatsBase
using DataFrames
using LinearAlgebra
using Random
using Gadfly; precompile
using DataFrames
using CSV
using Distributions
using Statistics
using TimeSeries; precompile
using IterableTables


include("correlation.jl")
include("mch_charts.jl")
include("mch_timeseries.jl")

function test()
    println("Hello")
end
end # module
