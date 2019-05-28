# Time-Series Simulation

## Overview
mch_timeseries contains functions to create simulated times series with mc_hammer. Current implementation supports GBM only. Other methods should be added

## Functions
```@docs
GBMMfit
```
```jldoctest
Random.seed!(1) #hide
historical = rand(Normal(10,2.5),1000)
GBMM_Fit(historical, 12)

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
```jldoctest
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

### How to simulate a random walk

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
