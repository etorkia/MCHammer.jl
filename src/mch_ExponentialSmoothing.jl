#Basic ES Forecast Methods for MCHammer
#by Eric Torkia, 2019-2025 (Please join the team so I don't have to do this alone)

# -------------------------------------------------------------------------
# Types for Exponential Smoothing Methods
# -------------------------------------------------------------------------


"""
Abstract type for exponential smoothing methods.
"""
abstract type ExponentialSmoothingMethod end

"""
Simple exponential smoothing model.

# Fields
- `alpha::Float64`: Smoothing constant.
"""
struct SimpleES <: ExponentialSmoothingMethod
    alpha::Float64
end

"""
Double exponential smoothing model.

# Fields
- `alpha::Float64`: Level smoothing constant.
- `beta::Float64`: Trend smoothing factor.
"""
struct DoubleES <: ExponentialSmoothingMethod
    alpha::Float64
    beta::Float64
end

"""
Triple exponential smoothing (Holt–Winters) model.

# Fields
- `season_length::Int`: Number of periods in a season (e.g., 12 for monthly data).
- `alpha::Float64`: Level smoothing constant.
- `beta::Float64`: Trend smoothing factor.
- `gamma::Float64`: Seasonal smoothing factor.
"""
struct TripleES <: ExponentialSmoothingMethod
    season_length::Int
    alpha::Float64
    beta::Float64
    gamma::Float64
end

# -------------------------------------------------------------------------
# Helper Functions for Triple Exponential Smoothing
# -------------------------------------------------------------------------

"""
Calculate the initial trend for triple exponential smoothing.

    initial_trend(HistoricalSeries::Vector{<:Real}, season_length::Int)

# Arguments
- `HistoricalSeries`: Vector of historical data.
- `season_length`: Number of periods in a season.

# Returns
The average trend over one season.
"""
function initial_trend(HistoricalSeries::Vector{<:Real}, season_length::Int)
    n = length(HistoricalSeries)
    if n < 2 * season_length
        return n > 1 ? (HistoricalSeries[end] - HistoricalSeries[1]) / (n - 1) : 0.0
    else
        result = 0.0
        for i in 1:season_length
            result += (HistoricalSeries[i+season_length] - HistoricalSeries[i]) / season_length
        end
        return result / season_length
    end
end

"""
Calculate the seasonal components for triple exponential smoothing.

    seasonal_components(HistoricalSeries::Vector{<:Real}, season_length::Int)

# Arguments
- `HistoricalSeries`: Vector of historical data.
- `season_length`: Number of periods in a season.

# Returns
A vector of seasonal components.
"""
function seasonal_components(HistoricalSeries::Vector{<:Real}, season_length::Int)
    n_seasons = div(length(HistoricalSeries), season_length)
    # Use only complete seasons for reshaping
    data_mat = reshape(HistoricalSeries[1:(n_seasons*season_length)], season_length, n_seasons)
    seasonal_avgs = mean(data_mat, dims=1)
    return vec(mean(data_mat .- seasonal_avgs, dims=2))
end

# -------------------------------------------------------------------------
# Exponential Smoothing Functions
# -------------------------------------------------------------------------

"""
Perform simple exponential smoothing on the historical series.

    es_smooth(m::SimpleES, HistoricalSeries::Vector{<:Real}; forecast_only::Bool=false)

# Arguments
- `m::SimpleES`: A SimpleES model containing the smoothing constant `alpha`.
- `HistoricalSeries`: A vector of historical data.
- `forecast_only` (optional): If true, only the smoothed forecast is returned.

# Returns
A dataframe of smoothed values or the original and smoothed values.
"""
function es_smooth(m::SimpleES, HistoricalSeries::Vector{<:Real}; forecast_only::Bool=false)
    α = m.alpha
    forecast = Vector{Float64}()   # Initialize forecast vector
    for i in 1:length(HistoricalSeries)
        if i == 1
            es = HistoricalSeries[1]
        else
            es = α * HistoricalSeries[i] + (1 - α) * forecast[i-1]
        end
        push!(forecast, es)
    end
    if forecast_only == true
        return DataFrame(forecast=forecast)
    else
        return DataFrame(Historical=HistoricalSeries, forecast=forecast)
    end
end

