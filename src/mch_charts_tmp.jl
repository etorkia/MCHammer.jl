
using Plots
using DataFrames
using Statistics
using Dates
using StatsPlots
using Plots, Printf


# Set the ggplot2 theme globally.
theme(:ggplot2)

#-----------------------------------------------------------------------------
# DENSITY CHART
#-----------------------------------------------------------------------------
"""
    density_chrt(Data, x_label="Sim. Values")

Data is your array (simulated or historical).
x_label (optional) customizes the X-axis label.
"""
function density_chrt(Data, x_label="Sim. Values")
    x_label == "" && (x_label = "x")
    
    p = density(Data,
                xlabel = x_label,
                ylabel = "Frequency",
                seriescolor = :blue,            # Blue fill for the area under the curve.
                linecolor = :lightblue,
                linewidth = 4,       
                legend_background_color = :white)  # White legend background.
    
    println(describe(Data))
    println("")
    println("Mean: ", mean(Data))
    println("Std.Dev: ", std(Data))
    println("Prob. of Neg.: ", GetCertainty(Data, 0, 0))
    println("")
    println("p10, p50, p90 : ", quantile(collect(Float64, Data), [0.1, 0.5, 0.9]))
    
    return p
end

#-----------------------------------------------------------------------------
# HISTOGRAM CHART
#-----------------------------------------------------------------------------
"""
    histogram_chrt(Data, x_label="Sim. Values")

Data is your array (simulated or historical).
x_label (optional) customizes the X-axis label.
"""
function histogram_chrt(Data, x_label="Sim. Values")
    x_label == "" && (x_label = "x")
    
    # Create a histogram with light gray borders and a white legend background.
    p = histogram(Data,
                  xlabel = x_label,
                  ylabel = "Frequency",
                  seriescolor = :lightblue,
                  linecolor = :white,
                  legend_background_color = :white)
    
    # Print statistical summaries.
    println(describe(Data))
    println("")
    println("Mean: ", mean(Data))
    println("Std.Dev: ", std(Data))
    println("Prob. of Neg.: ", GetCertainty(Data, 0, 0))
    println("")
    println("p10, p50, p90 : ", quantile(collect(Float64, Data), [0.1, 0.5, 0.9]))
    
    return p
end

#-----------------------------------------------------------------------------
# SENSITIVITY CHART
#-----------------------------------------------------------------------------
"""
    sensitivity_chrt(ArrayName::DataFrame, TargetCol; Chrt_Type=1, show_values=false)

- **TargetCol**: selects the output against which the other variables are compared.
- **Chrt_Type**: selects the metric:
    1. Spearman,
    2. Pearson,
    3. % Contribution to Variance.
   
"""


