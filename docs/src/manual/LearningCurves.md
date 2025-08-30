# Learning Curve Modeling Approaches

```@setup LCs
using DataFrames, Distributions, Random, Plots
using MCHammer
```

Learning curves are mathematical models predicting improvements in productivity and efficiency as experience with a task increases. These curves are essential tools for:

- Estimating project costs and timelines.
- Analyzing historical data for efficiency trends.
- Forecasting and decision-making.

The following documentation covers three popular methods implemented using Julia with multiple dispatch:

## Learning Curve Methods

The learning curve methods are implemented as an abstract type hierarchy:

- `LearningCurveMethod`: Abstract base type
- `WrightMethod`: Wright's cumulative-average model
- `CrawfordMethod`: Crawford's unit-time model  
- `ExperienceMethod`: Experience curve model

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
# compute the cumulative total cost for 500 units with a progress ratio of 0.85
result = lc_analytic(WrightMethod(), 200, 500, 0.85)
println(result)
```

### Crawford Learning Curve


```@example LCs
# compute the cumulative total cost for 500 units with a progress ratio of 0.85
result = lc_analytic(CrawfordMethod(), 200, 500, 0.85)
println(result)
```

### Experience Curve


```@example LCs
# compute the cumulative total cost for 500 units with a progress ratio of 0.85
result = lc_analytic(ExperienceMethod(), 200, 500, 0.85)
println(result)
```

## Curve Functions

Generates detailed DataFrame including cumulative, incremental, and average costs.

```@docs 
lc_curve
```
### Wright Learning Curve
Generate a table of cumulative and per‑unit costs for Wright’s model using initial cost $200, from unit 1 to 500, progress ratio 0.85, sampling every 25 units

```@example LCs
df = lc_curve(WrightMethod(), 200, 1, 500, 0.85; steps=25)
println(first(df, 5))
```
### Crawford Learning Curve
Generate a table of cumulative and per‑unit costs for Crawford’s model using initial cost $200, from unit 1 to 500, progress ratio 0.85, sampling every 25 units

```@example LCs
df = lc_curve(CrawfordMethod(), 200, 1, 500, 0.85; steps=25)
println(first(df, 5))
```
### Experience Curve
Generate a table of cumulative and per‑unit costs for the Experience model using initial cost $200, from unit 1 to 500, progress ratio 0.85, sampling every 25 units

```@example LCs
df = lc_curve(ExperienceMethod(), 200, 1, 500, 0.85; steps=25)
println(first(df, 5))
```


## Analysis Functions

### Fitting Functions

```@docs
lc_fit
```

**Example:**

The function `lc_fit` estimates the slope ``b`` and progress ratio ``p = 2^b``
from two observations.  Given two points at units ``n_1`` and ``n_2`` with
corresponding costs ``x_1`` and ``x_2``, we can estimate ``b`` and ``p`` for
any of the learning‑curve methods.  The following example uses the same
data for Wright, Crawford and Experience models. Though the results are identical, the derivations are different.

```@example LCs
# two observation points
n1, x1 = 8, 200.0
n2, x2 = 32, 140.0

# estimate (b, progress ratio) for each method using the same inputs
(b_w, L_w) = lc_fit(WrightMethod(),    n1, x1, n2, x2)
(b_c, L_c) = lc_fit(CrawfordMethod(),  n1, x1, n2, x2)
(b_e, L_e) = lc_fit(ExperienceMethod(),n1, x1, n2, x2)

((b_w, L_w), (b_c, L_c), (b_e, L_e))
```

### Learning Rate Estimation

Estimates learning rates using Wright's method from two data points.

```@docs
learn_rate
```


```@example LCs
rate = learn_rate(WrightMethod(), 1, 2000, 144, 1600)
println(rate)
```

### Comparison Utility

Compares learning curves across a range of learning rates.

```@docs
learn_rates
```

**Example:**
```@example LCs
rates_df = learn_rates(100, 500; α_step=0.05)
println(first(rates_df, 5))
```

## Picking the right curve

Sometimes picking the right curve is challenging and in these cases plotting a comparison of average costs across methods using `Plots.jl` can be very helpful.

```@example LCs
# Generate sample tables for each method and plot the average cost across units.
CC = lc_curve(CrawfordMethod(), 50, 1, 1000, 0.85; steps=25)
WC = lc_curve(WrightMethod(), 50, 1, 1000, 0.85; steps=25)
EC = lc_curve(ExperienceMethod(), 50, 1, 1000, 0.85; steps=25)

# Combine the results
GraphResults = vcat(CC, WC, EC)
first(GraphResults,5)
```

# Create and display the plot
```@example LCs
using Plots
plot(GraphResults.Units, GraphResults.AvgCost, group=GraphResults.Method,
           xlabel="Units", ylabel="Average Cost per Unit", 
           title="Learning Curves Comparison",
           lw=2, legend=:topright)
```

## Mathematical Notes

**Symbols:**
- α: learning exponent (progress ratio = $2^{b}$)
- N: number of units

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
