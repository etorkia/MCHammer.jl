#NPV TEST MODEL FOR MC HAMMER
#MAY 2019


using Distributions
using Dates
using Gadfly
using StatsBase
using MCHammer
using DataFrames

#Setup the Date Range for the analysis
dr = collect(Date(2019,1,01):Dates.Year(1):Date(2023,01,01))

#Setup Global Inputs
ForecastYrs = 5
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

for i = 1:100000

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

    #Discounted CashFLow
    CashFlow = (Annual_Sales - Annual_COGS - OPEX - Investment) ./ DiscountRate

    Trial_NPV = sum(CashFlow)-InitialInvestment

#Setup output tables
    push!(ProjectNPV, Trial_NPV)
    push!(USC, mean(UnitCost))
    push!(USP, mean(UnitSellPrice))
    push!(DR,  mean(DiscountRate))
    push!(OP,  mean(OPEX))
    push!(Annual_CashFlows,  CashFlow)

end
Sensitivity_Tbl = DataFrame(hcat(ProjectNPV, USC, USP, DR, OP))
names!(Sensitivity_Tbl, [:ProjectNPV, :USC, :USP, :DR, :OP])
NPV_Sensitivity = cormat(Sensitivity_Tbl,1)

#Stats
clearconsole()
plot(ProjectNPV, x=ProjectNPV, Geom.density)
print("Project Mean: ", mean(ProjectNPV),"\n")
print("Project Std.Dev: ", std(ProjectNPV),"\n")
print("Prob. of Neg. NPV: ", GetCertainty(ProjectNPV,0,0),"\n")
print("NPV p10, p50, p90 : ", quantile(collect(Float64, ProjectNPV),[0.1,0.5,0.9]),"\n")
println("")
println("OUTPUTS: Annual_CashFlows, ProjectNPV, Sensitivity_Tbl")
println("date range = dr")
