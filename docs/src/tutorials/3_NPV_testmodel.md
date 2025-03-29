# Simulated NPV with Time-Series

## Load Environment
Let's start by making sure all the tools we nned are loaded up. You will almost always need to load these packages up anytime you are build a Monte-Carlo model.

```@setup NPVModel
#=using Pkg
Pkg.add("Distributions")
Pkg.add("StatsBase")
Pkg.add("Statistics")
Pkg.add("Dates")
Pkg.add("MCHammer")
Pkg.add("DataFrames")
Pkg.add("Plots")
Pkg.add("StatsPlots")=#

using Distributions
using Dates
using Plots, StatsPlots
using StatsBase, Statistics
using MCHammer
using DataFrames
```

## Setup Inputs and Outputs
The next critical step is to setup key inputs, arrays and other important model parameters.

```@example NPVModel
#Setup the Date Range for the analysis
dr = collect(Date(2019,1,01):Dates.Year(1):Date(2023,01,01))

#Setup Global Inputs
ForecastYrs = 5
Trials = 10000
Units = [5000, 10000, 17000, 18000, 20000]
InitialInvestment = 250000
Investment = [100000, 0, 0, 25000,0] #fill(0,ForecastYrs)

#Setup Outputs
Sensitivity_Tbl = []

ProjectNPV = []
USP = []
USC =[]
DR = []
OP =[]
Annual_CashFlows =[]
```
## Simulation Model
Monte-Carlo simulation needs to generate a table of scenarios which are known as **Trials**. A trial documents, in the form of a row, all of the inputs and calculated outputs for a particular scenario.

Using this results table allows you to runs all sorts of analysis, including sensitivity analysis and assigning probabilities to outcomes. To generate this table, you need to loop your equation/function as many times as you need and vary the inputs using probability distributions.

Another challenge to account for is that our example is a 5yr NPV model which requires building and analyzing the results over multiple periods. To extend the model, we are using MCHammer's GBMM function that allows to project a random walk forecast over how ever many periods you need, which extends automatically the model in Julia.

```@example NPVModel
for i = 1:Trials
    UnitSellPrice = GBMM(80, 0.2, 0.1, ForecastYrs)
    UnitCost = GBMM(40, 0.1, 0.05, ForecastYrs)

    #Each period the discount rate is independent. If you use an additive method instead of multiplicative, you can end up with differences. These may or may not impact the decision. For simulation it is best to use the risk free rate.

        #Multiplicative Method
        DiscountRate = cumprod(rand(Normal(0.02,0.0075),ForecastYrs)+fill(1,ForecastYrs))#accumulate(+,rand(Normal(0.02,0.0075),ForecastYrs))+fill(1,ForecastYrs)

        #Additive Method
        #DiscountRate = accumulate(+,rand(Normal(0.02,0.0075),ForecastYrs))+fill(1,ForecastYrs)

        #a static DR
        #DiscountRate = accumulate(+, fill(0.02,ForecastYrs))+fill(1,ForecastYrs)

    #print(DiscountRate)

    #DCF Elements
    Annual_Sales = UnitSellPrice .* Units
    Annual_COGS = UnitCost .* Units
    OPEX = rand(TriangularDist(.2,0.5,0.35),ForecastYrs) .* Annual_Sales

    #Constant Dollar Cashflow
    #CashFlow_C = (Annual_Sales - Annual_COGS - OPEX - Investment)

    #Discounted CashFLow over multpile periods. This function uses arrays and DOT functions.

    CashFlow = (Annual_Sales - Annual_COGS - OPEX - Investment) ./ DiscountRate

    #Calculated Output
    Trial_NPV = sum(CashFlow)-InitialInvestment

#Convert Arrays to Scalars for sensitivity analysis
    push!(ProjectNPV, Trial_NPV)
    push!(USC, mean(UnitCost))
    push!(USP, mean(UnitSellPrice))
    push!(DR,  mean(DiscountRate))
    push!(OP,  mean(OPEX))
    push!(Annual_CashFlows,  CashFlow)
end
```
### Setting up data for analysis and charting
**Setup inputs/outputs(above) and output tables (below)** for sensitivity analysis and charting. Since correlation is based on the same math as regression, the only way to calculate sensitivity on an Array > 1 (in this case multiple years) is to condense the array into a scalar value using either mean, sum or any other transform because what ever you pick will generate a similar or identical result.

```@example NPVModel
Sensitivity_Tbl = DataFrame(ProjectNPV = ProjectNPV, USC = USC, USP = USP, DR = DR, OP = OP)
sensitivity_chrt(Sensitivity_Tbl,1)
```

### Stats
Generate model results and list all the outputs for your charting and analysis functions.

```@example NPVModel
print("Project Mean: ", mean(ProjectNPV),"\n")
print("Project Std.Dev: ", std(ProjectNPV),"\n")
print("Prob. of Neg. NPV: ", GetCertainty(ProjectNPV,0,0),"\n")
print("NPV p10, p50, p90 : ", quantile(collect(Float64, ProjectNPV),[0.1,0.5,0.9]),"\n")
println("")
println("OUTPUTS: Annual_CashFlows, ProjectNPV, Sensitivity_Tbl")
println("date range = dr")
```
To generate a complete list of percentiles, use the `fractiles()`.
```@example NPVModel
fractiles(ProjectNPV)
```

## Looking at the Probability Distribution

```@example NPVModel
histogram_chrt(ProjectNPV, "Five Year NPV")
```

```@example NPVModel
s_curve(ProjectNPV, "Five Year NPV")
```

```@example NPVModel
density_chrt(ProjectNPV, "Five Year NPV")
```

## What variables are most influential on my output distribution?

```@example NPVModel
sensitivity_chrt(Sensitivity_Tbl, 1, 3)
```
## What does my cashflow look like over time?
The trend chart is a median centered chart that establishes a 90% confidence interval for each period. Remember **dr** or the date range is specified at the top.

### CashFlow forecast
```@example NPVModel
trend_chrt(Annual_CashFlows, dr)
```
