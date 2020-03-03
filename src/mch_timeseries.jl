#TIME SERIES FUNCTIONS FOR MC HAMMER
#by Eric Torkia, April 2019

# mch_timeseries contains functions to create simulated times series with mc_hammer. Current implementation supports GBM only. Other methods should be added


# using DataFrames
# using CSV
# using Distributions
# using Statistics
# using StatsBase
# using TimeSeries; precompile
# using IterableTables #this important to convert DF to TimeSeries


#--------------------------------------
"""
    GBMMfit(HistoricalData, PeriodsToForecast)

GBMMfit uses a vector of historical data to calculate the log returns and use the mean and standard deviation to project a random walk. It the uses the last datapoint in the set as the starting point for the new forecast.

**HistoricalData**: Vector containing historical data

**PeriodsToForecast**: integer >1

"""
function GBMMfit(HistoricalData, PeriodsToForecast)
#calculate returns
Returns_Arr = []
for i = 1:size(HistoricalData,1)-1
    T2_cursor = 1
    Period_T1 = HistoricalData[i,1]
    Period_T2 = HistoricalData[i+T2_cursor,1]
    if  ismissing(HistoricalData[i+T2_cursor,1])==1
        Period_T2 = Period_T1
                #T2_cursor += 1
    else
        Period_T2 = HistoricalData[i+T2_cursor,1]
    end

    returns =
    if isinf(log(Period_T1 / Period_T2))==1
        returns = 0
    elseif isnan(log(Period_T1 / Period_T2))==1
        returns = 0
    else
        log(Period_T1 / Period_T2)
    end
    push!(Returns_Arr, returns)
end
push!(Returns_Arr, 0 )

# project Series
    frct_multiplier = cumprod(rand(Normal(mean(Returns_Arr),std(Returns_Arr)),PeriodsToForecast,1) + fill(1,PeriodsToForecast,1), dims=1)
    LastValue = HistoricalData[size(HistoricalData,1)]
    result = LastValue .* frct_multiplier
    return result
end


"""
    GBMM(LastValue, ReturnsMean, ReturnsStd, PeriodsToForecast)

GBMM produces a random wlak using the last data point and requires a mean and standard deviation to be provided.

**LastValue**: The most recent data point on which to base your random walk.

**ReturnsMean and ReturnsStd** : Historical Mean and Standard Deviation of Returns

**PeriodsToForecast** is an integer >1
"""
function GBMM(LastValue, ReturnsMean, ReturnsStd, PeriodsToForecast)
    # project Series
        frct_multiplier = cumprod(rand(Normal(ReturnsMean,ReturnsStd),PeriodsToForecast,1) + fill(1,PeriodsToForecast,1), dims=1)
        result = LastValue .* frct_multiplier
        return result
    end


    """
        GBMA_d(price_0, t, rf, exp_vol)

    GBMA_d allows you to forecast the stock price at a given day in the future.

    This function uses a multiplicative Geometric Brownian Motion to forecast

    """
    function GBMA_d(price_0, t, rf, exp_vol)
    forecast = price_0 * exp((rf - ((exp_vol^2)/2) *t/252)+ (exp_vol*rand(Normal(0,1))*sqrt(t/252)))
    return forecast
    end


#---------------------------------------------------------------
# testing exercises
#_______________________________________________________________

# # Get date,CDNUSD,USDCDN,bent,wti,USGDP
# TS_DF = CSV.read("..\\TS_Array_Oil.csv")
#
# test = TS_DF[201:242,2]
#
# #using TimeSeries Pkg
# TS_TA = TimeArray(TS_DF[[:date, :CDNUSD, :USDCDN, :bent, :wti, :USGDP]], timestamp_column=:date)
#
#
# # To get percentage change. If you add :log it will calculate LogReturns
# percentchange(TS_TA, :log)
#
# #You can convert the percent change results back to a DataFrame
# DF = DataFrame(percentchange(TS_TA, :log))
# describe(DF)
#
# plot(stack(DF,[:CDNUSD, :USDCDN, :bent, :wti, :USGDP]), x=:timestamp,y=:value, color=:variable, Geom.line)
# plot(stack(TS_DF,[:CDNUSD, :USDCDN, :bent, :wti, :USGDP]), x=:date,y=:value, color=:variable, Geom.line)
#
# plot(stack(TS_DF,[:bent, :wti]), x=:date,y=:value, color=:variable, Geom.line)
#
#
# #BASE GBM Idea
# #cumprod is a function that does the product of n * n(-1)
# test_1= cumprod(rand(Normal(mean(DF[1:200,2]),std(DF[1:200,2])),42,1) + fill(1,42,1), dims=1)
# LastValue = TS_DF[size(TS_DF,1),4]
# result = LastValue .* test_1
# test_3 = DataFrame(hcat(TS_DF[201:242,1], result))
# plot(test_3, x=:x1, y=:x2, Geom.line)
