#module LearningCurves

using DataFrames

export LearningCurveMethod, WrightMethod, CrawfordMethod, ExperienceMethod
export lc_analytic, lc_curve, lc_fit, learn_rate, learn_rates

# =====================================================================
# Types
# =====================================================================


"""
    abstract type LearningCurveMethod end

    Abstract type for learning curve methods for MCHammer
        
"""
abstract type LearningCurveMethod end

"""
Wright learning curve method. 

    struct WrightMethod <: LearningCurveMethod end

Introduced by T.P. Wright in 1936 in his seminal work on airplane production cost 
analysis (Wright, 1936). This model observes that with each doubling of cumulative production, the unit cost 
decreases by a fixed percentage. It is well‑suited for processes where learning is continuous and gradual.

**Parameters (package-wide convention)**
- `Learning` = progress ratio **LR** in `(0,1]` (e.g. `0.85` = 85%)
- `b = log(Learning)/log(2)` (negative when there is learning)
- `InitialEffort` = first‑unit cost `C₁`

**Implementation returns cumulative total cost (cumulative‑average form):**
```math
\\mathrm{Total}(N)=C_1\\,N^{\\,b+1},\\qquad b=\\frac{\\log(\\mathrm{LR})}{\\log 2}
```
**Unit‑cost form (reference):**
```math
C_N = C_1\\,N^{\\,b}
```

**When to Use**
- When historical data show a smooth, predictable decline in unit costs as production doubles.

**When to Avoid**
- When cost reductions occur in discrete steps or when the production process experiences structural changes.
"""
struct WrightMethod <: LearningCurveMethod end

"""
Crawford learning curve method.

    struct CrawfordMethod <: LearningCurveMethod end

Crawford models per‑unit learning discretely and accumulates unit costs.

**Parameters**
- `Learning` = progress ratio **LR** in `(0,1]`
- `b = log(Learning)/log(2)`
- `InitialEffort` = first‑unit cost `C₁`

**Implementation returns cumulative total cost (discrete sum):**
```math
\\mathrm{Total}(N)=\\sum_{i=1}^N C_1\\, i^{\\,b}
```
**Per‑unit cost (reference):** 
```math
C_i = C_1\\, i^{\\,b}
```
"""
struct CrawfordMethod <: LearningCurveMethod end

"""
Experience learning curve method.

    struct ExperienceMethod <: LearningCurveMethod end

BCG/Excel-style experience curve where the **exponent equals the progress ratio** `LR`.
This matches spreadsheet formulas like `C1 * N^(LR)`; e.g., with `LR=0.8` the total is `C1 * N^0.8`.

**Parameters**
- `Learning` = progress ratio **LR** in `(0,1]`
- `InitialEffort` = average cost at `N=1` (`\bar{C}_1`)

**Implementation returns cumulative total cost:**
```math
\\mathrm{Total}(N)=\\bar{C}_1\\,N^{\\,\\mathrm{LR}}
```

**When to Use**
- Strategic/competitive planning when broad efficiency improvements are observed and spreadsheet convention is desired.

**When to Avoid**
- When per‑unit discreteness dominates (see `CrawfordMethod`).
"""
struct ExperienceMethod <: LearningCurveMethod end

# =====================================================================
# Internal helpers (not exported)
# =====================================================================

# Convert progress ratio p to slope b (for Wright & Crawford)
_b_from_p(p::Real) = log(p) / log(2)

# Wright unit-increment (difference of cumulative totals)
_wright_unit_inc(n::Real, b::Real) = n^(1+b) - (n-1)^(1+b)

# Two-point solver for Wright from UNIT times; returns b
function _wright_two_point_unit_b(n1::Real, u1::Real, n2::Real, u2::Real;
                                  tol::Real=1e-10, maxiter::Int=200)::Float64
    @assert n1>0 && n2>0 && u1>0 && u2>0
    R = u2 / u1
    f(b) = log(R) - log( _wright_unit_inc(n2, b) / _wright_unit_inc(n1, b) )

    # Bracket then bisection
    lo, hi = -3.0, 1.0
    nbins = 80
    xs = range(lo, hi; length=nbins)
    vals = [f(x) for x in xs]
    bracket = false
    a = xs[1]; fa = vals[1]
    for (x, fx) in zip(xs[2:end], vals[2:end])
        if fa * fx < 0
            lo = a; hi = x; bracket = true; break
        end
        a = x; fa = fx
    end
    b_est = 0.0
    if bracket
        a = lo; b = hi; fa = f(a); fb = f(b)
        iter = 0
        while iter < maxiter && (b - a) > tol
            m = (a + b) / 2
            fm = f(m)
            if fa * fm <= 0
                b = m; fb = fm
            else
                a = m; fa = fm
            end
            iter += 1
        end
        b_est = (a + b) / 2
    else
        # fallback: secant from endpoints
        x0, x1 = lo, hi
        f0, f1 = f(x0), f(x1)
        iter = 0
        while iter < maxiter && abs(x1 - x0) > tol
            denom = (f1 - f0)
            if abs(denom) < 1e-16
                break
            end
            x2 = x1 - f1 * (x1 - x0) / denom
            x0, f0, x1, f1 = x1, f1, x2, f(x2)
            iter += 1
        end
        b_est = x1
    end
    return b_est
