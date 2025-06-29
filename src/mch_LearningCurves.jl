

#------------------------------------------------------------------------------
# Types for Multiple Dispatch
#------------------------------------------------------------------------------

"""
    abstract type LearningCurveMethod end

    Abstract type for learning curve methods for MCHammer
        
"""
abstract type LearningCurveMethod end

"""
Wright learning curve method. 

    struct WrightMethod <: LearningCurveMethod end

Introduced by T.P. Wright in 1936 in his seminal work on airplane production cost 
analysis (Wright, 1936).  This model observes that with each doubling of cumulative production, the unit cost 
decreases by a fixed percentage. It is well‐suited for processes where learning is continuous and 
gradual.  

\
\
``\\text{Cost} = \\text{InitialEffort} \\times \\text{TotalUnits}^{\\frac{\\log(\\text{Learning})}{\\log(2)} + 1}``

\
\
**When to Use:**  
  - When historical data show a smooth, predictable decline in unit costs as production doubles.  

  **When to Avoid:**  
  - When cost reductions occur in discrete steps or when the production process experiences structural changes.

"""
struct WrightMethod <: LearningCurveMethod end

"""
Crawford learning curve method.
        
    struct CrawfordMethod <: LearningCurveMethod end

Derived from discrete cumulative cost analysis methods found in operations research, the Crawford 
learning curve (e.g., Crawford, 1982) aggregates individual unit costs—which decrease according to a 
power‐law function of the unit index—to yield a total cost. Unlike the smooth curves of Wright and Experience, the Crawford method sums unit‐by‐unit 
costs that are reduced based on their position in the production sequence.  

\
\
``\\text{Cost} = \\sum_{i=1}^{\\text{TotalUnits}} \\text{InitialEffort} \\times i^{\\frac{\\log(\\text{Learning})}{\\log(2)}}``
\
\

**When to Use:**  
  - When you have detailed unit cost data and need a granular, discrete analysis of learning effects.  

**When to Avoid:**  
  - When the overall cost trend is continuous and best represented by a smooth curve, in which case 
    Wright’s or the Experience model might be preferable.
"""
struct CrawfordMethod <: LearningCurveMethod end

"""
Experience learning curve method.
    
        struct ExperienceMethod <: LearningCurveMethod end

Popularized by Bruce Henderson of the Boston Consulting Group in the 1970s, the experience 
curve expands on Wright’s observation to encompass total cost reductions (including overhead and other 
factors) as cumulative production increases. It suggests that as cumulative output doubles, total costs fall by a constant percentage,
reflecting economies of scale and learning effects throughout an organization.  

\
\
``\\text{Cost} = \\text{InitialEffort} \\times (\\text{TotalUnits}^{\\text{Learning}})``
\
\

**When to Use:**  
  - For strategic analysis and competitive planning when broad organizational efficiency improvements 
    are observed.  

    **When to Avoid:**  
  - When cost behavior is highly non-linear or when improvements are due to sudden technological breakthroughs.
"""
struct ExperienceMethod <: LearningCurveMethod end

#------------------------------------------------------------------------------
# Analytic (Cumulative Cost) Functions
#------------------------------------------------------------------------------

@doc """
    lc_analytic(::ExperienceMethod, InitialEffort, TotalUnits, Learning)

Compute the cumulative cost using the Experience model.

Formula:
    cost = InitialEffort * (TotalUnits ^ Learning)
""" lc_analytic(::ExperienceMethod, InitialEffort, TotalUnits, Learning)
function lc_analytic(::ExperienceMethod, InitialEffort, TotalUnits, Learning)
    return InitialEffort * (TotalUnits ^ Learning)
end



"""
    lc_analytic(::WrightMethod, InitialEffort, TotalUnits, Learning)

Compute the cumulative cost using Wright's learning curve model.

Formula:
    cost = InitialEffort * (TotalUnits ^ ((log(Learning) / log(2)) + 1))
"""
function lc_analytic(::WrightMethod, InitialEffort, TotalUnits, Learning)
    exponent = (log(Learning) / log(2)) + 1
    return InitialEffort * (TotalUnits ^ exponent)
end


"""
    lc_analytic(::CrawfordMethod, InitialEffort, TotalUnits, Learning)

Compute the cumulative cost using Crawford's learning curve model.

Formula:
    cost = Σ(i=1 to TotalUnits)[ InitialEffort * i ^ (log(Learning) / log(2)) ]
"""
function lc_analytic(::CrawfordMethod, InitialEffort, TotalUnits, Learning)
    exponent = log(Learning) / log(2)
    total_cost = 0.0
    for i in 1:TotalUnits
        total_cost += InitialEffort * (i ^ exponent)
    end
    return total_cost
