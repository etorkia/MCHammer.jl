#  MCHammer.jl

## Overview

The *MC* in MC Hammer stands for Monte-Carlo. This tool is inspired by seminal tools such as *Oracle Crystal Ball and Palisade @RISK* for their ability to quickly build and analyze Monte-Carlo simulation models using Excel functions and automations. MC Hammer replicates their logic, functions and elemental tools in Julia, thus significantly reducing the time, lines of code, complexity and effort to perform advanced modeling and simulation.

Most of the code and functions were developped in the Decision Superhero series by Eric Torkia. MCHammer was partly developped as the companion software to volumes 2 and 3. 

### Key Features:

- **Comprehensive Simulation Functions:** MCHammer.jl offers a suite of tools and user-friendly wrapper functions for risk events, correlation and covariance analysis, and simulation result evaluation, allowing you to gain deeper insights into your models. 

- **Advanced Charting and Analysis:** Visualize your simulation results with built-in functions for density plots, histograms, sensitivity analyses, and trend charts, facilitating a clearer understanding of data patterns and relationships. 

- **Time-Series Simulation:** Generate simulated time series using methods like Geometric Brownian Motion and Martingales, making it ideal for modeling financial data and other temporal datasets. 

- **Data Import/Export:** Seamlessly import and export simulation results, ensuring smooth integration with other data analysis workflows. 

### Get Started:

Begin your journey with MCHammer.jl by following the comprehensive tutorials available on the website. Learn to build your first model, correlate inputs, and simulate cash flow scenarios with step-by-step guidance.

### Contribute to the Project:

MCHammer.jl thrives on community collaboration. Whether you're interested in reporting issues, suggesting enhancements, or contributing code, your involvement is highly valued. Visit the GitHub repository to join the community and help drive the project forward. Embrace the power of Monte Carlo simulations in Julia with MCHammer.jl. Download it today and be part of a growing community dedicated to advancing simulation modeling. 

## Installing MCHammer

 Install the package as usual using Pkg.

```julia
    using Pkg
    Pkg.("MCHammer")
```

If you need to install direct, we recommend using ']' to go in the native Pkg manager.

```
    (v1.11) pkg> add https://github.com/etorkia/MCHammer.jl
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

* [Building your first model](@ref)


## Index

```@index
```
