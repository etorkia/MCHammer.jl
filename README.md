<p align="center"><img src="logo.png" height="200"></p>

# MC HAMMER Monte Carlo Simulation and Business Analysis tools for Julia

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] |


## Overview

The *MC* in MCHammer stands for Monte-Carlo. This tool is inspired by seminal tools such as *Oracle Crystal Ball and Palisade @RISK* for their ability to quickly build and analyze Monte-Carlo simulation models using excel functions and automations.

Though you can build a Monte-Carlo simulation in Julia using a few simple packages, it can be tedious setting up all the charts and analysis every time you build a new model. In order to save time and improve clarity, we have taken the standard charts and analysis used in **every Monte-Carlo simulation** and packaged them into functions that allow the user to focus on modeling instead of coding the same things over and over again.

MCHammer replicates Excel's familiar logic, functions and elemental tools in Julia, thus significantly reducing the time, complexity and effort to perform advanced modeling and simulation.

## Why use MCHammer to build your Monte-Carlo simulation model?
* Ability to correlate variables using Iman-Connover's numeric method with a simple function.
* Analyze and visualize input data and simulation results using simple Excel like formulas
* Simplify and eliminate 100s of lines of code for your charts and results analysis using MCHammers wrapper functions.
* Elegant pre-built chart functions for rendering your simulation results : Histograms, Trend Charts, Sensitivity analysis.
* Time Series functions to stress test your model over multiple time periods.
* Easy for an Excel analyst to pick up quickly.

## Example models and applications
Even though you can make the argument that anything can be modelled using uncertainty, here are some classic areas where MCHammer can streamline your analysis process.
* CashFlow Modeling
* Portfolio Modeling
* Valuation models
* Options Value using stock price forecasts
* Total ShareHolder Returns
* Contagion models
* Geological / Oil & Gas Modeling
* Quantitative Risk Modeling

## Current Features

### Modeling Features
* Correlation of Simulated Inputs (Iman-Conover[1982])
	* Covariance Matrix
	* Rank Order Correlation Matrix
	* Pearson Product Moment Correlation Matrix
* Stats and Simulation Charts
	* Density and Histogram Charts with Descriptive Stats
	* Fractiles
	* GetCertainty to find the exact probability of a scenario
	* Cumulative and Reverse Cumulative S-Curves (New)
* Sensitivity Analysis Chart
	* Rank Correlation
	* PPMC
	* Contribution to Variance %
 * Distribution Fitting
 	* Continuous /Discrete
  	* Godness of Fit
   	* Statistics
    	* Visual Fits	    

### Time Series Features
* Time Series using Simulated Random Walk
* Time Series using Historical Data to calculate parameters for Simulated Random Walk
* Trend Charts with Customizable Confidence Bands
* Exponential Smoothing (New)
	* Simple
	* Double
	* Triple (Holt-Winters)
 * Learning Curves
   	* Crawford
   	* Wright
   	* Experience
* Probability / Random Methods
  	* Martingale Simulation
  	* Markov Chains

### Import / Exporting

<p align="left"><img src="siplogo.png" height="150"></p>

* Import SIPmath 2.0 Libraries
* Export simulation results to the SIPmath 2.0 standard.

### Stochastic Processes (New)
* Introduced a simulated martingale process with adjustable win probability
* Markov Chain discrete time-series solution
* Markov Chain analytical solve method to calculate equilibrium state

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**

- [**MCHammer.jl Project Page**][mch_site]

## Project Mission

We want to give access to models to those who need it because for too long insight has inadvertently been hidden away on some analysts computers. This project has the objective to give business analysts tools to either develop or migrate advanced models ***quickly*** into Julia so they can be used embedded into systems and workflows that support entire teams and organizations. More people who have access to insights generated by a model, the better the decision making will be over time.

## Development Roadmap
* Functions : MetaLog Distributions
* Chart: Changes to output means Sensitivity Chart
* Function: Combined Expert Opinion
* Time Series: Learning Curve Forecasts
* Chart: Error Bar Example (base code in mch_charts)

## Questions?
If you have any bugs to report or issues with the package, please visit our project page.

## Become an MCHammer contributor
MCHammer is an *open source project* sponsored by Technology Partnerz Ltd. We are happy to share our tools and approaches with the wider Julia community. Rolling out features is not an easy process to take on alone so if you are interested in joining our open source team to build and automate simulation using Julia, then please drop us a line.

For more information, send us a note at info@technologypartnerz.com




[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://etorkia.github.io/MCHammer.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: http://www.technologypartnerz.com/mch_docs

[travis-img]: https://travis-ci.com/etorkia/MCHammer.jl.svg?branch=master
[travis-url]: https://travis-ci.com/etorkia/MCHammer.jl

[siplogo]: https://github.com/etorkia/MCHammer.jl/tree/master/docs/src/assets/siplogo.png "SIPMath 2.0 Certified"
[mch_logo]: https://github.com/etorkia/MCHammer.jl/tree/master/docs/src/assets/logo.png "MCHammer : MCS in Julia"


[mch_site]: https://www.crystalballservices.com/MCHammerjl "Official MCHammer.jl Project Page"
