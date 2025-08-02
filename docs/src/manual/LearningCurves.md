# Learning Curve Modeling Approaches

```@setup LCs
using MCHammer, DataFrames, Distributions, Random, Plots
```

Learning curves are mathematical models predicting improvements in productivity and efficiency as experience with a task increases. These curves are essential tools for:

- Estimating project costs and timelines.
- Analyzing historical data for efficiency trends.
- Forecasting and decision-making.

The following documentation covers three popular methods implemented using Julia with multiple dispatch:

## Learning Curve Methods

```julia
abstract type LearningCurveMethod end
    struct WrightMethod <: LearningCurveMethod end
    struct CrawfordMethod <: LearningCurveMethod end
    struct ExperienceMethod <: LearningCurveMethod end
```

### Wright's Curve

```@docs
WrightMethod 
```

### Crawford's Curve

```@docs
CrawfordMethod 
```

### Experience Curve

```@docs
ExperienceMethod
```

## Cumulative Cost Analysis

To compute cumulative cost analytically for an experience curve, here are the functions to accomplish this.

### Wright Learning Curve


```@example LCs
result = lc_analytic(WrightMethod(), 200, 500, 0.85)
println(result)
```

### Crawford Learning Curve


```@example LCs
result = lc_analytic(CrawfordMethod(), 150, 400, 0.75)
```

### Experience Curve


```@example LCs
result = lc_analytic(ExperienceMethod(), 100, 1000, 0.8)
```

## Curve Functions

Generates detailed DataFrame including cumulative, incremental, and average costs.

```@docs 
lc_curve
```


```@example LCs
df = lc_curve(WrightMethod(), 200, 1, 500, 100; steps=25)
println(first(df, 5))
```

## Analysis Functions

### Fitting Functions

```@docs
lc_fit
```

**Example:**

```julia
lc_fit(::ExperienceMethod, InitialEffort, Units; EstLC=0.8)
lc_fit(::CrawfordMethod, InitialEffort, Units; EstLC=0.8)
lc_fit(::WrightMethod, InitialEffort, Units; EstLC=0.8)
```


```@example LCs
best_fit = lc_fit(CrawfordMethod(), 150, 400; EstLC=0.75)
```

### Learning Rate Estimation

Estimates learning rates using Wright's method from two data points.

```@docs
learn_rate
```


```@example LCs
rate = learn_rate(WrightMethod(), 1, 2000, 144, 8000)
println(rate)
```

### Comparison Utility

Compares learning curves across a range of learning rates.

```@docs
learn_rates
```

**Example:**
```@example LCs
rates_df = learn_rates(100, 500; LC_Step=0.05)
println(first(rates_df, 5))
```

## Picking the right curve

Sometimes picking the right curve is challenging and in these cases plotting a comparison of average costs across methods using `Plots.jl` can be very helpful.

```@example LCs
using DataFrames
using Plots

# Using the correct function signature for the current implementation
# Two-point fitting approach: x1 at n1, x2 at n2

# Example data points for each method

CC = lc_curve(CrawfordMethod(), 50, 1, 1000, 25; steps=50)
CC.Method = fill("Crawford", nrow(CC))

WC = lc_curve(WrightMethod(), 50, 1, 1000, 25; steps=50)
WC.Method = fill("Wright", nrow(WC))

EC = lc_curve(ExperienceMethod(), 50, 1, 1000, 25; steps=50)
EC.Method = fill("Experience", nrow(EC))

GraphResults = vcat(CC, WC, EC)

plot(GraphResults.Units, GraphResults.Time, group=GraphResults.Method,
    xlabel="Units", ylabel="Time per Unit", title="Learning Curves Comparison",
    lw=2, legend=:topright)
```

## Mathematical Notes

- `$\alpha$`: learning exponent (progress ratio = $2^b$)
- $N$: number of units

**Wright's Law (Cumulative Average Model):**

```math
\text{Cumulative Average Cost}_N = \text{Initial} \times N^{-\alpha}
```

**Crawford's Law (Unit Cost Model):**

```math
\text{Unit Cost}_N = \text{Initial} \times N^{-\alpha}
```

**Experience Curve:**

```math
\text{Cost}_N = \text{Initial} \times N^{-\alpha}
```

## Sources & References

- Eric Torkia, Decision Superhero Vol. 2, chapter 6 : SuperPower: The Laws of Nature that Predict, Technics Publishing, 2025
- Available on Amazon : https://a.co/d/4YlJFzY . Volumes 2 and 3 to be released in Spring and Fall 2025.
- Wright, T.P. (1936). *Factors Affecting the Cost of Airplanes*. Journal of the Aeronautical Sciences, 3(4), 122–128.
- Henderson, B.D. (1973). *Industrial Experience, Technology Transfer, and Cost Behavior*. Harvard Business School Working Paper.
- Crawford, D. (1982). *Learning Curves: Theory and Practice*. Journal of Cost Analysis.
