# Simulation Modeling Functions

```@meta
DocTestSetup = quote
    using Pkg
    Pkg.add("Distributions")
    Pkg.add("StatsBase")
    Pkg.add("Statistics")
    Pkg.add("Dates")
    Pkg.add("MCHammer")
    Pkg.add("DataFrames")
    Pkg.add("Gadfly")


    using MCHammer
    using Distributions
    using Random
end
```

## Overview

Though most of your modeling can be realized in raw Julia, some of the most important features in a Monte-Carlo simulation package have to do with analyzing and applying correlation in models. MCHammer's correlation approach is based on *"Ronald L. Iman & W. J. Conover (1982) A distribution-free approach to inducing rank correlation among input variables, Communications in Statistics - Simulation and Computation"*

The simulation and correlation functions are designed to quickly obtain risk and decision analysis metrics such as moments, percentiles and risk over time.

## Risk Events and Conditional Distributions
Risk Events allow you to model a joint distribution accounting for the probability of it occurring and the conditional impact when it does. The process simulates the *Probability x Impact* formula correctly.

```@docs
RiskEvent
```

```@example ConditionalEvent
using MCHammer, Distributions, Random #hide
# Simulate a conditional risk event with a 30% chance of occurring and an impact
# that is distributed along a standard Normal. 10 trials are generated and about
# 3 should have non-zero outcomes.

using MCHammer #hide

RiskEvent(0.3, Normal(0,1), 10)
```

## Correlation and Covariance



```@docs
cormat
```
```jldoctest matrix
Random.seed!(1)
test = rand(Normal(),1000,5)
cormat(test)

# output

5×5 Matrix{Float64}:
  1.0          0.0641469   -0.00164873  -0.0410409    0.0146842
  0.0641469    1.0          0.00569981  -0.00542921  -0.00458057
 -0.00164873   0.00569981   1.0          0.0159979    0.0457586
 -0.0410409   -0.00542921   0.0159979    1.0          0.0358837
  0.0146842   -0.00458057   0.0457586    0.0358837    1.0
```

```@docs
covmat
```
```jldoctest matrix
covmat(test)

# output

5×5 Matrix{Any}:
  1.0567       0.078814     -0.0176948    -0.0372203   0.00640185
  0.078814     1.05362       0.000851738  -0.0255822  -0.00263391
 -0.0176948    0.000851738   1.01647       0.0210734   0.04654
 -0.0372203   -0.0255822     0.0210734     0.995772    0.0418357
  0.00640185  -0.00263391    0.04654       0.0418357   0.977371
```


## Correlating simulation variables
```@docs
corvar
```
```jldoctest correlating_vars
Random.seed!(1)
n_trials = 1000
sample_data = [rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials) rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials)]

test_cmatrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0;0 0 0 1 0.75 -0.7; 0 0 0 0.75 1 -0.95; 0 0 0 -0.7 -0.95 1 ]

cormat(corvar(sample_data, n_trials, test_cmatrix))

# output

6×6 Matrix{Float64}:
  1.0           0.000549289   0.00918833  -0.0312524   -0.0201316  -0.00976841
  0.000549289   1.0           0.00117379  -0.00107629  -0.0425818   0.0372328
  0.00918833    0.00117379    1.0         -0.0048328   -0.0116922   0.0236538
 -0.0312524    -0.00107629   -0.0048328    1.0          0.715437   -0.681833
 -0.0201316    -0.0425818    -0.0116922    0.715437     1.0        -0.949906
 -0.00976841    0.0372328     0.0236538   -0.681833    -0.949906    1.0

```
## Analyzing Simulation Results
```@docs
GetCertainty
```
```jldoctest dist_ex
Random.seed!(1)
test = rand(Normal(),1000)

GetCertainty(test, 0, 1)

# output

0.509
```

```@docs
fractiles
```
```jldoctest dist_ex
fractiles(test)

# output

11×2 Matrix{Any}:
 "P0.0"    -3.2576
 "P10.0"   -1.25856
 "P20.0"   -0.829978
 "P30.0"   -0.517456
 "P40.0"   -0.266082
 "P50.0"    0.024796
 "P60.0"    0.287842
 "P70.0"    0.553121
 "P80.0"    0.907712
 "P90.0"    1.40875
 "P100.0"   4.03504

```

## Misc functions
```@docs
cmd
```
```@docs
truncate_digit
```
```jldoctest truncate
Result_1 = truncate_digit(0.667)
Result_2 = truncate_digit(0.661)
Result_1 == Result_2

# output
true
```
