# Random + Probability Time-Series 

## Overview
MCH Timeseries contains functions to create simulated times series with MCHammer. Current implementation supports Geometric Brownian Motion, Martingales and Markov Chain Time Series. 

```@setup
DocTestSetup = quote
    rng = MersenneTwister(1)
    Random.seed!(1)
    BrandShare = [0.1, 0.25, 0.05, 0.35, 0.25]

    DrinkPreferences =
    [0.6	0.03 0.15 0.2 0.02;
    0.02 0.4 0.3 0.2 0.08;
    0.15	0.25	0.3 0.25	0.05;
    0.15	0.02	0.1	0.7	0.03;
    0.15	0.3 0.05	0.05	0.45]

end
```


## Random Walks (Geometric Brownian Motion)
Geometric Brownian Motion is commonly used for simulating financial time series, such as stock prices. It models continuous price paths where changes follow a log-normal distribution.
```@docs
GBMMfit
```
```@jldoctest GBBMFit
using MCHammer, Random, Distributions
rng = MersenneTwister(1)
Random.seed!(1)
historical = rand(Normal(10,2.5),1000)

GBMMfit(historical, 12; rng=rng)

# output
12×1 Matrix{Float64}:
 7.3005613535018785
 9.941620113944857
 7.103000072680243
 3.5244881063798483
 0.5845383089109127
 0.8153566312249856
 1.072169905405429
 1.0457817586351268
 1.1470926126750904
 0.8738792037186909
 1.0021288627898237
 1.7966621213142604
```
```@docs
GBMM
```
```@jldoctest RandWalk
using MCHammer, Random, Distributions
Random.seed!(1)
rng = MersenneTwister(1)
GBMM(100000, 0.05,0.05,12, rng=rng)

# output
12×1 Matrix{Float64}:
 104315.42290790279
 114538.65544311896
 115918.4421778525
 113954.88460165854
 107025.58832570235
 117985.02450091281
 128814.81609339731
 134829.80326014754
 143300.85485171276
 145928.17297856198
 156063.17236356856
 180291.78429354102
```

```@docs
GBMA_d
```
```@jldoctest RandWalk
using MCHammer, Random #hide
rng = MersenneTwister(1)
Random.seed!(1)
GBMA_d(100, 504,0.03,.3, rng=rng)

# output
88.86175908928719
```

### Simulating a random walk time-series

```@example Graphing
using Dates, MCHammer, Random, Distributions
Random.seed!(1)

ts_trials =[]

#To setup a TimeSeries simulation with MCHammer
for i = 1:1000
     Monthly_Sales = GBMM(100000, 0.05,0.05,12)
     Monthly_Expenses = GBMM(50000, 0.03,0.02,12)
     MonthlyCOGS = Monthly_Sales .* 0.3
     MonthlyProfit = Monthly_Sales - Monthly_Expenses - MonthlyCOGS
     push!(ts_trials, MonthlyProfit)
end

#You can graph the result using trend_chrt()
dr = collect(Date(2025,1,01):Dates.Month(1):Date(2025,12,31))
trend_chrt(ts_trials,dr)
```
## Martingales
A stochastic time-series modeled as a martingale describes a process where each subsequent value's expected future outcome is equal to the current observed value, conditional on the history of all past values. It characterizes a fair, unbiased random walk without drift, commonly applied in scenarios like fair gambling games, financial markets under risk-neutral conditions, or unbiased forecasting models.
```@setup Stochastic
using Dates, MCHammer, Random, Plots, Distributions, DataFrames
theme(:ggplot2)
```

```@docs
marty
```

For example a gambler with 50\$ making wagers of 50\$, 10 times using the double or nothing strategy.

```@example Stochastic
marty(50,10)
```

Now let's assume that the gambler knows the odds of winning  at the casino are less than 0.5 and decides to bring additional funds to persist until the bet pays off.

```@example Stochastic
println(marty(50,10; GameWinProb=0.45, CashInHand=400))
```

Using `Plots.jl`,  you can compare outcomes at different win probabilities

```@example Stochastic
using Plots

# Generate the four plots as scatter plots.
Exp11 = scatter(marty(5, 100, GameWinProb = 0.25, CashInHand = 400), title="GameWinProb = 0.25", label="Bets", markerstrokecolor=:white, markercolor=:lightblue, titlefontsize=10)

Exp12 = scatter(marty(5, 100, GameWinProb = 0.33, CashInHand = 400), title="GameWinProb = 0.33", label="Bets", markerstrokecolor=:white, markercolor=:lightblue, titlefontsize=10)

Exp13 = scatter(marty(5, 100, GameWinProb = 0.5,  CashInHand = 400), title="GameWinProb = 0.5", label="Bets", markerstrokecolor=:white, markercolor=:lightblue, titlefontsize=10)

Exp14 = scatter(marty(5, 100, GameWinProb = 0.55, CashInHand = 400), title="GameWinProb = 0.55", label="Bets", markerstrokecolor=:white, markercolor=:lightblue, titlefontsize=10)

#) Combine them into a 2x2 grid layout.
combined = Plots.plot(Exp11, Exp12, Exp13, Exp14, layout=(2,2), legend=:topleft)

```
---

## Sources & References
- Eric Torkia, Decision Superhero Vol. 2, chapter 7 : SuperPower – Modeling Probability and Random Events, 2025
- Eric Torkia, Decision Superhero Vol. 3, chapter 5 : Predicting 1000 futures, Technics Publishing, 2025
