#Learning Curve Modelling Tools (Please Document before including in Package)

using DataFrames, Gadfly


## Experience Curves

function ExpAnalytic(InitialEffort, TotalUnits, Learning)
    alpha = 1-Learning
    result = InitialEffort*(TotalUnits^-alpha)*TotalUnits
    return result
end

function ExpCurve(InitialEffort, TotalUnits, Learning; LotSize=1)

LearnCalc = 1-Learning

    C_Array = DataFrame(Units = Float64[], CurvePoint = Float64[], IncrementalCost=Float64[], AvgCost=Float64[], Method=[] )
    for i = 1:LotSize:TotalUnits+1
        if i == 1
            StepID = 1
            global PreviousResult = 0
            IncrementalCost = 0
            AvgCost = InitialEffort * ((StepID) ^ (-LearnCalc))
            VectorResult = AvgCost * StepID
        else
            StepID = i - 1
            AvgCost = InitialEffort * ((StepID) ^ (-LearnCalc))
            VectorResult = AvgCost * StepID
            IncrementalCost = VectorResult - PreviousResult
            global PreviousResult = VectorResult

        end

        #VectorResult = CrawfordAnalytic(InitialEffort,StepID,Learning; LotSize=1)

        push!(C_Array, [StepID;VectorResult; IncrementalCost; AvgCost; "Experience"])
    end

return C_Array

end

function ExpLCFit(InitialEffort, Units; EstLC = 0.8)

    WC = WrightAnalytic(InitialEffort, Units, EstLC)
    global ExpRate = EstLC

    while WC < ExpAnalytic(InitialEffort, Units, ExpRate)
        global ExpRate -= 0.0001
        #println(CrawfordRate)
    end

return ExpRate

end

## Wright Learning Curve Functions

# Test Inputs
# TotalUnitsA = 1; WorkUnitA = 2000; TotalUnitsB = 144; WorkUnitB = 8000;
# TotalUnitsA = 1; WorkUnitA = 2000; TotalUnitsB = 144; WorkUnitB = 138000;

# Function to calculate the learning curve using Wright's method
function WrightLearnRate(TotalUnitsA, WorkUnitA, TotalUnitsB, WorkUnitB)
   b_val = log(TotalUnitsB) - log(TotalUnitsA)
   x_Val = log(TotalUnitsB) - log(TotalUnitsA)
   LC_Constant = 2
   finalresult = 10^(((log(WorkUnitB) - log(WorkUnitA) - x_Val) / b_val)*(log(2) / log(10)))

   return finalresult
end

#
function WrightAnalytic(InitialEffort, TotalUnits, Learning)
LearnCalc = log(Learning) / log(2)
result = InitialEffort * (TotalUnits ^ (LearnCalc + 1))
return result
end

#Tests
test=WrightAnalytic(2000,1000,0.8)


function WrightCurve(InitialEffort, TotalUnits, Learning; LotSize=1)

LearnCalc = log(Learning) / log(2)

    C_Array = DataFrame(Units = Float64[], CurvePoint = Float64[], IncrementalCost=Float64[], AvgCost=Float64[], Method=[] )
    for i = 1:LotSize:TotalUnits+1
        if i == 1
            StepID = 1
            global PreviousResult = 0
            IncrementalCost = 0
            VectorResult = InitialEffort * ((StepID) ^ (LearnCalc + 1))
            AvgCost = VectorResult / StepID
        else
            StepID = i - 1
            VectorResult = InitialEffort * ((StepID) ^ (LearnCalc + 1))
            IncrementalCost = VectorResult - PreviousResult
            global PreviousResult = VectorResult
            AvgCost = VectorResult / StepID
        end

        #VectorResult = CrawfordAnalytic(InitialEffort,StepID,Learning; LotSize=1)

        push!(C_Array, [StepID;VectorResult; IncrementalCost; AvgCost; "Wright"])
    end

return C_Array
end

# Tests
# test=WrightCurve(2000,1000,50,0.8)
# plot(x=test.Units, y=test.CurvePoint, Geom.line)

# LotUnitsA = 2; WorkUnitsA = 72; LotUnitsB = 4; WorkUnitsB = 183;

## Crawford Learning Curve Formulas

#test inputs
# InitialEffort=50; Units=25; Learning=0.36
# InitialEffort=50; TotalUnits=1000; Learning=0.8


#Calculates the cumulative total (Time or cost) given an initial effort for 1 unit and the total units to be produced.
function CrawfordAnalytic(InitialEffort, TotalUnits, Learning; LotSize=1)
    LearnCalc = log(Learning) / log(2)
    Cum_Total = 0
    for i = 1:LotSize:TotalUnits
        CalcCurrent = InitialEffort * (i ^ LearnCalc)
        Cum_Total = Cum_Total + CalcCurrent
    end
    return Cum_Total
