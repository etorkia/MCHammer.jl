#TIME SERIES FUNCTIONS FOR MC HAMMER
#by Eric Torkia, April 2019-July 2022

# mch_timeseries contains functions to create simulated times series with mc_hammer. Current implementation supports GBM only. Other methods should be added


#--------------------------------------
"""
    GBMMfit(HistoricalData, PeriodsToForecast; rng="none")

GBMMfit uses a vector of historical data to calculate the log returns and use the mean and standard deviation to project a random walk. It the uses the last datapoint in the set as the starting point for the new forecast.

**HistoricalData**: Vector containing historical data

**PeriodsToForecast**: integer >1

**rng** is fully random when set to none. You can specify the rng you want to seed the results e.g. MersenneTwister(1234)

"""
function GBMMfit(HistoricalData, PeriodsToForecast; rng="none")
    #Seeding
    if rng=="none"
        rng = Random.seed!()
    end
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
    frct_multiplier = cumprod(rand(rng, Normal(mean(Returns_Arr),std(Returns_Arr)),PeriodsToForecast,1) + fill(1,PeriodsToForecast,1), dims=1)
    LastValue = HistoricalData[size(HistoricalData,1)]
    result = LastValue .* frct_multiplier
    return result
end


"""
    GBMM(LastValue, ReturnsMean, ReturnsStd, PeriodsToForecast; rng="none")

GBMM produces a random walk using the last data point and requires a mean and standard deviation to be provided.

**LastValue**: The most recent data point on which to base your random walk.

**ReturnsMean and ReturnsStd** : Historical Mean and Standard Deviation of Returns

**PeriodsToForecast** is an integer >1

**rng** is fully random when set to none. You can specify the rng you want to seed the results e.g. MersenneTwister(1234)
"""
function GBMM(LastValue, ReturnsMean, ReturnsStd, PeriodsToForecast; rng::Any="none")
    #Seeding
    if rng=="none"
        rng = Random.seed!()
    end
    # project Series
    frct_multiplier = cumprod(rand(rng, Normal(ReturnsMean,ReturnsStd),PeriodsToForecast,1) + fill(1,PeriodsToForecast,1), dims=1)
    result = LastValue .* frct_multiplier
        return result
    end


    """
        GBMA_d(price_0, t, rf, exp_vol; rng="none")

    GBMA_d allows you to forecast the stock price at a given day in the future. This function uses a multiplicative Geometric Brownian Motion to forecast but using the Black-Scholes approach

        **price_0**: Stock Price at period 0
        **t**: Number of days out to forecast
        **rf**: Risk free rate (usually the country's 25 or 30 bond)
        **exp_vol**: Expected volatility is the annual volatility
        **rng**: Used seed the results to make the forecast reproducible. Set to none by default which means fully random  but can use any of Julia's rngs to seed results. e.g. *GBMA_d(price_0, t, rf, exp_vol; rng=MersenneTwister(1))*

    """
    function GBMA_d(price_0, t, rf, exp_vol; rng="none")
    #Randomize Seed for simulation
    if rng=="none"
        rng = Random.seed!()
    end

    forecast = price_0 * exp((rf - ((exp_vol^2)/2) *t/252)+ (exp_vol*rand(rng, Normal(0,1))*sqrt(t/252)))
    return forecast
    end
