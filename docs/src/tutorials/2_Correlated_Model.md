# Correlating Variables in Your Model

To get started, we are going to recap what we did in your first model and build a correlated version of the same model and compare.


## Building a Simple Uncorrelated Model

```@example SampleModel
using Distributions, StatsBase, DataFrames, MCHammer
n_trials = 10000
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)

# The Model
Profit = Revenue - Expenses

#Trial Results : the Profit vector (OUTPUT)
Profit

# Trials or Results Table (OUTPUT)
Trials = hcat(Profit, Revenue, Expenses)
Trials = DataFrame(Trials)
names!(Trials, [:Profit, :Revenue, :Expenses])

cormat(Trials)
```
## Applying correlation to your simulation
Using the `corvar()` function, we are going to correlate the Revenue and Expenses at -0.8 and generate the results tables for both the correlated and uncorrelated versions.

```@example SampleModel
#Apply correlation to random samples
Rev_Exp_Cor = 0.8
cor_matrix = [1 Rev_Exp_Cor; Rev_Exp_Cor 1]

#Validate input correlation. You can also use cormat() to define the correlation
#matrix from historical data.
cor_matrix
```
It is very important to join Trial into an array before applying correlation. Furthermore, this step is necessary in order to produce a `sensitivity_chrt()`
```@example SampleModel
c_table = [Revenue Expenses]
C_Trials = corvar(c_table, n_trials, cor_matrix)

#Correlated Model(2) - Create Correlated Results Array
C_Profit = C_Trials[1] - C_Trials[2]
C_Trials = [C_Profit, C_Trials[1], C_Trials[2]]
C_Trials = DataFrame(C_Trials)
names!(C_Trials, [:C_Profit, :C_Revenue, :C_Expenses])

cormat(C_Trials)

```

## Analyze the impact of correlation on your output
### Input Correlation between Revenue and Expenses
Input Correlation:
```@example SampleModel
cor(Revenue,Expenses)
```
Input Correlation for the Correlated Model:
```@example SampleModel
cor(C_Trials[2],C_Trials[3])
```

Make sure to put a line in your project that lists all the outputs you can query with the charting and stats functions.
```@REPL
println("Model Outputs: Trials, C_Trials, Profit, C_Profit")
```

## Correlated vs. Uncorrelated results in Julia
Let us compare the percentiles of an uncorrelated  model vs. a correlated one.

### Uncorrelated Results
```@example SampleModel
density_chrt(Profit)
```
Probability of Making 1m or less (uncorrelated) :
```@example SampleModel
GetCertainty(Profit, 1000000, 0)
```

`fractiles()` allows you to get the percentiles at various increments.

```@example SampleModel
fractiles(Profit)
```

```@example SampleModel
sensitivity_chrt(Trials,1)
```

### Correlated Results
```@example SampleModel
density_chrt(C_Profit)
```

Probability of Making 1m or less (correlated) :
```@example SampleModel
GetCertainty(C_Profit, 1000000, 0)
```

```@example SampleModel
fractiles(C_Profit)
```

```@example SampleModel
sensitivity_chrt(C_Trials,1)
```
## A quick analysis of the results
1. Accounting for correlation meant a 5% (42.5% vs. 47.7%) reduction in probability of not making our goals.

2. The Worse Case goes from -290k to 230k, a 225% difference

3. The critical driver in both cases is expenses.
