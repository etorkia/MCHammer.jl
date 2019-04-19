module master_mc

using LinearAlgebra
using Distributions, StatsBase, Random, DataFrames, CSV, Distributions, Statistics, IterableTables
using TimeSeries
using Gadfly


import Random: rand, rand!
import LinearAlgebra: BlasReal, BlasFloat
import Statistics: mean, mean!, var, varm, varm!, std, stdm, cov, covm,
                   cor, corm, cov2cor!, unscaled_covzm, quantile, sqrt!,
median, middle

export
cormat,
covmat,
corvar,
GetCertainty,
density_chrt,
histogram_chrt,
sensitivity_chrt,
trend_chrt,
GBMMult_Fit,
GBMM

include("correlation.jl")
include("mch_charts.jl")
include("mch_timeseries.jl")

#uuid = "b2cdeac0-6178-11e9-0dae-dd520ea357d8"
end
