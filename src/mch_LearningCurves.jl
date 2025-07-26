
module MCHammer.LearningCurves

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

"""
    lc_analytic(::WrightMethod, initial, α, N) -> Float64

Compute cumulative cost using Wright’s model:
- `initial`: base cost for first unit
- `α`: learning exponent (progress ratio = 2^b)
- `N`: total units

Formula:
```
cost = initial * sum(i^(-α) for i in 1:N)
```
"""
function lc_analytic(::WrightMethod, initial::Real, α::Real, N::Integer)::Float64
    return initial * sum(i^(-α) for i in 1:N)
end

"""
    lc_analytic(::CrawfordMethod, initial, α, N) -> Float64

Compute cumulative cost using Crawford’s model (same analytic form as Wright):
- Uses batch-average reduction.

Formula:
```
cost = initial * sum(i^(-α) for i in 1:N)
```
"""
lc_analytic(::CrawfordMethod, initial::Real, α::Real, N::Integer) = lc_analytic(WrightMethod(), initial, α, N)

"""
    lc_analytic(::ExperienceMethod, initial_avg, α, N) -> Float64

Compute cumulative cost using Experience curve:
- `initial_avg`: average cost per unit at unit 1
- `α`: learning exponent
- `N`: total units

Formula:
```
cost = (initial_avg * N^(-α)) * N
```
"""
function lc_analytic(::ExperienceMethod, initial_avg::Real, α::Real, N::Integer)::Float64
    avgN = initial_avg * N^(-α)
    return avgN * N
end

#------------------------------------------------------------------------------
# Two-Point Learning-Rate Estimation
#------------------------------------------------------------------------------

"""
    learn_rate(::WrightMethod, n1, x1, n2, x2) -> Float64

Two-point fit for Wright’s method:
- `n1`,`n2`: unit indices
- `x1`,`x2`: time for nth unit

b = log(x2/x1)/log(n2/n1), returns progress ratio = 2^b.
"""
function learn_rate(::WrightMethod, n1::Real, x1::Real, n2::Real, x2::Real)::Float64
    b = (log(x2) - log(x1)) / (log(n2) - log(n1))
    return 2.0^b
end

"""
    learn_rate(::CrawfordMethod, n1, T1, n2, T2) -> Float64

Two-point fit for Crawford’s method:
- `n1`,`n2`: batch sizes
- `T1`,`T2`: total times for each batch

a1 = T1/n1, a2 = T2/n2; b = log(a2/a1)/log(n2/n1); returns 2^b.
"""
function learn_rate(::CrawfordMethod, n1::Real, T1::Real, n2::Real, T2::Real)::Float64
    a1 = T1 / n1
    a2 = T2 / n2
    b  = (log(a2) - log(a1)) / (log(n2) - log(n1))
    return 2.0^b
end

"""
    learn_rate(::ExperienceMethod, n1, avg1, n2, avg2) -> Float64

Two-point fit for Experience curve:
- `n1`,`n2`: cumulative units
- `avg1`,`avg2`: cumulative average cost/time

b = log(avg2/avg1)/log(n2/n1); returns 2^b.
"""
function learn_rate(::ExperienceMethod, n1::Real, avg1::Real, n2::Real, avg2::Real)::Float64
    b = (log(avg2) - log(avg1)) / (log(n2) - log(n1))
    return 2.0^b
end

#------------------------------------------------------------------------------
# Curve Generation and Fitting
#------------------------------------------------------------------------------

"""
    lc_fit(method, x1, n1, n2, x2) -> Tuple{Float64,Float64}

Fit power-law slope b and progress ratio for any method using two points:
- `x1` at `n1`, `x2` at `n2`.
Returns `(b, 2^b)`.
"""
function lc_fit(::LearningCurveMethod, x1::Real, n1::Real, n2::Real, x2::Real)
    b = (log(x2) - log(x1)) / (log(n2) - log(n1))
    return b, 2.0^b
end

"""
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

"""
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
        w = lc_analytic(WrightMethod(), initial, α, N)
        c = lc_analytic(CrawfordMethod(), initial, α, N)
        e = lc_analytic(ExperienceMethod(), initial, α, N)
        push!(df, (α, w, c, e))
    end
    return df
end

end # module
