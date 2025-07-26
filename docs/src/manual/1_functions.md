# Simulation Modeling Functions

## Overview

Though most of your modeling can be done directly in raw Julia, some of the most important features in a Monte-Carlo simulation package involve analyzing and applying correlation in models. MCHammer's correlation approach is based on:

> Ronald L. Iman & W. J. Conover (1982) A distribution-free approach to inducing rank correlation among input variables, Communications in Statistics - Simulation and Computation

The simulation and correlation functions are designed to quickly obtain risk and decision analysis metrics, such as moments, percentiles, and risk over time.

## Risk Events and Conditional Distributions
Risk Events allow you to model a joint distribution accounting for the probability of an event occurring and the conditional impact when it does. The process simulates the *Probability x Impact* formula correctly.

```@docs
RiskEvent
```

```@example ConditionalEvent
using MCHammer, Distributions, Random #hide
# Simulate a conditional risk event with a 30% chance of occurring and an impact
# that is distributed according to a standard Normal. 10 trials are generated and
# about 3 should have non-zero outcomes.

using MCHammer #hide

RiskEvent(0.3, Normal(0,1), 10)
```
## Correlation and Covariance
Correlation and covariance functions help you understand relationships between different simulation inputs. In practical modeling:
- **Use Cases**: Assess which variables move together (positive/negative correlation) to reduce or amplify overall risk.
- **Applications**: Finance (portfolio risk), engineering (linked component failures), supply chain planning (demand and lead-time co-fluctuation).
```@docs
cormat
```
```@jldoctest matrix
using Distributions, MCHammer, Random #hide
rng = MersenneTwister(1)
Random.seed!(1)
test = rand(Normal(), 1000, 5)
cormat(test)

# output

5×5 Matrix{Float64}:
  1.0         0.0262401  -0.0119314    0.0386272   -0.0755551
  0.0262401   1.0        -0.0118889    0.0137545   -0.0305986
 -0.0119314  -0.0118889   1.0         -0.00762943  -0.0264234
  0.0386272   0.0137545  -0.00762943   1.0         -0.00137442
 -0.0755551  -0.0305986  -0.0264234   -0.00137442   1.0
```
```@docs
covmat
```
```@jldoctest matrix
using Distributions, MCHammer, Random #hide
rng = MersenneTwister(1)
Random.seed!(1)
test = rand(Normal(), 1000, 5)
covmat(test)

# output
5×5 Matrix{Any}:
  1.01123      0.0293154    0.00167811   0.0401224   -0.0820211
  0.0293154    1.11648     -0.00357405   0.0142628   -0.032553
  0.00167811  -0.00357405   1.05398     -0.0033127   -0.0285162
  0.0401224    0.0142628   -0.0033127    0.872718    -0.00241684
 -0.0820211   -0.032553    -0.0285162   -0.00241684   1.01745
```

## Correlating Simulation Variables

`corvar` adjusts your simulated datasets to match a desired correlation matrix. In modeling:

- **Use Cases**: Forces scenario data to reflect real-world or hypothesized correlations, ensuring valid joint distributions.
- **Applications**: Stress tests in finance, correlated risk analysis (e.g., hurricane + flood), and multivariate forecasting.

```@docs
corvar
```
```@jldoctest correlating_vars
using Distributions, MCHammer, Random #hide
rng = MersenneTwister(1)
Random.seed!(1)
n_trials = 1000
sample_data = [rand(rng, LogNormal(0, 0.5), n_trials) rand(rng, Normal(3,2), n_trials) rand(rng, Gamma(1, 0.5), n_trials) rand(rng, LogNormal(0, 0.5), n_trials) rand(rng, Normal(3,2), n_trials) rand(rng, Gamma(1, 0.5), n_trials)]

test_cmatrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0;0 0 0 1 0.75 -0.7; 0 0 0 0.75 1 -0.95; 0 0 0 -0.7 -0.95 1 ]

cormat(corvar(sample_data, n_trials, test_cmatrix))

# output

6×6 Matrix{Float64}:
  1.0         0.0262401  -0.0119314    0.0386272   -0.0295832   0.034389
  0.0262401   1.0        -0.0118889    0.0137545   -0.0160956   0.0147439
 -0.0119314  -0.0118889   1.0         -0.00762943  -0.0242712   0.0420867
  0.0386272   0.0137545  -0.00762943   1.0          0.713931   -0.659495
 -0.0295832  -0.0160956  -0.0242712    0.713931     1.0        -0.939242
  0.034389    0.0147439   0.0420867   -0.659495    -0.939242    1.0
```
## Analyzing Simulation Results
Result analysis functions like `GetCertainty` and `fractiles` help interpret simulation outputs:
- **Use Cases**: Identify probability of crossing thresholds (e.g., "chance of negative profit"), or measure percentile-based risk.
- **Applications**: Cost-risk analysis, reliability engineering, or performance metrics (min, max, median) in uncertain environments.
```@docs
GetCertainty
```
```@jldoctest dist_ex
using Random, MCHammer, Distributions #hide
rng = MersenneTwister(1)
Random.seed!(1)
test = rand(Normal(), 1000)

GetCertainty(test, 0, 1)

# output

0.528
```
```@docs
fractiles
```
```@jldoctest dist_ex
using Random, MCHammer, Distributions #hide
rng = MersenneTwister(1)
Random.seed!(1)
test = rand(Normal(), 1000)

fractiles(test)

# output

11×2 Matrix{Any}:
 "P0.0"    -2.95049
 "P10.0"   -1.30285
 "P20.0"   -0.834923
 "P30.0"   -0.472307
 "P40.0"   -0.227086
 "P50.0"    0.0882202
 "P60.0"    0.319301
 "P70.0"    0.579717
 "P80.0"    0.873708
 "P90.0"    1.29457
 "P100.0"   2.97612
```
## Misc Functions
These utility functions provide convenience in data cleanup and quick calculation:
- **Use Cases**: Scripting and reporting automation where formatting or command line interactions are needed.
- **Applications**: Rounding values for dashboards, truncating decimal places in sensitivity outputs, or running shell commands mid-simulation.

```@docs
cmd
```

```@docs
truncate_digit
```
```@jldoctest truncate
using Random, MCHammer #hide
Result_1 = truncate_digit(0.667)
Result_2 = truncate_digit(0.661)
Result_1 == Result_2

# output

true
```

## Sources & References
- Eric Torkia, Decision Superhero Vol. 2, chapter 5 : Predicting 1000 futures, Technics Publishing 2025
- Available on Amazon : https://a.co/d/4YlJFzY . Volumes 2 and 3 to be released in Spring and Fall 2025.