"""
Perform double exponential smoothing on the historical series.

    es_smooth(m::DoubleES, HistoricalSeries::Vector{<:Real})

# Arguments
- `m::DoubleES`: A DoubleES model with `alpha` and `beta`.
- `HistoricalSeries`: A vector of historical data.

# Returns
A DataFrame where:
- `level`: The smoothed level values.
- `trend`: The estimated trend values.
- `smoothed`: The sum of level and trend.
"""
function es_smooth(m::DoubleES, HistoricalSeries::Vector{<:Real})
    α, β = m.alpha, m.beta
    # Call the simple ES function; it returns a DataFrame with one column.
    level_df = es_smooth(SimpleES(α), HistoricalSeries; forecast_only=true)
    # Extract the vector from the first (and only) column:
    level = level_df[!, 1]

    trend_arr = [0.0]
    trend = 0.0
    # Iterate over the indices using axes:
    for i in axes(level, 1)[2:end]
        trend = β * (level[i] - level[i-1]) + (1 - β) * trend
        push!(trend_arr, trend)
    end
    smoothed = level .+ trend_arr
    return DataFrame(level=level, trend=trend_arr, smoothed=smoothed)
end

"""
Produce a forecast using double exponential smoothing.

    es_forecast(m::DoubleES, HistoricalSeries::Vector{<:Real}, periods::Int)

# Arguments
- `m::DoubleES`: A DoubleES model with `alpha` and `beta`.
- `HistoricalSeries`: A vector of historical data.
- `periods`: Number of periods to forecast beyond the historical data.

# Returns
A DataFrame with columns: `Historical`, `Level`, and `Forecast`.
"""
function es_forecast(m::DoubleES, HistoricalSeries::Vector{<:Real}, periods::Int; forecast_only::Bool=false)
    df = es_smooth(m, HistoricalSeries)
    # Extract the 'level' and 'trend' columns as vectors.
    level = df[!, :level]
    trend_arr = df[!, :trend]
    
    ts = copy(HistoricalSeries)
    fcast = copy(level)
    last_level = level[end]
    last_trend = trend_arr[end]
    for i in 1:periods
        new_fcast = last_level + i * last_trend
        push!(fcast, new_fcast)
        push!(ts, 0)  # extend the historical series with placeholders
    end
    
    if forecast_only
        # Return only the forecast portion (the appended values).
        forecast_vals = fcast[length(HistoricalSeries)+1:end]
        return DataFrame(Forecast = forecast_vals)
    else
        # Return full DataFrame including historical and forecast data.
        return DataFrame(Historical = ts, Level = vcat(level, fill(0, periods)), Forecast = fcast)
    end
end



"""
Produce a forecast using triple exponential smoothing (Holt–Winters method) with seasonal adjustment.

    es_forecast(m::TripleES, HistoricalSeries::Vector{<:Real}, periods_out::Int; forecast_only::Bool=false)

# Arguments
- `m::TripleES`: A TripleES model with `season_length`, `alpha`, `beta`, and `gamma`.
- `HistoricalSeries`: A vector of historical data.
- `periods_out`: Number of periods to forecast beyond the historical data.
- `forecast_only` (optional): If true, returns only the forecasted values.

# Returns
Either a vector of forecasted values (if `forecast_only=true`) or the complete in-sample forecast.
"""
function es_forecast(m::TripleES, HistoricalSeries::Vector{<:Real}, periods_out::Int; forecast_only::Bool=false)
    season_length = m.season_length
    α, β, γ = m.alpha, m.beta, m.gamma
    results = Float64[]
    seasonals = seasonal_components(HistoricalSeries, season_length)
    total_periods = length(HistoricalSeries) + periods_out
    # Copy the historical series; we will extend it with placeholders for forecast periods.
    ts = copy(HistoricalSeries)
    smooth_val = ts[1]
    trend_val = initial_trend(ts, season_length)
    
    for i in 1:total_periods
        if i == 1
            smooth_val = ts[1]
            trend_val = initial_trend(ts, season_length)
            push!(results, ts[1])
        elseif i > length(HistoricalSeries)
            m_val = i - length(HistoricalSeries)
            fc = (smooth_val + m_val * trend_val) + seasonals[mod1(i, season_length)]
            push!(results, fc)
            push!(ts, 0)  # extend ts with a placeholder so its length equals total_periods
        else
            data_point = ts[i]
            prev_smooth = smooth_val
            smooth_val = α * (data_point - seasonals[mod1(i, season_length)]) + (1 - α) * (smooth_val + trend_val)
            trend_val = β * (smooth_val - prev_smooth) + (1 - β) * trend_val
            seasonals[mod1(i, season_length)] = γ * (data_point - smooth_val) + (1 - γ) * seasonals[mod1(i, season_length)]
            fc = smooth_val + trend_val + seasonals[mod1(i, season_length)]
            push!(results, fc)
        end
    end
    
    if forecast_only
        forecast_vals = results[length(HistoricalSeries)+1:end]
        return DataFrame(Forecast = forecast_vals)
    else
        return DataFrame(Historical = ts, Forecast = results)
    end
