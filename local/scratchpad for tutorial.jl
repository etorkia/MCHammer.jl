# Simulated NPV with Time-Series

## Load Environment
Let's start by making sure all the tools we nned are loaded up. You will almost always need to load these packages up anytime you are build a Monte-Carlo model.

using Distributions
using Dates
using Gadfly
using StatsBase, Statistics
using MCHammer
using DataFrames

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

    #Discounted CashFLow over multiple periods. This function uses arrays and DOT functions.

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

Sensitivity_Tbl = DataFrame(ProjectNPV = ProjectNPV, USC = USC, USP = USP, DR = DR, OP = OP)
NPV_Sensitivity = cormat(Sensitivity_Tbl,1)

print("Project Mean: ", mean(ProjectNPV),"\n")
print("Project Std.Dev: ", std(ProjectNPV),"\n")
print("Prob. of Neg. NPV: ", GetCertainty(ProjectNPV,0,0),"\n")
print("NPV p10, p50, p90 : ", quantile(collect(Float64, ProjectNPV),[0.1,0.5,0.9]),"\n")
println("")
println("OUTPUTS: Annual_CashFlows, ProjectNPV, Sensitivity_Tbl")
println("date range = dr")

fractiles(ProjectNPV)

histogram_chrt(ProjectNPV, "Five Year NPV")

density_chrt(ProjectNPV, "Five Year NPV")

s_curve(ProjectNPV, "Five Year NPV")

sensitivity_chrt(Sensitivity_Tbl, 1, 3)

trend_chrt(Annual_CashFlows, dr)
