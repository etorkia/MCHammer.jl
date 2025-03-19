# Function Tests for Distribution Fitting Functions

## Distribution Fitting

Distribution fitting is the process of selecting and parameterizing a probability distribution that best describes observed data. Analysts accomplish this by comparing empirical data against theoretical distributions, adjusting parameters to minimize discrepancies. Methods often include statistical tests (e.g., Kolmogorov-Smirnov, Anderson-Darling), visual assessments (e.g., histograms, Q-Q plots), and numerical criteria (e.g., AIC, BIC, or log-likelihood).

### Practical Applications for Analysts

Distribution fitting is foundational for analysts across various fields:

- **Risk Management & Finance:**  
  Analysts fit distributions to asset returns or operational loss data to estimate Value at Risk (VaR), conduct stress testing, and manage financial risks.

- **Reliability Engineering:**  
  By fitting failure-time data (such as machine lifetimes) to distributions like Weibull or Lognormal, analysts predict product lifespan and develop appropriate maintenance schedules.

- **Quality Control:**  
  Analysts use fitted distributions to monitor manufacturing processes, identifying deviations from expected behaviors to maintain quality standards.

- **Environmental Modeling:**  
  Distribution fitting helps predict extreme weather events, flood frequency, and environmental risks by modeling historical weather data or natural phenomena.

- **Decision Analysis & Simulation:**  
  Analysts model uncertainty in decision-making contexts by fitting distributions to historical data, enabling realistic simulations (e.g., Monte Carlo simulations) for strategic planning.

### Caveats of Fitting Distributions Empirically

Despite its usefulness, empirical distribution fitting has important limitations:

- **Data Quantity and Quality:**  
  Small or noisy datasets may lead to unstable parameter estimates, resulting in unreliable conclusions.

- **Outliers and Extreme Values:**  
  Extreme observations can significantly influence the fitted distribution parameters, potentially distorting insights unless handled appropriately.

- **Overfitting Risk:**  
  Analysts might select overly complex distributions that closely fit historical data but generalize poorly to new observations, limiting predictive power.

- **Misinterpretation of Statistical Tests:**  
  Statistical tests like Kolmogorov-Smirnov or Anderson-Darling can indicate a good fit even when practical considerations (such as data context) suggest otherwise, or vice versa.

- **Subjective Judgment:**  
  Empirical fitting often requires subjective judgment when choosing between multiple similarly good fits, potentially introducing bias or inconsistency.

### Importance of Selecting Appropriate Distributions Beforehand

Understanding appropriate theoretical distributions prior to analysis is crucial:

- **Domain Knowledge:**  
  Analysts familiar with the underlying process or theoretical context of the data (e.g., finance, engineering, biology) can immediately focus on distributions that are known to realistically model the phenomena.

- **Statistical Properties:**  
  Different distributions have distinct properties such as skewness, kurtosis, tail heaviness, and bounds. Analysts must select distributions that inherently align with these features of the data.

- **Avoiding Mis-Specification:**  
  Selecting inappropriate distributions can lead to misinterpretation of risk, poor resource allocation, or misguided policy decisions. Knowledgeable selection beforehand reduces the likelihood of such errors.

- **Interpreting Results:**  
  Using contextually appropriate distributions enhances the interpretability of model parameters, helping stakeholders more clearly understand risks, probabilities, and implications of the analysis.

When used carefully, distribution fitting is a valuable analytical tool enabling informed decision-making under uncertainty. However, analysts must carefully consider data quality, model complexity, and theoretical context to ensure robust, meaningful insights from their fitted distributions.

## Functions for analyzing and fitting distributions

