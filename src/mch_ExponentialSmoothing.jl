#Basic ES Forecast Methods for MCHammer
#by Eric Torkia, 2019-2022 (Please join the team so I don't have to do this alone)

using DataFrames, StatsBase, DataFramesMeta, CSV, Gadfly, Distributions, Dates


## Exponential Smoothing
"""
    ESmooth(HistoricalSeries, alpha; forecast_only=false)

Exponential Smoothing is a forecasting techniques that basically uses a weighted moving average that puts more weight on recent data points.

*alpha* is the smoothing constant

https://en.wikipedia.org/wiki/Exponential_smoothing

"""
function ESmooth(HistoricalSeries, alpha; forecast_only=false)
    forecast = []
    for i = 1:size(HistoricalSeries,1)
        if i == 1
            ESValue = HistoricalSeries[1]
        else
            ESValue = (alpha*HistoricalSeries[i])+ ((1-alpha)*forecast[i-1])
        end
        push!(forecast,ESValue)
    end
    if forecast_only==false
        forecast = hcat(HistoricalSeries, forecast)
    end
return forecast
end

## Double Exponential Smoothing
"""
    ESmooth2x(HistoricalSeries, alpha, beta)

Double exponential smoothing is a technique that incorporates trend into the forecast which it's single exponential smoothing cousin does not.

*alpha* is the smoothing constant
*beta* is the trend smoothing factor

Double Exponential smoothing can only project 1 period out.

https://en.wikipedia.org/wiki/Exponential_smoothing
"""
function ESmooth2x(HistoricalSeries, alpha, beta)
    #step 1: Calculate Level (this is essentiually a single Exponential Smoothing)
    level = ESmooth(HistoricalSeries, alpha)

    #step 2: Calculate slope. For simplicity we have decomposed the simple eq. into 2 terms.
    slope = 0.0
    slope_arr = [0.0] #this sets the first item to zero and the array to Float64
    for i = 2:size(level,1)
        slope_t1 = beta * (level[i]-level[i-1])
        slope_t2 = (1-beta)* slope
        slope = slope_t1 + slope_t2
        push!(slope_arr, slope)
    end

    #step 3: Produce smoothed forecast
    forecast = slope_arr + level

    #offset forecast values
    push!(HistoricalSeries, 0)
    pushfirst!(forecast, 0)

    #step 4: Calculate the standard error.
    stderror_array = hcat(HistoricalSeries, forecast)
    Error_arr =  HistoricalSeries - forecast
    Error_arr = Error_arr[2:end-1, 1:end]
    Stderror= sqrt(sum((Error_arr.^2))/size(Error_arr,1))

    # if forecast_only==false
        forecast = hcat(HistoricalSeries, forecast)
    # end
    println()
    println("Alpha: ", alpha, "   Beta: ", beta)
    println("Standard Error: ",Stderror )
    println()
    println()

return forecast

end

##Double Exponential Smoothing forecast
"""
    ESFore2x(HistoricalSeries, alpha, beta, periods)

Double exponential smoothing forecasting is a technique that will calculate a trend forecast.

    *alpha* is the smoothing constant
    *beta* is the trend smoothing factor
    *periods* is the number of periods to cast out above 1
"""
function ESFore2x(HistoricalSeries, alpha, beta, periods)
    #step 1: Calculate Level (this is essentiually a single Exponential Smoothing)
    TimeSeries_arr = copy(HistoricalSeries)
    level = ESmooth(TimeSeries_arr, alpha; forecast_only=true)
    forecast =[]

    #step 2: Calculate slope. For simplicity we have decomposed the simple eq. into 2 terms.
    slope = 0.0
    slope_arr = [0.0] #this sets the first item to zero and the array to Float64
    for i = 2:size(level,1)
        slope_t1 = beta * (level[i]-level[i-1])
        slope_t2 = (1-beta)* slope
        slope = slope_t1 + slope_t2
        push!(slope_arr, slope)
    end

    #step 3: Produce smoothed forecast
    forecast = slope_arr + level

    #step 4: Cast out over multiple periods by bootsrapping last forecast into level
    if periods==1 periods = 2 end
    if periods > 2
        for i = 1:periods-1
            push!(level, forecast[end-1]) #appends new level from previous forecast
            slope_t1 = beta * (level[end]-level[end-1])
            slope_t2 = (1-beta)* slope
            slope = slope_t1 + slope_t2
            newforecast = last(forecast)+ slope
            #push!(level, newforecast)
            push!(TimeSeries_arr, 0)
            push!(forecast, newforecast)
        end
    end
    #offset forecast values
    push!(TimeSeries_arr, 0)
    push!(level, 0)
    pushfirst!(forecast, 0)

    #step 5: Calculate the standard error.
    stderror_array = hcat(level, forecast)
    Error_arr =  level - forecast
    Error_arr = Error_arr[2:end-1, 1:end]
    Stderror= sqrt(sum((Error_arr.^2))/size(Error_arr,1))


    # if forecast_only==false
         forecast = hcat(TimeSeries_arr, level, forecast)
    # end

    println()
    println("Alpha: ", alpha, "   Beta: ", beta)
    println("Standard Error on Forecast: ",Stderror )
    println()
    println()
    forecast = DataFrame(forecast, :auto)
    DataFrames.rename!(forecast, [:Historical, :Level, :Forecast])