end

#------------------------------------------------------------------------------
# Curve Functions (Generate DataFrames)
#------------------------------------------------------------------------------

@doc"""
Generate a learning curve as a DataFrame for a given method. 

    lc_curve(method::LearningCurveMethod, InitialEffort, TotalUnits, Learning; LotSize=1)
    
The DataFrame columns are:
- `Units`: Production unit number.
- `CurvePoint`: Cumulative cost/effort at that unit.
- `IncrementalCost`: Difference in cumulative cost from the previous step.
- `AvgCost`: Average cost per unit up to that point.
- `Method`: A string identifier for the method.
""" lc_curve(method::LearningCurveMethod, InitialEffort, TotalUnits, Learning; LotSize=1)
function lc_curve(method::LearningCurveMethod, InitialEffort, TotalUnits, Learning; LotSize=1)
    df = DataFrame(
        Units=Float64[],
        CurvePoint=Float64[],
        IncrementalCost=Float64[],
        AvgCost=Float64[],
        Method=String[]
    )
    prev = 0.0
    method_str = method isa WrightMethod ? "Wright" :
                method isa CrawfordMethod ? "Crawford" :
                "Experience"
    for units in 1:LotSize:TotalUnits
        cp = lc_analytic(method, InitialEffort, units, Learning)
        incremental = cp - prev
        avg = cp / units
        push!(df, (units, cp, incremental, avg, method_str))
        prev = cp
    end
    return df
end

#------------------------------------------------------------------------------
# Fitting Functions
#------------------------------------------------------------------------------

@doc """
    lc_fit(::ExperienceMethod, InitialEffort, Units; EstLC=0.8)

Fit the learning rate for the Experience method by adjusting the rate 
until its analytic cumulative cost converges to that computed using Wright's model.
"""
function lc_fit(::ExperienceMethod, InitialEffort, Units; EstLC=0.8)
    target = lc_analytic(WrightMethod(), InitialEffort, Units, EstLC)
    rate = EstLC
    while target < lc_analytic(ExperienceMethod(), InitialEffort, Units, rate)
        rate -= 0.0001
    end
    return rate
end

""" 
    lc_fit(::CrawfordMethod, InitialEffort, Units; EstLC=0.8)

Fit the learning rate for the Crawford method by adjusting the rate 
until its analytic cumulative cost converges to that computed using Wright's model.
"""
function lc_fit(::CrawfordMethod, InitialEffort, Units; EstLC=0.8)
    target = lc_analytic(WrightMethod(), InitialEffort, Units, EstLC)
    rate = EstLC
    while target < lc_analytic(CrawfordMethod(), InitialEffort, Units, rate)
        rate -= 0.0001
    end
    return rate
end

"""
    lc_fit(::WrightMethod, InitialEffort, Units; EstLC=0.8)

Wright's method is taken as the baseline model so no fitting is performed. 
Returns the provided estimated learning rate.
"""
function lc_fit(::WrightMethod, InitialEffort, Units; EstLC=0.8)
    return EstLC
end

#------------------------------------------------------------------------------
# Wright Learning Rate from Two Data Points
#------------------------------------------------------------------------------

"""
Estimate the learning rate using Wright's method from two production data points. 
    
    learn_rate(::WrightMethod, UnitsA, WorkA, UnitsB, WorkB)

# Arguments
- `UnitsA`: cumulative units at point A (independent variable, x-axis)
- `WorkA`: total effort/cost for point A (dependent variable, y-axis)
- `UnitsB`: cumulative units at point B (independent variable, x-axis)  
- `WorkB`: total effort/cost for point B (dependent variable, y-axis)

This method can be used as a starting point for the Crawford and Experience curves because no closed form solutions exist for these methods.
""" 
function learn_rate(::WrightMethod, UnitsA, WorkA, UnitsB, WorkB)
    b_val = log(UnitsB) - log(UnitsA)
    x_val = b_val
    return 10 ^ (((log(WorkB) - log(WorkA) - x_val) / b_val) * (log(2) / log(10)))
end

