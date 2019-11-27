module MCHammer

#MC Hammer is a Monte-Carlo Tool Kit for quickly building/porting risk and decisision analysis in Julia for breakneck performance.


using LinearAlgebra
using Statistics, Random, Distributions, StatsBase, DataFrames, CSV, IterableTables
using TimeSeries
using Gadfly


import StatsBase: tiedrank
import Random: rand, rand!, seed!
import LinearAlgebra: BlasReal, BlasFloat
import Statistics: mean, mean!, var, varm, varm!, std, stdm, cov, covm,
                   cor, corm, cov2cor!, unscaled_covzm, quantile, sqrt!,
median, middle

export
    cormat,
    covmat,
    corvar,
    GetCertainty,
    fractiles,
    cmd,
    truncate_digit,
    density_chrt,
    histogram_chrt,
    sensitivity_chrt,
    trend_chrt,
    GBMMfit,
    GBMM,
    sip2csv,
    importxlsip,
    importsip,
    genmeta



#Source files for MC_Hammer functions
include("mch_simtools.jl")
include("mch_charts.jl")
include("mch_timeseries.jl")
include("mch_SIPTools.jl")

function test()
    println("Hello")

end
end # module
