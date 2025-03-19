# Script to fit distributions using Julia
# ©Decision Superhero. Please cite source if using code in your projects.

using Distributions, StatsBase, Statistics  # MCHammer
using DataFrames, HypothesisTests, StatsAPI, StatsPlots

"""
    viz_fit(SampleData; DistFit=[], cumulative=false)

Visualizes sample data against fitted probability density functions (PDFs) and cumulative densidty functions (CDFs).

# Arguments
- `SampleData`: Array of sample data.
- `DistFit` (optional): Array of distribution types to fit.  
  If not provided, defaults to `[Normal, LogNormal, Uniform]`.
-`cumulative` (optional): Returns the results in cumulative form. Default is in probability density form.

# Returns
A plot object with the density of `SampleData` overlaid by the fitted PDFs / CDFs.
"""
function viz_fit(SampleData; DistFit=[], cumulative=false)
    # Set default fits if none provided.
    if DistFit == []
        DistFit = [Normal, LogNormal, Uniform]
    end

    if cumulative == false
        # Set base plot of sample data (density estimate).
        StatsPlots.plot()
        base_plot = StatsPlots.density(SampleData; label="SampleData", linewidth=4, alpha=0.5)

        for i = 1:length(DistFit)
            try
                fitted_dist = fit(DistFit[i], SampleData)
                println(fitted_dist)
                base_plot = plot!(fitted_dist, minimum(SampleData) * 1.2, maximum(SampleData) * 1.2; label=DistFit[i], ls=:dash, linewidth=1.5)
            catch
                println(DistFit[i], " does not work - pick another candidate")
                continue
            end
        end
    else
        # Set base plot of sample data (cumulative density estimate).
        StatsPlots.plot()
        base_plot = StatsPlots.cdensity(SampleData, func=cdf; label="SampleData", linewidth=4, alpha=0.5)

        for i = 1:length(DistFit)
            try
                fitted_dist = fit(DistFit[i], SampleData)
                println(fitted_dist)
                base_plot = plot!(fitted_dist, func=cdf, minimum(SampleData) * 1.2, maximum(SampleData) * 1.2; label=DistFit[i], ls=:dash, linewidth=1.5)
            catch
                println(DistFit[i], " does not work - pick another candidate")
                continue
            end
        end
    end
    return base_plot
end



#Support function, do not export

"""
    p_fit(SampleData; DistFit=[], Increment=0.1)

Calculates and returns a DataFrame comparing percentiles of the sample data to the theoretical percentiles 
from fitted distributions.

# Arguments
- `SampleData`: Array of sample data.
- `DistFit` (optional): Array of distribution types to fit.  
  Defaults to `[Normal, LogNormal, Uniform]` if not provided.
- `Increment` (optional): Increment for the percentiles (e.g., 0.1 for 0%, 10%, …, 100%).  
  Default is 0.1.

# Returns
A DataFrame with columns:
- `Percentile`: The percentile (in %).
- `SampleData`: The corresponding quantile of the sample data.
- One column per fitted distribution containing the theoretical quantiles.
"""
function p_fit(SampleData; DistFit=[], Increment=0.1)
    if DistFit == []
        DistFit = [Normal, LogNormal, Uniform]
    end

    # Setup Sample Data Percentiles
    P_Vals = collect(0:Increment:1)
    fractile_values = quantile(collect(Float64, SampleData), P_Vals)
    results = [P_Vals * 100 fractile_values]
    col_names = [:Percentile, :SampleData]

    for i = 1:length(DistFit)
        try
            test_fit = fit(DistFit[i], SampleData)
            theoreticals = quantile(test_fit, P_Vals)
            results = hcat(results, theoreticals)
            push!(col_names, Symbol(DistFit[i]))
        catch
            continue
        end
    end
    results = DataFrame(results, :auto)
    rename!(results, col_names)
    return results
end

#---------------------------------------------------------------------------------