end

# Fit Wright AVG on vectors via log-log least squares; returns (a,b,p,sse)
function _fit_wright_avg(ns::AbstractVector, ys::AbstractVector)
    ns = collect(ns); ys = collect(ys)
    @assert length(ns) == length(ys) ≥ 2 "Need at least two points"
    @assert all(ns .> 0) && all(ys .> 0)
    X = [ones(length(ns)) log.(ns)]
    θ = X \ log.(ys)
    loga, b = θ
    a = exp(loga)
    yhat = a .* (ns .^ b)
    sse = sum((ys .- yhat).^2)
    return a, b, 2.0^b, sse
end

# Fit Wright UNIT on vectors by searching over b and LS for a; returns (a,b,p,sse)
function _fit_wright_unit(ns::AbstractVector, ys::AbstractVector)
    ns = collect(ns); ys = collect(ys)
    @assert length(ns) == length(ys) ≥ 2 "Need at least two points"
    @assert all(ns .> 0) && all(ys .> 0)
    function sse_for_b(b)
        F = _wright_unit_inc.(ns, b)
        denom = sum(F.^2)
        if denom ≤ 0
            return Inf, 0.0, F
        end
        a = sum(F .* ys) / denom
        yhat = a .* F
        return sum((ys .- yhat).^2), a, F
    end
    bgrid = range(-2.5, 0.5; length=121)
    best_sse = Inf; best_b = -0.3; best_a = NaN
    for b in bgrid
        sse, a, _ = sse_for_b(b)
        if sse < best_sse
            best_sse = sse; best_b = b; best_a = a
        end
    end
    # refine locally
    for δ in (0.1, 0.05, 0.02, 0.01, 0.005)
        for b in (best_b-δ):δ/10:(best_b+δ)
            sse, a, _ = sse_for_b(b)
            if sse < best_sse
                best_sse = sse; best_b = b; best_a = a
            end
        end
    end
    return best_a, best_b, 2.0^best_b, best_sse
end

# =====================================================================
# Analytic cumulative‑cost functions
# =====================================================================

"""
    lc_analytic(::ExperienceMethod, InitialEffort, TotalUnits, Learning)

Returns the **cumulative total cost** using the Excel/BCG convention where the
**exponent equals the progress ratio** `LR`:

```math
\\mathrm{Total}(N)=\\bar{C}_1\\,N^{\\,\\mathrm{LR}}
```
"""
function lc_analytic(::ExperienceMethod, InitialEffort::Real, TotalUnits::Integer, Learning::Real)
    @assert TotalUnits ≥ 0 "TotalUnits must be non‑negative"
    @assert 0 < Learning ≤ 1 "Experience Learning (progress ratio) must be in (0,1]"
    return InitialEffort * (TotalUnits ^ Learning)
end

"""
    lc_analytic(::WrightMethod, InitialEffort, TotalUnits, Learning)

Returns the **cumulative total cost up to `TotalUnits`** for Wright’s cumulative‑average model
with progress ratio `LR` (`b = log(LR)/log 2`):

```math
\\mathrm{Total}(N)=C_1\\,N^{\\,b+1}
```
"""
function lc_analytic(::WrightMethod, InitialEffort::Real, TotalUnits::Integer, Learning::Real)
    @assert TotalUnits ≥ 0 "TotalUnits must be non‑negative"
    @assert 0 < Learning ≤ 1 "Wright Learning (progress ratio) must be in (0,1]"
    b = _b_from_p(Learning)
    return InitialEffort * (TotalUnits ^ (1 + b))
end

