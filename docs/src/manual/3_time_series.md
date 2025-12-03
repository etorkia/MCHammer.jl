# Random + Probability Time-Series

## Overview
The MCH TimeSeries module provides tools to simulate stochastic systems and probability-driven processes.
It supports three main modeling patterns:
- Geometric Brownian Motion
- Martingales
- Markov Chains

These examples mirror the stories and models from *Decision Superhero Vol. 2*.

```@setup
DocTestSetup = quote
    rng = MersenneTwister(1)
    Random.seed!(1)
    BrandShare = [0.1, 0.25, 0.05, 0.35, 0.25]

    DrinkPreferences =
    [0.6  0.03 0.15 0.2  0.02;
     0.02 0.4  0.3  0.2  0.08;
     0.15 0.25 0.3  0.25 0.05;
     0.15 0.02 0.1  0.7  0.03;
     0.15 0.3  0.05 0.05 0.45]
end
```
  

---

## Geometric Brownian Motion (GBM)

Now we move from the general setup to a concrete continuous price process.

GBM is commonly used to simulate continuous price paths such as stock prices or any variable that evolves with compounding random variation.

```@docs
GBMMfit
```

```@jldoctest GBBMFit
using MCHammer, Random, Distributions
rng = MersenneTwister(1)
Random.seed!(1)

historical = rand(Normal(10,2.5),1000)
GBMMfit(historical, 12; rng=rng)
```

```@docs
GBMM
```

```@jldoctest RandWalk
using MCHammer, Random, Distributions
rng = MersenneTwister(1)
Random.seed!(1)
GBMM(100000, 0.05,0.05,12, rng=rng)
```

```@docs
GBMA_d
```

```@jldoctest RandWalk
using MCHammer, Random
rng = MersenneTwister(1)
Random.seed!(1)
GBMA_d(100, 504,0.03,.3, rng=rng)
```
  


### Example: Profit Random Walk

Now we combine several GBM paths into a simple business story.

```@example Graphing
using Dates, MCHammer, Random, Distributions
Random.seed!(1)

ts_trials = []

for i = 1:1000
     Monthly_Sales = GBMM(100000, 0.05,0.05,12)
     Monthly_Expenses = GBMM(50000, 0.03,0.02,12)
     MonthlyCOGS = Monthly_Sales .* 0.3
     MonthlyProfit = Monthly_Sales - Monthly_Expenses - MonthlyCOGS
     push!(ts_trials, MonthlyProfit)
end

dr = collect(Date(2025,1,01):Dates.Month(1):Date(2025,12,31))
trend_chrt(ts_trials,dr)
```
  


---

## Martingales

Now we switch to processes that are fair in expectation.

A martingale describes a process where the expected value of the next step equals the current value.
This creates a fair game in expectation, with no drift up or down.

```@setup Stochastic
using Dates, MCHammer, Random, Plots, Distributions, DataFrames
theme(:ggplot2)
```

```@docs
marty
```

### Example: Simple Gambler

Here is the most compact form of the martingale idea in practice.

```@example Stochastic
marty(50,10)
```

### Example: Adjusting for Known Odds

Now we introduce biased odds and extra cash to see how the behavior changes.

```@example Stochastic
println(marty(50,10; GameWinProb=0.45, CashInHand=400))
```

### Comparing Different Win Probabilities

Next we compare different win probabilities side by side.

```@example Stochastic
using Plots

Exp11 = scatter(marty(5, 100, GameWinProb = 0.25, CashInHand = 400), title="GameWinProb = 0.25", label="Bets")
Exp12 = scatter(marty(5, 100, GameWinProb = 0.33, CashInHand = 400), title="GameWinProb = 0.33", label="Bets")
Exp13 = scatter(marty(5, 100, GameWinProb = 0.5,  CashInHand = 400), title="GameWinProb = 0.5",  label="Bets")
Exp14 = scatter(marty(5, 100, GameWinProb = 0.55, CashInHand = 400), title="GameWinProb = 0.55", label="Bets")

combined = Plots.plot(Exp11, Exp12, Exp13, Exp14, layout=(2,2), legend=:topleft)

```

  


## Markov Chain Modeling Functions

Now we move to systems that evolve step by step between discrete states.

A Markov chain models a system moving step by step between states where the probability of the next state depends only on the current one.

What you can predict:

