# Forecasting with Exponential Smoothing 

This page documents the exponential smoothing methods and functions provided by the package, including detailed explanations, docstrings, and usage examples.

## Method Functions
### Simple Exponential Smoothing

Simple exponential smoothing model.
**Fields:**
- `alpha::Float64`: Smoothing constant.

```@setup ExpMethods
using MCHammer, DataFrames, Distributions, Random, Plots, StatsPlots, GraphRecipes #hide
```
**Example:**
```@example ExpMethods
using MCHammer #hide
model = MCHammer.SimpleES(0.2)
```

### Double Exponential Smoothing

Double exponential smoothing model with trend.
**Fields:**
- `alpha::Float64`: Level smoothing constant.
- `beta::Float64`: Trend smoothing factor.

**Example:**
```@example ExpMethods
using MCHammer #hide
model = DoubleES(0.3, 0.1)
```

### Triple Exponential Smoothing

Triple exponential smoothing model (Holt–Winters method) with trend and seasonality.

**Fields:**
- `season_length::Int`: Number of periods in a season (e.g., 12 for monthly).
- `alpha::Float64`: Level smoothing constant.
- `beta::Float64`: Trend smoothing factor.
- `gamma::Float64`: Seasonal smoothing factor.

**Example:**
```@example ExpMethods
using MCHammer #hide
model = TripleES(12, 0.3, 0.2, 0.1)
```

---

## Smoothing Functions

Perform smoothing on historical data.

```@docs 
MCHammer.es_smooth 
```

### Smoothing `SimpleES`:

```@example ExpMethods
using DataFrames, Distributions, Random, MCHammer #hide

data = [100, 102, 104, 108, 110]
simple_model = SimpleES(0.2)
smoothed_simple = es_smooth(simple_model, data; forecast_only=true)
```

### Smoothing `DoubleES`:
```@example ExpMethods
# DoubleES example
using MCHammer, DataFrames, Distributions, Random # hide
double_model = DoubleES(0.2, 0.1)
smoothed_double = es_smooth(double_model, data)
```

## Forecasting out

Generate forecasts based on smoothing models.
```@docs
MCHammer.es_forecast
```

### Forecasting `DoubleES`:
```@example ExpMethods
using MCHammer,Plots # hide

data = [100, 102, 104, 108, 110]

# DoubleES forecast
double_model = DoubleES(0.2, 0.1)
df_forecast = es_forecast(double_model, data, 3)
```
<br>
Let's visualize this as a line plot comparing historical data and the forecast
<br>
```@example ExpMethods
using Plots

# Create an index vector corresponding to the rows.
x_all = 1:nrow(df_forecast)

# Identify the indices where Historical is nonzero.
nonzero_idx = findall(x -> x != 0, df_forecast.Historical)

# Plot forecast over all rows.
plot(x_all, df_forecast.Forecast, label="Forecast", xlabel="Time", ylabel="Value", lw=2)

# Plot Historical and Level only on nonzero indices.
plot!(nonzero_idx, df_forecast.Historical[nonzero_idx], label="Historical", marker=:circle, lw=2)
plot!(nonzero_idx, df_forecast.Level[nonzero_idx], label="Level", marker=:square, lw=2)

```

### Forecasting `TripleES`:
```@example ExpMethods
# TripleES forecast
using MCHammer, DataFrames, Distributions, Random # hide

seasonal_data = [120,130,140,130,125,135,145,150,160,155,165,170]
triple_model = MCHammer.TripleES(12, 0.3, 0.2, 0.1)
df_forecast = es_forecast(triple_model, seasonal_data, 6; forecast_only=false)
```
```@raw html
Let's visualize this as a line plot comparing historical and forecasted data
```
```@example ExpMethods
using Plots
theme(:ggplot2)

# Create an index vector corresponding to the rows.
x_all = 1:nrow(df_forecast)

# Identify the indices where Historical is nonzero.
nonzero_idx = findall(x -> x != 0, df_forecast.Historical)

# Plot forecast over all rows.
plot(x_all, df_forecast.Forecast, label="Forecast", xlabel="Time", ylabel="Value", lw=2)

# Plot Historical and Level only on nonzero indices.
plot!(nonzero_idx, df_forecast.Historical[nonzero_idx], label="Historical", marker=:circle, lw=2)

```


