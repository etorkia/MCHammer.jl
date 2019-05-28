# Simulation Modeling Functions

## Overview

Though most of your modeling can be realized in raw Julia, some of the most important features in a Monte-Carlo simulation package have to do with analyzing and applying correlation in models. MCHammer's correlation approach is based on *"Ronald L. Iman & W. J. Conover (1982) A distribution-free approach to inducing rank correlation among input variables, Communications in Statistics - Simulation and Computation"*

The simulation and correlation functions are designed to quickly obtain risk and decision analysis metrics such as moments, percentiles and risk over time.

## Functions

```@meta
DocTestSetup = quote
    using MCHammer
    using Distributions
    using Random
end
```

```@docs
cormat
```
```jldoctest matrix
Random.seed!(1) #hide
test = rand(Normal(),1000,5)
cormat(test)

# output

5×5 Array{Float64,2}:
  1.0         0.045012   0.00247197  -0.0455839   0.0126131
  0.045012    1.0        0.0534       0.0449149   0.0219751
  0.00247197  0.0534     1.0          0.0194396   0.0504692
 -0.0455839   0.0449149  0.0194396    1.0        -0.0301272
  0.0126131   0.0219751  0.0504692   -0.0301272   1.0
```

```@docs
covmat
```
```jldoctest matrix
covmat(test)

# output

5×5 Array{Any,2}:
  1.00069    0.0286309  0.0102903  -0.0356815   0.0132867
  0.0286309  1.09233    0.0598539   0.0536936   0.0216141
  0.0102903  0.0598539  1.07241     0.0140108   0.0583517
 -0.0356815  0.0536936  0.0140108   0.942015   -0.0240827
  0.0132867  0.0216141  0.0583517  -0.0240827   1.02767
```

```@docs
corvar
```
```jldoctest
Random.seed!(1)
n_trials = 1000
sample_data = [rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials) rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials)]

test_cmatrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0;0 0 0 1 0.75 -0.7; 0 0 0 0.75 1 -0.95; 0 0 0 -0.7 -0.95 1 ]

Random.seed!(1)
cormat(corvar(sample_data, n_trials, test_cmatrix))

# output

6×6 Array{Float64,2}:
  1.0          0.045012    0.00247197  -0.0455839  -0.0138308   0.0112554
  0.045012     1.0         0.0534       0.0449149   0.0592791  -0.0355262
  0.00247197   0.0534      1.0          0.0194396   0.0532426  -0.0468971
 -0.0455839    0.0449149   0.0194396    1.0         0.719585   -0.662708
 -0.0138308    0.0592791   0.0532426    0.719585    1.0        -0.939008
  0.0112554   -0.0355262  -0.0468971   -0.662708   -0.939008    1.0
```

```@docs
GetCertainty
```
```jldoctest dist_ex
Random.seed!(1)
test = rand(Normal(),1000)

GetCertainty(test, 0, 1)

# output

0.502
```

```@docs
fractiles
```
```jldoctest dist_ex
fractiles(test)

# output

11×2 Array{Any,2}:
 "P0.0"    -3.882
 "P10.0"   -1.34325
 "P20.0"   -0.860748
 "P30.0"   -0.526089
 "P40.0"   -0.274806
 "P50.0"    0.00474446
 "P60.0"    0.218685
 "P70.0"    0.472055
 "P80.0"    0.800966
 "P90.0"    1.2504
 "P100.0"   3.12432
```

```@docs
cmd
```
```@docs
truncate_digit
```
```jldoctest
Result_1 = truncate_digit(0.667)
Result_2 = truncate_digit(0.661)
Result_1 == Result_2

# output
true
```