"""
    lc_analytic(::CrawfordMethod, InitialEffort, TotalUnits, Learning)

Returns the **cumulative total cost up to `TotalUnits`** for Crawford’s discrete unit model:

```math
\\mathrm{Total}(N)=\\sum_{i=1}^{N} C_1\\, i^{\\,b},\\qquad b=\\frac{\\log(\\mathrm{LR})}{\\log 2}
```
"""
function lc_analytic(::CrawfordMethod, InitialEffort::Real, TotalUnits::Integer, Learning::Real)
    @assert TotalUnits ≥ 0 "TotalUnits must be non‑negative"
    @assert 0 < Learning ≤ 1 "Crawford Learning (progress ratio) must be in (0,1]"
    b = _b_from_p(Learning)
    total = 0.0
    for i in 1:TotalUnits
        total += InitialEffort * (i ^ b)
    end
    return total
end

# =====================================================================
# Two‑point learning‑rate estimation (public API)
# =====================================================================

"""
    learn_rate(::WrightMethod, n1, y1, n2, y2; mode=:avg) -> Float64

Estimate Wright **progress ratio** `p` from two observations.

- If `mode = :avg` (default), `y` values are **cumulative averages** at `n1` and `n2`:
```math
b = \\frac{\\ln(y_2/y_1)}{\\ln(n_2/n_1)}, \\quad p = 2^b.
```
- If `mode = :unit`, `y` values are **unit times** at `n1` and `n2`. The function solves
for `b` from the unit‑increment relation and returns `p = 2^b`.
"""
function learn_rate(::WrightMethod, n1::Real, y1::Real, n2::Real, y2::Real; mode::Symbol=:avg)::Float64
    @assert n1>0 && n2>0 && y1>0 && y2>0
    if mode === :avg
        b = (log(y2) - log(y1)) / (log(n2) - log(n1))
        return 2.0 ^ b
    elseif mode === :unit
        b = _wright_two_point_unit_b(n1, y1, n2, y2)
        return 2.0 ^ b
    else
        error("For two points, set mode=:avg (cumulative averages) or :unit (unit times)." )
    end
end

"""
    learn_rate(::WrightMethod, n::AbstractVector, y::AbstractVector; mode=:auto) -> Float64

Estimate Wright **progress ratio** `p` from ≥3 points. If `mode = :auto` (default),
fits both average and unit models and picks the lower SSE. Set `mode=:avg` or
`:unit` to force a specific interpretation.
"""
function learn_rate(::WrightMethod, n::AbstractVector, y::AbstractVector; mode::Symbol=:auto)::Float64
    if mode === :avg
        _, _, p, _ = _fit_wright_avg(n, y)
        return p
    elseif mode === :unit
        _, _, p, _ = _fit_wright_unit(n, y)
        return p
    else
        # auto
        _, _, p_avg, sse_avg  = _fit_wright_avg(n, y)
        _, _, p_unit, sse_unit = _fit_wright_unit(n, y)
        return sse_avg ≤ sse_unit ? p_avg : p_unit
    end
end

"""
    learn_rate(::CrawfordMethod, i1, y1, i2, y2) -> Float64

Two‑point fit for Crawford’s **unit** model using **per‑unit** costs
`y(i) = a i^b`. With two observations `(i₁, y₁)` and `(i₂, y₂)`:
```math
b = \\frac{\\ln(y_2/y_1)}{\\ln(i_2/i_1)}, \\quad p = 2^b.
```
Returns the learning rate `p`.
"""
function learn_rate(::CrawfordMethod, i1::Real, y1::Real, i2::Real, y2::Real)::Float64
    b  = (log(y2) - log(y1)) / (log(i2) - log(i1))
    return 2.0 ^ b
end

"""
    learn_rate(::ExperienceMethod, n1, avg1, n2, avg2) -> Float64

Two‑point fit for the Experience curve under the Excel/BCG convention where the
**exponent equals LR**. Given cumulative **totals** `T(N) = \bar{C}_1 N^{LR}`, the
average at `N` is `avg(N) = T(N)/N = \bar{C}_1 N^{LR-1}`. Using averages:
```math
LR = 1 + \\frac{\\ln(\\mathrm{avg}_2/\\mathrm{avg}_1)}{\\ln(n_2/n_1)}.
```
Returns `LR` (e.g., `0.8`).
"""
function learn_rate(::ExperienceMethod, n1::Real, avg1::Real, n2::Real, avg2::Real)::Float64
    LR = 1 + (log(avg2) - log(avg1)) / (log(n2) - log(n1))
    return LR