1. Long-run equilibrium  
2. State distribution at each step  
3. Growth or decline of states  
4. Speed of convergence  
5. Absorbing outcomes  

### Core Markov Functions

```@docs
cmatrix
```

```@docs
markov_solve
```

```@docs
markov_ts
```

```@docs
markov_ts_plot
```

```@docs
markov_state_graph
```

```@raw html
<br style="line-height: 150%;"/>
```

### Example A — Soft Drink Brand Switching (Ergodic Chain)
---
Now we see how these tools behave in a real consumer switching problem.

People switch cola brands all the time, and it feels random when you look at just one shopper, but across millions of decisions the switching pattern becomes predictable. A Markov chain captures those movements by tracking the chance that a Classic drinker moves to Zero, or a DietCola fan slides to CherryCola, or a CaffeineFree loyalist quietly disappears. Run those transitions forward and you can see where the market is heading, which brands gain ground, which ones fade and what the long run looks like. In short, if you want to understand how consumers drift between choices over time, a Markov chain gives you a simple way to model the flow and forecast the future.

**Why this matters:**  
Brand switching looks chaotic, but the long term trend is predictable. This model shows who wins and how fast.

```@raw html
<br style="line-height: 150%;"/>
```

#### A1. Analytic Solve

We start by understanding the long-run behavior directly from the transition matrix.

```@example MarkovSoftDrinks
using MCHammer, DataFrames

drink_names  = ["CherryCola", "DietCola", "CaffeineFree", "Classic", "Zero"]
brand_share  = [0.10, 0.25, 0.05, 0.35, 0.25]

drink_preferences = [
    0.60  0.03  0.15  0.20  0.02;
    0.02  0.40  0.30  0.20  0.08;
    0.15  0.25  0.30  0.25  0.05;
    0.15  0.02  0.10  0.70  0.03;
    0.15  0.30  0.05  0.05  0.45
]

markov_solve(drink_preferences; state_names = drink_names)
```

```@raw html
<br style="line-height: 150%;"/>
```  

#### A2. Time-Series Forecast

Next we push the chain forward in time to see how shares evolve.

```@example MarkovSoftDrinks
using MCHammer, Plots

drink_periods = 10

ms_drink = markov_ts(drink_preferences, brand_share;
                     trials      = drink_periods,
                     state_names = drink_names)
```
  
```@raw html
<br style="line-height: 150%;"/>
```

#### A2.1 Plot

Now we convert the forecast into a simple time-series chart.

```@example MarkovSoftDrinks
plt_drink_ts = markov_ts_plot(
    ms_drink;
    title  = "Brand Share Over Time",
    ylabel = "Market Share",
    xlabel = "Years Out"
)
plt_drink_ts
```
  
```@raw html
<br style="line-height: 150%;"/>
```

#### A3. State Graph

Finally we switch from time-series to structure and visualize the full chain.

```@example MarkovSoftDrinks
plt_drink_state = markov_state_graph(
    drink_preferences, ms_drink;
    state_names = drink_names,
    title       = "Brand Switching\n(Node Size = Year 10 Share)",
    size        = (700, 700)
)
plt_drink_state
```

  ```@raw html
<br style="line-height: 250%;"/>
```


### Example B — Marital Status Over Time (6-State Ergodic)
---

Now we move from brand choices to life events that evolve more slowly.

The time series plot for the marital example shows how each relationship category rises or falls over the years. Instead of only seeing the final state, the chart reveals the path the population takes to get there. You can watch Single shrink or grow, Married stabilize or decline, Divorced expand at a steady pace and Widowed increase slowly as the population ages. Each line tracks one state across every forecast step, making it easy to see momentum, turning points and long term trends. It is the unfolding story of the system, not just the ending.

```@raw html
<br style="line-height: 150%;"/>
```

#### B1. Time-Series Forecast

We start by forecasting how the distribution across marital states changes over time.

```@example MarkovMarital6
using MCHammer, Plots

marital_names = ["Single", "CommonLaw", "Married",
                 "Separated", "Divorced", "Widowed"]

initial_marital = [0.291, 0.126, 0.443, 0.024, 0.062, 0.054]

marital_T = [
    0.65  0.15  0.12  0.03  0.01  0.04;
    0.00  0.50  0.33  0.08  0.04  0.05;
    0.00  0.00  0.13  0.40  0.42  0.05;
    0.00  0.20  0.09  0.02  0.65  0.04;
    0.00  0.15  0.10  0.00  0.70  0.05;
    0.00  0.25  0.25  0.00  0.00  0.50
]

ms_marital = markov_ts(marital_T, initial_marital;
                       trials      = 25,
                       state_names = marital_names)
```
  
