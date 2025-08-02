module LearningCurves

using DataFrames

export LearningCurveMethod, WrightMethod, CrawfordMethod, ExperienceMethod
export lc_analytic, lc_curve, lc_fit, learn_rate, learn_rates

#------------------------------------------------------------------------------
# Types
#------------------------------------------------------------------------------

"""Abstract type for learning curve methods."""
abstract type LearningCurveMethod end

"""Wright’s learning-curve method."""
struct WrightMethod <: LearningCurveMethod end

"""Crawford’s learning-curve method."""
struct CrawfordMethod <: LearningCurveMethod end

"""Experience curve learning method."""
struct ExperienceMethod <: LearningCurveMethod end

#------------------------------------------------------------------------------
# Analytic Cumulative-Cost Functions
#------------------------------------------------------------------------------


@doc raw"""
    lc_analytic(::WrightMethod, initial, N, α) -> Float64

Compute cumulative cost using Wright’s model:
- `initial`: base cost for first unit
- `N`: total units
- `α`: learning exponent (progress ratio = 2^b)

Formula:
```math
\text{Cumulative Cost}_N = \text{initial} \times \sum_{i=1}^N i^{-\alpha}
```
"""
function lc_analytic(::WrightMethod, initial::Real, N::Integer, α::Real)::Float64
    return initial * sum(i^(-α) for i in 1:N)
end

@doc raw"""
    lc_analytic(::CrawfordMethod, initial, N, α) -> Float64

Compute cumulative cost using Crawford’s model (same analytic form as Wright):
- Uses batch-average reduction.

Formula:
```math
\text{Cumulative Cost}_N = \text{initial} \times \sum_{i=1}^N i^{-\alpha}
```
"""
lc_analytic(::CrawfordMethod, initial::Real, N::Integer, α::Real) = lc_analytic(WrightMethod(), initial, N, α)

@doc raw"""
    lc_analytic(::ExperienceMethod, initial_avg, N, α) -> Float64

Compute cumulative cost using Experience curve:
- `initial_avg`: average cost per unit at unit 1
- `N`: total units
- `α`: learning exponent

Formula:
```math
\text{Cumulative Cost}_N = (\text{initial\_avg} \times N^{-\alpha}) \times N
```
"""
function lc_analytic(::ExperienceMethod, initial_avg::Real, N::Integer, α::Real)::Float64
    avgN = initial_avg * N^(-α)
    return avgN * N
end

#------------------------------------------------------------------------------
# Two-Point Learning-Rate Estimation
#------------------------------------------------------------------------------


@doc raw"""
    learn_rate(method, ...) -> Float64

Summary of two-point learning rate formulas:

- Wright:  $b = \frac{\log(x_2/x_1)}{\log(n_2/n_1)}$  (progress ratio $2^b$)
- Crawford:  $a_1 = T_1/n_1$, $a_2 = T_2/n_2$, $b = \frac{\log(a_2/a_1)}{\log(n_2/n_1)}$  (progress ratio $2^b$)
- Experience:  $b = \frac{\log(\text{avg}_2/\text{avg}_1)}{\log(n_2/n_1)}$  (progress ratio $2^b$)

See method-specific docstrings below for details.
"""

@doc raw"""
    learn_rate(::WrightMethod, n1, x1, n2, x2) -> Float64

Two-point fit for Wright’s method:
- `n1`, `n2`: unit indices
- `x1`, `x2`: time for nth unit

Formula:
```math
b = \frac{\log(x_2/x_1)}{\log(n_2/n_1)}
```
Returns progress ratio: ``2^b``
"""
function learn_rate(::WrightMethod, n1::Real, x1::Real, n2::Real, x2::Real)::Float64
    b = (log(x2) - log(x1)) / (log(n2) - log(n1))
    return 2.0^b
end

@doc raw"""
    learn_rate(::CrawfordMethod, n1, T1, n2, T2) -> Float64

Two-point fit for Crawford’s method:
- `n1`, `n2`: batch sizes
- `T1`, `T2`: total times for each batch

Formula:
```math
a_1 = \frac{T_1}{n_1},\quad a_2 = \frac{T_2}{n_2}
```
```math
b = \frac{\log(a_2/a_1)}{\log(n_2/n_1)}
```
Returns progress ratio: ``2^b``
"""
function learn_rate(::CrawfordMethod, n1::Real, T1::Real, n2::Real, T2::Real)::Float64
    a1 = T1 / n1
    a2 = T2 / n2
    b  = (log(a2) - log(a1)) / (log(n2) - log(n1))
    return 2.0^b
end

@doc raw"""
    learn_rate(::ExperienceMethod, n1, avg1, n2, avg2) -> Float64

Two-point fit for Experience curve:
- `n1`, `n2`: cumulative units
- `avg1`, `avg2`: cumulative average cost/time

Formula:
```math
b = \frac{\log(\text{avg}_2/\text{avg}_1)}{\log(n_2/n_1)}
```
Returns progress ratio: ``2^b``
"""
function learn_rate(::ExperienceMethod, n1::Real, avg1::Real, n2::Real, avg2::Real)::Float64
    b = (log(avg2) - log(avg1)) / (log(n2) - log(n1))
    return 2.0^b
end

#------------------------------------------------------------------------------
# Curve Generation and Fitting
#------------------------------------------------------------------------------

@doc raw"""
    lc_fit(method, x1, n1, n2, x2) -> Tuple{Float64,Float64}

Fit power-law slope b and progress ratio for any method using two points:
- `x1` at `n1`, `x2` at `n2`.
Returns `(b, 2^b)`.
"""
function lc_fit(::LearningCurveMethod, x1::Real, n1::Real, n2::Real, x2::Real)
    b = (log(x2) - log(x1)) / (log(n2) - log(n1))
    return b, 2.0^b
end

@doc raw"""
    lc_curve(method, x1, n1, n2, x2; steps) -> DataFrame

Generate DataFrame of time per unit across `steps` points between `n1` and `n2`:
- `x1` at `n1`, slope b from two-point fit, then x(n) = x1*(n/n1)^b.
"""
function lc_curve(::LearningCurveMethod, x1::Real, n1::Real, n2::Real, x2::Real; steps::Int=100)::DataFrame
    b = (log(x2) - log(x1)) / (log(n2) - log(n1))
    ns = range(n1, n2, length=steps)
    xs = x1 .* (ns ./ n1) .^ b
    return DataFrame(Units=collect(ns), Time=collect(xs))
end

#------------------------------------------------------------------------------
# Comparison of Cumulative Costs Across Learning Rates
#------------------------------------------------------------------------------

@doc raw"""
    learn_rates(initial, N; α_step) -> DataFrame

Compare cumulative cost at total units `N` across methods for learning exponents from 0 to 1:
- `initial` cost parameter
- `N` total units
- `α_step`: increment for the learning exponent scan

Returns DataFrame with columns `:α`, `:Wright`, `:Crawford`, `:Experience`.
"""
function learn_rates(initial::Real, N::Integer; α_step::Real=0.1)::DataFrame
    df = DataFrame(α=Float64[], Wright=Float64[], Crawford=Float64[], Experience=Float64[])
    for α in 0:α_step:1
        w = lc_analytic(WrightMethod(), initial, N, α)
        c = lc_analytic(CrawfordMethod(), initial, N, α)
        e = lc_analytic(ExperienceMethod(), initial, N, α)
        push!(df, (α, w, c, e))
    end
    return df
end

end # module
