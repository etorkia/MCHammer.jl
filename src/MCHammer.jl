
module MCHammer

# MC Hammer is a Monte-Carlo Tool Kit for quickly building/porting risk and decision analysis in Julia.

using LinearAlgebra, HypothesisTests
using Distributions, DataFrames, DataFramesMeta, CSV, IterableTables
using Statistics, StatsBase, StatsAPI, StatsPlots, Random
using TimeSeries, Dates
using Plots, Printf, GraphRecipes

import StatsBase: tiedrank
import Random: rand, rand!, seed!
import LinearAlgebra: BlasReal, BlasFloat
import Statistics: mean, mean!, var, varm, varm!, std, stdm, cov, covm,
                   cor, corm, cov2cor!, unscaled_covzm, quantile, sqrt!,
                   median, middle
import DataFrames: DataFrame, nrow, ncol, names, select, select!, rename!

# Source files for MC_Hammer functions
include("mch_simtools.jl")
export cormat, covmat, corvar, GetCertainty, fractiles, cmd, truncate_digit

include("mch_distributions.jl")
export RiskEvent

include("mch_charts.jl")
export density_chrt, histogram_chrt, sensitivity_chrt, trend_chrt, s_curve

include("mch_SIPTools.jl")
export sip2csv, importxlsip, importsip, genmeta

include("mch_stochastic.jl")
export marty, markov_a, markov_ts, cmatrix

include("mch_timeseries.jl")
export GBMMfit, GBMM, GBMA_d, GBMM_Sim

include("mch_LearningCurves.jl")
using .LearningCurves
export LearningCurveMethod, WrightMethod, CrawfordMethod, ExperienceMethod,
       lc_analytic, lc_curve, lc_fit, learn_rate, learn_rates

include("mch_DistributionFitting.jl")
export autofit_dist, viz_fit, fit_stats

include("mch_ExponentialSmoothing.jl")
export ExponentialSmoothingMethod, SimpleES, DoubleES, TripleES,
       es_smooth, es_forecast, es_fit, FrctStdError, forecast_uncertainty

end # module
