# Charting Functions

## Overview
MCHammer offers the most important charts for building and analyzing Monte-Carlo Results. `MCH_Charts` contains standard simulation charts for sensitivity, density, trends (time series with confidence bands) for simulation arrays, vectors, and DataFrames.

```@setup Graphing
using Distributions, MCHammer, Random, StatsPlots, Dates
theme(:ggplot2)
```

## Functions

### Density Chart

```@docs
density_chrt
```

```@example Graphing

dist = rand(Normal(), 1000)
density_chrt(dist, "The Standard Normal")
```

### Histogram Chart

```@docs
histogram_chrt
```

```@example Graphing
histogram_chrt(dist, "The Standard Normal")
```

### S-Curve

```@docs
s_curve
```

#### Regular Cumulative Density Function

```@example Graphing
s_curve(dist)
```

#### Reverse Cumulative Density Function

```@example Graphing
s_curve(dist; rev=true)
```

## Sensitivity Chart (Tornado Chart)

Analyzing variables most influential using a tornado sensitivity chart. Here is an example using the simple 3-2-1 profit model.

```@docs
sensitivity_chrt
```

```@example Graphing
using DataFrames, Distributions, Random #hide

# Set trials
n_trials = 1000

# Set inputs
Revenue = rand(TriangularDist(2_500_000, 4_000_000, 3_000_000), n_trials)
Expenses = rand(TriangularDist(1_400_000, 3_000_000, 2_000_000), n_trials)

# Model
Profit = Revenue - Expenses

# Capture results
Trials_df = DataFrame(Profit = Revenue - Expenses, Revenue = Revenue, Expenses = Expenses)

# Chart sensitivity of profit (column 1 in DataFrame)
sensitivity_chrt(Trials_df, 1)
```

## Trend Charts

### Probabilistic Line Chart and Time Series Charts

```@docs
trend_chrt
```

```@example Graphing
ts_trials = []

# Setup a TimeSeries simulation with MCHammer over 12 periods
for i in 1:1000
    Monthly_Sales = GBMM(100_000, 0.05, 0.05, 12)
    Monthly_Expenses = GBMM(50_000, 0.03, 0.02, 12)
    MonthlyCOGS = Monthly_Sales .* 0.3
    MonthlyProfit = Monthly_Sales - Monthly_Expenses - MonthlyCOGS
    push!(ts_trials, MonthlyProfit)
end

trend_chrt(ts_trials, x_label="last 12 months")
```

#### Using Dates for X-axis

To replace periods with a series of dates:

```@example Graphing
dr = collect(Date(2019,1,1):Dates.Month(1):Date(2019,12,1))
trend_chrt(ts_trials, dr, x_label="last 12 months")
```

## Sources & References
Eric Torkia, Decision Superhero Vol. 2, chapter 3 : Superpower: Modeling the Behaviors of Inputs, Technics Publishing, 2025
Available on Amazon : https://a.co/d/4YlJFzY . Volumes 2 and 3 to be released in Spring and Fall 2025.