- [Visualizing Fits: `viz_fit`](#viz_fit)
- [Descriptive Fit Statistics: `fit_stats`](#fit_stats)
- [Automatic Distribution Fitting: `autofit_dist`](#autofit_dist)
---

```@meta
DocTestSetup = quote
    using Pkg
    Pkg.add("Distributions")
    Pkg.add("StatsBase")
    Pkg.add("StatsAPI")
    Pkg.add("Statistics")
    Pkg.add("Dates")
    Pkg.add("DataFrames")
    Pkg.add("Plots")

    using Distributions
    using StatsBase, Statistics, StatsAPI
    using Random
    using DataFrames
    using Plots
    using Dates
    rng = MersenneTwister(1)
    
```

## viz_fit

```@docs
viz_fit
```
```jldoctest viz_fit

# Generate sample data from a Normal distribution
Random.seed!(42)
sample_data = rand(Normal(0, 1), 1000)
viz_fit(sample_data)

# output
Normal{Float64}(μ=-0.06011369418452059, σ=0.9867066446571413)
LogNormal does not work - pick another candidate
Uniform{Float64}(a=-2.850847138573644, b=3.092335453036495)
```

## fit_stats

```@docs
fit_stats
```
```jldoctest fit_stats
# Generate sample data from a LogNormal distribution
Random.seed!(42)
sample_data = rand(LogNormal(0, 1), 1000)
fit_stats(sample_data)

# output
22×5 DataFrame
 Row │ Name                Sample Data  Normal      LogNormal  Uniform   
     │ Any                 Any          Any         Any        Any       
─────┼───────────────────────────────────────────────────────────────────
   1 │ Mean                1.52063      1.52063     1.53291    11.0431
   2 │ Median              0.956697     1.52063     0.941657   11.0431
   3 │ Mode                0.695338     1.52063     0.355341   11.0431
   4 │ Standard_Deviation  1.85148      1.85055     1.96907    6.34239
   5 │ Variance            3.42797      3.42454     3.87723    40.2259
   6 │ Skewness            4.24973      0.0         5.97307    0.0
   7 │ Kurtosis            30.1931      0.0         101.604    -1.2
   8 │ Coeff_Variation     1.21757      1.21696     1.28453    0.574329
   9 │ Minimum             0.0577953    -Inf        0.0        0.0577953
  10 │ Maximum             22.0285      Inf         Inf        22.0285
  11 │ MeanStdError        0.0585489    NaN         NaN        NaN
  12 │ 0.0                 0.0577953    -Inf        0.0        0.0577953
  13 │ 10.0                0.255968     -0.850948   0.265733   2.25486
  14 │ 20.0                0.407048     -0.0368346  0.410261   4.45193
  15 │ 30.0                0.569005     0.550199    0.56113    6.649
  16 │ 40.0                0.755634     1.0518      0.733287   8.84606
  17 │ 50.0                0.956697     1.52063     0.941657   11.0431
  18 │ 60.0                1.20084      1.98946     1.20924    13.2402
  19 │ 70.0                1.62215      2.49106     1.58024    15.4373
  20 │ 80.0                2.22462      3.07809     2.16135    17.6343
  21 │ 90.0                3.37068      3.89221     3.33687    19.8314
  22 │ 100.0               22.0285      Inf         Inf        22.0285
```

## autofit_dist

```@docs
autofit_dist
```
```jldoctest autofit_dist
Random.seed!(42)
sample_data = rand(LogNormal(0, 1), 1000)
autofit_dist(sample_data)

# output

13×7 DataFrame
 Row │ DistName                      ADTest      KSTest     AIC       AICc      LogLikelihood  FitParams                         
     │ String                        Float64     Float64    Float64   Float64   Float64        Any
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ LogNormal                       0.214931  0.0158499   2694.89   2694.9        -1345.44  (-0.0601137, 0.9872)
   2 │ InverseGaussian                 3.71398   0.0561168   2724.91   2724.92       -1360.45  (1.52063, 0.938592)
   3 │ Gamma                           9.73695   0.0766574   2825.48   2825.49       -1410.74  (1.18215, 1.28633)
   4 │ Exponential                    10.8273    0.0653088   2840.25   2840.25       -1419.12  (1.52063,)
   5 │ Weibull                        10.324     0.0664369   2840.86   2840.87       -1418.43  (1.02719, 1.54015)
   6 │ Cauchy                         39.889     0.211156    3352.57   3352.59       -1674.29  (0.956697, 0.702138)
   7 │ Laplace                        48.0785    0.207575    3431.8    3431.81       -1713.9   (0.956697, 1.02097)
   8 │ Pareto                        Inf         0.323936    3936.38   3936.39       -1966.19  (0.358329, 0.0577953)
   9 │ Normal                         86.8675    0.214622    4072.84   4072.86       -2034.42  (1.52063, 1.85055)
  10 │ Rayleigh                      418.213     0.380772    4229.75   4229.76       -2113.88  (1.69364,)
  11 │ Uniform                       Inf         0.753007    6183.42   6183.43       -3089.71  (0.0577953, 22.0285)
  12 │ Categorical{P} where P<:Real  Inf         0.001      13819.5   13819.5        -6907.76  ([0.0577953, 0.0640543, 0.064986…
  13 │ DiscreteNonParametric         Inf         0.001      13819.5   13819.5        -6907.76  ([0.0577953, 0.0640543, 0.064986…
```