"""
    fit_stats(SampleData; DistFit=[], pvals=true, Increment=0.1)

Calculates descriptive statistics for the sample data and for each fitted distribution in `DistFit`.

# Arguments
- `SampleData`: Array of sample data.
- `DistFit` (optional): Pre-selected array of distribution types to fit.  
  Defaults to `[Normal, LogNormal, Uniform]` if not provided.
- `pvals` (optional): Displays percentiles for the sample data and the fits
- `Increment` (optional): Increment for the percentiles (e.g., 0.1 for 0%, 10%, …, 100%).  
  Default is 0.1.


# Returns
A DataFrame (transposed) containing descriptive statistics (mean, median, mode, std, variance, skewness, kurtosis, etc.) 
for the sample data and for each fitted distribution.

When `pvals = true` percentiles are added the to stats table
- `Percentile`: The percentile (in %).
- `SampleData`: The corresponding quantile of the sample data.
- One column per fitted distribution containing the theoretical quantiles.
"""
function fit_stats(SampleData; DistFit=[], pvals=true, Increment=0.1)

    if DistFit == []
        DistFit = [Normal, LogNormal, Uniform]
    end

    #Setup Sample Data Stats
    results_df = DataFrame(
        Name="Sample Data",
        Mean=mean(SampleData),
        Median=median(SampleData),
        Mode=Distributions.mode(SampleData),
        Standard_Deviation=std(SampleData),
        Variance=var(SampleData),
        Skewness=skewness(SampleData),
        Kurtosis=kurtosis(SampleData),
        Coeff_Variation=variation(SampleData),
        Minimum=minimum(SampleData),
        Maximum=maximum(SampleData),
        MeanStdError=sem(SampleData)
    )

    # Loop theoreticals
    for i = 1:length(DistFit)
        try
            test_fit = fit(DistFit[i], SampleData)
            results = [
                string(DistFit[i]),
                try
                    mean(test_fit)
                catch
                    NaN
                end,
                try
                    median(test_fit)
                catch
                    NaN
                end,
                try
                    Distributions.mode(test_fit)
                catch
                    NaN
                end,
                try
                    std(test_fit)
                catch
                    NaN
                end,
                try
                    var(test_fit)
                catch
                    NaN
                end,
                try
                    skewness(test_fit)
                catch
                    NaN
                end,
                try
                    kurtosis(test_fit)
                catch
                    NaN
                end,
                try
                    std(test_fit) / mean(test_fit)
                catch
                    NaN
                end,
                try
                    minimum(test_fit)
                catch
                    NaN
                end,
                try
                    maximum(test_fit)
                catch
                    NaN
                end,
                try
                    sem(test_fit)
                catch
                    NaN
                end
            ]
            push!(results_df, results)
        catch
            continue
        end
    end
    results = permutedims(results_df, 1)

    if pvals == false
        return results
    else
        percentiles = p_fit(SampleData; DistFit, Increment)
        combined_table = DataFrame(vcat(Matrix(results), Matrix(percentiles)), names(results))
        return combined_table
        print(combined_table)
    end
end


# AUTO FIT
# Helper function to sort results (Do not export)

function sort_fit_df!(fit_df::DataFrame, sort::String)
    if sort == "ad"
        sort!(fit_df, :ADTest)
        filter!(row -> !isnan(row.ADTest), fit_df)
    elseif sort == "ks"
        sort!(fit_df, :KSTest)
        filter!(row -> !isnan(row.KSTest), fit_df)
    elseif sort == "ll"
        sort!(fit_df, :LogLikelihood, rev=true)
        filter!(row -> !isnan(row.LogLikelihood), fit_df)
    elseif sort == "AIC"
        sort!(fit_df, :AIC)
        filter!(row -> !isnan(row.AIC), fit_df)
    else
        error("Invalid sort option: $sort")
    end
    return fit_df
end