end

"""
Calculate the fractional standard error between the historical series and forecast series.

    FrctStdError(HistoricalSeries::Vector{<:Real}, ForecastSeries::Vector{<:Real})

# Arguments
- `HistoricalSeries`: A vector of historical data.
- `ForecastSeries`: A vector of forecasted data.

# Returns
The standard error as a Float64.
"""
function FrctStdError(HistoricalSeries::Vector{<:Real}, ForecastSeries::Vector{<:Real})
    ts = copy(HistoricalSeries)
    fcast = copy(ForecastSeries)
    push!(ts, 0)
    pushfirst!(fcast, 0)
    err = ts .- fcast
    if length(err) <= 2
        return 0.0
    end
    err = err[2:end-1]
    return sqrt(sum(err .^ 2) / length(err))
end

"""
    forecast_uncertainty(HistoricalData::Vector{<:Real}, PeriodsToForecast::Int) -> Vector{Float64}

Calculate forecast uncertainty multipliers based on historical data volatility.

This function computes the percentage returns from the historical data, estimates the standard deviation (σ) of those returns, and then generates a vector of forecast multipliers. Each multiplier is calculated as:

``u = 1 + \\sigma \\cdot \\epsilon ``

where (``\\epsilon``) is a random sample drawn from a standard normal distribution 
        ``\\epsilon \\sim \\mathcal{N}(0,1)`` and ``\\sigma`` is the standard deviation of the historical percentage returns.

# Arguments
- `HistoricalData::Vector{<:Real}`: A vector of historical observations (e.g., prices, values).
- `PeriodsToForecast::Int`: The number of forecast periods for which to generate uncertainty multipliers.

# Returns
- A vector of length `PeriodsToForecast` containing the forecast uncertainty multipliers. These multipliers can be used to perturb a base forecast to simulate forecast variability.
"""
function forecast_uncertainty(HistoricalData::Vector{<:Real}, PeriodsToForecast::Int)
    # Compute historical returns as percentage changes.
    returns = diff(HistoricalData) ./ HistoricalData[1:end-1]
    # Calculate the standard deviation of returns as a measure of volatility.
    sigma = std(returns)
    # Generate uncertainty multipliers for each forecast period.
    # Here, we assume that forecast uncertainty is modeled as 1 plus a normally distributed noise.
    uncertainty = 1 .+ randn(PeriodsToForecast) .* sigma
    return uncertainty
end




"""
Automatically fit optimal parameters for triple exponential smoothing by random trials.
     
    es_fit(::Type{TripleES}, HistoricalSeries::Vector{<:Real}, season_length::Int, trials::Int)

# Arguments
- `HistoricalSeries`: A vector of historical data.
- `season_length`: Number of periods in a season.
- `trials`: Number of random trials to perform.

# Returns
A `TripleES` instance with the best parameters (lowest forecast error).
""" 
function es_fit(::Type{TripleES}, HistoricalSeries::Vector{<:Real}, season_length::Int, trials::Int)
    ts = copy(HistoricalSeries)
    base_model = TripleES(season_length, 0.1, 0.1, 0.1)
    base_forecast = es_forecast(base_model, ts, 0)
    # If forecast is returned as a DataFrame, extract the Forecast column.
    if base_forecast isa DataFrame
        base_forecast = base_forecast.Forecast
    end
    best_se = FrctStdError(ts, base_forecast)
    best_model = base_model
    for i in 1:trials
        α = rand()
        β = rand()
        γ = rand()
        model = TripleES(season_length, α, β, γ)
        fcast = es_forecast(model, ts, 0)
        if fcast isa DataFrame
            fcast = fcast.Forecast
        end
        se = FrctStdError(ts, fcast)
        if se < best_se
            best_se = se
            best_model = model
            println("Trial ", i, ": Best parameters so far: ", best_model, " SE: ", best_se)
        end
    end
    return best_model
end