"""
Estimate the learning rate using Crawford's method from two production data points.
    
    learn_rate(::CrawfordMethod, UnitsA, WorkA, UnitsB, WorkB)

# Arguments
- `UnitsA`: cumulative units at point A (independent variable, x-axis)
- `WorkA`: total effort/cost for point A (dependent variable, y-axis)
- `UnitsB`: cumulative units at point B (independent variable, x-axis)  
- `WorkB`: total effort/cost for point B (dependent variable, y-axis)

This method uses an iterative approach to estimate the learning rate since Crawford's method
does not have a closed-form solution for rate estimation from two data points.
"""
function learn_rate(::CrawfordMethod, UnitsA, WorkA, UnitsB, WorkB)
    # Start with Wright's method as initial estimate
    initial_rate = learn_rate(WrightMethod(), UnitsA, WorkA, UnitsB, WorkB)
    
    # Use iterative approach with numerical optimization
    rate = initial_rate
    tolerance = 1e-6
    max_iterations = 1000
    step_size = 0.001
    
    best_rate = rate
    best_error = Inf
    
    for iteration in 1:max_iterations
        # Calculate initial effort from point A
        initial_effort = WorkA / lc_analytic(CrawfordMethod(), 1.0, UnitsA, rate)
        
        # Calculate predicted cost at point B
        predicted_WorkB = lc_analytic(CrawfordMethod(), initial_effort, UnitsB, rate)
        
        # Calculate error
        error = abs(predicted_WorkB - WorkB)
        
        if error < best_error
            best_error = error
            best_rate = rate
        end
        
        if error < tolerance
            break
        end
        
        # Gradient-based adjustment
        rate_plus = rate + step_size
        initial_effort_plus = WorkA / lc_analytic(CrawfordMethod(), 1.0, UnitsA, rate_plus)
        predicted_WorkB_plus = lc_analytic(CrawfordMethod(), initial_effort_plus, UnitsB, rate_plus)
        error_plus = abs(predicted_WorkB_plus - WorkB)
        
        # Adjust rate based on gradient
        if error_plus < error
            rate += step_size
        else
            rate -= step_size
        end
        
        # Adaptive step size
        if iteration % 100 == 0
            step_size *= 0.9
        end
    end
    
    return best_rate
end

"""
Estimate the learning rate using Experience method from two production data points.
    
    learn_rate(::ExperienceMethod, UnitsA, WorkA, UnitsB, WorkB)

# Arguments
- `UnitsA`: cumulative units at point A (independent variable, x-axis)
- `WorkA`: total effort/cost for point A (dependent variable, y-axis)
- `UnitsB`: cumulative units at point B (independent variable, x-axis)  
- `WorkB`: total effort/cost for point B (dependent variable, y-axis)

This method uses the Experience curve formula to estimate the learning rate directly
from two data points using logarithmic transformation.
"""
function learn_rate(::ExperienceMethod, UnitsA, WorkA, UnitsB, WorkB)
    # Experience curve: Cost = InitialEffort * (Units^Learning)
    # Taking log: log(Cost) = log(InitialEffort) + Learning * log(Units)
    # From two points: Learning = (log(WorkB) - log(WorkA)) / (log(UnitsB) - log(UnitsA))
    
    if UnitsA == UnitsB
        error("UnitsA and UnitsB cannot be equal")
    end
    
    learning_rate = (log(WorkB) - log(WorkA)) / (log(UnitsB) - log(UnitsA))
    
    return learning_rate
end

#------------------------------------------------------------------------------
# Comparison Utility
#------------------------------------------------------------------------------

"""
Generate a comparison of cumulative costs for a range of learning rates (0 to 1) 
across the three methods: Wright, Crawford, and Experience.
    
    learn_rates(InitialEffort, Units; LC_Step=0.1)

Returns a DataFrame with columns:
- `LC`: The learning rate.
- `Wright`: Cumulative cost from Wright's model.
- `Crawford`: Cumulative cost from Crawford's model.
- `Experience`: Cumulative cost from the Experience model.
"""
function learn_rates(InitialEffort, Units; LC_Step=0.1)
    df = DataFrame(LC=Float64[], Wright=Float64[], Crawford=Float64[], Experience=Float64[])
    for lc in 0:LC_Step:1
        w_cost = lc_analytic(WrightMethod(), InitialEffort, Units, lc)
        c_cost = lc_analytic(CrawfordMethod(), InitialEffort, Units, lc)
        e_cost = lc_analytic(ExperienceMethod(), InitialEffort, Units, lc)
        push!(df, (lc, w_cost, c_cost, e_cost))
    end
    sort!(df, :LC, rev=true)
    return df
end