function sensitivity_chrt(ArrayName::DataFrame, TargetCol, Chrt_Type=1)
    # 1) Number of columns in the DataFrame
    M_Size = size(ArrayName, 2)

    # 2) Calculate Spearman correlation (correl_vals_s)
    cor_mat_s = []
    for t in TargetCol
        cor_vector = []
        for j in 1:M_Size
            cor_i = cor(tiedrank(ArrayName[!, t]), tiedrank(ArrayName[!, j]))
            push!(cor_vector, cor_i)
        end
        push!(cor_mat_s, cor_vector)
    end
    correl_vals_s = hcat(cor_mat_s...)
    # If only one target column, flatten to a vector
    if size(correl_vals_s, 2) == 1
        correl_vals_s = vec(correl_vals_s)
    end

    # 3) Calculate Pearson correlation (correl_vals_p)
    cor_mat_p = []
    for t in TargetCol
        cor_vector = []
        for j in 1:M_Size
            cor_i = cor(ArrayName[!, t], ArrayName[!, j])
            push!(cor_vector, cor_i)
        end
        push!(cor_mat_p, cor_vector)
    end
    correl_vals_p = hcat(cor_mat_p...)
    if size(correl_vals_p, 2) == 1
        correl_vals_p = vec(correl_vals_p)
    end

    # 4) Determine sign (Negative vs Positive) for color
    color_code = if Chrt_Type == 1
        correl_vals_s .< 0
    elseif Chrt_Type == 2
        correl_vals_p .< 0
    else
        # If Chrt_Type == 3 or invalid, default to Spearman
        correl_vals_s .< 0
    end

    impact   = [ isneg ? "Negative" : "Positive" for isneg in color_code ]
    var_sign = [ isneg ? -1 : 1 for isneg in color_code ]

    # 5) Calculate contribution to variance (based on Spearman)
    cont_var = correl_vals_s .^ 2
    cont_var = cont_var ./ (sum(cont_var) - 1)
    cont_var = cont_var .* var_sign

    # 6) Build a DataFrame of results
    ystr = names(ArrayName)
    graph_tbl = DataFrame(
        name        = ystr,
        correlation = correl_vals_s,
        abs_cor     = abs.(correl_vals_s),
        PPMC        = correl_vals_p,
        cont_var    = cont_var,
        impact      = impact
    )

    # Remove self-correlation (==1) and sort ascending by abs_cor
    graph_tbl = filter(row -> row.correlation != 1, graph_tbl)
    graph_tbl = sort(graph_tbl, :abs_cor, rev=false)

    println(graph_tbl)

    # 7) Decide which metric to show on the x-axis
    if Chrt_Type == 1
        xdata        = graph_tbl.correlation
        x_axis_label = "Rank Correlation"
        x_min, x_max = -1, 1
    elseif Chrt_Type == 2
        xdata        = graph_tbl.PPMC
        x_axis_label = "Pearson Correlation"
        x_min, x_max = -1, 1
    else
        # % Contribution to Variance
        xdata        = graph_tbl.cont_var .* 100
        x_axis_label = "% Contribution to Variance"
        # Use [-100,100] so bars can spread out if negative is possible
        x_min, x_max = -100, 100
    end

    # 8) Assign colors: Negative => red, Positive => blue
    colors = [ row == "Negative" ? :red : :deepskyblue for row in graph_tbl.impact ]

    # 9) Use integer y-values for consistent spacing
    #    and define y-limits so bars aren't "bunched" at the bottom.
    yvals = collect(1:size(graph_tbl, 1))
    ylims_ = (0.5, size(graph_tbl, 1) + 0.5)  # small padding top/bottom

    # 10) Create a horizontal bar chart
    p = bar(
        yvals,
        xdata,
        orientation = :horizontal,
        label       = "",
        xlabel      = x_axis_label,
        ylabel      = "Input",
        title       = "Variables with Biggest Impact",
        color       = colors,
        linecolor   = :lightgray,
        bar_width   = 0.6,
        xlims       = (x_min, x_max),
        ylims       = ylims_,
        legend      = false
    )

    # Replace numeric y ticks with variable names
    plot!(p, yticks = (yvals, graph_tbl.name))

    return p
end





#-----------------------------------------------------------------------------
# TREND CHART (with Date range)
#-----------------------------------------------------------------------------
"""
    trend_chrt(SimTimeArray, PeriodRange::Vector{Date}; x_label="periods", quantiles=[0.05,0.5,0.95])

Visualizes a simulated time series with confidence bands.
PeriodRange must be a vector of Dates (e.g., using Dates: `collect(Date(2019,1,1):Year(1):Date(2023,1,1))`).
"""
using DataFrames, Statistics, Plots
using StatsBase: tiedrank  # For Spearman correlation

