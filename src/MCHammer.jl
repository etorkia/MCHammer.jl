module MCHammer

#MC Hammer is a Monte-Carlo Tool Kit for quickly building/porting risk and decisision analysis in Julia for breakneck performance.


using LinearAlgebra
using Statistics, Random, Distributions, StatsBase, DataFrames, DataFramesMeta, CSV, IterableTables
using TimeSeries, Dates
using Gadfly

#Source files for MC_Hammer functions
include("mch_simtools.jl")
include("mch_charts.jl")
include("mch_timeseries.jl")
include("mch_SIPTools.jl")
include("mch_distributions.jl")
include("mch_stochastic.jl")
include("mch_ExponentialSmoothing.jl")


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
    GBMA_d,
    sip2csv,
    importxlsip,
    importsip,
    genmeta,
    marty,
    markov_a,
    markov_ts,
    RiskEvent,
    s_curve,
    ESmooth,
    ESmooth2x,
    ESFore2x,
    #ES3_initial_trend,
    #ES3_seasonsal,
    #ES3_SeasonalIndicies,
    ESFore3X,
    #FrctStdError,
    ES3xFit,
    ForecastUncertainty





function test()
    println("Hello")

end
end # module