## Forecast Standard Error

Calculate standard error between historical and forecasted data.

```@docs
MCHammer.FrctStdError
```

**Example:**
```@example ExpMethods
using MCHammer # hide

data = [100, 102, 104, 108, 110]
double_model = DoubleES(0.3, 0.2)

# Generate in-sample forecast; since periods = 0, the forecast equals the smoothed level

df_forecast = es_forecast(double_model, data, 0)
forecasted = df_forecast.Forecast  # Access the forecast column from the returned DataFrame
se = FrctStdError(data, forecasted)
println("Forecast Standard Error: ", se)
```

## Fitting historical data

Automatically optimize parameters for TripleES.

```@docs
MCHammer.es_fit
```

```@example ExpMethods
using MCHammer # hide
data = [120,130,140,130,125,135,145,150,160,155,165,170]
best_model = es_fit(TripleES, data, 12, 1000)
```

## Simulating forecasts (Monte-Carlo)

Simulate forecast uncertainty using historical returns.

```@docs
forecast_uncertainty
```

**Practical Example:**
```@example ExpMethods
using MCHammer, DataFrames, Distributions, Random # hide

#The historical data is used to assess the volatility of the series automatically.
data = [100, 105, 102, 108, 110]

uncertainty = forecast_uncertainty(data, 4)
```

Now let's assume we want to run 1000 Monte-Carlo Trials, this is the approach we would take.

```@example simulation
using MCHammer, DataFrames, Distributions, Random # hide

function simulate_ESTS()

#Simulation Model Inputs and Parameters
n_trials = 1000
n_periods = 5
historical_data = [100, 105, 102, 108, 110, 115, 120, 118, 122, 125, 130, 128]
seasonality = 12

    # 1. Fit optimal TripleES parameters using 1,000 optimization trials. Seasonality is the number of periods to test for seasonal patterns.
    optimal_triple = es_fit(TripleES, historical_data, seasonality, 1000)

    # 2. Generate the base forecast (for n_periods = 5) with the fitted model
    base_forecast = es_forecast(optimal_triple, historical_data, n_periods; forecast_only=true)

    # 3. Run simulation: for 1,000 trials, apply forecast uncertainty to the base forecast


    # Prepare a DataFrame to store simulation results in long format.
    # Columns: Trial (simulation number), Period (forecast period), Forecast (simulated forecast value)
    sim_results = DataFrame(Trial=Int[], Period=Int[], Forecast=Float64[])

        for trial in 1:n_trials
        # Compute forecast uncertainty multipliers for the next n_periods
        uncertainty = forecast_uncertainty(historical_data, n_periods)
        
        # Apply the uncertainty multipliers to the base forecast to simulate forecast variability.
        # This returns a DataFrame with columns "Historical", "Level", and "Forecast".
        simulated_forecast = base_forecast .* uncertainty

        # Now iterate over the rows using eachrow() and enumerate to get an index.
            for (i, row) in enumerate(eachrow(simulated_forecast))
                push!(sim_results, (Trial = trial, Period = i, Forecast = row.Forecast))
            end
            
        end


        return sim_results = unstack(sim_results, :Period, :Forecast)

end

#Genreate simulation trials
sim_results_to_chart = simulate_ESTS()

#Here are the first 10 trials
first(sim_results_to_chart,10)

```
When plotted, we can see the uncertainty is applied using historical volatility. Remember to remove the trials column for better charting.

```@example simulation
trend_chrt(sim_results_to_chart[:,2:6])
```
## Sources & References
- Eric Torkia, Decision Superhero Vol. 3, chapter 5 : Predicting 1000 futures, Technics Publishing, 2025
- Available on Amazon : https://a.co/d/4YlJFzY . Volumes 2 and 3 to be released in Spring and Fall 2025.