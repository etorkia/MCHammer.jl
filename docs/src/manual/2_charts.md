# Charting Functions

## Overview
MCHammer offers the most important charts for building and analyzing Monte-Carlo Results. MCH_Charts contains standard simulation charts for sensitivity, density, trends (time series with confidence bands) for simulation arrays, vectors and dataframes.

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
using Dates
```
## Functions
```@docs
density_chrt
```
```@example Graphing
dist = rand(Normal(),1000)
density_chrt(dist, "The Standard Normal")
```
```@docs
histogram_chrt
```
```@example Graphing
histogram_chrt(dist, "The Standard Normal")
```
```@docs
s_curve
```
# Regular Cumulative Density Function
```@example Graphing
s_curve(dist)
```
# Reverse Cumulative Density Function
```@example Graphing
s_curve(dist; rev=true)
```
## Analyzing which variables are most influential using a tornado sensitivity chart
To illustrate the chart we are using the simple 3-2-1 profit model example.
```@docs
sensitivity_chrt
```
```@example Graphing
#Set trials
n_trials = 1000

#Set inputs
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)

#Model
Profit = Revenue - Expenses

#Capture results
Trials_df = DataFrame(Profit = Revenue-Expenses, Revenue = Revenue, Expenses = Expenses)

#Chart sensitivity of profit (column 1 in DataFrame)
sensitivity_chrt(Trials_df,1)
```
## Trend Charts - Probabilistic Line Chart and Time Series Charts
```@docs
trend_chrt
```
```@example Graphing
ts_trials =[]

#To setup a TimeSeries simulation with MCHammer over 12 periods
for i = 1:1000
    Monthly_Sales = GBMM(100000, 0.05,0.05,12)
    Monthly_Expenses = GBMM(50000, 0.03,0.02,12)
    MonthlyCOGS = Monthly_Sales .* 0.3
    MonthlyProfit = Monthly_Sales - Monthly_Expenses - MonthlyCOGS
    push!(ts_trials, MonthlyProfit)
end

trend_chrt(ts_trials, x_label="last 12 months")
```
Say you wanted to replace periods with a series of dates.

```@example Graphing
dr = collect(Date(2019,1,01):Dates.Month(1):Date(2019,12,01))

trend_chrt(ts_trials, dr, x_label="last 12 months")
