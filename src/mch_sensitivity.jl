using Plots
using DataFrames
using Statistics
using Dates
using StatsBase
using Plots, Printf



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