function trend_chrt(SimTimeArray, PeriodRange::Vector{Date}; x_label="periods", quantiles=[0.05,0.5,0.95])
    # Convert to DataFrame if needed.
    AC_DF = typeof(SimTimeArray) == DataFrame ? SimTimeArray :
        DataFrame(vcat(map(x -> x', SimTimeArray)...), :auto)
    
    # Compute quantiles for each column.
    trend_chart = [ quantile(AC_DF[!, i], quantiles) for i in 1:size(AC_DF, 2) ]
    # Convert to DataFrame.
    trend_chart = DataFrame(vcat(map(x -> x', trend_chart)...), :auto)
    rename!(trend_chart, [:LowerBound, :p50, :UpperBound])
    
    # Add timestamp column.
    trend_chart.timestamp = PeriodRange

    # Calculate the differences for the ribbon:
    lower_error = trend_chart.p50 .- trend_chart.LowerBound
    upper_error = trend_chart.UpperBound .- trend_chart.p50

    # Plot the p50 (center line) with a ribbon that spans from LowerBound to UpperBound.
    p = plot(trend_chart.timestamp, trend_chart.p50,
             ribbon = (lower_error, upper_error),
             xlabel = x_label,
             ylabel = "Value",
             label = "p50",
             linecolor = :white)
    
    # Optionally, overlay the LowerBound and UpperBound as separate lines:
    plot!(trend_chart.timestamp, trend_chart.LowerBound,
          label = "LowerBound", linecolor = :lightblue)
    plot!(trend_chart.timestamp, trend_chart.UpperBound,
          label = "UpperBound", linecolor = :lightblue)
    
    return p
end


#-----------------------------------------------------------------------------
# TREND CHART (without Date range)
#-----------------------------------------------------------------------------
"""
    trend_chrt(SimTimeArray; x_label="periods", quantiles=[0.05,0.5,0.95])

Visualizes a simulated time series with confidence bands. The x-axis is a simple period index.
"""
using DataFrames, Statistics, Plots

function trend_chrt(SimTimeArray; x_label="periods", quantiles=[0.05, 0.5, 0.95])
    # Convert to DataFrame if needed.
    AC_DF = typeof(SimTimeArray) == DataFrame ? SimTimeArray :
        DataFrame(vcat(map(x -> x', SimTimeArray)...), :auto)
    
    # Compute quantiles for each column.
    trend_chart = [ quantile(AC_DF[!, i], quantiles) for i in 1:size(AC_DF, 2) ]
    trend_chart = DataFrame(vcat(map(x -> x', trend_chart)...), :auto)
    rename!(trend_chart, [:LowerBound, :p50, :UpperBound])
    
    # Create a period index.
    n_periods = size(trend_chart, 1)
    trend_chart.period = collect(1:n_periods)
    
    # Compute the ribbon extents:
    # Lower error: difference between p50 and LowerBound.
    # Upper error: difference between UpperBound and p50.
    lower_error = trend_chart.p50 .- trend_chart.LowerBound
    upper_error = trend_chart.UpperBound .- trend_chart.p50

    # Plot the center line (p50) with the ribbon.
    p = plot(trend_chart.period, trend_chart.p50,
             ribbon = (lower_error, upper_error),
             label = "p50",
             xlabel = x_label,
             ylabel = "Value",
             linecolor = :lightgray,
             legend = :top)
    
    # Optionally, overlay the lower and upper bounds as separate lines.
    plot!(trend_chart.period, trend_chart.LowerBound, label = "LowerBound", linecolor = :lightgray)
    plot!(trend_chart.period, trend_chart.UpperBound, label = "UpperBound", linecolor = :lightgray)
    
    return p
end


#-----------------------------------------------------------------------------
# S CURVE (Empirical CDF)
#-----------------------------------------------------------------------------
"""
    s_curve(results, x_label="Sim. Values"; rev=false)

Visualizes the cumulative distribution (empirical CDF) of a data set.
Set rev=true for a reversed empirical CDF.
"""
function s_curve(results, x_label="Sim. Values"; rev=false)
    n = size(results, 1)
    sorted_results = rev ? sort(results, rev = true) : sort(results)
    
    # Plot the empirical CDF.
    p = plot(sorted_results,
             (1:n) ./ n,
             xlabel = x_label,
             ylabel = "Frequency",
             linecolor = :lightgray,
             label = "")
    
    return p
end


#------------------------------------------------------------------------------
# Testing each chart with sample data.
#------------------------------------------------------------------------------

println("------ Testing Density Chart ------")
sample_data = randn(1000)
p_density = density_chrt(sample_data, "Sample Density")
display(p_density)

println("\n------ Testing Histogram Chart ------")
p_hist = histogram_chrt(sample_data, "Sample Histogram")
display(p_hist)

println("\n------ Testing Sensitivity Chart ------")
# Create a sample DataFrame with 5 columns.
df = DataFrame(A = randn(100),
               B = randn(100),
               C = randn(100),
               D = randn(100),
               E = randn(100))

println("\nSensitivity Chart (Spearman):")
p_sens1 = sensitivity_chrt(df, [1], 1)
display(p_sens1)

println("\nSensitivity Chart (Pearson):")
p_sens2 = sensitivity_chrt(df, [1], 2)
display(p_sens2)

println("\nSensitivity Chart (% Contribution to Variance):")
p_sens3 = sensitivity_chrt(df, [1], 3)
display(p_sens3)

println("\n------ Testing Trend Chart with Date Range ------")
# Generate 10 simulation paths, each of length 50.
simTimeArray = [randn(50) for i in 1:10]
# Create a date range of 50 days.
date_range = collect(Date(2025, 1, 1):Day(1):Date(2025, 2, 19))
p_trend_date = trend_chrt(simTimeArray, date_range, x_label = "Date", quantiles = [0.05, 0.5, 0.95])
display(p_trend_date)

println("\n------ Testing Trend Chart without Date Range ------")
p_trend_no_date = trend_chrt(simTimeArray, x_label = "Period", quantiles = [0.05, 0.5, 0.95])
display(p_trend_no_date)

println("\n------ Testing S Curve Chart ------")
p_scurve = s_curve(sample_data, "Sample s_curve", rev = false)
display(p_scurve)