end

function CrawfordCurve(InitialEffort, TotalUnits, Learning; LotSize=1)
    #LearnCalc = log(Learning) / log(2)
        C_Array = DataFrame(Units = Float64[], CurvePoint = Float64[], IncrementalCost=Float64[], AvgCost=Float64[], Method=[] )
        for i = 1:LotSize:TotalUnits+1
            if i == 1
                StepID = 1
                global PreviousResult = 0
                IncrementalCost = 0
                VectorResult = CrawfordAnalytic(InitialEffort,StepID,Learning; LotSize=1)
                AvgCost = VectorResult / StepID
            else
                StepID = i - 1
                VectorResult = CrawfordAnalytic(InitialEffort,StepID,Learning; LotSize=1)
                IncrementalCost = VectorResult - PreviousResult
                global PreviousResult = VectorResult
                AvgCost = VectorResult / StepID
            end

            #VectorResult = CrawfordAnalytic(InitialEffort,StepID,Learning; LotSize=1)



            push!(C_Array, [StepID;VectorResult; IncrementalCost; AvgCost; "Crawford"])
        end
    return C_Array
end

# Tests
# test=CrawfordCurve(2000,1000,0.8; LotSize=25)
# plot(x=test.Units, y=test.CurvePoint, Geom.line)


# This function uses a brute force method to convert the Wright learning rate into one usable in Crawford's method.
# Could be used in conjunction Wright's Curve Function
function CrawfordLCFit(InitialEffort, Units; EstLC = 0.8)

    WC = WrightAnalytic(InitialEffort, Units, EstLC)
    global CrawfordRate = EstLC

    while WC < CrawfordAnalytic(InitialEffort, Units, CrawfordRate)
        global CrawfordRate -= 0.0001
        #println(CrawfordRate)
    end

return CrawfordRate

end



## Meta LC Analysis and Comparison Functions
# Compare learning Rates
function LearnRates(InitialEffort, Units; LC_Step=0.1)
results = DataFrame(LC=Float64[], WC = Float64[], CC=Float64[])
    for i = 0:LC_Step:1
        WC = WrightAnalytic(InitialEffort, Units, i)
        CC = CrawfordAnalytic(InitialEffort, Units, i)
        push!(results, [i; WC; CC])
    end
    sort!(results,:LC, rev=true)
    return results
end


## Exercises

#Comparing Curves using same rate

LC = 0.78
CC = CrawfordCurve(50, 1000, LC; LotSize=25)
WC = WrightCurve(50, 1000, LC; LotSize=25)
EC = ExpCurve(50, 1000, LC; LotSize=25)
GraphResults = vcat(CC, WC, EC)

plot(GraphResults, x=:Units, y=:AvgCost, color=:Method, Geom.line)
plot(GraphResults, x=:Units, y=:IncrementalCost, color=:Method, Geom.line)
plot(GraphResults, x=:Units, y=:CurvePoint, color=:Method, Geom.line)


##Comparing Curves using fitted rate
LC = 0.78
LCCFit = CrawfordLCFit(50,1000; EstLC = LC)
ELCFit = ExpLCFit(50, 1000; EstLC = LC)
CC = CrawfordCurve(50, 1000, LCCFit; LotSize=25)
WC = WrightCurve(50, 1000, LC; LotSize=25)
EC = ExpCurve(50, 1000, ELCFit; LotSize=25)
GraphResults = vcat(CC, WC, EC)

plot(GraphResults, x=:Units, y=:AvgCost, color=:Method, Geom.line)
plot(GraphResults, x=:Units, y=:IncrementalCost, color=:Method, Geom.line)
plot(GraphResults, x=:Units, y=:CurvePoint, color=:Method, Geom.line)





# function CrawfordLearn1(LotUnitsA, WorkUnitA, LotUnitsB, WorkUnitB)
#     Mid_Lot_A =  ((LotUnitsA+1)/3)+0.5
#     Mid_Lot_B = LotUnitsB/2+LotUnitsA
#
#     Mid_Work_A = WorkUnitsA/LotUnitsA
#     Mid_Work_B = (WorkUnitsB - WorkUnitsA)/LotUnitsB
#
#     SolveB = (log(Mid_Work_A)-log(Mid_Work_B))/(log(Mid_Lot_B)-log(Mid_Lot_A))
#     SolveA = Mid_Work_A/(1.5^SolveB)
#
#     LearningRate = exp10(log10(2) * SolveB)
#
# end
