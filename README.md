# MC HAMMER Monte Carlo Simulation and Business Analysis tools for Julia

## Overview

The *MC* in MC Hammer stands for Monte-Carlo. This tool is inspired by seminal tools such as *Oracle Crystal Ball and Palisade @RISK* for their ability to quickly build and analyze Monte-Carlo simulation models using excel functions and automations. MC Hammer replicates their logic, functions and elemental tools in Julia, thus significantly reducing the time, complexity and effort to perform advanced modeling and simulation.

## Current Features

### Modeling Features
*	Correlation of Simulated Inputs (Iman-Connover[1982])
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
