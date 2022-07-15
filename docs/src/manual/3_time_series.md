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
using TimeSeries, Dates
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
    using Dates
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
12×1 Matrix{Float64}:
12×1 Matrix{Float64}:
14.9841041471206
13.173975261845019
 5.583633586576405
 7.6339649415704285
 1.9828532914096435
 1.7098509331782616
 1.4736020097212592
 0.8039772093974257
 0.3910586242984384
 0.40850588933635484
 0.1610792608898977
 0.16589444773512724
```
```@docs
GBMM
```
```jldoctest RandWalk
Random.seed!(1)

GBMM(100000, 0.05,0.05,12)

# output
12×1 Matrix{Float64}:
 104647.08430523051
 112660.31315346305
 113748.31702531039
 133409.66433589451
 147850.42050983387
 157220.91712571305
 178838.2719844225
 180393.97903114106
 180008.3650923122
 186046.44107246998
 190862.7004979811
 211688.13727362957
```

```@docs
GBMA_d
```

## Simulating a random walk

```@setup Graphing
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
using TimeSeries, Dates
using Compose, Cairo, Fontconfig

```@example Graphing

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
dr = collect(Date(2019,1,01):Dates.Month(1):Date(2019,12,31))
trend_chrt(ts_trials, collect(Date(2019,1,01):Dates.Month(1):Date(2019,12,31)))
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
### Exponential Smoothing Methods
Exponential smoothing has proven as one of the best naïve forecasting methods around. Though there are 4 methods out there, we will cover simple, double and triple (a.k.a Holt-Winters Seasonal Method) exponential smoothing.

##Simple Exponetial Smoothing.
The basic idea behind ES (Exponential Smoothing) is to give more weight to recent observations over older ones. As the name implies, this method projects provides a smoothed forecast for each historical observations. Originally developed during the Second World War to predict tank positions, it was deemed very accurate for other applications.

```@docs
ESmooth
```

```@setup ES
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
using TimeSeries, Dates
using Compose, Cairo, Fontconfig
```

```@example ES
HistoricalSeries = [3,10,12,13,12,10,12] # results [803.0, 957.8, 900.38, 828.938, 842.4938,  886.14938, 927.414938, 888.3414938]
alpha = 0.9

ESmooth(HistoricalSeries, alpha; forecast_only=false)

```
## Double Exponential Smoothing
The difference between single and double exponential smoothing is easily explained byduck hunting. In single exponential smoothing we are essentially pointing the gun where we think the duck will be and not where it is. In a double exponential smoothing situation imagine the duck shoots back! For this reason, we can predict one period out using this method. Being the crafty programmers that we are, we extended the method so that you can predict further out but you will realize that in reality the forecast stabilizes after the first period.

```@docs
ESmooth2x
```

```@docs
ESFore2x
```

```@example ES
HistoricalSeries = [30,21,29,31,40,48,53,47,37,39,31,29,17,9,20,24,27,35,41,38,
          27,31,27,26,21,13,21,18,33,35,40,36,22,24,21,20,17,14,17,19,
          26,29,40,31,20,24,18,26,17,9,17,21,28,32,46,33,23,28,22,27,
          18,8,17,21,31,34,44,38,31,30,26,32]

periods = 4
alpha = 0.9
beta = 0.1

ESFore2x(HistoricalSeries, alpha, beta, periods)
```

## Triple Exponential Smoothing (Holt-Winters Multiplicative Method)
If the historical data has some seasonal patterns in it, we can use the Holt-Winters Multiplicative. This function is most effective when combined with the auto fitting function like in the example below.

```@docs
ES3xFit
```

```@docs
ESFore3x
```


```@example ES
fit = ES3xFit(HistoricalSeries, 12, 100_000)
ForecastSeries = ESFore3x(HistoricalSeries, 12, fit[1], fit[2], fit[3], 24)
frct = layer(y=ForecastSeries, Geom.line, Theme(default_color="red"))
hist = layer(y=HistoricalSeries, Geom.line)
plot(hist,frct)
```

## Simulating forecast using historical uncertainty

Because most models we work on are probabilistic, we can apply the Rand Walk approach to the predicted time series to get a stochastic result over time.

```@docs
ForecastUncertainty
```
```@example ES
@time fit = ES3xFit(HistoricalData, 12, 100_000)
ForecastSeries = ESFore3x(HistoricalData, 12, fit[1], fit[2], fit[3], 24; forecast_only=true)
SimResults = []

for i = 1:10000
    Uncertainty = ForecastUncertainty(HistoricalData, 24)
    TrialFrct = ForecastSeries .* Uncertainty
    push!(SimResults, TrialFrct)
end


#set the date range for the trend chart and generate plot
dr = collect(Date(2019,1,01):Dates.Month(1):Date(2020,12,31))
trend_chrt(SimResults, dr)
```
