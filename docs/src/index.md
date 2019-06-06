#  MCHammer.jl

## Overview

The *MC* in MC Hammer stands for Monte-Carlo. This tool is inspired by seminal tools such as *Oracle Crystal Ball and Palisade @RISK* for their ability to quickly build and analyze Monte-Carlo simulation models using Excel functions and automations. MC Hammer replicates their logic, functions and elemental tools in Julia, thus significantly reducing the time, lines of code, complexity and effort to perform advanced modeling and simulation.

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


## Getting your environment setup for modeling

In order to build your first model, you will need to get a few more packages installed:
* **Distributions.jl** : To build a simulation, you need distributions as inputs. Julia offers univariate and multivariate distributions covering most needs.

* **StatsBase.jl and Statistics.jl** : These packages provide all the functions to analyze results and build models.

To load the support packages:

      julia> using Distributions, Statistics, StatsBase, DataFrames


## Tutorials

* [Getting Started with MCHammer](\tutorials\1_first_model\index.html)


## Index

```@index
```