return forecast

end


## Triple Exponetial Smoothing (Holt-Winters) (do not export in TOML)
# This function requires several subfunctions

function ES3_initial_trend(HistoricalSeries, season_length)
    result = 0.0
    season_length = 12

        for i = 1:season_length
            calc = (HistoricalSeries[i + season_length]-HistoricalSeries[i])/season_length
            result = result + calc
        end

    result = result / season_length
    return result

end

# Calculate Seasonal Components

function ES3_seasonal(HistoricalSeries, season_length)
    # Periods are observations, seasons are groups of observations
    n_seasons = convert(BigInt, trunc(length(HistoricalSeries)/season_length; digits=0))

    #Copy dataset to avoid overwriting original array
    hist_data = copy(HistoricalSeries)

    #CALC SEASONAL AVERAGES / Indicies
    #step 1: Organize data into a table for easy calcs
    hist_data = reshape(hist_data, (season_length, n_seasons))
    seasonal_avgs = mean(hist_data, dims=1)
    seasonal_components = mean(hist_data .- seasonal_avgs, dims=2)

    return seasonal_components

end

function ES3_SeasonalIndicies(HistoricalSeries, season_length)
    # Periods are observations, seasons are groups of observations
    n_seasons = convert(BigInt, trunc(length(HistoricalSeries)/season_length; digits=0))

    #Copy dataset to avoid overwriting original array
    hist_data = copy(HistoricalSeries)

    #CALC SEASONAL AVERAGES / Indicies
    #step 1: Organize data into a table for easy calcs
    hist_data = reshape(hist_data, (season_length, n_seasons))
    seasonal_avgs = mean(hist_data, dims=1)
    seasonal_indicies = mean(hist_data ./ seasonal_avgs, dims=2)
    return seasonal_indicies
end

##Forecasting using ES3x
"""
    ESFore3x(HistoricalSeries, season_length, alpha, beta, gamma, periods_out; forecast_only=false)

    *HistoricalSeries* is a vector of historical data.
    *season_length* is the number of periods. For example if you have monthly data then you set this parameter to 12.
    *alpha* is the smoothing constant
    *beta* is the trend smoothing factor
    *gamma* controls the influence of the seasonal component
    *periods_out* reflects how many forecast periods

Here is an example of how to use the fitting function to find the optimal fit parameters.

    fit = ES3xFit(HistoricalSeries, 12, 100_000)
    ForecastSeries = ESFore3x(HistoricalSeries, 12, fit[1], fit[2], fit[3], 24)
.
"""
function ESFore3x(HistoricalSeries, season_length, alpha, beta, gamma, periods_out; forecast_only=false)
    results = []
    seasonals  = ES3_seasonal(HistoricalSeries, season_length)
    periods = length(HistoricalSeries) + periods_out
    hist_data = copy(HistoricalSeries)
    smooth = 0.0
    trend = ES3_initial_trend(HistoricalSeries, season_length)

    for i = 1:periods
        #Smoothing loop
        if i == 1 #Set initial values
            smooth = hist_data[1]
            trend = ES3_initial_trend(HistoricalSeries, season_length)
            pushfirst!(results, hist_data[1])
            #Forecasting Loop
        elseif i >= length(HistoricalSeries) #forecasting values
            m = i - length(HistoricalSeries)+1
            calc = (smooth + (m*trend))+ seasonals[mod(i,season_length)+1]
            push!(results,calc)
        else
            data_point = hist_data[i]
            smooth = alpha*(data_point-seasonals[mod(i,season_length)+1]) + (1-alpha)*(smooth+trend)
            last_smooth = smooth
            trend = beta * (smooth-last_smooth) + (1-beta)*trend
            seasonals[mod(i,season_length)+1] = gamma*(data_point-smooth) + (1-gamma)*seasonals[mod(i,season_length)+1]
            calc = smooth+trend+seasonals[mod(i,season_length)+1]
            push!(results,calc)
        end
    end
    results = convert.(Float64, results)

    if forecast_only == true
        results = results[length(hist_data)+1:end]
    end
    return results