end

"""
    lc_fit(::LearningCurveMethod, n1, x1, n2, x2) -> (b, p)

Generic two‑point fit for a power law `x = a n^b`. Returns the slope `b` and
the progress ratio `p = 2^b`.
"""
function lc_fit(::LearningCurveMethod, n1::Real, x1::Real, n2::Real, x2::Real)
    b = (log(x2) - log(x1)) / (log(n2) - log(n1))
    return b, 2.0 ^ b
end

# =====================================================================
# Curve generation
# =====================================================================
"""
    lc_curve(method::LearningCurveMethod,
             InitialEffort::Real,
             StartUnit::Integer,
             TotalUnits::Integer,
             Learning::Real;
             steps::Integer=1) -> DataFrame

Build a table of cumulative and per-unit costs.

Columns:
- `Units` — cumulative units at this row (StartUnit:steps:TotalUnits)
- `CumulativeCost` — total cost up to `Units` (via `lc_analytic`)
- `Incremental` — **per-unit** cost at `Units` (`C_N`)
  * Wright/Experience: `T(N) - T(N-1)` where `T(·)` is the cumulative total
  * Crawford: direct unit cost `C_N = C₁ · N^b`, with `b = log(LR)/log(2)`
- `AvgCost` — `CumulativeCost / Units`
- `Method` — method name
"""
function lc_curve(method::LearningCurveMethod,
                  InitialEffort::Real,
                  StartUnit::Integer,
                  TotalUnits::Integer,
                  Learning::Real; steps::Integer=1)

    @assert StartUnit ≥ 1 "StartUnit must be ≥ 1"
    @assert TotalUnits ≥ StartUnit "TotalUnits must be ≥ StartUnit"
    @assert steps ≥ 1 "steps must be ≥ 1"

    df = DataFrame(Units=Float64[], CumulativeCost=Float64[],
                   Incremental=Float64[], AvgCost=Float64[], Method=String[])

    method_str = method isa WrightMethod    ? "Wright" :
                 method isa CrawfordMethod  ? "Crawford" :
                 method isa ExperienceMethod ? "Experience" : "Unknown"

    # precompute b when needed
    b = (method isa WrightMethod || method isa CrawfordMethod) ? _b_from_p(Learning) : nothing

    for n in StartUnit:steps:TotalUnits
        # cumulative total via the package's analytic formula
        cum = lc_analytic(method, InitialEffort, n, Learning)
        avg = cum / n

        incr = if method isa CrawfordMethod
            # unit model: per-unit cost at N
            InitialEffort * (n ^ b)
        else
            # average models (Wright, Experience): per-unit = T(N) - T(N-1)
            prev_cum = (n > 1) ? lc_analytic(method, InitialEffort, n - 1, Learning) : 0.0
            cum - prev_cum
        end

        push!(df, (Float64(n), cum, incr, avg, method_str))
    end

    return df
end

# =====================================================================
# Comparison across learning ratios
# =====================================================================


"""
    learn_rates(InitialEffort, TotalUnits; LR_step=0.1) -> DataFrame

Compare cumulative total cost across methods for a sweep of progress ratios `LR` in (0, 1].

Totals at N = `TotalUnits`:
- Wright:     T_W(N) = C₁ * N^(1 + b),   with b = log(LR) / log(2)
- Crawford:   T_C(N) = ∑_{i=1}^N C₁ * i^b, with b = log(LR) / log(2)
- Experience: T_E(N) = C₁ * N^(LR)
"""
function learn_rates(InitialEffort::Real, TotalUnits::Integer; LR_step::Real=0.1)::DataFrame
    @assert 0 < LR_step ≤ 1 "LR_step must be in (0,1]"

    df = DataFrame(LR=Float64[], Wright=Float64[], Crawford=Float64[], Experience=Float64[])

    # Sweep LR from LR_step up to 1.0
    for LR in range(LR_step, stop=1.0, step=LR_step)
        w_cost = lc_analytic(WrightMethod(),      InitialEffort, TotalUnits, LR)
        c_cost = lc_analytic(CrawfordMethod(),    InitialEffort, TotalUnits, LR)
        e_cost = lc_analytic(ExperienceMethod(),  InitialEffort, TotalUnits, LR)
        push!(df, (Float64(LR), w_cost, c_cost, e_cost))
    end

    sort!(df, :LR, rev=true)  # show 1.0 → smaller LR
    return df
end


#end # module
