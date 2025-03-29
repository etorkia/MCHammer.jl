# Building your first model

## Installing MCHammer

 Install the package as usual using Pkg.

```julia
    using Pkg
    Pkg.("MCHammer")
```

If you need to install direct, we recommend using ']' to go in the native Pkg manager.

```
    (v1.1) pkg> add https://github.com/etorkia/MCHammer.jl
```

## Loading MCHammer

**To load the MCHammer package**

```julia
using MCHammer
```


# Getting your environment setup for modeling

In order to build your first model, you will need to get a few more packages installed:
* **Distributions.jl** : To build a simulation, you need distributions as inputs. Julia offers univariate and multivariate distributions covering most needs.

* **StatsBase.jl and Statistics.jl** : These packages provide all the functions to analyze results and build models.

To load the support packages:

      julia> using Distributions, Statistics, StatsBase, DataFrames

## Building a simple example

**EVERY MONTE CARLO MODEL HAS 3 COMPONENTS**
* **Inputs**: Ranges or Single Values
* **A Model**:  Set of mathematical relationships f(x)
* **Outputs**: The variable(s) of interest you want to analyze

### Main Distributions for most modeling situations

Though the most used distributions are cite below, Julia's Distributions package has an impressive array of options. Please check out the complete library of distributions at [Distributions.jl](http://juliastats.github.io/Distributions.jl/latest/index.html)

* Normal()
* LogNormal()
* Triangular()
* Uniform()
* Beta()
* Exponential()
* Gamma()
* Weibull()
* Poisson()
* Binomial()
* Bernoulli()



In order to define a simulated input you need to use the *rand* function. By assigning a variable name, you can generate any simulated vector you want.

```@example
using Distributions, Random
Random.seed!(1)
input_variable = rand(Normal(0,1),100)
```

## Creating a simple model

A model is either a visual or mathematical representation of a situation or system. The easiest example of a model is

**PROFIT = REVENUE - EXPENSES**

Let's create a simple simulation model with 1000 trials with the following inputs:

### Setup environment and inputs
```@setup SampleModel

using Distributions, StatsBase, Statistics, DataFrames, MCHammer 
n_trials = 1000
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)

```

```@example SampleModel
using Distributions, StatsBase, DataFrames, MCHammer #hide
n_trials = 1000
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)
```
### Define a Model and Outputs
```@example SampleModel
# The Model
Profit = Revenue - Expenses

#Trial Results : the Profit vector (OUTPUT)
Profit
```

### Analyzing the results in Julia

```@example SampleModel
# `fractiles()` allows you to get the percentiles at various increments.

fractiles(Profit)
```

```@example SampleModel

density_chrt(Profit)
```

### Sensitivity Analysis
First we need to create a sensitivity table with **hcat()** using both the input and output vectors.

```@example SampleModel

#Construct the sensitivity input table by consolidating all the relevant inputs and outputs.

s_table = DataFrame(Profit = Profit, Revenue = Revenue, Expenses = Expenses)

#To produce a sensitivity tornado chart, we need to select the output against
#which the inputs are measured for effect.

sensitivity_chrt(s_table, 1, 3)
```