end


"""
    FrctStdError(HistoricalSeries, ForecastSeries)

[...].
"""
function FrctStdError(HistoricalSeries, ForecastSeries)
    hist_data = copy(HistoricalSeries)
    forecast = ForecastSeries

    push!(hist_data, 0)
    pushfirst!(forecast, 0)

    #step 4: Calculate the standard error.
    stderror_array = hcat(hist_data, forecast)
    Error_arr =  hist_data - forecast
    Error_arr = Error_arr[2:end-1, 1:end]
    Stderror= sqrt(sum((Error_arr.^2))/size(Error_arr,1))
    #println("Standard Error: ", Stderror)
    return Stderror
end

"""
    ES3xFit(HistoricalSeries, season_length, trials)

This function automatically finds the 3x exponential smoothing parameters.
    *HistoricalSeries* is a vector of historical data.
    *season_length* is the number of periods. For example if you have monthly data then you set this parameter to 12.
    *trials* is how many iterations to test in order to get an optimal fit.

How to use the fit function with the forecast function:
    fit = ES3xFit(HistoricalSeries, 12, 100_000)
    ForecastSeries = ESFore3x(HistoricalSeries, 12, fit[1], fit[2], fit[3], 24)

"""
function ES3xFit(HistoricalSeries, season_length, trials)
    #Set starting values
    # alpha = 0.1
    # beta = 0.1
    # gamma = 0.1
    hist_data = copy(HistoricalSeries)

    #create baseline using (0.1, 0.1, 0.1)
    forecast = ESFore3x(HistoricalSeries, season_length, 0.1, 0.1, 0.1, 0)

    init_se = FrctStdError(hist_data, forecast)
    best_se = init_se
    best_result =[]

    for i = 1:trials
        opt_vals = rand(1,3)
        # alpha = rand()
        # beta = rand()
        # gamma = rand()
        forecast = ESFore3x(HistoricalSeries, season_length, opt_vals[1], opt_vals[2], opt_vals[3], 0)
        frct_se = FrctStdError(hist_data, forecast)
        if frct_se < best_se
            best_se = frct_se
            best_alpha = opt_vals[1]
            best_beta = opt_vals[2]
            best_gamma = opt_vals[3]
            best_result = [best_alpha, best_beta, best_gamma, best_se]
            println("Best Result(Trial: ",i,") ", [best_alpha, best_beta, best_gamma, best_se])
        end
    end
    println()
    println()
    return best_result
end

## Simulation function to incorporate untrended uncertainty into base forecast.

"""
    ForecastUncertainty(HistoricalData, PeriodsToForecast)

Similar to the approach used in the Geometric Brownian Motion forecast (random walk), this function calculates the mean change and volatility over time. Each time this is run, a different forecast is produced thus allowing for simulation.
"""
function ForecastUncertainty(HistoricalData, PeriodsToForecast)

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
    m_returns = 0
    volatility = std(Returns_Arr)
    periodfrct = Returns_Arr[length(Returns_Arr)-PeriodsToForecast:end-1]

    #frct_multiplier = cumprod(rand(Normal(mean(periodfrct),std(periodfrct)),PeriodsToForecast,1) + fill(1,PeriodsToForecast,1), dims=1)
    frct_multiplier =rand(Normal(0, std(periodfrct)),PeriodsToForecast) #Untrended Noise from historical data
    result = 1 .+ frct_multiplier
    return result
end
