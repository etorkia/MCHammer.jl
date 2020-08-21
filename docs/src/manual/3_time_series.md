# Time-Series Simulation

## Overview
MCH Timeseries contains functions to create simulated times series with MCHammer. Current implementation supports Geometric Brownian Motion, Martingales and Markov Chain Time Series. Other methods will be added.

## Functions
```@setup Stochastic
using Pkg
Pkg.add("Gadfly")
Pkg.add("Distributions")
Pkg.add("StatsBase")
Pkg.add("Statistics")
Pkg.add("Dates")
Pkg.add("MCHammer")
Pkg.add("DataFrames")

using Distributions
using DataFrames
using MCHammer
using Random
using Gadfly
using Compose, Cairo, Fontconfig

BrandShare = [0.1, 0.25, 0.05, 0.35, 0.25]

DrinkPreferences =
[0.6	0.03 0.15 0.2 0.02;
0.02 0.4 0.3 0.2 0.08;
0.15	0.25	0.3 0.25	0.05;
0.15	0.02	0.1	0.7	0.03;
0.15	0.3 0.05	0.05	0.45]

```

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
    using DataFrames
    using Gadfly
end
```
```@docs
GBMMfit
```
```jldoctest GBBMFit
Random.seed!(1)
historical = rand(Normal(10,2.5),1000)
GBMMfit(historical, 12)

# output
12×1 Array{Float64,2}:
 6.6992003689078325
 7.062760356166932
 7.103000620460403
 7.420415139367789
 8.514400412609032
 3.943937898162356
 4.146251875790493
 5.262045352529825
 0.7692838668172376
 1.2648073358011491
 1.5912440333414342
 2.1886864479965875
```
```@docs
GBMM
```
```jldoctest RandWalk
Random.seed!(1)

GBMM(100000, 0.05,0.05,12)

# output

12×1 Array{Float64,2}:
 106486.4399226773
 113846.7611813516
 116137.16176312814
 121883.36579797923
 122864.3632374885
 130918.80622439094
 152488.25443945627
 142827.4651618234
 153753.52041326065
 164757.82535740297
 177804.24203041938
 195258.14301210243
```

```@docs
GBMA_d
```

## Simulating a random walk

```@example Graphing
using Dates, Distributions, DataFrames, MCHammer #hide

ts_trials =[]
dr = collect(Date(2019,1,01):Dates.Month(1):Date(2019,12,31))

#To setup a TimeSeries simulation with MCHammer
for i = 1:1000
     Monthly_Sales = GBMM(100000, 0.05,0.05,12)
     Monthly_Expenses = GBMM(50000, 0.03,0.02,12)
     MonthlyCOGS = Monthly_Sales .* 0.3
     MonthlyProfit = Monthly_Sales - Monthly_Expenses - MonthlyCOGS
     push!(ts_trials, MonthlyProfit)
end

#You can graph the result using trend_chrt()
trend_chrt(ts_trials, dr)
```

# Stochastic Time Series

## Martingales

```@docs
marty
```

For example a gambler with 50$ making wagers of 50$, 10 times using the double or nothing strategy.

```@example Stochastic
marty(50,10)
```

Now let's assume that the gambler knows the odds of winning  at the casino are less than 0.5 and decides to bring additional funds to persist until the bet pays off.

```@example Stochastic
println(marty(50,10; GameWinProb=0.45, CashInHand=400))
```

Using `Gadfly.jl`,  you can compare outcomes at different win probabilities

```@example Stochastic
Exp11 = plot(y = marty(5, 100, GameWinProb = 0.25, CashInHand = 400), Geom.point)
Exp12 = plot(y = marty(5, 100, GameWinProb = 0.33, CashInHand = 400), Geom.point)
Exp13 = plot(y = marty(5, 100, GameWinProb = 0.5, CashInHand = 400), Geom.point)
Exp14 = plot(y = marty(5, 100, GameWinProb = 0.55, CashInHand = 400), Geom.point)

gridstack([Exp11 Exp12; Exp13 Exp14])
```

## Markov Chains
### Analytic Solution
Using linear algebra and matrix math, you can calculate the final state of equilibrium of the Markov Chain directly from the transition matrix.

```@docs
markov_a
```

For example, we want to see how many people will still be married once the Markov chain has stabilized. In the example below we will calculate what is the probability of still being married in 25 or 50 yrs assuming we are still alive.

Lets define the **Marital Status Transition Matrix =  [Single Married Separated Divorced]**

As we can see, from a starting point of 88% of the people who are married, we have a 44% of them are still being married at the end of the process while 47% of the population is divorced.

```@example Stochastic

Marital_StatM = [0.85	0.12	0.02	0.01;
0	0.88	0.08	0.04;
0	0.13	0.45	0.42;
0	0.09	0.02	0.89;
]

markov_a(Marital_StatM)

```

### Times Series (Iterative Approach)
```@docs
markov_ts
```
A large bottling company wants to calculate market share based on clients switching to and from their beverage brands. The transition matrix below represents the probabilities of switching for the company's various beverage type

**Drink Preferences Transition Matrix = [CherryCola DietCola CaffeinFree Classic Zero]**

Assumming that each trial is equal to 1 year, we can calculate the brand shares at different points in time (e.g. 5 or 10 yrs.) using the `markov_ts()`

```@example Stochastic

DrinkPreferences =
[0.6	0.03 0.15 0.2 0.02;
0.02 0.4 0.3 0.2 0.08;
0.15	0.25	0.3 0.25	0.05;
0.15	0.02	0.1	0.7	0.03;
0.15	0.3 0.05	0.05	0.45]

# This array represents the starting brand share. It must total 1.

BrandShare = [0.1, 0.25, 0.05, 0.35, 0.25]

 markov_ts(DrinkPreferences, BrandShare, 10)

```

To visualize the changes in state over time, we can chart the results using `Gadfly.jl`

```@example Stochastic

DrinkPreferences =
[0.6	0.03 0.15 0.2 0.02;
0.02 0.4 0.3 0.2 0.08;
0.15	0.25	0.3 0.25	0.05;
0.15	0.02	0.1	0.7	0.03;
0.15	0.3 0.05	0.05	0.45]

# This array represents the starting brand share. It must total 1.

BrandShare = [0.1, 0.25, 0.05, 0.35, 0.25]

#Organize results using DataFrames for plot
ms = markov_ts(DrinkPreferences, BrandShare, 10)
ms = DataFrame(hcat(transpose(ms), collect(1:10)), [:CherryCola, :DietCola, :CaffeinFree, :Classic, :Zero, :Yr])

#Plot Brandshare over time
plot(stack(ms, Not(:Yr)), x=:Yr, y=:value, color=:variable, Geom.line)
```
