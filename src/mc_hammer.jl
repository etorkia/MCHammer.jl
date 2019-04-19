module mc_hammer

#MC Hammer is a Monte-Carlo Tool Kit for quickly building risk and decisision analysis

using
    Distributions,
    StatsBase,
    DataFrames,
    LinearAlgebra,
    Random,
    DataFrames,
    CSV,
    Distributions,
    Statistics,
    IterableTables
    using TimeSeries; precompile,
    using Gadfly; precompile,


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

function test()
    println("Hello")

end
end # module
