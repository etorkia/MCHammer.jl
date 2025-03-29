# Correlating Variables in Your Model

To get started, we are going to recap what we did in your first model and build a correlated version of the same model and compare.


## Building a Simple Uncorrelated Model

```@setup SampleModel
#=using Pkg
Pkg.add("Distributions")
Pkg.add("StatsBase")
Pkg.add("Statistics")
Pkg.add("Dates")
Pkg.add("MCHammer")
Pkg.add("DataFrames")
Pkg.add("Plots")
Pkg.add("TimeSeries")
Pkg.add("StatsPlots")=#

using DataFrames, MCHammer, Plots, Distributions,Statistics, StatsBase, StatsPlots, Dates, TimeSeries, Random

n_trials = 10000
Random.seed!(1)
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)
Input_Table = DataFrame(Revenue=Revenue, Expenses=Expenses)
```

```@example SampleModel
using Distributions, StatsBase, DataFrames, MCHammer
n_trials = 10000
Random.seed!(1)
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)

# The Model
Profit = Revenue - Expenses
```
```@example SampleModel
#Trial Results : the Profit vector (OUTPUT)
Profit
```
```@example SampleModel
# Trials or Results Table (OUTPUT)
Trials = DataFrame(Revenue = Revenue, Expenses = Expenses, Profit = Profit)
first(Trials,20)
```
```@example SampleModel
# Uncorrelated simulation
cormat(Trials)
```
## Applying correlation to your simulation
Using the `corvar()` function, we are going to correlate the Revenue and Expenses at -0.8 and generate the results tables for both the correlated and uncorrelated versions.

```@example SampleModel
#Correlate the expenses and the revenue with a coefficient of 0.8
Rev_Exp_Cor = 0.8
cor_matrix = [1 Rev_Exp_Cor; Rev_Exp_Cor 1]

#Validate input correlation. You can also use cormat() to define the correlation
#matrix from historical data.
cor_matrix
```
It is very important to join Trial into an array before applying correlation. Furthermore, this step is necessary in order to produce a `sensitivity_chrt()`

```@example SampleModel
Input_Table = DataFrame(Revenue=Revenue, Expenses=Expenses)
Correl_Trials = corvar(Input_Table, n_trials, cor_matrix)
DataFrames.rename!(Correl_Trials, [:Revenue, :Expenses])

#Using the correlated inputs to calculate the correlated profit
Correl_Trials.Profit = Correl_Trials.Revenue - Correl_Trials.Expenses
```
```@example SampleModel
#Verify correlation is applied correctly
cormat(Correl_Trials)
```

## Analyze the impact of correlation on your output
### Input Correlation between Revenue and Expenses
Input Correlation:
```@example SampleModel
cor(Revenue,Expenses)
```
Input Correlation for the Correlated Model:
```@example SampleModel
cor(Correl_Trials.Revenue, Correl_Trials.Expenses)
```
You can query with the charting and stats functions using these Model Outputs: `Trials`, `Correl_Trials`, `Profit`, `Correl_Trials.Profit`

## Correlated vs. Uncorrelated results in Julia
Let us compare the percentiles of an uncorrelated  model vs. a correlated one.

### Probability Analysis
```@example SampleModel

compresults_df = DataFrame(uprofit = Profit, cprofit = Correl_Trials.Profit )

@df stack(compresults_df) density(:value, group=:variable, legend=:topright, title="Density Plot")
```
Using `GetCertainty()` we can do some simple probability accounting to assess the likelyhood of making 1m or less in profit :
```@example SampleModel
GetCertainty(Profit, 1000000, 0)
```
```@example SampleModel
GetCertainty(Correl_Trials.Profit, 1000000, 0)
```
By accounting for the correlation, we can see the probability of achieving our profit objective dropped by about 5%


`fractiles()` allows you to get the percentiles at various increments to be able to compare results along a continuum.

```@example SampleModel
#Uncorrelated
fractiles(Profit)
```
```@example SampleModel
#Correlated
fractiles(Correl_Trials.Profit)
```

### Comparing the impact of the inputs

Sensitivity of uncorrelated results:

```@example SampleModel
sensitivity_chrt(Trials,3)
```
Sensitivity of correlated results
```@example SampleModel
sensitivity_chrt(Correl_Trials,3)
```
## A quick analysis of the results
1. Accounting for correlation meant a 5% (~42% vs. ~47%) reduction in probability of not making our goals.

2. The Worse Case goes from -290k to 230k, a 225% difference

3. The critical driver in both cases is expenses.
