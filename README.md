<p align="center"><img src="logo.png" height="200"></p>

# MC HAMMER Monte Carlo Simulation and Business Analysis tools for Julia

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] |



## Project Mission

We want to give access to models to those who need it because for too long insight has inadvertently been hidden away on some analysts computers. This project has the objective to give business analysts tools to either develop or migrate advanced models ***quickly*** into Julia so they can be used embedded into systems and workflows that support entire teams and organizations. More people who have access to insights generated by a model, the better the decision making will be over time.

## Overview

The *MC* in MC Hammer stands for Monte-Carlo. This tool is inspired by seminal tools such as *Oracle Crystal Ball and Palisade @RISK* for their ability to quickly build and analyze Monte-Carlo simulation models using excel functions and automations. MC Hammer replicates their logic, functions and elemental tools in Julia, thus significantly reducing the time, complexity and effort to perform advanced modeling and simulation.

## Current Features

### Modeling Features
*	Correlation of Simulated Inputs (Iman-Conover[1982])
	*	Covariance Matrix
	*	Rank Order Correlation Matrix
	*	Pearson Product Moment Correlation Matrix
*	Density & Histogram Charts with Descriptive Stats
*	Sensitivity Analysis Chart
	*	Rank Correlation
	*	PPMC
	*	Contribution to Variance %

### Time Series Features
*	Time Series using Simulated Random Walk
*	Time Series using Historical Data to calculate parameters for Simulated Random Walk
*	Trend Charts with Customizable Confidence Bands

### Import / Exporting

<p align="left"><img src="siplogo.png" height="150"></p>

* Import SIPmath 2.0 Libraries
* Export simulation results to the SIPmath 2.0 standard.

### Stochastic Processes (New)
* Introduced a simulated martingale process with adjustable win probability
* Markov Chain discrete time-series solution
* Markov Chain analytical solve method to calculate equilibrium state

### Current Functions
* cormat()
* covmat()
* corvar()
* GetCertainty()
* fractiles()
* cmd()
* truncate_digit()
* density_chrt()
* histogram_chrt()
* sensitivity_chrt()
* trend_chrt()
* GBMMult_Fit()
* GBMM()
* genmeta()
* sip2csv()
* importsip()
* importxlsip()
* RiskEvent()
* marty()
* markov_a()
* markov_ts()

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**DEVEL**][docs-dev-url] &mdash; *in-development version of the documentation.*
- [**MCHammer.jl Project Page**][mch_site]

## Development Roadmap
* Functions : MetaLog Distributions
* Chart: Changes to output means Sensitivity Chart
* Function: Combined Expert Opinion
* Time Series: Learning Curve Forecasts
* Function: Ogive through empirical resampling
* Chart: ADD S-Curve (in Markowitz example)
* Chart: Error Bar Example (base code in mch_charts)
* Chart: Add Overlay

## Questions?
If you have any bugs to report or issues with the package, please send a note to

## Become an MCHammer contributor
If you are interested about learning or sharing extensive experience on how to build and automate simulation using Julia, then the MCHammer team NEEDS YOU!



[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://etorkia.github.io/MCHammer.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: http://www.technologypartnerz.com/mch_docs

[travis-img]: https://travis-ci.com/etorkia/MCHammer.jl.svg?branch=master
[travis-url]: https://travis-ci.com/etorkia/MCHammer.jl

[siplogo]: https://github.com/etorkia/MCHammer.jl/tree/master/docs/src/assets/siplogo.png "SIPMath 2.0 Certified"
[mch_logo]: https://github.com/etorkia/MCHammer.jl/tree/master/docs/src/assets/logo.png "MCHammer : MCS in Julia"


[mch_site]: https://www.crystalballservices.com/MCHammerjl "MCHammer.jl Project Page"