```@raw html
<br style="line-height: 150%;"/>
```

#### B1.1 Plot

Next we plot how each marital state moves over the forecast horizon.

```@example MarkovMarital6
plt_marital_ts = markov_ts_plot(
    ms_marital;
    title  = "Marital Status Over Time",
    ylabel = "Proportion of Population",
    xlabel = "Years Out"
)
plt_marital_ts
```
  
```@raw html
<br style="line-height: 150%;"/>
```

#### B2. State Graph

Finally we look at the structure of transitions and the long-run distribution.

```@example MarkovMarital6
plt_marital_state = markov_state_graph(
    marital_T, ms_marital;
    state_names = marital_names,
    title       = "Marital Status Transitions\n(Node Size = Year 25 Share)",
    size        = (700, 700)
)
plt_marital_state
```
  
```@raw html
<br style="line-height: 250%;"/>
```


### Example C — Accounts Receivable & Default (Absorbing Chain)
---

Now we close with a financial example that has clear end states.

Receivables slide through aging buckets just like shoppers drift between cola brands, and even though each invoice feels like a one-off headache, the overall flow settles into a predictable pattern. A Markov chain captures how money moves from 30 days to 60, then 90, then either paid or default. Once you know those transition probabilities, you can jump straight to the end of the story. The model tells you the final state without tracking every month: how much cash will eventually be collected, how much will be lost and how long it takes for the portfolio to clear. If you want a simple shortcut to the endgame of your AR pipeline, a Markov chain gives you the final answer.

```@raw html
<br style="line-height: 150%;"/>
```

#### C1. Analytic Absorbing Solution

We begin by solving the absorbing chain to understand paid versus default outcomes.

```@example MarkovARAbsorbing
using MCHammer, Plots

ar_names   = ["30days", "30_60days", "60_90days",
              "90daysPlus", "default", "paid"]

ar_current = [0.50, 0.30, 0.15, 0.05, 0.0, 0.0]

ar_rates = [
    0.50  0.10  0.10  0.05  0.05  0.20;
    0.00  0.30  0.15  0.25  0.075 0.225;
    0.00  0.00  0.25  0.25  0.04  0.46;
    0.00  0.00  0.00  0.30  0.20  0.50;
    0.00  0.00  0.00  0.00  1.00  0.00;
    0.00  0.00  0.00  0.00  0.00  1.00
]

ar_solve = markov_solve(ar_rates; state_names = ar_names)
```

```@raw html
<br style="line-height: 150%;"/>
```

#### C2. Time-Series Forecast

Next we track how the portfolio migrates between buckets over time.

```@example MarkovARAbsorbing
ms_ar = markov_ts(ar_rates, ar_current;
                  trials      = 12,
                  state_names = ar_names)
```

  ```@raw html
<br style="line-height: 150%;"/>
```

#### C2.1 Plot

Now we plot how much of the portfolio sits in each bucket at each period.

```@example MarkovARAbsorbing
plt_ar_ts = markov_ts_plot(
    ms_ar;
    title  = "Payment Status Over Time",
    ylabel = "Proportion of Receivables",
    xlabel = "Months Out"
)
plt_ar_ts
```

```@raw html
<br style="line-height: 150%;"/>
```

#### C3. State Graph

Finally we summarize the structure and final distribution in a single picture.

```@example MarkovARAbsorbing
plt_ar_state = markov_state_graph(
    ar_rates, ms_ar;
    state_names = ar_names,
    title       = "Receivables Transitions\n(Node Size = Month 12 Share)",
    size        = (700, 700)
)
plt_ar_state
```

   ```@raw html
<br style="line-height: 250%;"/>
```  

  

## Sources & References

- Eric Torkia, Decision Superhero Vol. 2, chapter 10 : Beyond Monte Carlo — When Uncertainty HAS Memory, Technics Publishing, 2026
- Available on Amazon : https://a.co/d/4YlJFzY . Volumes 2 and 3 to be released in Fall 2025 and Summer 2026.
- Eric Torkia, *Decision Superhero Vol. 3*, Chapter 5
