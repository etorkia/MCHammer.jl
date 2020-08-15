#TIME SERIES FUNCTIONS FOR MC HAMMER
#by Eric Torkia, April 2019

# mch_timeseries contains functions to create simulated times series with mc_hammer. Current implementation supports GBM only. Other methods should be added


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