"""
    autofit_dist(SampleData; DistFit=nothing, FitLib=nothing, sort="AIC", verbose=false)

Fits a list of candidate distributions to the provided sample data, computes goodness-of-fit statistics,
and returns a DataFrame summarizing the results.

# Arguments
- `SampleData`: Array of sample data.
- `DistFit` (optional): Array of distribution types to attempt (e.g., `[Normal, Gamma, Exponential]`).
  Each element must be a type that is a subtype of `Distribution`. If provided, this overrides `FitLib`.
- `FitLib` (optional): Symbol indicating a predefined library of distributions to use.
  Valid options include `:all`, `:continuous`, or `:discrete`. Defaults to `:continuous` if neither
  `DistFit` nor `FitLib` is provided.
- `sort` (optional): String indicating the criterion to sort the results. Options include `"ad"`, `"ks"`, `"ll"`, or `"AIC"`.
  Defaults to `"AIC"`.
- `verbose` (optional): Boolean flag indicating whether to print warnings for distributions that fail to fit.
  Defaults to `false`.

# Returns
A DataFrame with the following columns:
- `DistName`: The name of the distribution type.
- `ADTest`: Anderson-Darling test statistic.
- `KSTest`: Kolmogorov-Smirnov test statistic.
- `AIC`: Akaike Information Criterion.
- `AICc`: Corrected AIC.
- `LogLikelihood`: Log-likelihood of the fit.
- `FitParams`: The parameters of the fitted distribution.
"""
function autofit_dist(SampleData::AbstractVector;
    DistFit::Union{Nothing,AbstractVector}=nothing,
    FitLib::Union{Nothing,Symbol}=nothing,
    sort::String="AIC",
    verbose::Bool=false)
    # Ensure that only one of DistFit or FitLib is provided.
    if DistFit !== nothing && FitLib !== nothing
        error("Provide either `DistFit` or `FitLib`, but not both.")
    elseif DistFit === nothing && FitLib === nothing
        @info "No `DistFit` or `FitLib` provided, defaulting to FitLib = :all."
        FitLib = :all
    end

    # Dictionary of distribution libraries.
    # The :all key now includes all the distributions you provided.
    # The continuous/discrete subsets below are one possible classification.
    dist_libraries = Dict(
        :all => [Arcsine, Bernoulli, Beta, BetaBinomial, BetaPrime, Binomial, Biweight,
            Categorical, Cauchy, Chernoff, Chi, Chisq, Cosine, DiagNormal, DiagNormalCanon,
            Dirac, DiscreteUniform, DoubleExponential, EdgeworthMean, EdgeworthSum,
            EdgeworthZ, Erlang, Epanechnikov, Exponential, FDist, FisherNoncentralHypergeometric,
            Frechet, FullNormal, FullNormalCanon, Gamma, DiscreteNonParametric,
            GeneralizedPareto, GeneralizedExtremeValue, Geometric, Gumbel, Hypergeometric,
            InverseWishart, InverseGamma, InverseGaussian, IsoNormal, IsoNormalCanon,
            Kolmogorov, KSDist, KSOneSided, Laplace, Levy, LKJ, LocationScale, Logistic,
            LogNormal, LogitNormal, NegativeBinomial, NoncentralBeta, NoncentralChisq,
            NoncentralF, NoncentralHypergeometric, NoncentralT, Normal, NormalCanon,
            NormalInverseGaussian, Pareto, PGeneralizedGaussian, Poisson, PoissonBinomial,
            QQPair, Rayleigh, Semicircle, Skellam, SkewNormal, Soliton, StudentizedRange,
            SymTriangularDist, TDist, TriangularDist, Triweight, Truncated, Uniform,
            UnivariateGMM, VonMises, VonMisesFisher, WalleniusNoncentralHypergeometric,
            Weibull, Wishart, ZeroMeanIsoNormal, ZeroMeanIsoNormalCanon, ZeroMeanDiagNormal,
            ZeroMeanDiagNormalCanon, ZeroMeanFullNormal, ZeroMeanFullNormalCanon],
        :continuous => [Arcsine, Beta, BetaPrime, Cauchy, Chernoff, Chi, Chisq, Cosine,
            DiagNormal, DiagNormalCanon, DoubleExponential, EdgeworthMean,
            EdgeworthSum, EdgeworthZ, Erlang, Epanechnikov, Exponential, FDist,
            FisherNoncentralHypergeometric, Frechet, FullNormal, FullNormalCanon,
            Gamma, DiscreteNonParametric, GeneralizedPareto, GeneralizedExtremeValue,
            Geometric, Gumbel, Hypergeometric, InverseWishart, InverseGamma,
            InverseGaussian, IsoNormal, IsoNormalCanon, Kolmogorov, KSDist,
            KSOneSided, Laplace, Levy, LKJ, LocationScale, Logistic, LogNormal,
            LogitNormal, NegativeBinomial, NoncentralBeta, NoncentralChisq,
            NoncentralF, NoncentralHypergeometric, NoncentralT, Normal, NormalCanon,
            NormalInverseGaussian, Pareto, PGeneralizedGaussian, QQPair, Rayleigh,
            Semicircle, SkewNormal, Soliton, StudentizedRange, SymTriangularDist,
            TDist, TriangularDist, Triweight, Truncated, Uniform, UnivariateGMM,
            VonMises, VonMisesFisher, WalleniusNoncentralHypergeometric, Weibull,
            Wishart, ZeroMeanIsoNormal, ZeroMeanIsoNormalCanon, ZeroMeanDiagNormal,
            ZeroMeanDiagNormalCanon, ZeroMeanFullNormal, ZeroMeanFullNormalCanon],
        :discrete => [Bernoulli, BetaBinomial, Binomial, Categorical, Dirac, DiscreteUniform,
            Poisson, PoissonBinomial, Skellam]
    )

    # Resolve DistFit using FitLib if needed.
    if DistFit === nothing
        if !(FitLib in keys(dist_libraries))
            error("Invalid FitLib: $FitLib")
        end
        DistFit = dist_libraries[FitLib]
    else
        # Verify that each element in DistFit is a type that is a subtype of Distribution.
        for d in DistFit
            if !(d <: Distribution)
                error("Each element in DistFit must be a type that is a subtype of Distribution")
            end
        end
    end

    # Initialize the DataFrame for results.
    fit_df = DataFrame(DistName=String[], ADTest=Float64[], KSTest=Float64[],
        AIC=Float64[], AICc=Float64[], LogLikelihood=Float64[],
        FitParams=Any[])

    for dist in DistFit
        try
            test_fit = fit(dist, SampleData)
            params_fit = params(test_fit)
            n_params = length(params_fit)
            n_obs = length(SampleData)
            ll = Distributions.loglikelihood(test_fit, SampleData)
            aic = 2 * n_params - 2 * ll
            aicc = aic + ((2 * n_params^2 + 2 * n_params) / (n_obs - n_params - 1))

            ad_stat = OneSampleADTest(SampleData, test_fit).A²
            ks_stat = ApproximateOneSampleKSTest(SampleData, test_fit).δ

            push!(fit_df, (string(dist), ad_stat, ks_stat, aic, aicc, ll, params_fit))
        catch e
            if verbose
                @warn "Fitting failed for $(dist): $(e.msg)"
            end
            # Instead of printing chaotic errors, record NaN.
            push!(fit_df, (string(dist), NaN, NaN, NaN, NaN, NaN, []))
        end
    end

    return sort_fit_df!(fit_df, sort)
end



# ----------------------------------------------------------
# EXAMPLES & tests
# ----------------------------------------------------------

## Comparing a fit to sample data visually

#= #Sample Data
using StatsBase, Statistics, Distributions, StatsPlots, Random
Random.seed!(1)
trials = 10_000
SampleData = rand(LogNormal(0.5, 0.5), trials)
dist_array = [Cauchy{Float32}, Normal, Uniform, Poisson, LogNormal]

## Resample Distribution
using StatsBase, Statistics, Distributions, StatsPlots, Random

Random.seed!(1)
resample_array = [12, 12, 23, 98, 37, 55]
test = fit(DiscreteNonParametric, resample_array)
test_sample = rand(test, 1_000)
StatsPlots.histogram(test_sample, label="Non Parametric")
s_curve(test_sample)
histogram_chrt(test_sample) =#