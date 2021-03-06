
# Building your first model



## Installing MCHammer

 Install the package as usual using Pkg.
 '''julia
    julia> using Pkg
    julia> Pkg.("MCHammer")
'''
If you need to install direct, we recommend using ']' to go in the native Pkg manager.

    `(v1.1) pkg> add https://github.com/etorkia/MCHammer.jl`


## Loading MCHammer

**To load the MCHammer package**

    julia> using MCHammer



# Getting your environment setup for modeling

In order to build your first model, you will need to get a few more packages installed:
* **Distributions.jl** : To build a simulation, you need distributions as inputs. Julia offers univariate and multivariate distributons covering most needs.

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
* Beta
* Exponential
* Gamma
* Weibull
* Poisson
* Binomial
* Bernoulli


```julia
# In order to define a simulated input you need to use the *rand* function. By assigning a a variable name, you can generate any simulated vector you want.

 input_variable = rand(Normal(0,1),100)

```




    100-element Array{Float64,1}:
      0.34184307762963473
     -0.5836249933168663
     -0.3347717974788874
      1.4851076381026804
      0.05055005263441324
      2.4757712957851146
      1.8370555121579322
      0.07955662573350962
     -0.39964881550935605
      0.13010426853370186
     -1.7269972704338015
      0.4897252866276185
      1.4172034655236783
      ⋮                  
      0.6276504682142857
      0.16545298261952496
     -0.82752578455256   
     -0.8240919315781859
      1.0607354503306607
      2.2937727638187417
      2.3440701399346713
      0.7184858636946713
     -0.5623286232701635
      1.138150944911331  
      1.3427456594127016
      0.13216694887195482



## Creating a simple model

A model is either a visual or mathematical representation of a situation or system. The easiest example of a model is
**PROFIT = REVENUE - EXPENSES**

Let's create a simple simulation model with 1000 trials with the following inputs:

### Key Variables
    julia> n_trials = 1000

    julia> Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)

    julia> Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)

### The Model

    Profit = Revenue - Expenses

### Running the model in Julia


```julia
using Distributions, StatsBase, DataFrames, MCHammer

n_trials = 1000
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)

#Create the Profit vector (OUTPUT)
Profit = Revenue - Expenses
```




    1000-element Array{Float64,1}:
          1.841241674160832e6
          1.4156499414901608e6
          1.2105413274467543e6
          1.0687483406613292e6
     876591.8331595464        
     527052.3499909146        
          1.6255640066060121e6
          1.1602873849725197e6
     952739.3852217281        
          1.1822401412746625e6
          1.3709037561450617e6
     402692.67386464775       
     922341.0329292435        
          ⋮                   
          1.6761018705512453e6
          1.3133656896411446e6
          1.8084383765362215e6
     403144.2110476871        
     650785.5327470759        
          1.21644843163562e6  
          1.4995124395753627e6
          1.1167425103408266e6
     207987.70947793731       
          1.36216468388598e6  
     339247.167980656         
     680651.236735153         



### Analyzing the results


```julia
# the fractiles() allows you to get the percentiles at various increments.

fractiles(Profit)
```




    11×2 Array{Any,2}:
     "P0.0"        -2.39902e5
     "P10.0"        4.57414e5
     "P20.0"   640228.0      
     "P30.0"        7.52291e5
     "P40.0"        8.76352e5
     "P50.0"        1.02023e6
     "P60.0"        1.14275e6
     "P70.0"        1.27711e6
     "P80.0"        1.43487e6
     "P90.0"        1.63611e6
     "P100.0"       2.29365e6




```julia
density_chrt(Profit)
```

    Summary Stats:
    Length:         1000
    Missing Count:  0
    Mean:           1031048.460418
    Minimum:        -239901.723002
    1st Quartile:   704018.049065
    Median:         1020233.950742
    3rd Quartile:   1352731.749280
    Maximum:        2293649.934407
    Type:           Float64

    Mean: 1.0310484604178977e6
    Std.Dev: 463036.17572127725
    Prob. of Neg.: 0.011

    p10, p50, p90 : [4.57414e5, 1.02023e6, 1.63611e6]





<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:gadfly="http://www.gadflyjl.org/ns"
     version="1.2"
     width="141.42mm" height="100mm" viewBox="0 0 141.42 100"
     stroke="none"
     fill="#000000"
     stroke-width="0.3"
     font-size="3.88"

     id="img-79db7dcd">
<defs>
  <marker id="arrow" markerWidth="15" markerHeight="7" refX="5" refY="3.5" orient="auto" markerUnits="strokeWidth">
    <path d="M0,0 L15,3.5 L0,7 z" stroke="context-stroke" fill="context-stroke"/>
  </marker>
</defs>
<g class="plotroot xscalable yscalable" id="img-79db7dcd-1">
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="#000000" stroke-opacity="0.000" id="img-79db7dcd-2">
    <g transform="translate(83.6,88.39)">
      <g class="primitive">
        <text text-anchor="middle" dy="0.6em">Sim. Values</text>
      </g>
    </g>
  </g>
  <g class="guide xlabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="img-79db7dcd-3">
    <g transform="translate(-94.29,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-6×10⁶</text>
      </g>
    </g>
    <g transform="translate(-68.88,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-5×10⁶</text>
      </g>
    </g>
    <g transform="translate(-43.47,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4×10⁶</text>
      </g>
    </g>
    <g transform="translate(-18.05,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3×10⁶</text>
      </g>
    </g>
    <g transform="translate(7.36,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2×10⁶</text>
      </g>
    </g>
    <g transform="translate(32.77,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1×10⁶</text>
      </g>
    </g>
    <g transform="translate(58.18,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0</text>
      </g>
    </g>
    <g transform="translate(83.6,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1×10⁶</text>
      </g>
    </g>
    <g transform="translate(109.01,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2×10⁶</text>
      </g>
    </g>
    <g transform="translate(134.42,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3×10⁶</text>
      </g>
    </g>
    <g transform="translate(159.83,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4×10⁶</text>
      </g>
    </g>
    <g transform="translate(185.25,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5×10⁶</text>
      </g>
    </g>
    <g transform="translate(210.66,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6×10⁶</text>
      </g>
    </g>
    <g transform="translate(236.07,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">7×10⁶</text>
      </g>
    </g>
    <g transform="translate(261.48,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">8×10⁶</text>
      </g>
    </g>
    <g transform="translate(-68.88,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-5.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(-63.8,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(-58.71,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(-53.63,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(-48.55,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(-43.47,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(-38.38,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(-33.3,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(-28.22,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(-23.14,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(-18.05,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(-12.97,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(-7.89,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(-2.81,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(2.28,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(7.36,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(12.44,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(17.52,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(22.61,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(27.69,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(32.77,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(37.85,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-8.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(42.94,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-6.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(48.02,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(53.1,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(58.18,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0</text>
      </g>
    </g>
    <g transform="translate(63.27,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(68.35,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(73.43,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(78.51,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">8.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(83.6,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(88.68,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(93.76,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(98.84,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(103.93,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(109.01,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(114.09,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(119.17,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(124.26,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(129.34,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(134.42,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(139.5,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(144.59,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(149.67,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(154.75,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(159.83,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(164.92,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(170,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(175.08,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(180.16,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(185.25,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(190.33,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(195.41,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(200.49,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(205.58,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(210.66,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(215.74,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.2×10⁶</text>
      </g>
    </g>
    <g transform="translate(220.82,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.4×10⁶</text>
      </g>
    </g>
    <g transform="translate(225.91,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.6×10⁶</text>
      </g>
    </g>
    <g transform="translate(230.99,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.8×10⁶</text>
      </g>
    </g>
    <g transform="translate(236.07,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">7.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(-68.88,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-5×10⁶</text>
      </g>
    </g>
    <g transform="translate(58.18,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0</text>
      </g>
    </g>
    <g transform="translate(185.25,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5×10⁶</text>
      </g>
    </g>
    <g transform="translate(312.31,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1×10⁷</text>
      </g>
    </g>
    <g transform="translate(-68.88,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-5.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(-56.17,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(-43.47,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(-30.76,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(-18.05,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(-5.35,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(7.36,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(20.07,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(32.77,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(45.48,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-5.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(58.18,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0</text>
      </g>
    </g>
    <g transform="translate(70.89,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.0×10⁵</text>
      </g>
    </g>
    <g transform="translate(83.6,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(96.3,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(109.01,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(121.72,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(134.42,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(147.13,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(159.83,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(172.54,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(185.25,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(197.95,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">5.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(210.66,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.0×10⁶</text>
      </g>
    </g>
    <g transform="translate(223.36,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">6.5×10⁶</text>
      </g>
    </g>
    <g transform="translate(236.07,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">7.0×10⁶</text>
      </g>
    </g>
  </g>
  <g clip-path="url(#img-79db7dcd-4)">
    <g id="img-79db7dcd-5">
      <g pointer-events="visible" fill="#000000" fill-opacity="0.000" stroke="#000000" stroke-opacity="0.000" class="guide background" id="img-79db7dcd-6">
        <g transform="translate(83.6,42.86)" id="img-79db7dcd-7">
          <path d="M-52.82,-37.86 L 52.82 -37.86 52.82 37.86 -52.82 37.86 z" class="primitive"/>
        </g>
      </g>
      <g class="guide ygridlines xfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="img-79db7dcd-8">
        <g transform="translate(83.6,168.36)" id="img-79db7dcd-9" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,150.43)" id="img-79db7dcd-10" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,132.5)" id="img-79db7dcd-11" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,114.57)" id="img-79db7dcd-12" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,96.64)" id="img-79db7dcd-13" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,78.72)" id="img-79db7dcd-14" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,60.79)" id="img-79db7dcd-15" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,42.86)" id="img-79db7dcd-16" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,24.93)" id="img-79db7dcd-17" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,7)" id="img-79db7dcd-18" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-10.93)" id="img-79db7dcd-19" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-28.86)" id="img-79db7dcd-20" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-46.79)" id="img-79db7dcd-21" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-64.72)" id="img-79db7dcd-22" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-82.64)" id="img-79db7dcd-23" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,150.43)" id="img-79db7dcd-24" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,146.84)" id="img-79db7dcd-25" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,143.26)" id="img-79db7dcd-26" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,139.67)" id="img-79db7dcd-27" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,136.09)" id="img-79db7dcd-28" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,132.5)" id="img-79db7dcd-29" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,128.92)" id="img-79db7dcd-30" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,125.33)" id="img-79db7dcd-31" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,121.74)" id="img-79db7dcd-32" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,118.16)" id="img-79db7dcd-33" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,114.57)" id="img-79db7dcd-34" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,110.99)" id="img-79db7dcd-35" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,107.4)" id="img-79db7dcd-36" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,103.82)" id="img-79db7dcd-37" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,100.23)" id="img-79db7dcd-38" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,96.64)" id="img-79db7dcd-39" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,93.06)" id="img-79db7dcd-40" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,89.47)" id="img-79db7dcd-41" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,85.89)" id="img-79db7dcd-42" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,82.3)" id="img-79db7dcd-43" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,78.72)" id="img-79db7dcd-44" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,75.13)" id="img-79db7dcd-45" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,71.54)" id="img-79db7dcd-46" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,67.96)" id="img-79db7dcd-47" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,64.37)" id="img-79db7dcd-48" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,60.79)" id="img-79db7dcd-49" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,57.2)" id="img-79db7dcd-50" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,53.61)" id="img-79db7dcd-51" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,50.03)" id="img-79db7dcd-52" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,46.44)" id="img-79db7dcd-53" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,42.86)" id="img-79db7dcd-54" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,39.27)" id="img-79db7dcd-55" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,35.69)" id="img-79db7dcd-56" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,32.1)" id="img-79db7dcd-57" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,28.51)" id="img-79db7dcd-58" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,24.93)" id="img-79db7dcd-59" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,21.34)" id="img-79db7dcd-60" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,17.76)" id="img-79db7dcd-61" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,14.17)" id="img-79db7dcd-62" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,10.59)" id="img-79db7dcd-63" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,7)" id="img-79db7dcd-64" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,3.41)" id="img-79db7dcd-65" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-0.17)" id="img-79db7dcd-66" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-3.76)" id="img-79db7dcd-67" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-7.34)" id="img-79db7dcd-68" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-10.93)" id="img-79db7dcd-69" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-14.51)" id="img-79db7dcd-70" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-18.1)" id="img-79db7dcd-71" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-21.69)" id="img-79db7dcd-72" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-25.27)" id="img-79db7dcd-73" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-28.86)" id="img-79db7dcd-74" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-32.44)" id="img-79db7dcd-75" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-36.03)" id="img-79db7dcd-76" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-39.61)" id="img-79db7dcd-77" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-43.2)" id="img-79db7dcd-78" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-46.79)" id="img-79db7dcd-79" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-50.37)" id="img-79db7dcd-80" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-53.96)" id="img-79db7dcd-81" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-57.54)" id="img-79db7dcd-82" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-61.13)" id="img-79db7dcd-83" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-64.72)" id="img-79db7dcd-84" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,150.43)" id="img-79db7dcd-85" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,78.72)" id="img-79db7dcd-86" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,7)" id="img-79db7dcd-87" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-64.72)" id="img-79db7dcd-88" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,150.43)" id="img-79db7dcd-89" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,143.26)" id="img-79db7dcd-90" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,136.09)" id="img-79db7dcd-91" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,128.92)" id="img-79db7dcd-92" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,121.74)" id="img-79db7dcd-93" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,114.57)" id="img-79db7dcd-94" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,107.4)" id="img-79db7dcd-95" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,100.23)" id="img-79db7dcd-96" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,93.06)" id="img-79db7dcd-97" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,85.89)" id="img-79db7dcd-98" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,78.72)" id="img-79db7dcd-99" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,71.54)" id="img-79db7dcd-100" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,64.37)" id="img-79db7dcd-101" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,57.2)" id="img-79db7dcd-102" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,50.03)" id="img-79db7dcd-103" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,42.86)" id="img-79db7dcd-104" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,35.69)" id="img-79db7dcd-105" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,28.51)" id="img-79db7dcd-106" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,21.34)" id="img-79db7dcd-107" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,14.17)" id="img-79db7dcd-108" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,7)" id="img-79db7dcd-109" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-0.17)" id="img-79db7dcd-110" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-7.34)" id="img-79db7dcd-111" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-14.51)" id="img-79db7dcd-112" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-21.69)" id="img-79db7dcd-113" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-28.86)" id="img-79db7dcd-114" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-36.03)" id="img-79db7dcd-115" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-43.2)" id="img-79db7dcd-116" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-50.37)" id="img-79db7dcd-117" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-57.54)" id="img-79db7dcd-118" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
        <g transform="translate(83.6,-64.72)" id="img-79db7dcd-119" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M-52.82,0 L 52.82 0" class="primitive"/>
        </g>
      </g>
      <g class="guide xgridlines yfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="img-79db7dcd-120">
        <g transform="translate(-94.29,42.86)" id="img-79db7dcd-121" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-68.88,42.86)" id="img-79db7dcd-122" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-43.47,42.86)" id="img-79db7dcd-123" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-18.05,42.86)" id="img-79db7dcd-124" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(7.36,42.86)" id="img-79db7dcd-125" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(32.77,42.86)" id="img-79db7dcd-126" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(58.18,42.86)" id="img-79db7dcd-127" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(83.6,42.86)" id="img-79db7dcd-128" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(109.01,42.86)" id="img-79db7dcd-129" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(134.42,42.86)" id="img-79db7dcd-130" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(159.83,42.86)" id="img-79db7dcd-131" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(185.25,42.86)" id="img-79db7dcd-132" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(210.66,42.86)" id="img-79db7dcd-133" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(236.07,42.86)" id="img-79db7dcd-134" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(261.48,42.86)" id="img-79db7dcd-135" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-68.88,42.86)" id="img-79db7dcd-136" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-63.8,42.86)" id="img-79db7dcd-137" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-58.71,42.86)" id="img-79db7dcd-138" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-53.63,42.86)" id="img-79db7dcd-139" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-48.55,42.86)" id="img-79db7dcd-140" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-43.47,42.86)" id="img-79db7dcd-141" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-38.38,42.86)" id="img-79db7dcd-142" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-33.3,42.86)" id="img-79db7dcd-143" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-28.22,42.86)" id="img-79db7dcd-144" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-23.14,42.86)" id="img-79db7dcd-145" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-18.05,42.86)" id="img-79db7dcd-146" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-12.97,42.86)" id="img-79db7dcd-147" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-7.89,42.86)" id="img-79db7dcd-148" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-2.81,42.86)" id="img-79db7dcd-149" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(2.28,42.86)" id="img-79db7dcd-150" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(7.36,42.86)" id="img-79db7dcd-151" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(12.44,42.86)" id="img-79db7dcd-152" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(17.52,42.86)" id="img-79db7dcd-153" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(22.61,42.86)" id="img-79db7dcd-154" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(27.69,42.86)" id="img-79db7dcd-155" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(32.77,42.86)" id="img-79db7dcd-156" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(37.85,42.86)" id="img-79db7dcd-157" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(42.94,42.86)" id="img-79db7dcd-158" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(48.02,42.86)" id="img-79db7dcd-159" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(53.1,42.86)" id="img-79db7dcd-160" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(58.18,42.86)" id="img-79db7dcd-161" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(63.27,42.86)" id="img-79db7dcd-162" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(68.35,42.86)" id="img-79db7dcd-163" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(73.43,42.86)" id="img-79db7dcd-164" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(78.51,42.86)" id="img-79db7dcd-165" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(83.6,42.86)" id="img-79db7dcd-166" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(88.68,42.86)" id="img-79db7dcd-167" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(93.76,42.86)" id="img-79db7dcd-168" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(98.84,42.86)" id="img-79db7dcd-169" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(103.93,42.86)" id="img-79db7dcd-170" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(109.01,42.86)" id="img-79db7dcd-171" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(114.09,42.86)" id="img-79db7dcd-172" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(119.17,42.86)" id="img-79db7dcd-173" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(124.26,42.86)" id="img-79db7dcd-174" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(129.34,42.86)" id="img-79db7dcd-175" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(134.42,42.86)" id="img-79db7dcd-176" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(139.5,42.86)" id="img-79db7dcd-177" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(144.59,42.86)" id="img-79db7dcd-178" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(149.67,42.86)" id="img-79db7dcd-179" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(154.75,42.86)" id="img-79db7dcd-180" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(159.83,42.86)" id="img-79db7dcd-181" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(164.92,42.86)" id="img-79db7dcd-182" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(170,42.86)" id="img-79db7dcd-183" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(175.08,42.86)" id="img-79db7dcd-184" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(180.16,42.86)" id="img-79db7dcd-185" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(185.25,42.86)" id="img-79db7dcd-186" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(190.33,42.86)" id="img-79db7dcd-187" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(195.41,42.86)" id="img-79db7dcd-188" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(200.49,42.86)" id="img-79db7dcd-189" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(205.58,42.86)" id="img-79db7dcd-190" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(210.66,42.86)" id="img-79db7dcd-191" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(215.74,42.86)" id="img-79db7dcd-192" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(220.82,42.86)" id="img-79db7dcd-193" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(225.91,42.86)" id="img-79db7dcd-194" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(230.99,42.86)" id="img-79db7dcd-195" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(236.07,42.86)" id="img-79db7dcd-196" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-68.88,42.86)" id="img-79db7dcd-197" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(58.18,42.86)" id="img-79db7dcd-198" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(185.25,42.86)" id="img-79db7dcd-199" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(312.31,42.86)" id="img-79db7dcd-200" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-68.88,42.86)" id="img-79db7dcd-201" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-56.17,42.86)" id="img-79db7dcd-202" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-43.47,42.86)" id="img-79db7dcd-203" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-30.76,42.86)" id="img-79db7dcd-204" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-18.05,42.86)" id="img-79db7dcd-205" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(-5.35,42.86)" id="img-79db7dcd-206" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(7.36,42.86)" id="img-79db7dcd-207" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(20.07,42.86)" id="img-79db7dcd-208" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(32.77,42.86)" id="img-79db7dcd-209" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(45.48,42.86)" id="img-79db7dcd-210" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(58.18,42.86)" id="img-79db7dcd-211" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(70.89,42.86)" id="img-79db7dcd-212" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(83.6,42.86)" id="img-79db7dcd-213" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(96.3,42.86)" id="img-79db7dcd-214" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(109.01,42.86)" id="img-79db7dcd-215" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(121.72,42.86)" id="img-79db7dcd-216" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(134.42,42.86)" id="img-79db7dcd-217" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(147.13,42.86)" id="img-79db7dcd-218" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(159.83,42.86)" id="img-79db7dcd-219" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(172.54,42.86)" id="img-79db7dcd-220" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(185.25,42.86)" id="img-79db7dcd-221" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(197.95,42.86)" id="img-79db7dcd-222" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(210.66,42.86)" id="img-79db7dcd-223" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(223.36,42.86)" id="img-79db7dcd-224" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
        <g transform="translate(236.07,42.86)" id="img-79db7dcd-225" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-37.86 L 0 37.86" class="primitive"/>
        </g>
      </g>
      <g class="plotpanel" id="img-79db7dcd-226">
        <metadata>
          <boundingbox value="30.771666666666675mm 5.0mm 105.64968957064283mm 75.715mm"/>
          <unitbox value="-1.0787016668107018e6 1.0278881684445373e-6 4.1574033336214037e6 -1.0557763368890748e-6"/>
        </metadata>
        <g stroke-width="0.3" fill="#000000" fill-opacity="0.000" class="geometry" id="img-79db7dcd-227">
          <g class="color_LCHab{Float32}(70.0f0,60.0f0,240.0f0)" stroke-dasharray="none" stroke="#00BFFF" id="img-79db7dcd-228">
            <g transform="translate(84.28,57.52)" id="img-79db7dcd-229">
              <path fill="none" d="M-42.83,21.19 L -42.5 21.19 -42.16 21.19 -41.82 21.19 -41.49 21.19 -41.15 21.19 -40.82 21.19 -40.48 21.19 -40.14 21.19 -39.81 21.19 -39.47 21.18 -39.14 21.18 -38.8 21.17 -38.47 21.17 -38.13 21.16 -37.79 21.15 -37.46 21.13 -37.12 21.11 -36.79 21.09 -36.45 21.06 -36.11 21.02 -35.78 20.98 -35.44 20.93 -35.11 20.87 -34.77 20.8 -34.43 20.72 -34.1 20.63 -33.76 20.53 -33.43 20.42 -33.09 20.3 -32.75 20.17 -32.42 20.03 -32.08 19.88 -31.75 19.71 -31.41 19.54 -31.07 19.36 -30.74 19.18 -30.4 18.98 -30.07 18.78 -29.73 18.57 -29.39 18.35 -29.06 18.13 -28.72 17.9 -28.39 17.66 -28.05 17.42 -27.72 17.17 -27.38 16.91 -27.04 16.63 -26.71 16.35 -26.37 16.06 -26.04 15.74 -25.7 15.41 -25.36 15.06 -25.03 14.68 -24.69 14.27 -24.36 13.84 -24.02 13.37 -23.68 12.88 -23.35 12.35 -23.01 11.79 -22.68 11.21 -22.34 10.59 -22 9.96 -21.67 9.3 -21.33 8.63 -21 7.95 -20.66 7.25 -20.32 6.55 -19.99 5.85 -19.65 5.13 -19.32 4.42 -18.98 3.69 -18.64 2.96 -18.31 2.22 -17.97 1.47 -17.64 0.7 -17.3 -0.09 -16.96 -0.9 -16.63 -1.75 -16.29 -2.63 -15.96 -3.55 -15.62 -4.51 -15.29 -5.52 -14.95 -6.59 -14.61 -7.71 -14.28 -8.88 -13.94 -10.11 -13.61 -11.4 -13.27 -12.74 -12.93 -14.14 -12.6 -15.58 -12.26 -17.06 -11.93 -18.56 -11.59 -20.09 -11.25 -21.63 -10.92 -23.17 -10.58 -24.68 -10.25 -26.16 -9.91 -27.58 -9.57 -28.94 -9.24 -30.22 -8.9 -31.4 -8.57 -32.47 -8.23 -33.41 -7.89 -34.24 -7.56 -34.93 -7.22 -35.49 -6.89 -35.91 -6.55 -36.22 -6.21 -36.4 -5.88 -36.47 -5.54 -36.44 -5.21 -36.33 -4.87 -36.14 -4.54 -35.89 -4.2 -35.59 -3.86 -35.27 -3.53 -34.92 -3.19 -34.58 -2.86 -34.24 -2.52 -33.93 -2.18 -33.65 -1.85 -33.41 -1.51 -33.23 -1.18 -33.1 -0.84 -33.03 -0.5 -33 -0.17 -33.03 0.17 -33.09 0.5 -33.19 0.84 -33.29 1.18 -33.4 1.51 -33.5 1.85 -33.57 2.18 -33.6 2.52 -33.58 2.86 -33.51 3.19 -33.36 3.53 -33.15 3.86 -32.87 4.2 -32.52 4.54 -32.1 4.87 -31.62 5.21 -31.07 5.54 -30.47 5.88 -29.81 6.21 -29.11 6.55 -28.37 6.89 -27.59 7.22 -26.77 7.56 -25.92 7.89 -25.06 8.23 -24.17 8.57 -23.27 8.9 -22.37 9.24 -21.47 9.57 -20.59 9.91 -19.73 10.25 -18.89 10.58 -18.08 10.92 -17.3 11.25 -16.55 11.59 -15.84 11.93 -15.15 12.26 -14.48 12.6 -13.82 12.93 -13.17 13.27 -12.51 13.61 -11.83 13.94 -11.13 14.28 -10.4 14.61 -9.63 14.95 -8.83 15.29 -7.99 15.62 -7.11 15.96 -6.21 16.29 -5.28 16.63 -4.33 16.96 -3.38 17.3 -2.42 17.64 -1.48 17.97 -0.55 18.31 0.37 18.64 1.25 18.98 2.1 19.32 2.93 19.65 3.72 19.99 4.48 20.32 5.21 20.66 5.91 21 6.58 21.33 7.23 21.67 7.85 22 8.45 22.34 9.02 22.68 9.58 23.01 10.11 23.35 10.62 23.68 11.1 24.02 11.57 24.36 12.02 24.69 12.44 25.03 12.85 25.36 13.25 25.7 13.63 26.04 14 26.37 14.36 26.71 14.71 27.04 15.06 27.38 15.4 27.72 15.74 28.05 16.07 28.39 16.4 28.72 16.72 29.06 17.03 29.39 17.34 29.73 17.63 30.07 17.92 30.4 18.19 30.74 18.46 31.07 18.71 31.41 18.94 31.75 19.17 32.08 19.38 32.42 19.57 32.75 19.76 33.09 19.93 33.43 20.09 33.76 20.24 34.1 20.37 34.43 20.5 34.77 20.61 35.11 20.7 35.44 20.79 35.78 20.86 36.11 20.93 36.45 20.98 36.79 21.03 37.12 21.06 37.46 21.09 37.79 21.12 38.13 21.14 38.47 21.15 38.8 21.16 39.14 21.17 39.47 21.18 39.81 21.18 40.14 21.18 40.48 21.19 40.82 21.19 41.15 21.19 41.49 21.19 41.82 21.19 42.16 21.19 42.5 21.19 42.83 21.19" class="primitive"/>
            </g>
          </g>
        </g>
      </g>
      <g fill-opacity="0" class="guide crosshair" id="img-79db7dcd-230">
        <g class="text_box" fill="#000000" id="img-79db7dcd-231">
          <g transform="translate(129.37,5.53)" id="img-79db7dcd-232">
            <g class="primitive">
              <text text-anchor="end" dy="0.6em"></text>
            </g>
          </g>
        </g>
      </g>
      <g fill-opacity="0" class="guide helpscreen" id="img-79db7dcd-233">
        <g class="text_box" id="img-79db7dcd-234">
          <g fill="#000000" id="img-79db7dcd-235">
            <g transform="translate(83.6,42.86)" id="img-79db7dcd-236">
              <path d="M-27.48,-9.93 L 27.48 -9.93 27.48 9.93 -27.48 9.93 z" class="primitive"/>
            </g>
          </g>
          <g fill="#FFFF62" font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" id="img-79db7dcd-237">
            <g transform="translate(83.6,35.63)" id="img-79db7dcd-238">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">h,j,k,l,arrows,drag to pan</text>
              </g>
            </g>
            <g transform="translate(83.6,39.25)" id="img-79db7dcd-239">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">i,o,+,-,scroll,shift-drag to zoom</text>
              </g>
            </g>
            <g transform="translate(83.6,42.86)" id="img-79db7dcd-240">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">r,dbl-click to reset</text>
              </g>
            </g>
            <g transform="translate(83.6,46.47)" id="img-79db7dcd-241">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">c for coordinates</text>
              </g>
            </g>
            <g transform="translate(83.6,50.08)" id="img-79db7dcd-242">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">? for help</text>
              </g>
            </g>
          </g>
        </g>
      </g>
      <g fill-opacity="0" class="guide questionmark" id="img-79db7dcd-243">
        <g class="text_box" fill="#000000" id="img-79db7dcd-244">
          <g transform="translate(136.42,5.53)" id="img-79db7dcd-245">
            <g class="primitive">
              <text text-anchor="end" dy="0.6em">?</text>
            </g>
          </g>
        </g>
      </g>
    </g>
  </g>
  <g class="guide ylabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="img-79db7dcd-246">
    <g transform="translate(29.77,168.36)" id="img-79db7dcd-247" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1.25×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,150.43)" id="img-79db7dcd-248" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1.00×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,132.5)" id="img-79db7dcd-249" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-7.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,114.57)" id="img-79db7dcd-250" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-5.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,96.64)" id="img-79db7dcd-251" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-2.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,78.72)" id="img-79db7dcd-252" gadfly:scale="1.0" visibility="visible">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">0</text>
      </g>
    </g>
    <g transform="translate(29.77,60.79)" id="img-79db7dcd-253" gadfly:scale="1.0" visibility="visible">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,42.86)" id="img-79db7dcd-254" gadfly:scale="1.0" visibility="visible">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">5.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,24.93)" id="img-79db7dcd-255" gadfly:scale="1.0" visibility="visible">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">7.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,7)" id="img-79db7dcd-256" gadfly:scale="1.0" visibility="visible">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.00×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-10.93)" id="img-79db7dcd-257" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.25×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-28.86)" id="img-79db7dcd-258" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.50×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-46.79)" id="img-79db7dcd-259" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.75×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-64.72)" id="img-79db7dcd-260" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.00×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-82.64)" id="img-79db7dcd-261" gadfly:scale="1.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.25×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,150.43)" id="img-79db7dcd-262" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1.00×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,146.84)" id="img-79db7dcd-263" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-9.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,143.26)" id="img-79db7dcd-264" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-9.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,139.67)" id="img-79db7dcd-265" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-8.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,136.09)" id="img-79db7dcd-266" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-8.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,132.5)" id="img-79db7dcd-267" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-7.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,128.92)" id="img-79db7dcd-268" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-7.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,125.33)" id="img-79db7dcd-269" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-6.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,121.74)" id="img-79db7dcd-270" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-6.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,118.16)" id="img-79db7dcd-271" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-5.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,114.57)" id="img-79db7dcd-272" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-5.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,110.99)" id="img-79db7dcd-273" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-4.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,107.4)" id="img-79db7dcd-274" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-4.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,103.82)" id="img-79db7dcd-275" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-3.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,100.23)" id="img-79db7dcd-276" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-3.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,96.64)" id="img-79db7dcd-277" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-2.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,93.06)" id="img-79db7dcd-278" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-2.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,89.47)" id="img-79db7dcd-279" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,85.89)" id="img-79db7dcd-280" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,82.3)" id="img-79db7dcd-281" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-5.00×10⁻⁸</text>
      </g>
    </g>
    <g transform="translate(29.77,78.72)" id="img-79db7dcd-282" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">0</text>
      </g>
    </g>
    <g transform="translate(29.77,75.13)" id="img-79db7dcd-283" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">5.00×10⁻⁸</text>
      </g>
    </g>
    <g transform="translate(29.77,71.54)" id="img-79db7dcd-284" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,67.96)" id="img-79db7dcd-285" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,64.37)" id="img-79db7dcd-286" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,60.79)" id="img-79db7dcd-287" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,57.2)" id="img-79db7dcd-288" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">3.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,53.61)" id="img-79db7dcd-289" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">3.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,50.03)" id="img-79db7dcd-290" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">4.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,46.44)" id="img-79db7dcd-291" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">4.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,42.86)" id="img-79db7dcd-292" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">5.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,39.27)" id="img-79db7dcd-293" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">5.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,35.69)" id="img-79db7dcd-294" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">6.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,32.1)" id="img-79db7dcd-295" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">6.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,28.51)" id="img-79db7dcd-296" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">7.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,24.93)" id="img-79db7dcd-297" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">7.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,21.34)" id="img-79db7dcd-298" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">8.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,17.76)" id="img-79db7dcd-299" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">8.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,14.17)" id="img-79db7dcd-300" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">9.00×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,10.59)" id="img-79db7dcd-301" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">9.50×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,7)" id="img-79db7dcd-302" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.00×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,3.41)" id="img-79db7dcd-303" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.05×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-0.17)" id="img-79db7dcd-304" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.10×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-3.76)" id="img-79db7dcd-305" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.15×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-7.34)" id="img-79db7dcd-306" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.20×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-10.93)" id="img-79db7dcd-307" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.25×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-14.51)" id="img-79db7dcd-308" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.30×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-18.1)" id="img-79db7dcd-309" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.35×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-21.69)" id="img-79db7dcd-310" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.40×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-25.27)" id="img-79db7dcd-311" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.45×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-28.86)" id="img-79db7dcd-312" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.50×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-32.44)" id="img-79db7dcd-313" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.55×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-36.03)" id="img-79db7dcd-314" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.60×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-39.61)" id="img-79db7dcd-315" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.65×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-43.2)" id="img-79db7dcd-316" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.70×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-46.79)" id="img-79db7dcd-317" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.75×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-50.37)" id="img-79db7dcd-318" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.80×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-53.96)" id="img-79db7dcd-319" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.85×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-57.54)" id="img-79db7dcd-320" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.90×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-61.13)" id="img-79db7dcd-321" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.95×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-64.72)" id="img-79db7dcd-322" gadfly:scale="10.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.00×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,150.43)" id="img-79db7dcd-323" gadfly:scale="0.5" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,78.72)" id="img-79db7dcd-324" gadfly:scale="0.5" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">0</text>
      </g>
    </g>
    <g transform="translate(29.77,7)" id="img-79db7dcd-325" gadfly:scale="0.5" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-64.72)" id="img-79db7dcd-326" gadfly:scale="0.5" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,150.43)" id="img-79db7dcd-327" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1.0×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,143.26)" id="img-79db7dcd-328" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-9.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,136.09)" id="img-79db7dcd-329" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-8.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,128.92)" id="img-79db7dcd-330" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-7.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,121.74)" id="img-79db7dcd-331" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-6.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,114.57)" id="img-79db7dcd-332" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-5.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,107.4)" id="img-79db7dcd-333" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-4.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,100.23)" id="img-79db7dcd-334" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-3.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,93.06)" id="img-79db7dcd-335" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-2.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,85.89)" id="img-79db7dcd-336" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">-1.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,78.72)" id="img-79db7dcd-337" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">0</text>
      </g>
    </g>
    <g transform="translate(29.77,71.54)" id="img-79db7dcd-338" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,64.37)" id="img-79db7dcd-339" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,57.2)" id="img-79db7dcd-340" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">3.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,50.03)" id="img-79db7dcd-341" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">4.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,42.86)" id="img-79db7dcd-342" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">5.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,35.69)" id="img-79db7dcd-343" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">6.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,28.51)" id="img-79db7dcd-344" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">7.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,21.34)" id="img-79db7dcd-345" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">8.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,14.17)" id="img-79db7dcd-346" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">9.0×10⁻⁷</text>
      </g>
    </g>
    <g transform="translate(29.77,7)" id="img-79db7dcd-347" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.0×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-0.17)" id="img-79db7dcd-348" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.1×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-7.34)" id="img-79db7dcd-349" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.2×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-14.51)" id="img-79db7dcd-350" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.3×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-21.69)" id="img-79db7dcd-351" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.4×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-28.86)" id="img-79db7dcd-352" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.5×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-36.03)" id="img-79db7dcd-353" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.6×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-43.2)" id="img-79db7dcd-354" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.7×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-50.37)" id="img-79db7dcd-355" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.8×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-57.54)" id="img-79db7dcd-356" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">1.9×10⁻⁶</text>
      </g>
    </g>
    <g transform="translate(29.77,-64.72)" id="img-79db7dcd-357" gadfly:scale="5.0" visibility="hidden">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">2.0×10⁻⁶</text>
      </g>
    </g>
  </g>
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="#000000" stroke-opacity="0.000" id="img-79db7dcd-358">
    <g transform="translate(8.81,40.86)" id="img-79db7dcd-359">
      <g class="primitive">
        <text text-anchor="middle" dy="0.35em" transform="rotate(-90,0, 2)">Frequency</text>
      </g>
    </g>
  </g>
</g>
<defs>
  <clipPath id="img-79db7dcd-4">
    <path d="M30.77,5 L 136.42 5 136.42 80.72 30.77 80.72" />
  </clipPath>
</defs>
<script> <![CDATA[
(function(N){var k=/[\.\/]/,L=/\s*,\s*/,C=function(a,d){return a-d},a,v,y={n:{}},M=function(){for(var a=0,d=this.length;a<d;a++)if("undefined"!=typeof this[a])return this[a]},A=function(){for(var a=this.length;--a;)if("undefined"!=typeof this[a])return this[a]},w=function(k,d){k=String(k);var f=v,n=Array.prototype.slice.call(arguments,2),u=w.listeners(k),p=0,b,q=[],e={},l=[],r=a;l.firstDefined=M;l.lastDefined=A;a=k;for(var s=v=0,x=u.length;s<x;s++)"zIndex"in u[s]&&(q.push(u[s].zIndex),0>u[s].zIndex&&
(e[u[s].zIndex]=u[s]));for(q.sort(C);0>q[p];)if(b=e[q[p++] ],l.push(b.apply(d,n)),v)return v=f,l;for(s=0;s<x;s++)if(b=u[s],"zIndex"in b)if(b.zIndex==q[p]){l.push(b.apply(d,n));if(v)break;do if(p++,(b=e[q[p] ])&&l.push(b.apply(d,n)),v)break;while(b)}else e[b.zIndex]=b;else if(l.push(b.apply(d,n)),v)break;v=f;a=r;return l};w._events=y;w.listeners=function(a){a=a.split(k);var d=y,f,n,u,p,b,q,e,l=[d],r=[];u=0;for(p=a.length;u<p;u++){e=[];b=0;for(q=l.length;b<q;b++)for(d=l[b].n,f=[d[a[u] ],d["*"] ],n=2;n--;)if(d=
f[n])e.push(d),r=r.concat(d.f||[]);l=e}return r};w.on=function(a,d){a=String(a);if("function"!=typeof d)return function(){};for(var f=a.split(L),n=0,u=f.length;n<u;n++)(function(a){a=a.split(k);for(var b=y,f,e=0,l=a.length;e<l;e++)b=b.n,b=b.hasOwnProperty(a[e])&&b[a[e] ]||(b[a[e] ]={n:{}});b.f=b.f||[];e=0;for(l=b.f.length;e<l;e++)if(b.f[e]==d){f=!0;break}!f&&b.f.push(d)})(f[n]);return function(a){+a==+a&&(d.zIndex=+a)}};w.f=function(a){var d=[].slice.call(arguments,1);return function(){w.apply(null,
[a,null].concat(d).concat([].slice.call(arguments,0)))}};w.stop=function(){v=1};w.nt=function(k){return k?(new RegExp("(?:\\.|\\/|^)"+k+"(?:\\.|\\/|$)")).test(a):a};w.nts=function(){return a.split(k)};w.off=w.unbind=function(a,d){if(a){var f=a.split(L);if(1<f.length)for(var n=0,u=f.length;n<u;n++)w.off(f[n],d);else{for(var f=a.split(k),p,b,q,e,l=[y],n=0,u=f.length;n<u;n++)for(e=0;e<l.length;e+=q.length-2){q=[e,1];p=l[e].n;if("*"!=f[n])p[f[n] ]&&q.push(p[f[n] ]);else for(b in p)p.hasOwnProperty(b)&&
q.push(p[b]);l.splice.apply(l,q)}n=0;for(u=l.length;n<u;n++)for(p=l[n];p.n;){if(d){if(p.f){e=0;for(f=p.f.length;e<f;e++)if(p.f[e]==d){p.f.splice(e,1);break}!p.f.length&&delete p.f}for(b in p.n)if(p.n.hasOwnProperty(b)&&p.n[b].f){q=p.n[b].f;e=0;for(f=q.length;e<f;e++)if(q[e]==d){q.splice(e,1);break}!q.length&&delete p.n[b].f}}else for(b in delete p.f,p.n)p.n.hasOwnProperty(b)&&p.n[b].f&&delete p.n[b].f;p=p.n}}}else w._events=y={n:{}}};w.once=function(a,d){var f=function(){w.unbind(a,f);return d.apply(this,
arguments)};return w.on(a,f)};w.version="0.4.2";w.toString=function(){return"You are running Eve 0.4.2"};"undefined"!=typeof module&&module.exports?module.exports=w:"function"===typeof define&&define.amd?define("eve",[],function(){return w}):N.eve=w})(this);
(function(N,k){"function"===typeof define&&define.amd?define("Snap.svg",["eve"],function(L){return k(N,L)}):k(N,N.eve)})(this,function(N,k){var L=function(a){var k={},y=N.requestAnimationFrame||N.webkitRequestAnimationFrame||N.mozRequestAnimationFrame||N.oRequestAnimationFrame||N.msRequestAnimationFrame||function(a){setTimeout(a,16)},M=Array.isArray||function(a){return a instanceof Array||"[object Array]"==Object.prototype.toString.call(a)},A=0,w="M"+(+new Date).toString(36),z=function(a){if(null==
a)return this.s;var b=this.s-a;this.b+=this.dur*b;this.B+=this.dur*b;this.s=a},d=function(a){if(null==a)return this.spd;this.spd=a},f=function(a){if(null==a)return this.dur;this.s=this.s*a/this.dur;this.dur=a},n=function(){delete k[this.id];this.update();a("mina.stop."+this.id,this)},u=function(){this.pdif||(delete k[this.id],this.update(),this.pdif=this.get()-this.b)},p=function(){this.pdif&&(this.b=this.get()-this.pdif,delete this.pdif,k[this.id]=this)},b=function(){var a;if(M(this.start)){a=[];
for(var b=0,e=this.start.length;b<e;b++)a[b]=+this.start[b]+(this.end[b]-this.start[b])*this.easing(this.s)}else a=+this.start+(this.end-this.start)*this.easing(this.s);this.set(a)},q=function(){var l=0,b;for(b in k)if(k.hasOwnProperty(b)){var e=k[b],f=e.get();l++;e.s=(f-e.b)/(e.dur/e.spd);1<=e.s&&(delete k[b],e.s=1,l--,function(b){setTimeout(function(){a("mina.finish."+b.id,b)})}(e));e.update()}l&&y(q)},e=function(a,r,s,x,G,h,J){a={id:w+(A++).toString(36),start:a,end:r,b:s,s:0,dur:x-s,spd:1,get:G,
set:h,easing:J||e.linear,status:z,speed:d,duration:f,stop:n,pause:u,resume:p,update:b};k[a.id]=a;r=0;for(var K in k)if(k.hasOwnProperty(K)&&(r++,2==r))break;1==r&&y(q);return a};e.time=Date.now||function(){return+new Date};e.getById=function(a){return k[a]||null};e.linear=function(a){return a};e.easeout=function(a){return Math.pow(a,1.7)};e.easein=function(a){return Math.pow(a,0.48)};e.easeinout=function(a){if(1==a)return 1;if(0==a)return 0;var b=0.48-a/1.04,e=Math.sqrt(0.1734+b*b);a=e-b;a=Math.pow(Math.abs(a),
1/3)*(0>a?-1:1);b=-e-b;b=Math.pow(Math.abs(b),1/3)*(0>b?-1:1);a=a+b+0.5;return 3*(1-a)*a*a+a*a*a};e.backin=function(a){return 1==a?1:a*a*(2.70158*a-1.70158)};e.backout=function(a){if(0==a)return 0;a-=1;return a*a*(2.70158*a+1.70158)+1};e.elastic=function(a){return a==!!a?a:Math.pow(2,-10*a)*Math.sin(2*(a-0.075)*Math.PI/0.3)+1};e.bounce=function(a){a<1/2.75?a*=7.5625*a:a<2/2.75?(a-=1.5/2.75,a=7.5625*a*a+0.75):a<2.5/2.75?(a-=2.25/2.75,a=7.5625*a*a+0.9375):(a-=2.625/2.75,a=7.5625*a*a+0.984375);return a};
return N.mina=e}("undefined"==typeof k?function(){}:k),C=function(){function a(c,t){if(c){if(c.tagName)return x(c);if(y(c,"array")&&a.set)return a.set.apply(a,c);if(c instanceof e)return c;if(null==t)return c=G.doc.querySelector(c),x(c)}return new s(null==c?"100%":c,null==t?"100%":t)}function v(c,a){if(a){"#text"==c&&(c=G.doc.createTextNode(a.text||""));"string"==typeof c&&(c=v(c));if("string"==typeof a)return"xlink:"==a.substring(0,6)?c.getAttributeNS(m,a.substring(6)):"xml:"==a.substring(0,4)?c.getAttributeNS(la,
a.substring(4)):c.getAttribute(a);for(var da in a)if(a[h](da)){var b=J(a[da]);b?"xlink:"==da.substring(0,6)?c.setAttributeNS(m,da.substring(6),b):"xml:"==da.substring(0,4)?c.setAttributeNS(la,da.substring(4),b):c.setAttribute(da,b):c.removeAttribute(da)}}else c=G.doc.createElementNS(la,c);return c}function y(c,a){a=J.prototype.toLowerCase.call(a);return"finite"==a?isFinite(c):"array"==a&&(c instanceof Array||Array.isArray&&Array.isArray(c))?!0:"null"==a&&null===c||a==typeof c&&null!==c||"object"==
a&&c===Object(c)||$.call(c).slice(8,-1).toLowerCase()==a}function M(c){if("function"==typeof c||Object(c)!==c)return c;var a=new c.constructor,b;for(b in c)c[h](b)&&(a[b]=M(c[b]));return a}function A(c,a,b){function m(){var e=Array.prototype.slice.call(arguments,0),f=e.join("\u2400"),d=m.cache=m.cache||{},l=m.count=m.count||[];if(d[h](f)){a:for(var e=l,l=f,B=0,H=e.length;B<H;B++)if(e[B]===l){e.push(e.splice(B,1)[0]);break a}return b?b(d[f]):d[f]}1E3<=l.length&&delete d[l.shift()];l.push(f);d[f]=c.apply(a,
e);return b?b(d[f]):d[f]}return m}function w(c,a,b,m,e,f){return null==e?(c-=b,a-=m,c||a?(180*I.atan2(-a,-c)/C+540)%360:0):w(c,a,e,f)-w(b,m,e,f)}function z(c){return c%360*C/180}function d(c){var a=[];c=c.replace(/(?:^|\s)(\w+)\(([^)]+)\)/g,function(c,b,m){m=m.split(/\s*,\s*|\s+/);"rotate"==b&&1==m.length&&m.push(0,0);"scale"==b&&(2<m.length?m=m.slice(0,2):2==m.length&&m.push(0,0),1==m.length&&m.push(m[0],0,0));"skewX"==b?a.push(["m",1,0,I.tan(z(m[0])),1,0,0]):"skewY"==b?a.push(["m",1,I.tan(z(m[0])),
0,1,0,0]):a.push([b.charAt(0)].concat(m));return c});return a}function f(c,t){var b=O(c),m=new a.Matrix;if(b)for(var e=0,f=b.length;e<f;e++){var h=b[e],d=h.length,B=J(h[0]).toLowerCase(),H=h[0]!=B,l=H?m.invert():0,E;"t"==B&&2==d?m.translate(h[1],0):"t"==B&&3==d?H?(d=l.x(0,0),B=l.y(0,0),H=l.x(h[1],h[2]),l=l.y(h[1],h[2]),m.translate(H-d,l-B)):m.translate(h[1],h[2]):"r"==B?2==d?(E=E||t,m.rotate(h[1],E.x+E.width/2,E.y+E.height/2)):4==d&&(H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.rotate(h[1],H,l)):m.rotate(h[1],
h[2],h[3])):"s"==B?2==d||3==d?(E=E||t,m.scale(h[1],h[d-1],E.x+E.width/2,E.y+E.height/2)):4==d?H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.scale(h[1],h[1],H,l)):m.scale(h[1],h[1],h[2],h[3]):5==d&&(H?(H=l.x(h[3],h[4]),l=l.y(h[3],h[4]),m.scale(h[1],h[2],H,l)):m.scale(h[1],h[2],h[3],h[4])):"m"==B&&7==d&&m.add(h[1],h[2],h[3],h[4],h[5],h[6])}return m}function n(c,t){if(null==t){var m=!0;t="linearGradient"==c.type||"radialGradient"==c.type?c.node.getAttribute("gradientTransform"):"pattern"==c.type?c.node.getAttribute("patternTransform"):
c.node.getAttribute("transform");if(!t)return new a.Matrix;t=d(t)}else t=a._.rgTransform.test(t)?J(t).replace(/\.{3}|\u2026/g,c._.transform||aa):d(t),y(t,"array")&&(t=a.path?a.path.toString.call(t):J(t)),c._.transform=t;var b=f(t,c.getBBox(1));if(m)return b;c.matrix=b}function u(c){c=c.node.ownerSVGElement&&x(c.node.ownerSVGElement)||c.node.parentNode&&x(c.node.parentNode)||a.select("svg")||a(0,0);var t=c.select("defs"),t=null==t?!1:t.node;t||(t=r("defs",c.node).node);return t}function p(c){return c.node.ownerSVGElement&&
x(c.node.ownerSVGElement)||a.select("svg")}function b(c,a,m){function b(c){if(null==c)return aa;if(c==+c)return c;v(B,{width:c});try{return B.getBBox().width}catch(a){return 0}}function h(c){if(null==c)return aa;if(c==+c)return c;v(B,{height:c});try{return B.getBBox().height}catch(a){return 0}}function e(b,B){null==a?d[b]=B(c.attr(b)||0):b==a&&(d=B(null==m?c.attr(b)||0:m))}var f=p(c).node,d={},B=f.querySelector(".svg---mgr");B||(B=v("rect"),v(B,{x:-9E9,y:-9E9,width:10,height:10,"class":"svg---mgr",
fill:"none"}),f.appendChild(B));switch(c.type){case "rect":e("rx",b),e("ry",h);case "image":e("width",b),e("height",h);case "text":e("x",b);e("y",h);break;case "circle":e("cx",b);e("cy",h);e("r",b);break;case "ellipse":e("cx",b);e("cy",h);e("rx",b);e("ry",h);break;case "line":e("x1",b);e("x2",b);e("y1",h);e("y2",h);break;case "marker":e("refX",b);e("markerWidth",b);e("refY",h);e("markerHeight",h);break;case "radialGradient":e("fx",b);e("fy",h);break;case "tspan":e("dx",b);e("dy",h);break;default:e(a,
b)}f.removeChild(B);return d}function q(c){y(c,"array")||(c=Array.prototype.slice.call(arguments,0));for(var a=0,b=0,m=this.node;this[a];)delete this[a++];for(a=0;a<c.length;a++)"set"==c[a].type?c[a].forEach(function(c){m.appendChild(c.node)}):m.appendChild(c[a].node);for(var h=m.childNodes,a=0;a<h.length;a++)this[b++]=x(h[a]);return this}function e(c){if(c.snap in E)return E[c.snap];var a=this.id=V(),b;try{b=c.ownerSVGElement}catch(m){}this.node=c;b&&(this.paper=new s(b));this.type=c.tagName;this.anims=
{};this._={transform:[]};c.snap=a;E[a]=this;"g"==this.type&&(this.add=q);if(this.type in{g:1,mask:1,pattern:1})for(var e in s.prototype)s.prototype[h](e)&&(this[e]=s.prototype[e])}function l(c){this.node=c}function r(c,a){var b=v(c);a.appendChild(b);return x(b)}function s(c,a){var b,m,f,d=s.prototype;if(c&&"svg"==c.tagName){if(c.snap in E)return E[c.snap];var l=c.ownerDocument;b=new e(c);m=c.getElementsByTagName("desc")[0];f=c.getElementsByTagName("defs")[0];m||(m=v("desc"),m.appendChild(l.createTextNode("Created with Snap")),
b.node.appendChild(m));f||(f=v("defs"),b.node.appendChild(f));b.defs=f;for(var ca in d)d[h](ca)&&(b[ca]=d[ca]);b.paper=b.root=b}else b=r("svg",G.doc.body),v(b.node,{height:a,version:1.1,width:c,xmlns:la});return b}function x(c){return!c||c instanceof e||c instanceof l?c:c.tagName&&"svg"==c.tagName.toLowerCase()?new s(c):c.tagName&&"object"==c.tagName.toLowerCase()&&"image/svg+xml"==c.type?new s(c.contentDocument.getElementsByTagName("svg")[0]):new e(c)}a.version="0.3.0";a.toString=function(){return"Snap v"+
this.version};a._={};var G={win:N,doc:N.document};a._.glob=G;var h="hasOwnProperty",J=String,K=parseFloat,U=parseInt,I=Math,P=I.max,Q=I.min,Y=I.abs,C=I.PI,aa="",$=Object.prototype.toString,F=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\))\s*$/i;a._.separator=
RegExp("[,\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]+");var S=RegExp("[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*"),X={hs:1,rg:1},W=RegExp("([a-z])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)",
"ig"),ma=RegExp("([rstm])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)","ig"),Z=RegExp("(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*",
"ig"),na=0,ba="S"+(+new Date).toString(36),V=function(){return ba+(na++).toString(36)},m="http://www.w3.org/1999/xlink",la="http://www.w3.org/2000/svg",E={},ca=a.url=function(c){return"url('#"+c+"')"};a._.$=v;a._.id=V;a.format=function(){var c=/\{([^\}]+)\}/g,a=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,b=function(c,b,m){var h=m;b.replace(a,function(c,a,b,m,t){a=a||m;h&&(a in h&&(h=h[a]),"function"==typeof h&&t&&(h=h()))});return h=(null==h||h==m?c:h)+""};return function(a,m){return J(a).replace(c,
function(c,a){return b(c,a,m)})}}();a._.clone=M;a._.cacher=A;a.rad=z;a.deg=function(c){return 180*c/C%360};a.angle=w;a.is=y;a.snapTo=function(c,a,b){b=y(b,"finite")?b:10;if(y(c,"array"))for(var m=c.length;m--;){if(Y(c[m]-a)<=b)return c[m]}else{c=+c;m=a%c;if(m<b)return a-m;if(m>c-b)return a-m+c}return a};a.getRGB=A(function(c){if(!c||(c=J(c)).indexOf("-")+1)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};if("none"==c)return{r:-1,g:-1,b:-1,hex:"none",toString:ka};!X[h](c.toLowerCase().substring(0,
2))&&"#"!=c.charAt()&&(c=T(c));if(!c)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};var b,m,e,f,d;if(c=c.match(F)){c[2]&&(e=U(c[2].substring(5),16),m=U(c[2].substring(3,5),16),b=U(c[2].substring(1,3),16));c[3]&&(e=U((d=c[3].charAt(3))+d,16),m=U((d=c[3].charAt(2))+d,16),b=U((d=c[3].charAt(1))+d,16));c[4]&&(d=c[4].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b*=2.55),m=K(d[1]),"%"==d[1].slice(-1)&&(m*=2.55),e=K(d[2]),"%"==d[2].slice(-1)&&(e*=2.55),"rgba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),
d[3]&&"%"==d[3].slice(-1)&&(f/=100));if(c[5])return d=c[5].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsb2rgb(b,m,e,f);if(c[6])return d=c[6].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),
"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsla"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsl2rgb(b,m,e,f);b=Q(I.round(b),255);m=Q(I.round(m),255);e=Q(I.round(e),255);f=Q(P(f,0),1);c={r:b,g:m,b:e,toString:ka};c.hex="#"+(16777216|e|m<<8|b<<16).toString(16).slice(1);c.opacity=y(f,"finite")?f:1;return c}return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka}},a);a.hsb=A(function(c,b,m){return a.hsb2rgb(c,b,m).hex});a.hsl=A(function(c,b,m){return a.hsl2rgb(c,
b,m).hex});a.rgb=A(function(c,a,b,m){if(y(m,"finite")){var e=I.round;return"rgba("+[e(c),e(a),e(b),+m.toFixed(2)]+")"}return"#"+(16777216|b|a<<8|c<<16).toString(16).slice(1)});var T=function(c){var a=G.doc.getElementsByTagName("head")[0]||G.doc.getElementsByTagName("svg")[0];T=A(function(c){if("red"==c.toLowerCase())return"rgb(255, 0, 0)";a.style.color="rgb(255, 0, 0)";a.style.color=c;c=G.doc.defaultView.getComputedStyle(a,aa).getPropertyValue("color");return"rgb(255, 0, 0)"==c?null:c});return T(c)},
qa=function(){return"hsb("+[this.h,this.s,this.b]+")"},ra=function(){return"hsl("+[this.h,this.s,this.l]+")"},ka=function(){return 1==this.opacity||null==this.opacity?this.hex:"rgba("+[this.r,this.g,this.b,this.opacity]+")"},D=function(c,b,m){null==b&&y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&(m=c.b,b=c.g,c=c.r);null==b&&y(c,string)&&(m=a.getRGB(c),c=m.r,b=m.g,m=m.b);if(1<c||1<b||1<m)c/=255,b/=255,m/=255;return[c,b,m]},oa=function(c,b,m,e){c=I.round(255*c);b=I.round(255*b);m=I.round(255*m);c={r:c,
g:b,b:m,opacity:y(e,"finite")?e:1,hex:a.rgb(c,b,m),toString:ka};y(e,"finite")&&(c.opacity=e);return c};a.color=function(c){var b;y(c,"object")&&"h"in c&&"s"in c&&"b"in c?(b=a.hsb2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):y(c,"object")&&"h"in c&&"s"in c&&"l"in c?(b=a.hsl2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):(y(c,"string")&&(c=a.getRGB(c)),y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&!("error"in c)?(b=a.rgb2hsl(c),c.h=b.h,c.s=b.s,c.l=b.l,b=a.rgb2hsb(c),c.v=b.b):(c={hex:"none"},
c.r=c.g=c.b=c.h=c.s=c.v=c.l=-1,c.error=1));c.toString=ka;return c};a.hsb2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"b"in c&&(b=c.b,a=c.s,c=c.h,m=c.o);var e,h,d;c=360*c%360/60;d=b*a;a=d*(1-Y(c%2-1));b=e=h=b-d;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.hsl2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"l"in c&&(b=c.l,a=c.s,c=c.h);if(1<c||1<a||1<b)c/=360,a/=100,b/=100;var e,h,d;c=360*c%360/60;d=2*a*(0.5>b?b:1-b);a=d*(1-Y(c%2-1));b=e=
h=b-d/2;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.rgb2hsb=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e;m=P(c,a,b);e=m-Q(c,a,b);c=((0==e?0:m==c?(a-b)/e:m==a?(b-c)/e+2:(c-a)/e+4)+360)%6*60/360;return{h:c,s:0==e?0:e/m,b:m,toString:qa}};a.rgb2hsl=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e,h;m=P(c,a,b);e=Q(c,a,b);h=m-e;c=((0==h?0:m==c?(a-b)/h:m==a?(b-c)/h+2:(c-a)/h+4)+360)%6*60/360;m=(m+e)/2;return{h:c,s:0==h?0:0.5>m?h/(2*m):h/(2-2*
m),l:m,toString:ra}};a.parsePathString=function(c){if(!c)return null;var b=a.path(c);if(b.arr)return a.path.clone(b.arr);var m={a:7,c:6,o:2,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,u:3,z:0},e=[];y(c,"array")&&y(c[0],"array")&&(e=a.path.clone(c));e.length||J(c).replace(W,function(c,a,b){var h=[];c=a.toLowerCase();b.replace(Z,function(c,a){a&&h.push(+a)});"m"==c&&2<h.length&&(e.push([a].concat(h.splice(0,2))),c="l",a="m"==a?"l":"L");"o"==c&&1==h.length&&e.push([a,h[0] ]);if("r"==c)e.push([a].concat(h));else for(;h.length>=
m[c]&&(e.push([a].concat(h.splice(0,m[c]))),m[c]););});e.toString=a.path.toString;b.arr=a.path.clone(e);return e};var O=a.parseTransformString=function(c){if(!c)return null;var b=[];y(c,"array")&&y(c[0],"array")&&(b=a.path.clone(c));b.length||J(c).replace(ma,function(c,a,m){var e=[];a.toLowerCase();m.replace(Z,function(c,a){a&&e.push(+a)});b.push([a].concat(e))});b.toString=a.path.toString;return b};a._.svgTransform2string=d;a._.rgTransform=RegExp("^[a-z][\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*-?\\.?\\d",
"i");a._.transform2matrix=f;a._unit2px=b;a._.getSomeDefs=u;a._.getSomeSVG=p;a.select=function(c){return x(G.doc.querySelector(c))};a.selectAll=function(c){c=G.doc.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};setInterval(function(){for(var c in E)if(E[h](c)){var a=E[c],b=a.node;("svg"!=a.type&&!b.ownerSVGElement||"svg"==a.type&&(!b.parentNode||"ownerSVGElement"in b.parentNode&&!b.ownerSVGElement))&&delete E[c]}},1E4);(function(c){function m(c){function a(c,
b){var m=v(c.node,b);(m=(m=m&&m.match(d))&&m[2])&&"#"==m.charAt()&&(m=m.substring(1))&&(f[m]=(f[m]||[]).concat(function(a){var m={};m[b]=ca(a);v(c.node,m)}))}function b(c){var a=v(c.node,"xlink:href");a&&"#"==a.charAt()&&(a=a.substring(1))&&(f[a]=(f[a]||[]).concat(function(a){c.attr("xlink:href","#"+a)}))}var e=c.selectAll("*"),h,d=/^\s*url\(("|'|)(.*)\1\)\s*$/;c=[];for(var f={},l=0,E=e.length;l<E;l++){h=e[l];a(h,"fill");a(h,"stroke");a(h,"filter");a(h,"mask");a(h,"clip-path");b(h);var t=v(h.node,
"id");t&&(v(h.node,{id:h.id}),c.push({old:t,id:h.id}))}l=0;for(E=c.length;l<E;l++)if(e=f[c[l].old])for(h=0,t=e.length;h<t;h++)e[h](c[l].id)}function e(c,a,b){return function(m){m=m.slice(c,a);1==m.length&&(m=m[0]);return b?b(m):m}}function d(c){return function(){var a=c?"<"+this.type:"",b=this.node.attributes,m=this.node.childNodes;if(c)for(var e=0,h=b.length;e<h;e++)a+=" "+b[e].name+'="'+b[e].value.replace(/"/g,'\\"')+'"';if(m.length){c&&(a+=">");e=0;for(h=m.length;e<h;e++)3==m[e].nodeType?a+=m[e].nodeValue:
1==m[e].nodeType&&(a+=x(m[e]).toString());c&&(a+="</"+this.type+">")}else c&&(a+="/>");return a}}c.attr=function(c,a){if(!c)return this;if(y(c,"string"))if(1<arguments.length){var b={};b[c]=a;c=b}else return k("snap.util.getattr."+c,this).firstDefined();for(var m in c)c[h](m)&&k("snap.util.attr."+m,this,c[m]);return this};c.getBBox=function(c){if(!a.Matrix||!a.path)return this.node.getBBox();var b=this,m=new a.Matrix;if(b.removed)return a._.box();for(;"use"==b.type;)if(c||(m=m.add(b.transform().localMatrix.translate(b.attr("x")||
0,b.attr("y")||0))),b.original)b=b.original;else var e=b.attr("xlink:href"),b=b.original=b.node.ownerDocument.getElementById(e.substring(e.indexOf("#")+1));var e=b._,h=a.path.get[b.type]||a.path.get.deflt;try{if(c)return e.bboxwt=h?a.path.getBBox(b.realPath=h(b)):a._.box(b.node.getBBox()),a._.box(e.bboxwt);b.realPath=h(b);b.matrix=b.transform().localMatrix;e.bbox=a.path.getBBox(a.path.map(b.realPath,m.add(b.matrix)));return a._.box(e.bbox)}catch(d){return a._.box()}};var f=function(){return this.string};
c.transform=function(c){var b=this._;if(null==c){var m=this;c=new a.Matrix(this.node.getCTM());for(var e=n(this),h=[e],d=new a.Matrix,l=e.toTransformString(),b=J(e)==J(this.matrix)?J(b.transform):l;"svg"!=m.type&&(m=m.parent());)h.push(n(m));for(m=h.length;m--;)d.add(h[m]);return{string:b,globalMatrix:c,totalMatrix:d,localMatrix:e,diffMatrix:c.clone().add(e.invert()),global:c.toTransformString(),total:d.toTransformString(),local:l,toString:f}}c instanceof a.Matrix?this.matrix=c:n(this,c);this.node&&
("linearGradient"==this.type||"radialGradient"==this.type?v(this.node,{gradientTransform:this.matrix}):"pattern"==this.type?v(this.node,{patternTransform:this.matrix}):v(this.node,{transform:this.matrix}));return this};c.parent=function(){return x(this.node.parentNode)};c.append=c.add=function(c){if(c){if("set"==c.type){var a=this;c.forEach(function(c){a.add(c)});return this}c=x(c);this.node.appendChild(c.node);c.paper=this.paper}return this};c.appendTo=function(c){c&&(c=x(c),c.append(this));return this};
c.prepend=function(c){if(c){if("set"==c.type){var a=this,b;c.forEach(function(c){b?b.after(c):a.prepend(c);b=c});return this}c=x(c);var m=c.parent();this.node.insertBefore(c.node,this.node.firstChild);this.add&&this.add();c.paper=this.paper;this.parent()&&this.parent().add();m&&m.add()}return this};c.prependTo=function(c){c=x(c);c.prepend(this);return this};c.before=function(c){if("set"==c.type){var a=this;c.forEach(function(c){var b=c.parent();a.node.parentNode.insertBefore(c.node,a.node);b&&b.add()});
this.parent().add();return this}c=x(c);var b=c.parent();this.node.parentNode.insertBefore(c.node,this.node);this.parent()&&this.parent().add();b&&b.add();c.paper=this.paper;return this};c.after=function(c){c=x(c);var a=c.parent();this.node.nextSibling?this.node.parentNode.insertBefore(c.node,this.node.nextSibling):this.node.parentNode.appendChild(c.node);this.parent()&&this.parent().add();a&&a.add();c.paper=this.paper;return this};c.insertBefore=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,
c.node);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.insertAfter=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,c.node.nextSibling);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.remove=function(){var c=this.parent();this.node.parentNode&&this.node.parentNode.removeChild(this.node);delete this.paper;this.removed=!0;c&&c.add();return this};c.select=function(c){return x(this.node.querySelector(c))};c.selectAll=
function(c){c=this.node.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};c.asPX=function(c,a){null==a&&(a=this.attr(c));return+b(this,c,a)};c.use=function(){var c,a=this.node.id;a||(a=this.id,v(this.node,{id:a}));c="linearGradient"==this.type||"radialGradient"==this.type||"pattern"==this.type?r(this.type,this.node.parentNode):r("use",this.node.parentNode);v(c.node,{"xlink:href":"#"+a});c.original=this;return c};var l=/\S+/g;c.addClass=function(c){var a=(c||
"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h,d;if(a.length){for(e=0;d=a[e++];)h=m.indexOf(d),~h||m.push(d);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.removeClass=function(c){var a=(c||"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h;if(m.length){for(e=0;h=a[e++];)h=m.indexOf(h),~h&&m.splice(h,1);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.hasClass=function(c){return!!~(this.node.className.baseVal.match(l)||[]).indexOf(c)};
c.toggleClass=function(c,a){if(null!=a)return a?this.addClass(c):this.removeClass(c);var b=(c||"").match(l)||[],m=this.node,e=m.className.baseVal,h=e.match(l)||[],d,f,E;for(d=0;E=b[d++];)f=h.indexOf(E),~f?h.splice(f,1):h.push(E);b=h.join(" ");e!=b&&(m.className.baseVal=b);return this};c.clone=function(){var c=x(this.node.cloneNode(!0));v(c.node,"id")&&v(c.node,{id:c.id});m(c);c.insertAfter(this);return c};c.toDefs=function(){u(this).appendChild(this.node);return this};c.pattern=c.toPattern=function(c,
a,b,m){var e=r("pattern",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,c=c.x);v(e.node,{x:c,y:a,width:b,height:m,patternUnits:"userSpaceOnUse",id:e.id,viewBox:[c,a,b,m].join(" ")});e.node.appendChild(this.node);return e};c.marker=function(c,a,b,m,e,h){var d=r("marker",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,e=c.refX||c.cx,h=c.refY||c.cy,c=c.x);v(d.node,{viewBox:[c,a,b,m].join(" "),markerWidth:b,markerHeight:m,
orient:"auto",refX:e||0,refY:h||0,id:d.id});d.node.appendChild(this.node);return d};var E=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);this.attr=c;this.dur=a;b&&(this.easing=b);m&&(this.callback=m)};a._.Animation=E;a.animation=function(c,a,b,m){return new E(c,a,b,m)};c.inAnim=function(){var c=[],a;for(a in this.anims)this.anims[h](a)&&function(a){c.push({anim:new E(a._attrs,a.dur,a.easing,a._callback),mina:a,curStatus:a.status(),status:function(c){return a.status(c)},stop:function(){a.stop()}})}(this.anims[a]);
return c};a.animate=function(c,a,b,m,e,h){"function"!=typeof e||e.length||(h=e,e=L.linear);var d=L.time();c=L(c,a,d,d+m,L.time,b,e);h&&k.once("mina.finish."+c.id,h);return c};c.stop=function(){for(var c=this.inAnim(),a=0,b=c.length;a<b;a++)c[a].stop();return this};c.animate=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);c instanceof E&&(m=c.callback,b=c.easing,a=b.dur,c=c.attr);var d=[],f=[],l={},t,ca,n,T=this,q;for(q in c)if(c[h](q)){T.equal?(n=T.equal(q,J(c[q])),t=n.from,ca=
n.to,n=n.f):(t=+T.attr(q),ca=+c[q]);var la=y(t,"array")?t.length:1;l[q]=e(d.length,d.length+la,n);d=d.concat(t);f=f.concat(ca)}t=L.time();var p=L(d,f,t,t+a,L.time,function(c){var a={},b;for(b in l)l[h](b)&&(a[b]=l[b](c));T.attr(a)},b);T.anims[p.id]=p;p._attrs=c;p._callback=m;k("snap.animcreated."+T.id,p);k.once("mina.finish."+p.id,function(){delete T.anims[p.id];m&&m.call(T)});k.once("mina.stop."+p.id,function(){delete T.anims[p.id]});return T};var T={};c.data=function(c,b){var m=T[this.id]=T[this.id]||
{};if(0==arguments.length)return k("snap.data.get."+this.id,this,m,null),m;if(1==arguments.length){if(a.is(c,"object")){for(var e in c)c[h](e)&&this.data(e,c[e]);return this}k("snap.data.get."+this.id,this,m[c],c);return m[c]}m[c]=b;k("snap.data.set."+this.id,this,b,c);return this};c.removeData=function(c){null==c?T[this.id]={}:T[this.id]&&delete T[this.id][c];return this};c.outerSVG=c.toString=d(1);c.innerSVG=d()})(e.prototype);a.parse=function(c){var a=G.doc.createDocumentFragment(),b=!0,m=G.doc.createElement("div");
c=J(c);c.match(/^\s*<\s*svg(?:\s|>)/)||(c="<svg>"+c+"</svg>",b=!1);m.innerHTML=c;if(c=m.getElementsByTagName("svg")[0])if(b)a=c;else for(;c.firstChild;)a.appendChild(c.firstChild);m.innerHTML=aa;return new l(a)};l.prototype.select=e.prototype.select;l.prototype.selectAll=e.prototype.selectAll;a.fragment=function(){for(var c=Array.prototype.slice.call(arguments,0),b=G.doc.createDocumentFragment(),m=0,e=c.length;m<e;m++){var h=c[m];h.node&&h.node.nodeType&&b.appendChild(h.node);h.nodeType&&b.appendChild(h);
"string"==typeof h&&b.appendChild(a.parse(h).node)}return new l(b)};a._.make=r;a._.wrap=x;s.prototype.el=function(c,a){var b=r(c,this.node);a&&b.attr(a);return b};k.on("snap.util.getattr",function(){var c=k.nt(),c=c.substring(c.lastIndexOf(".")+1),a=c.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});return pa[h](a)?this.node.ownerDocument.defaultView.getComputedStyle(this.node,null).getPropertyValue(a):v(this.node,c)});var pa={"alignment-baseline":0,"baseline-shift":0,clip:0,"clip-path":0,
"clip-rule":0,color:0,"color-interpolation":0,"color-interpolation-filters":0,"color-profile":0,"color-rendering":0,cursor:0,direction:0,display:0,"dominant-baseline":0,"enable-background":0,fill:0,"fill-opacity":0,"fill-rule":0,filter:0,"flood-color":0,"flood-opacity":0,font:0,"font-family":0,"font-size":0,"font-size-adjust":0,"font-stretch":0,"font-style":0,"font-variant":0,"font-weight":0,"glyph-orientation-horizontal":0,"glyph-orientation-vertical":0,"image-rendering":0,kerning:0,"letter-spacing":0,
"lighting-color":0,marker:0,"marker-end":0,"marker-mid":0,"marker-start":0,mask:0,opacity:0,overflow:0,"pointer-events":0,"shape-rendering":0,"stop-color":0,"stop-opacity":0,stroke:0,"stroke-dasharray":0,"stroke-dashoffset":0,"stroke-linecap":0,"stroke-linejoin":0,"stroke-miterlimit":0,"stroke-opacity":0,"stroke-width":0,"text-anchor":0,"text-decoration":0,"text-rendering":0,"unicode-bidi":0,visibility:0,"word-spacing":0,"writing-mode":0};k.on("snap.util.attr",function(c){var a=k.nt(),b={},a=a.substring(a.lastIndexOf(".")+
1);b[a]=c;var m=a.replace(/-(\w)/gi,function(c,a){return a.toUpperCase()}),a=a.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});pa[h](a)?this.node.style[m]=null==c?aa:c:v(this.node,b)});a.ajax=function(c,a,b,m){var e=new XMLHttpRequest,h=V();if(e){if(y(a,"function"))m=b,b=a,a=null;else if(y(a,"object")){var d=[],f;for(f in a)a.hasOwnProperty(f)&&d.push(encodeURIComponent(f)+"="+encodeURIComponent(a[f]));a=d.join("&")}e.open(a?"POST":"GET",c,!0);a&&(e.setRequestHeader("X-Requested-With","XMLHttpRequest"),
e.setRequestHeader("Content-type","application/x-www-form-urlencoded"));b&&(k.once("snap.ajax."+h+".0",b),k.once("snap.ajax."+h+".200",b),k.once("snap.ajax."+h+".304",b));e.onreadystatechange=function(){4==e.readyState&&k("snap.ajax."+h+"."+e.status,m,e)};if(4==e.readyState)return e;e.send(a);return e}};a.load=function(c,b,m){a.ajax(c,function(c){c=a.parse(c.responseText);m?b.call(m,c):b(c)})};a.getElementByPoint=function(c,a){var b,m,e=G.doc.elementFromPoint(c,a);if(G.win.opera&&"svg"==e.tagName){b=
e;m=b.getBoundingClientRect();b=b.ownerDocument;var h=b.body,d=b.documentElement;b=m.top+(g.win.pageYOffset||d.scrollTop||h.scrollTop)-(d.clientTop||h.clientTop||0);m=m.left+(g.win.pageXOffset||d.scrollLeft||h.scrollLeft)-(d.clientLeft||h.clientLeft||0);h=e.createSVGRect();h.x=c-m;h.y=a-b;h.width=h.height=1;b=e.getIntersectionList(h,null);b.length&&(e=b[b.length-1])}return e?x(e):null};a.plugin=function(c){c(a,e,s,G,l)};return G.win.Snap=a}();C.plugin(function(a,k,y,M,A){function w(a,d,f,b,q,e){null==
d&&"[object SVGMatrix]"==z.call(a)?(this.a=a.a,this.b=a.b,this.c=a.c,this.d=a.d,this.e=a.e,this.f=a.f):null!=a?(this.a=+a,this.b=+d,this.c=+f,this.d=+b,this.e=+q,this.f=+e):(this.a=1,this.c=this.b=0,this.d=1,this.f=this.e=0)}var z=Object.prototype.toString,d=String,f=Math;(function(n){function k(a){return a[0]*a[0]+a[1]*a[1]}function p(a){var d=f.sqrt(k(a));a[0]&&(a[0]/=d);a[1]&&(a[1]/=d)}n.add=function(a,d,e,f,n,p){var k=[[],[],[] ],u=[[this.a,this.c,this.e],[this.b,this.d,this.f],[0,0,1] ];d=[[a,
e,n],[d,f,p],[0,0,1] ];a&&a instanceof w&&(d=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1] ]);for(a=0;3>a;a++)for(e=0;3>e;e++){for(f=n=0;3>f;f++)n+=u[a][f]*d[f][e];k[a][e]=n}this.a=k[0][0];this.b=k[1][0];this.c=k[0][1];this.d=k[1][1];this.e=k[0][2];this.f=k[1][2];return this};n.invert=function(){var a=this.a*this.d-this.b*this.c;return new w(this.d/a,-this.b/a,-this.c/a,this.a/a,(this.c*this.f-this.d*this.e)/a,(this.b*this.e-this.a*this.f)/a)};n.clone=function(){return new w(this.a,this.b,this.c,this.d,this.e,
this.f)};n.translate=function(a,d){return this.add(1,0,0,1,a,d)};n.scale=function(a,d,e,f){null==d&&(d=a);(e||f)&&this.add(1,0,0,1,e,f);this.add(a,0,0,d,0,0);(e||f)&&this.add(1,0,0,1,-e,-f);return this};n.rotate=function(b,d,e){b=a.rad(b);d=d||0;e=e||0;var l=+f.cos(b).toFixed(9);b=+f.sin(b).toFixed(9);this.add(l,b,-b,l,d,e);return this.add(1,0,0,1,-d,-e)};n.x=function(a,d){return a*this.a+d*this.c+this.e};n.y=function(a,d){return a*this.b+d*this.d+this.f};n.get=function(a){return+this[d.fromCharCode(97+
a)].toFixed(4)};n.toString=function(){return"matrix("+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)].join()+")"};n.offset=function(){return[this.e.toFixed(4),this.f.toFixed(4)]};n.determinant=function(){return this.a*this.d-this.b*this.c};n.split=function(){var b={};b.dx=this.e;b.dy=this.f;var d=[[this.a,this.c],[this.b,this.d] ];b.scalex=f.sqrt(k(d[0]));p(d[0]);b.shear=d[0][0]*d[1][0]+d[0][1]*d[1][1];d[1]=[d[1][0]-d[0][0]*b.shear,d[1][1]-d[0][1]*b.shear];b.scaley=f.sqrt(k(d[1]));
p(d[1]);b.shear/=b.scaley;0>this.determinant()&&(b.scalex=-b.scalex);var e=-d[0][1],d=d[1][1];0>d?(b.rotate=a.deg(f.acos(d)),0>e&&(b.rotate=360-b.rotate)):b.rotate=a.deg(f.asin(e));b.isSimple=!+b.shear.toFixed(9)&&(b.scalex.toFixed(9)==b.scaley.toFixed(9)||!b.rotate);b.isSuperSimple=!+b.shear.toFixed(9)&&b.scalex.toFixed(9)==b.scaley.toFixed(9)&&!b.rotate;b.noRotation=!+b.shear.toFixed(9)&&!b.rotate;return b};n.toTransformString=function(a){a=a||this.split();if(+a.shear.toFixed(9))return"m"+[this.get(0),
this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)];a.scalex=+a.scalex.toFixed(4);a.scaley=+a.scaley.toFixed(4);a.rotate=+a.rotate.toFixed(4);return(a.dx||a.dy?"t"+[+a.dx.toFixed(4),+a.dy.toFixed(4)]:"")+(1!=a.scalex||1!=a.scaley?"s"+[a.scalex,a.scaley,0,0]:"")+(a.rotate?"r"+[+a.rotate.toFixed(4),0,0]:"")}})(w.prototype);a.Matrix=w;a.matrix=function(a,d,f,b,k,e){return new w(a,d,f,b,k,e)}});C.plugin(function(a,v,y,M,A){function w(h){return function(d){k.stop();d instanceof A&&1==d.node.childNodes.length&&
("radialGradient"==d.node.firstChild.tagName||"linearGradient"==d.node.firstChild.tagName||"pattern"==d.node.firstChild.tagName)&&(d=d.node.firstChild,b(this).appendChild(d),d=u(d));if(d instanceof v)if("radialGradient"==d.type||"linearGradient"==d.type||"pattern"==d.type){d.node.id||e(d.node,{id:d.id});var f=l(d.node.id)}else f=d.attr(h);else f=a.color(d),f.error?(f=a(b(this).ownerSVGElement).gradient(d))?(f.node.id||e(f.node,{id:f.id}),f=l(f.node.id)):f=d:f=r(f);d={};d[h]=f;e(this.node,d);this.node.style[h]=
x}}function z(a){k.stop();a==+a&&(a+="px");this.node.style.fontSize=a}function d(a){var b=[];a=a.childNodes;for(var e=0,f=a.length;e<f;e++){var l=a[e];3==l.nodeType&&b.push(l.nodeValue);"tspan"==l.tagName&&(1==l.childNodes.length&&3==l.firstChild.nodeType?b.push(l.firstChild.nodeValue):b.push(d(l)))}return b}function f(){k.stop();return this.node.style.fontSize}var n=a._.make,u=a._.wrap,p=a.is,b=a._.getSomeDefs,q=/^url\(#?([^)]+)\)$/,e=a._.$,l=a.url,r=String,s=a._.separator,x="";k.on("snap.util.attr.mask",
function(a){if(a instanceof v||a instanceof A){k.stop();a instanceof A&&1==a.node.childNodes.length&&(a=a.node.firstChild,b(this).appendChild(a),a=u(a));if("mask"==a.type)var d=a;else d=n("mask",b(this)),d.node.appendChild(a.node);!d.node.id&&e(d.node,{id:d.id});e(this.node,{mask:l(d.id)})}});(function(a){k.on("snap.util.attr.clip",a);k.on("snap.util.attr.clip-path",a);k.on("snap.util.attr.clipPath",a)})(function(a){if(a instanceof v||a instanceof A){k.stop();if("clipPath"==a.type)var d=a;else d=
n("clipPath",b(this)),d.node.appendChild(a.node),!d.node.id&&e(d.node,{id:d.id});e(this.node,{"clip-path":l(d.id)})}});k.on("snap.util.attr.fill",w("fill"));k.on("snap.util.attr.stroke",w("stroke"));var G=/^([lr])(?:\(([^)]*)\))?(.*)$/i;k.on("snap.util.grad.parse",function(a){a=r(a);var b=a.match(G);if(!b)return null;a=b[1];var e=b[2],b=b[3],e=e.split(/\s*,\s*/).map(function(a){return+a==a?+a:a});1==e.length&&0==e[0]&&(e=[]);b=b.split("-");b=b.map(function(a){a=a.split(":");var b={color:a[0]};a[1]&&
(b.offset=parseFloat(a[1]));return b});return{type:a,params:e,stops:b}});k.on("snap.util.attr.d",function(b){k.stop();p(b,"array")&&p(b[0],"array")&&(b=a.path.toString.call(b));b=r(b);b.match(/[ruo]/i)&&(b=a.path.toAbsolute(b));e(this.node,{d:b})})(-1);k.on("snap.util.attr.#text",function(a){k.stop();a=r(a);for(a=M.doc.createTextNode(a);this.node.firstChild;)this.node.removeChild(this.node.firstChild);this.node.appendChild(a)})(-1);k.on("snap.util.attr.path",function(a){k.stop();this.attr({d:a})})(-1);
k.on("snap.util.attr.class",function(a){k.stop();this.node.className.baseVal=a})(-1);k.on("snap.util.attr.viewBox",function(a){a=p(a,"object")&&"x"in a?[a.x,a.y,a.width,a.height].join(" "):p(a,"array")?a.join(" "):a;e(this.node,{viewBox:a});k.stop()})(-1);k.on("snap.util.attr.transform",function(a){this.transform(a);k.stop()})(-1);k.on("snap.util.attr.r",function(a){"rect"==this.type&&(k.stop(),e(this.node,{rx:a,ry:a}))})(-1);k.on("snap.util.attr.textpath",function(a){k.stop();if("text"==this.type){var d,
f;if(!a&&this.textPath){for(a=this.textPath;a.node.firstChild;)this.node.appendChild(a.node.firstChild);a.remove();delete this.textPath}else if(p(a,"string")?(d=b(this),a=u(d.parentNode).path(a),d.appendChild(a.node),d=a.id,a.attr({id:d})):(a=u(a),a instanceof v&&(d=a.attr("id"),d||(d=a.id,a.attr({id:d})))),d)if(a=this.textPath,f=this.node,a)a.attr({"xlink:href":"#"+d});else{for(a=e("textPath",{"xlink:href":"#"+d});f.firstChild;)a.appendChild(f.firstChild);f.appendChild(a);this.textPath=u(a)}}})(-1);
k.on("snap.util.attr.text",function(a){if("text"==this.type){for(var b=this.node,d=function(a){var b=e("tspan");if(p(a,"array"))for(var f=0;f<a.length;f++)b.appendChild(d(a[f]));else b.appendChild(M.doc.createTextNode(a));b.normalize&&b.normalize();return b};b.firstChild;)b.removeChild(b.firstChild);for(a=d(a);a.firstChild;)b.appendChild(a.firstChild)}k.stop()})(-1);k.on("snap.util.attr.fontSize",z)(-1);k.on("snap.util.attr.font-size",z)(-1);k.on("snap.util.getattr.transform",function(){k.stop();
return this.transform()})(-1);k.on("snap.util.getattr.textpath",function(){k.stop();return this.textPath})(-1);(function(){function b(d){return function(){k.stop();var b=M.doc.defaultView.getComputedStyle(this.node,null).getPropertyValue("marker-"+d);return"none"==b?b:a(M.doc.getElementById(b.match(q)[1]))}}function d(a){return function(b){k.stop();var d="marker"+a.charAt(0).toUpperCase()+a.substring(1);if(""==b||!b)this.node.style[d]="none";else if("marker"==b.type){var f=b.node.id;f||e(b.node,{id:b.id});
this.node.style[d]=l(f)}}}k.on("snap.util.getattr.marker-end",b("end"))(-1);k.on("snap.util.getattr.markerEnd",b("end"))(-1);k.on("snap.util.getattr.marker-start",b("start"))(-1);k.on("snap.util.getattr.markerStart",b("start"))(-1);k.on("snap.util.getattr.marker-mid",b("mid"))(-1);k.on("snap.util.getattr.markerMid",b("mid"))(-1);k.on("snap.util.attr.marker-end",d("end"))(-1);k.on("snap.util.attr.markerEnd",d("end"))(-1);k.on("snap.util.attr.marker-start",d("start"))(-1);k.on("snap.util.attr.markerStart",
d("start"))(-1);k.on("snap.util.attr.marker-mid",d("mid"))(-1);k.on("snap.util.attr.markerMid",d("mid"))(-1)})();k.on("snap.util.getattr.r",function(){if("rect"==this.type&&e(this.node,"rx")==e(this.node,"ry"))return k.stop(),e(this.node,"rx")})(-1);k.on("snap.util.getattr.text",function(){if("text"==this.type||"tspan"==this.type){k.stop();var a=d(this.node);return 1==a.length?a[0]:a}})(-1);k.on("snap.util.getattr.#text",function(){return this.node.textContent})(-1);k.on("snap.util.getattr.viewBox",
function(){k.stop();var b=e(this.node,"viewBox");if(b)return b=b.split(s),a._.box(+b[0],+b[1],+b[2],+b[3])})(-1);k.on("snap.util.getattr.points",function(){var a=e(this.node,"points");k.stop();if(a)return a.split(s)})(-1);k.on("snap.util.getattr.path",function(){var a=e(this.node,"d");k.stop();return a})(-1);k.on("snap.util.getattr.class",function(){return this.node.className.baseVal})(-1);k.on("snap.util.getattr.fontSize",f)(-1);k.on("snap.util.getattr.font-size",f)(-1)});C.plugin(function(a,v,y,
M,A){function w(a){return a}function z(a){return function(b){return+b.toFixed(3)+a}}var d={"+":function(a,b){return a+b},"-":function(a,b){return a-b},"/":function(a,b){return a/b},"*":function(a,b){return a*b}},f=String,n=/[a-z]+$/i,u=/^\s*([+\-\/*])\s*=\s*([\d.eE+\-]+)\s*([^\d\s]+)?\s*$/;k.on("snap.util.attr",function(a){if(a=f(a).match(u)){var b=k.nt(),b=b.substring(b.lastIndexOf(".")+1),q=this.attr(b),e={};k.stop();var l=a[3]||"",r=q.match(n),s=d[a[1] ];r&&r==l?a=s(parseFloat(q),+a[2]):(q=this.asPX(b),
a=s(this.asPX(b),this.asPX(b,a[2]+l)));isNaN(q)||isNaN(a)||(e[b]=a,this.attr(e))}})(-10);k.on("snap.util.equal",function(a,b){var q=f(this.attr(a)||""),e=f(b).match(u);if(e){k.stop();var l=e[3]||"",r=q.match(n),s=d[e[1] ];if(r&&r==l)return{from:parseFloat(q),to:s(parseFloat(q),+e[2]),f:z(r)};q=this.asPX(a);return{from:q,to:s(q,this.asPX(a,e[2]+l)),f:w}}})(-10)});C.plugin(function(a,v,y,M,A){var w=y.prototype,z=a.is;w.rect=function(a,d,k,p,b,q){var e;null==q&&(q=b);z(a,"object")&&"[object Object]"==
a?e=a:null!=a&&(e={x:a,y:d,width:k,height:p},null!=b&&(e.rx=b,e.ry=q));return this.el("rect",e)};w.circle=function(a,d,k){var p;z(a,"object")&&"[object Object]"==a?p=a:null!=a&&(p={cx:a,cy:d,r:k});return this.el("circle",p)};var d=function(){function a(){this.parentNode.removeChild(this)}return function(d,k){var p=M.doc.createElement("img"),b=M.doc.body;p.style.cssText="position:absolute;left:-9999em;top:-9999em";p.onload=function(){k.call(p);p.onload=p.onerror=null;b.removeChild(p)};p.onerror=a;
b.appendChild(p);p.src=d}}();w.image=function(f,n,k,p,b){var q=this.el("image");if(z(f,"object")&&"src"in f)q.attr(f);else if(null!=f){var e={"xlink:href":f,preserveAspectRatio:"none"};null!=n&&null!=k&&(e.x=n,e.y=k);null!=p&&null!=b?(e.width=p,e.height=b):d(f,function(){a._.$(q.node,{width:this.offsetWidth,height:this.offsetHeight})});a._.$(q.node,e)}return q};w.ellipse=function(a,d,k,p){var b;z(a,"object")&&"[object Object]"==a?b=a:null!=a&&(b={cx:a,cy:d,rx:k,ry:p});return this.el("ellipse",b)};
w.path=function(a){var d;z(a,"object")&&!z(a,"array")?d=a:a&&(d={d:a});return this.el("path",d)};w.group=w.g=function(a){var d=this.el("g");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.svg=function(a,d,k,p,b,q,e,l){var r={};z(a,"object")&&null==d?r=a:(null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l]));return this.el("svg",r)};w.mask=function(a){var d=
this.el("mask");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.ptrn=function(a,d,k,p,b,q,e,l){if(z(a,"object"))var r=a;else arguments.length?(r={},null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l])):r={patternUnits:"userSpaceOnUse"};return this.el("pattern",r)};w.use=function(a){return null!=a?(make("use",this.node),a instanceof v&&(a.attr("id")||
a.attr({id:ID()}),a=a.attr("id")),this.el("use",{"xlink:href":a})):v.prototype.use.call(this)};w.text=function(a,d,k){var p={};z(a,"object")?p=a:null!=a&&(p={x:a,y:d,text:k||""});return this.el("text",p)};w.line=function(a,d,k,p){var b={};z(a,"object")?b=a:null!=a&&(b={x1:a,x2:k,y1:d,y2:p});return this.el("line",b)};w.polyline=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polyline",d)};
w.polygon=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polygon",d)};(function(){function d(){return this.selectAll("stop")}function n(b,d){var f=e("stop"),k={offset:+d+"%"};b=a.color(b);k["stop-color"]=b.hex;1>b.opacity&&(k["stop-opacity"]=b.opacity);e(f,k);this.node.appendChild(f);return this}function u(){if("linearGradient"==this.type){var b=e(this.node,"x1")||0,d=e(this.node,"x2")||
1,f=e(this.node,"y1")||0,k=e(this.node,"y2")||0;return a._.box(b,f,math.abs(d-b),math.abs(k-f))}b=this.node.r||0;return a._.box((this.node.cx||0.5)-b,(this.node.cy||0.5)-b,2*b,2*b)}function p(a,d){function f(a,b){for(var d=(b-u)/(a-w),e=w;e<a;e++)h[e].offset=+(+u+d*(e-w)).toFixed(2);w=a;u=b}var n=k("snap.util.grad.parse",null,d).firstDefined(),p;if(!n)return null;n.params.unshift(a);p="l"==n.type.toLowerCase()?b.apply(0,n.params):q.apply(0,n.params);n.type!=n.type.toLowerCase()&&e(p.node,{gradientUnits:"userSpaceOnUse"});
var h=n.stops,n=h.length,u=0,w=0;n--;for(var v=0;v<n;v++)"offset"in h[v]&&f(v,h[v].offset);h[n].offset=h[n].offset||100;f(n,h[n].offset);for(v=0;v<=n;v++){var y=h[v];p.addStop(y.color,y.offset)}return p}function b(b,k,p,q,w){b=a._.make("linearGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{x1:k,y1:p,x2:q,y2:w});return b}function q(b,k,p,q,w,h){b=a._.make("radialGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{cx:k,cy:p,r:q});null!=w&&null!=h&&e(b.node,{fx:w,fy:h});
return b}var e=a._.$;w.gradient=function(a){return p(this.defs,a)};w.gradientLinear=function(a,d,e,f){return b(this.defs,a,d,e,f)};w.gradientRadial=function(a,b,d,e,f){return q(this.defs,a,b,d,e,f)};w.toString=function(){var b=this.node.ownerDocument,d=b.createDocumentFragment(),b=b.createElement("div"),e=this.node.cloneNode(!0);d.appendChild(b);b.appendChild(e);a._.$(e,{xmlns:"http://www.w3.org/2000/svg"});b=b.innerHTML;d.removeChild(d.firstChild);return b};w.clear=function(){for(var a=this.node.firstChild,
b;a;)b=a.nextSibling,"defs"!=a.tagName?a.parentNode.removeChild(a):w.clear.call({node:a}),a=b}})()});C.plugin(function(a,k,y,M){function A(a){var b=A.ps=A.ps||{};b[a]?b[a].sleep=100:b[a]={sleep:100};setTimeout(function(){for(var d in b)b[L](d)&&d!=a&&(b[d].sleep--,!b[d].sleep&&delete b[d])});return b[a]}function w(a,b,d,e){null==a&&(a=b=d=e=0);null==b&&(b=a.y,d=a.width,e=a.height,a=a.x);return{x:a,y:b,width:d,w:d,height:e,h:e,x2:a+d,y2:b+e,cx:a+d/2,cy:b+e/2,r1:F.min(d,e)/2,r2:F.max(d,e)/2,r0:F.sqrt(d*
d+e*e)/2,path:s(a,b,d,e),vb:[a,b,d,e].join(" ")}}function z(){return this.join(",").replace(N,"$1")}function d(a){a=C(a);a.toString=z;return a}function f(a,b,d,h,f,k,l,n,p){if(null==p)return e(a,b,d,h,f,k,l,n);if(0>p||e(a,b,d,h,f,k,l,n)<p)p=void 0;else{var q=0.5,O=1-q,s;for(s=e(a,b,d,h,f,k,l,n,O);0.01<Z(s-p);)q/=2,O+=(s<p?1:-1)*q,s=e(a,b,d,h,f,k,l,n,O);p=O}return u(a,b,d,h,f,k,l,n,p)}function n(b,d){function e(a){return+(+a).toFixed(3)}return a._.cacher(function(a,h,l){a instanceof k&&(a=a.attr("d"));
a=I(a);for(var n,p,D,q,O="",s={},c=0,t=0,r=a.length;t<r;t++){D=a[t];if("M"==D[0])n=+D[1],p=+D[2];else{q=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6]);if(c+q>h){if(d&&!s.start){n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c);O+=["C"+e(n.start.x),e(n.start.y),e(n.m.x),e(n.m.y),e(n.x),e(n.y)];if(l)return O;s.start=O;O=["M"+e(n.x),e(n.y)+"C"+e(n.n.x),e(n.n.y),e(n.end.x),e(n.end.y),e(D[5]),e(D[6])].join();c+=q;n=+D[5];p=+D[6];continue}if(!b&&!d)return n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c)}c+=q;n=+D[5];p=+D[6]}O+=
D.shift()+D}s.end=O;return n=b?c:d?s:u(n,p,D[0],D[1],D[2],D[3],D[4],D[5],1)},null,a._.clone)}function u(a,b,d,e,h,f,k,l,n){var p=1-n,q=ma(p,3),s=ma(p,2),c=n*n,t=c*n,r=q*a+3*s*n*d+3*p*n*n*h+t*k,q=q*b+3*s*n*e+3*p*n*n*f+t*l,s=a+2*n*(d-a)+c*(h-2*d+a),t=b+2*n*(e-b)+c*(f-2*e+b),x=d+2*n*(h-d)+c*(k-2*h+d),c=e+2*n*(f-e)+c*(l-2*f+e);a=p*a+n*d;b=p*b+n*e;h=p*h+n*k;f=p*f+n*l;l=90-180*F.atan2(s-x,t-c)/S;return{x:r,y:q,m:{x:s,y:t},n:{x:x,y:c},start:{x:a,y:b},end:{x:h,y:f},alpha:l}}function p(b,d,e,h,f,n,k,l){a.is(b,
"array")||(b=[b,d,e,h,f,n,k,l]);b=U.apply(null,b);return w(b.min.x,b.min.y,b.max.x-b.min.x,b.max.y-b.min.y)}function b(a,b,d){return b>=a.x&&b<=a.x+a.width&&d>=a.y&&d<=a.y+a.height}function q(a,d){a=w(a);d=w(d);return b(d,a.x,a.y)||b(d,a.x2,a.y)||b(d,a.x,a.y2)||b(d,a.x2,a.y2)||b(a,d.x,d.y)||b(a,d.x2,d.y)||b(a,d.x,d.y2)||b(a,d.x2,d.y2)||(a.x<d.x2&&a.x>d.x||d.x<a.x2&&d.x>a.x)&&(a.y<d.y2&&a.y>d.y||d.y<a.y2&&d.y>a.y)}function e(a,b,d,e,h,f,n,k,l){null==l&&(l=1);l=(1<l?1:0>l?0:l)/2;for(var p=[-0.1252,
0.1252,-0.3678,0.3678,-0.5873,0.5873,-0.7699,0.7699,-0.9041,0.9041,-0.9816,0.9816],q=[0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],s=0,c=0;12>c;c++)var t=l*p[c]+l,r=t*(t*(-3*a+9*d-9*h+3*n)+6*a-12*d+6*h)-3*a+3*d,t=t*(t*(-3*b+9*e-9*f+3*k)+6*b-12*e+6*f)-3*b+3*e,s=s+q[c]*F.sqrt(r*r+t*t);return l*s}function l(a,b,d){a=I(a);b=I(b);for(var h,f,l,n,k,s,r,O,x,c,t=d?0:[],w=0,v=a.length;w<v;w++)if(x=a[w],"M"==x[0])h=k=x[1],f=s=x[2];else{"C"==x[0]?(x=[h,f].concat(x.slice(1)),
h=x[6],f=x[7]):(x=[h,f,h,f,k,s,k,s],h=k,f=s);for(var G=0,y=b.length;G<y;G++)if(c=b[G],"M"==c[0])l=r=c[1],n=O=c[2];else{"C"==c[0]?(c=[l,n].concat(c.slice(1)),l=c[6],n=c[7]):(c=[l,n,l,n,r,O,r,O],l=r,n=O);var z;var K=x,B=c;z=d;var H=p(K),J=p(B);if(q(H,J)){for(var H=e.apply(0,K),J=e.apply(0,B),H=~~(H/8),J=~~(J/8),U=[],A=[],F={},M=z?0:[],P=0;P<H+1;P++){var C=u.apply(0,K.concat(P/H));U.push({x:C.x,y:C.y,t:P/H})}for(P=0;P<J+1;P++)C=u.apply(0,B.concat(P/J)),A.push({x:C.x,y:C.y,t:P/J});for(P=0;P<H;P++)for(K=
0;K<J;K++){var Q=U[P],L=U[P+1],B=A[K],C=A[K+1],N=0.001>Z(L.x-Q.x)?"y":"x",S=0.001>Z(C.x-B.x)?"y":"x",R;R=Q.x;var Y=Q.y,V=L.x,ea=L.y,fa=B.x,ga=B.y,ha=C.x,ia=C.y;if(W(R,V)<X(fa,ha)||X(R,V)>W(fa,ha)||W(Y,ea)<X(ga,ia)||X(Y,ea)>W(ga,ia))R=void 0;else{var $=(R*ea-Y*V)*(fa-ha)-(R-V)*(fa*ia-ga*ha),aa=(R*ea-Y*V)*(ga-ia)-(Y-ea)*(fa*ia-ga*ha),ja=(R-V)*(ga-ia)-(Y-ea)*(fa-ha);if(ja){var $=$/ja,aa=aa/ja,ja=+$.toFixed(2),ba=+aa.toFixed(2);R=ja<+X(R,V).toFixed(2)||ja>+W(R,V).toFixed(2)||ja<+X(fa,ha).toFixed(2)||
ja>+W(fa,ha).toFixed(2)||ba<+X(Y,ea).toFixed(2)||ba>+W(Y,ea).toFixed(2)||ba<+X(ga,ia).toFixed(2)||ba>+W(ga,ia).toFixed(2)?void 0:{x:$,y:aa}}else R=void 0}R&&F[R.x.toFixed(4)]!=R.y.toFixed(4)&&(F[R.x.toFixed(4)]=R.y.toFixed(4),Q=Q.t+Z((R[N]-Q[N])/(L[N]-Q[N]))*(L.t-Q.t),B=B.t+Z((R[S]-B[S])/(C[S]-B[S]))*(C.t-B.t),0<=Q&&1>=Q&&0<=B&&1>=B&&(z?M++:M.push({x:R.x,y:R.y,t1:Q,t2:B})))}z=M}else z=z?0:[];if(d)t+=z;else{H=0;for(J=z.length;H<J;H++)z[H].segment1=w,z[H].segment2=G,z[H].bez1=x,z[H].bez2=c;t=t.concat(z)}}}return t}
function r(a){var b=A(a);if(b.bbox)return C(b.bbox);if(!a)return w();a=I(a);for(var d=0,e=0,h=[],f=[],l,n=0,k=a.length;n<k;n++)l=a[n],"M"==l[0]?(d=l[1],e=l[2],h.push(d),f.push(e)):(d=U(d,e,l[1],l[2],l[3],l[4],l[5],l[6]),h=h.concat(d.min.x,d.max.x),f=f.concat(d.min.y,d.max.y),d=l[5],e=l[6]);a=X.apply(0,h);l=X.apply(0,f);h=W.apply(0,h);f=W.apply(0,f);f=w(a,l,h-a,f-l);b.bbox=C(f);return f}function s(a,b,d,e,h){if(h)return[["M",+a+ +h,b],["l",d-2*h,0],["a",h,h,0,0,1,h,h],["l",0,e-2*h],["a",h,h,0,0,1,
-h,h],["l",2*h-d,0],["a",h,h,0,0,1,-h,-h],["l",0,2*h-e],["a",h,h,0,0,1,h,-h],["z"] ];a=[["M",a,b],["l",d,0],["l",0,e],["l",-d,0],["z"] ];a.toString=z;return a}function x(a,b,d,e,h){null==h&&null==e&&(e=d);a=+a;b=+b;d=+d;e=+e;if(null!=h){var f=Math.PI/180,l=a+d*Math.cos(-e*f);a+=d*Math.cos(-h*f);var n=b+d*Math.sin(-e*f);b+=d*Math.sin(-h*f);d=[["M",l,n],["A",d,d,0,+(180<h-e),0,a,b] ]}else d=[["M",a,b],["m",0,-e],["a",d,e,0,1,1,0,2*e],["a",d,e,0,1,1,0,-2*e],["z"] ];d.toString=z;return d}function G(b){var e=
A(b);if(e.abs)return d(e.abs);Q(b,"array")&&Q(b&&b[0],"array")||(b=a.parsePathString(b));if(!b||!b.length)return[["M",0,0] ];var h=[],f=0,l=0,n=0,k=0,p=0;"M"==b[0][0]&&(f=+b[0][1],l=+b[0][2],n=f,k=l,p++,h[0]=["M",f,l]);for(var q=3==b.length&&"M"==b[0][0]&&"R"==b[1][0].toUpperCase()&&"Z"==b[2][0].toUpperCase(),s,r,w=p,c=b.length;w<c;w++){h.push(s=[]);r=b[w];p=r[0];if(p!=p.toUpperCase())switch(s[0]=p.toUpperCase(),s[0]){case "A":s[1]=r[1];s[2]=r[2];s[3]=r[3];s[4]=r[4];s[5]=r[5];s[6]=+r[6]+f;s[7]=+r[7]+
l;break;case "V":s[1]=+r[1]+l;break;case "H":s[1]=+r[1]+f;break;case "R":for(var t=[f,l].concat(r.slice(1)),u=2,v=t.length;u<v;u++)t[u]=+t[u]+f,t[++u]=+t[u]+l;h.pop();h=h.concat(P(t,q));break;case "O":h.pop();t=x(f,l,r[1],r[2]);t.push(t[0]);h=h.concat(t);break;case "U":h.pop();h=h.concat(x(f,l,r[1],r[2],r[3]));s=["U"].concat(h[h.length-1].slice(-2));break;case "M":n=+r[1]+f,k=+r[2]+l;default:for(u=1,v=r.length;u<v;u++)s[u]=+r[u]+(u%2?f:l)}else if("R"==p)t=[f,l].concat(r.slice(1)),h.pop(),h=h.concat(P(t,
q)),s=["R"].concat(r.slice(-2));else if("O"==p)h.pop(),t=x(f,l,r[1],r[2]),t.push(t[0]),h=h.concat(t);else if("U"==p)h.pop(),h=h.concat(x(f,l,r[1],r[2],r[3])),s=["U"].concat(h[h.length-1].slice(-2));else for(t=0,u=r.length;t<u;t++)s[t]=r[t];p=p.toUpperCase();if("O"!=p)switch(s[0]){case "Z":f=+n;l=+k;break;case "H":f=s[1];break;case "V":l=s[1];break;case "M":n=s[s.length-2],k=s[s.length-1];default:f=s[s.length-2],l=s[s.length-1]}}h.toString=z;e.abs=d(h);return h}function h(a,b,d,e){return[a,b,d,e,d,
e]}function J(a,b,d,e,h,f){var l=1/3,n=2/3;return[l*a+n*d,l*b+n*e,l*h+n*d,l*f+n*e,h,f]}function K(b,d,e,h,f,l,n,k,p,s){var r=120*S/180,q=S/180*(+f||0),c=[],t,x=a._.cacher(function(a,b,c){var d=a*F.cos(c)-b*F.sin(c);a=a*F.sin(c)+b*F.cos(c);return{x:d,y:a}});if(s)v=s[0],t=s[1],l=s[2],u=s[3];else{t=x(b,d,-q);b=t.x;d=t.y;t=x(k,p,-q);k=t.x;p=t.y;F.cos(S/180*f);F.sin(S/180*f);t=(b-k)/2;v=(d-p)/2;u=t*t/(e*e)+v*v/(h*h);1<u&&(u=F.sqrt(u),e*=u,h*=u);var u=e*e,w=h*h,u=(l==n?-1:1)*F.sqrt(Z((u*w-u*v*v-w*t*t)/
(u*v*v+w*t*t)));l=u*e*v/h+(b+k)/2;var u=u*-h*t/e+(d+p)/2,v=F.asin(((d-u)/h).toFixed(9));t=F.asin(((p-u)/h).toFixed(9));v=b<l?S-v:v;t=k<l?S-t:t;0>v&&(v=2*S+v);0>t&&(t=2*S+t);n&&v>t&&(v-=2*S);!n&&t>v&&(t-=2*S)}if(Z(t-v)>r){var c=t,w=k,G=p;t=v+r*(n&&t>v?1:-1);k=l+e*F.cos(t);p=u+h*F.sin(t);c=K(k,p,e,h,f,0,n,w,G,[t,c,l,u])}l=t-v;f=F.cos(v);r=F.sin(v);n=F.cos(t);t=F.sin(t);l=F.tan(l/4);e=4/3*e*l;l*=4/3*h;h=[b,d];b=[b+e*r,d-l*f];d=[k+e*t,p-l*n];k=[k,p];b[0]=2*h[0]-b[0];b[1]=2*h[1]-b[1];if(s)return[b,d,k].concat(c);
c=[b,d,k].concat(c).join().split(",");s=[];k=0;for(p=c.length;k<p;k++)s[k]=k%2?x(c[k-1],c[k],q).y:x(c[k],c[k+1],q).x;return s}function U(a,b,d,e,h,f,l,k){for(var n=[],p=[[],[] ],s,r,c,t,q=0;2>q;++q)0==q?(r=6*a-12*d+6*h,s=-3*a+9*d-9*h+3*l,c=3*d-3*a):(r=6*b-12*e+6*f,s=-3*b+9*e-9*f+3*k,c=3*e-3*b),1E-12>Z(s)?1E-12>Z(r)||(s=-c/r,0<s&&1>s&&n.push(s)):(t=r*r-4*c*s,c=F.sqrt(t),0>t||(t=(-r+c)/(2*s),0<t&&1>t&&n.push(t),s=(-r-c)/(2*s),0<s&&1>s&&n.push(s)));for(r=q=n.length;q--;)s=n[q],c=1-s,p[0][q]=c*c*c*a+3*
c*c*s*d+3*c*s*s*h+s*s*s*l,p[1][q]=c*c*c*b+3*c*c*s*e+3*c*s*s*f+s*s*s*k;p[0][r]=a;p[1][r]=b;p[0][r+1]=l;p[1][r+1]=k;p[0].length=p[1].length=r+2;return{min:{x:X.apply(0,p[0]),y:X.apply(0,p[1])},max:{x:W.apply(0,p[0]),y:W.apply(0,p[1])}}}function I(a,b){var e=!b&&A(a);if(!b&&e.curve)return d(e.curve);var f=G(a),l=b&&G(b),n={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},k={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},p=function(a,b,c){if(!a)return["C",b.x,b.y,b.x,b.y,b.x,b.y];a[0]in{T:1,Q:1}||(b.qx=b.qy=null);
switch(a[0]){case "M":b.X=a[1];b.Y=a[2];break;case "A":a=["C"].concat(K.apply(0,[b.x,b.y].concat(a.slice(1))));break;case "S":"C"==c||"S"==c?(c=2*b.x-b.bx,b=2*b.y-b.by):(c=b.x,b=b.y);a=["C",c,b].concat(a.slice(1));break;case "T":"Q"==c||"T"==c?(b.qx=2*b.x-b.qx,b.qy=2*b.y-b.qy):(b.qx=b.x,b.qy=b.y);a=["C"].concat(J(b.x,b.y,b.qx,b.qy,a[1],a[2]));break;case "Q":b.qx=a[1];b.qy=a[2];a=["C"].concat(J(b.x,b.y,a[1],a[2],a[3],a[4]));break;case "L":a=["C"].concat(h(b.x,b.y,a[1],a[2]));break;case "H":a=["C"].concat(h(b.x,
b.y,a[1],b.y));break;case "V":a=["C"].concat(h(b.x,b.y,b.x,a[1]));break;case "Z":a=["C"].concat(h(b.x,b.y,b.X,b.Y))}return a},s=function(a,b){if(7<a[b].length){a[b].shift();for(var c=a[b];c.length;)q[b]="A",l&&(u[b]="A"),a.splice(b++,0,["C"].concat(c.splice(0,6)));a.splice(b,1);v=W(f.length,l&&l.length||0)}},r=function(a,b,c,d,e){a&&b&&"M"==a[e][0]&&"M"!=b[e][0]&&(b.splice(e,0,["M",d.x,d.y]),c.bx=0,c.by=0,c.x=a[e][1],c.y=a[e][2],v=W(f.length,l&&l.length||0))},q=[],u=[],c="",t="",x=0,v=W(f.length,
l&&l.length||0);for(;x<v;x++){f[x]&&(c=f[x][0]);"C"!=c&&(q[x]=c,x&&(t=q[x-1]));f[x]=p(f[x],n,t);"A"!=q[x]&&"C"==c&&(q[x]="C");s(f,x);l&&(l[x]&&(c=l[x][0]),"C"!=c&&(u[x]=c,x&&(t=u[x-1])),l[x]=p(l[x],k,t),"A"!=u[x]&&"C"==c&&(u[x]="C"),s(l,x));r(f,l,n,k,x);r(l,f,k,n,x);var w=f[x],z=l&&l[x],y=w.length,U=l&&z.length;n.x=w[y-2];n.y=w[y-1];n.bx=$(w[y-4])||n.x;n.by=$(w[y-3])||n.y;k.bx=l&&($(z[U-4])||k.x);k.by=l&&($(z[U-3])||k.y);k.x=l&&z[U-2];k.y=l&&z[U-1]}l||(e.curve=d(f));return l?[f,l]:f}function P(a,
b){for(var d=[],e=0,h=a.length;h-2*!b>e;e+=2){var f=[{x:+a[e-2],y:+a[e-1]},{x:+a[e],y:+a[e+1]},{x:+a[e+2],y:+a[e+3]},{x:+a[e+4],y:+a[e+5]}];b?e?h-4==e?f[3]={x:+a[0],y:+a[1]}:h-2==e&&(f[2]={x:+a[0],y:+a[1]},f[3]={x:+a[2],y:+a[3]}):f[0]={x:+a[h-2],y:+a[h-1]}:h-4==e?f[3]=f[2]:e||(f[0]={x:+a[e],y:+a[e+1]});d.push(["C",(-f[0].x+6*f[1].x+f[2].x)/6,(-f[0].y+6*f[1].y+f[2].y)/6,(f[1].x+6*f[2].x-f[3].x)/6,(f[1].y+6*f[2].y-f[3].y)/6,f[2].x,f[2].y])}return d}y=k.prototype;var Q=a.is,C=a._.clone,L="hasOwnProperty",
N=/,?([a-z]),?/gi,$=parseFloat,F=Math,S=F.PI,X=F.min,W=F.max,ma=F.pow,Z=F.abs;M=n(1);var na=n(),ba=n(0,1),V=a._unit2px;a.path=A;a.path.getTotalLength=M;a.path.getPointAtLength=na;a.path.getSubpath=function(a,b,d){if(1E-6>this.getTotalLength(a)-d)return ba(a,b).end;a=ba(a,d,1);return b?ba(a,b).end:a};y.getTotalLength=function(){if(this.node.getTotalLength)return this.node.getTotalLength()};y.getPointAtLength=function(a){return na(this.attr("d"),a)};y.getSubpath=function(b,d){return a.path.getSubpath(this.attr("d"),
b,d)};a._.box=w;a.path.findDotsAtSegment=u;a.path.bezierBBox=p;a.path.isPointInsideBBox=b;a.path.isBBoxIntersect=q;a.path.intersection=function(a,b){return l(a,b)};a.path.intersectionNumber=function(a,b){return l(a,b,1)};a.path.isPointInside=function(a,d,e){var h=r(a);return b(h,d,e)&&1==l(a,[["M",d,e],["H",h.x2+10] ],1)%2};a.path.getBBox=r;a.path.get={path:function(a){return a.attr("path")},circle:function(a){a=V(a);return x(a.cx,a.cy,a.r)},ellipse:function(a){a=V(a);return x(a.cx||0,a.cy||0,a.rx,
a.ry)},rect:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height,a.rx,a.ry)},image:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height)},line:function(a){return"M"+[a.attr("x1")||0,a.attr("y1")||0,a.attr("x2"),a.attr("y2")]},polyline:function(a){return"M"+a.attr("points")},polygon:function(a){return"M"+a.attr("points")+"z"},deflt:function(a){a=a.node.getBBox();return s(a.x,a.y,a.width,a.height)}};a.path.toRelative=function(b){var e=A(b),h=String.prototype.toLowerCase;if(e.rel)return d(e.rel);
a.is(b,"array")&&a.is(b&&b[0],"array")||(b=a.parsePathString(b));var f=[],l=0,n=0,k=0,p=0,s=0;"M"==b[0][0]&&(l=b[0][1],n=b[0][2],k=l,p=n,s++,f.push(["M",l,n]));for(var r=b.length;s<r;s++){var q=f[s]=[],x=b[s];if(x[0]!=h.call(x[0]))switch(q[0]=h.call(x[0]),q[0]){case "a":q[1]=x[1];q[2]=x[2];q[3]=x[3];q[4]=x[4];q[5]=x[5];q[6]=+(x[6]-l).toFixed(3);q[7]=+(x[7]-n).toFixed(3);break;case "v":q[1]=+(x[1]-n).toFixed(3);break;case "m":k=x[1],p=x[2];default:for(var c=1,t=x.length;c<t;c++)q[c]=+(x[c]-(c%2?l:
n)).toFixed(3)}else for(f[s]=[],"m"==x[0]&&(k=x[1]+l,p=x[2]+n),q=0,c=x.length;q<c;q++)f[s][q]=x[q];x=f[s].length;switch(f[s][0]){case "z":l=k;n=p;break;case "h":l+=+f[s][x-1];break;case "v":n+=+f[s][x-1];break;default:l+=+f[s][x-2],n+=+f[s][x-1]}}f.toString=z;e.rel=d(f);return f};a.path.toAbsolute=G;a.path.toCubic=I;a.path.map=function(a,b){if(!b)return a;var d,e,h,f,l,n,k;a=I(a);h=0;for(l=a.length;h<l;h++)for(k=a[h],f=1,n=k.length;f<n;f+=2)d=b.x(k[f],k[f+1]),e=b.y(k[f],k[f+1]),k[f]=d,k[f+1]=e;return a};
a.path.toString=z;a.path.clone=d});C.plugin(function(a,v,y,C){var A=Math.max,w=Math.min,z=function(a){this.items=[];this.bindings={};this.length=0;this.type="set";if(a)for(var f=0,n=a.length;f<n;f++)a[f]&&(this[this.items.length]=this.items[this.items.length]=a[f],this.length++)};v=z.prototype;v.push=function(){for(var a,f,n=0,k=arguments.length;n<k;n++)if(a=arguments[n])f=this.items.length,this[f]=this.items[f]=a,this.length++;return this};v.pop=function(){this.length&&delete this[this.length--];
return this.items.pop()};v.forEach=function(a,f){for(var n=0,k=this.items.length;n<k&&!1!==a.call(f,this.items[n],n);n++);return this};v.animate=function(d,f,n,u){"function"!=typeof n||n.length||(u=n,n=L.linear);d instanceof a._.Animation&&(u=d.callback,n=d.easing,f=n.dur,d=d.attr);var p=arguments;if(a.is(d,"array")&&a.is(p[p.length-1],"array"))var b=!0;var q,e=function(){q?this.b=q:q=this.b},l=0,r=u&&function(){l++==this.length&&u.call(this)};return this.forEach(function(a,l){k.once("snap.animcreated."+
a.id,e);b?p[l]&&a.animate.apply(a,p[l]):a.animate(d,f,n,r)})};v.remove=function(){for(;this.length;)this.pop().remove();return this};v.bind=function(a,f,k){var u={};if("function"==typeof f)this.bindings[a]=f;else{var p=k||a;this.bindings[a]=function(a){u[p]=a;f.attr(u)}}return this};v.attr=function(a){var f={},k;for(k in a)if(this.bindings[k])this.bindings[k](a[k]);else f[k]=a[k];a=0;for(k=this.items.length;a<k;a++)this.items[a].attr(f);return this};v.clear=function(){for(;this.length;)this.pop()};
v.splice=function(a,f,k){a=0>a?A(this.length+a,0):a;f=A(0,w(this.length-a,f));var u=[],p=[],b=[],q;for(q=2;q<arguments.length;q++)b.push(arguments[q]);for(q=0;q<f;q++)p.push(this[a+q]);for(;q<this.length-a;q++)u.push(this[a+q]);var e=b.length;for(q=0;q<e+u.length;q++)this.items[a+q]=this[a+q]=q<e?b[q]:u[q-e];for(q=this.items.length=this.length-=f-e;this[q];)delete this[q++];return new z(p)};v.exclude=function(a){for(var f=0,k=this.length;f<k;f++)if(this[f]==a)return this.splice(f,1),!0;return!1};
v.insertAfter=function(a){for(var f=this.items.length;f--;)this.items[f].insertAfter(a);return this};v.getBBox=function(){for(var a=[],f=[],k=[],u=[],p=this.items.length;p--;)if(!this.items[p].removed){var b=this.items[p].getBBox();a.push(b.x);f.push(b.y);k.push(b.x+b.width);u.push(b.y+b.height)}a=w.apply(0,a);f=w.apply(0,f);k=A.apply(0,k);u=A.apply(0,u);return{x:a,y:f,x2:k,y2:u,width:k-a,height:u-f,cx:a+(k-a)/2,cy:f+(u-f)/2}};v.clone=function(a){a=new z;for(var f=0,k=this.items.length;f<k;f++)a.push(this.items[f].clone());
return a};v.toString=function(){return"Snap\u2018s set"};v.type="set";a.set=function(){var a=new z;arguments.length&&a.push.apply(a,Array.prototype.slice.call(arguments,0));return a}});C.plugin(function(a,v,y,C){function A(a){var b=a[0];switch(b.toLowerCase()){case "t":return[b,0,0];case "m":return[b,1,0,0,1,0,0];case "r":return 4==a.length?[b,0,a[2],a[3] ]:[b,0];case "s":return 5==a.length?[b,1,1,a[3],a[4] ]:3==a.length?[b,1,1]:[b,1]}}function w(b,d,f){d=q(d).replace(/\.{3}|\u2026/g,b);b=a.parseTransformString(b)||
[];d=a.parseTransformString(d)||[];for(var k=Math.max(b.length,d.length),p=[],v=[],h=0,w,z,y,I;h<k;h++){y=b[h]||A(d[h]);I=d[h]||A(y);if(y[0]!=I[0]||"r"==y[0].toLowerCase()&&(y[2]!=I[2]||y[3]!=I[3])||"s"==y[0].toLowerCase()&&(y[3]!=I[3]||y[4]!=I[4])){b=a._.transform2matrix(b,f());d=a._.transform2matrix(d,f());p=[["m",b.a,b.b,b.c,b.d,b.e,b.f] ];v=[["m",d.a,d.b,d.c,d.d,d.e,d.f] ];break}p[h]=[];v[h]=[];w=0;for(z=Math.max(y.length,I.length);w<z;w++)w in y&&(p[h][w]=y[w]),w in I&&(v[h][w]=I[w])}return{from:u(p),
to:u(v),f:n(p)}}function z(a){return a}function d(a){return function(b){return+b.toFixed(3)+a}}function f(b){return a.rgb(b[0],b[1],b[2])}function n(a){var b=0,d,f,k,n,h,p,q=[];d=0;for(f=a.length;d<f;d++){h="[";p=['"'+a[d][0]+'"'];k=1;for(n=a[d].length;k<n;k++)p[k]="val["+b++ +"]";h+=p+"]";q[d]=h}return Function("val","return Snap.path.toString.call(["+q+"])")}function u(a){for(var b=[],d=0,f=a.length;d<f;d++)for(var k=1,n=a[d].length;k<n;k++)b.push(a[d][k]);return b}var p={},b=/[a-z]+$/i,q=String;
p.stroke=p.fill="colour";v.prototype.equal=function(a,b){return k("snap.util.equal",this,a,b).firstDefined()};k.on("snap.util.equal",function(e,k){var r,s;r=q(this.attr(e)||"");var x=this;if(r==+r&&k==+k)return{from:+r,to:+k,f:z};if("colour"==p[e])return r=a.color(r),s=a.color(k),{from:[r.r,r.g,r.b,r.opacity],to:[s.r,s.g,s.b,s.opacity],f:f};if("transform"==e||"gradientTransform"==e||"patternTransform"==e)return k instanceof a.Matrix&&(k=k.toTransformString()),a._.rgTransform.test(k)||(k=a._.svgTransform2string(k)),
w(r,k,function(){return x.getBBox(1)});if("d"==e||"path"==e)return r=a.path.toCubic(r,k),{from:u(r[0]),to:u(r[1]),f:n(r[0])};if("points"==e)return r=q(r).split(a._.separator),s=q(k).split(a._.separator),{from:r,to:s,f:function(a){return a}};aUnit=r.match(b);s=q(k).match(b);return aUnit&&aUnit==s?{from:parseFloat(r),to:parseFloat(k),f:d(aUnit)}:{from:this.asPX(e),to:this.asPX(e,k),f:z}})});C.plugin(function(a,v,y,C){var A=v.prototype,w="createTouch"in C.doc;v="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel".split(" ");
var z={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},d=function(a,b){var d="y"==a?"scrollTop":"scrollLeft",e=b&&b.node?b.node.ownerDocument:C.doc;return e[d in e.documentElement?"documentElement":"body"][d]},f=function(){this.returnValue=!1},n=function(){return this.originalEvent.preventDefault()},u=function(){this.cancelBubble=!0},p=function(){return this.originalEvent.stopPropagation()},b=function(){if(C.doc.addEventListener)return function(a,b,e,f){var k=w&&z[b]?z[b]:b,l=function(k){var l=
d("y",f),q=d("x",f);if(w&&z.hasOwnProperty(b))for(var r=0,u=k.targetTouches&&k.targetTouches.length;r<u;r++)if(k.targetTouches[r].target==a||a.contains(k.targetTouches[r].target)){u=k;k=k.targetTouches[r];k.originalEvent=u;k.preventDefault=n;k.stopPropagation=p;break}return e.call(f,k,k.clientX+q,k.clientY+l)};b!==k&&a.addEventListener(b,l,!1);a.addEventListener(k,l,!1);return function(){b!==k&&a.removeEventListener(b,l,!1);a.removeEventListener(k,l,!1);return!0}};if(C.doc.attachEvent)return function(a,
b,e,h){var k=function(a){a=a||h.node.ownerDocument.window.event;var b=d("y",h),k=d("x",h),k=a.clientX+k,b=a.clientY+b;a.preventDefault=a.preventDefault||f;a.stopPropagation=a.stopPropagation||u;return e.call(h,a,k,b)};a.attachEvent("on"+b,k);return function(){a.detachEvent("on"+b,k);return!0}}}(),q=[],e=function(a){for(var b=a.clientX,e=a.clientY,f=d("y"),l=d("x"),n,p=q.length;p--;){n=q[p];if(w)for(var r=a.touches&&a.touches.length,u;r--;){if(u=a.touches[r],u.identifier==n.el._drag.id||n.el.node.contains(u.target)){b=
u.clientX;e=u.clientY;(a.originalEvent?a.originalEvent:a).preventDefault();break}}else a.preventDefault();b+=l;e+=f;k("snap.drag.move."+n.el.id,n.move_scope||n.el,b-n.el._drag.x,e-n.el._drag.y,b,e,a)}},l=function(b){a.unmousemove(e).unmouseup(l);for(var d=q.length,f;d--;)f=q[d],f.el._drag={},k("snap.drag.end."+f.el.id,f.end_scope||f.start_scope||f.move_scope||f.el,b);q=[]};for(y=v.length;y--;)(function(d){a[d]=A[d]=function(e,f){a.is(e,"function")&&(this.events=this.events||[],this.events.push({name:d,
f:e,unbind:b(this.node||document,d,e,f||this)}));return this};a["un"+d]=A["un"+d]=function(a){for(var b=this.events||[],e=b.length;e--;)if(b[e].name==d&&(b[e].f==a||!a)){b[e].unbind();b.splice(e,1);!b.length&&delete this.events;break}return this}})(v[y]);A.hover=function(a,b,d,e){return this.mouseover(a,d).mouseout(b,e||d)};A.unhover=function(a,b){return this.unmouseover(a).unmouseout(b)};var r=[];A.drag=function(b,d,f,h,n,p){function u(r,v,w){(r.originalEvent||r).preventDefault();this._drag.x=v;
this._drag.y=w;this._drag.id=r.identifier;!q.length&&a.mousemove(e).mouseup(l);q.push({el:this,move_scope:h,start_scope:n,end_scope:p});d&&k.on("snap.drag.start."+this.id,d);b&&k.on("snap.drag.move."+this.id,b);f&&k.on("snap.drag.end."+this.id,f);k("snap.drag.start."+this.id,n||h||this,v,w,r)}if(!arguments.length){var v;return this.drag(function(a,b){this.attr({transform:v+(v?"T":"t")+[a,b]})},function(){v=this.transform().local})}this._drag={};r.push({el:this,start:u});this.mousedown(u);return this};
A.undrag=function(){for(var b=r.length;b--;)r[b].el==this&&(this.unmousedown(r[b].start),r.splice(b,1),k.unbind("snap.drag.*."+this.id));!r.length&&a.unmousemove(e).unmouseup(l);return this}});C.plugin(function(a,v,y,C){y=y.prototype;var A=/^\s*url\((.+)\)/,w=String,z=a._.$;a.filter={};y.filter=function(d){var f=this;"svg"!=f.type&&(f=f.paper);d=a.parse(w(d));var k=a._.id(),u=z("filter");z(u,{id:k,filterUnits:"userSpaceOnUse"});u.appendChild(d.node);f.defs.appendChild(u);return new v(u)};k.on("snap.util.getattr.filter",
function(){k.stop();var d=z(this.node,"filter");if(d)return(d=w(d).match(A))&&a.select(d[1])});k.on("snap.util.attr.filter",function(d){if(d instanceof v&&"filter"==d.type){k.stop();var f=d.node.id;f||(z(d.node,{id:d.id}),f=d.id);z(this.node,{filter:a.url(f)})}d&&"none"!=d||(k.stop(),this.node.removeAttribute("filter"))});a.filter.blur=function(d,f){null==d&&(d=2);return a.format('<feGaussianBlur stdDeviation="{def}"/>',{def:null==f?d:[d,f]})};a.filter.blur.toString=function(){return this()};a.filter.shadow=
function(d,f,k,u,p){"string"==typeof k&&(p=u=k,k=4);"string"!=typeof u&&(p=u,u="#000");null==k&&(k=4);null==p&&(p=1);null==d&&(d=0,f=2);null==f&&(f=d);u=a.color(u||"#000");return a.format('<feGaussianBlur in="SourceAlpha" stdDeviation="{blur}"/><feOffset dx="{dx}" dy="{dy}" result="offsetblur"/><feFlood flood-color="{color}"/><feComposite in2="offsetblur" operator="in"/><feComponentTransfer><feFuncA type="linear" slope="{opacity}"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>',
{color:u,dx:d,dy:f,blur:k,opacity:p})};a.filter.shadow.toString=function(){return this()};a.filter.grayscale=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {b} {h} 0 0 0 0 0 1 0"/>',{a:0.2126+0.7874*(1-d),b:0.7152-0.7152*(1-d),c:0.0722-0.0722*(1-d),d:0.2126-0.2126*(1-d),e:0.7152+0.2848*(1-d),f:0.0722-0.0722*(1-d),g:0.2126-0.2126*(1-d),h:0.0722+0.9278*(1-d)})};a.filter.grayscale.toString=function(){return this()};a.filter.sepia=
function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {h} {i} 0 0 0 0 0 1 0"/>',{a:0.393+0.607*(1-d),b:0.769-0.769*(1-d),c:0.189-0.189*(1-d),d:0.349-0.349*(1-d),e:0.686+0.314*(1-d),f:0.168-0.168*(1-d),g:0.272-0.272*(1-d),h:0.534-0.534*(1-d),i:0.131+0.869*(1-d)})};a.filter.sepia.toString=function(){return this()};a.filter.saturate=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="saturate" values="{amount}"/>',{amount:1-
d})};a.filter.saturate.toString=function(){return this()};a.filter.hueRotate=function(d){return a.format('<feColorMatrix type="hueRotate" values="{angle}"/>',{angle:d||0})};a.filter.hueRotate.toString=function(){return this()};a.filter.invert=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="table" tableValues="{amount} {amount2}"/><feFuncG type="table" tableValues="{amount} {amount2}"/><feFuncB type="table" tableValues="{amount} {amount2}"/></feComponentTransfer>',{amount:d,
amount2:1-d})};a.filter.invert.toString=function(){return this()};a.filter.brightness=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}"/><feFuncG type="linear" slope="{amount}"/><feFuncB type="linear" slope="{amount}"/></feComponentTransfer>',{amount:d})};a.filter.brightness.toString=function(){return this()};a.filter.contrast=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}" intercept="{amount2}"/><feFuncG type="linear" slope="{amount}" intercept="{amount2}"/><feFuncB type="linear" slope="{amount}" intercept="{amount2}"/></feComponentTransfer>',
{amount:d,amount2:0.5-d/2})};a.filter.contrast.toString=function(){return this()}});return C});

]]> </script>
<script> <![CDATA[

(function (glob, factory) {
    // AMD support
    if (typeof define === "function" && define.amd) {
        // Define as an anonymous module
        define("Gadfly", ["Snap.svg"], function (Snap) {
            return factory(Snap);
        });
    } else {
        // Browser globals (glob is window)
        // Snap adds itself to window
        glob.Gadfly = factory(glob.Snap);
    }
}(this, function (Snap) {

var Gadfly = {};

// Get an x/y coordinate value in pixels
var xPX = function(fig, x) {
    var client_box = fig.node.getBoundingClientRect();
    return x * fig.node.viewBox.baseVal.width / client_box.width;
};

var yPX = function(fig, y) {
    var client_box = fig.node.getBoundingClientRect();
    return y * fig.node.viewBox.baseVal.height / client_box.height;
};


Snap.plugin(function (Snap, Element, Paper, global) {
    // Traverse upwards from a snap element to find and return the first
    // note with the "plotroot" class.
    Element.prototype.plotroot = function () {
        var element = this;
        while (!element.hasClass("plotroot") && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.svgroot = function () {
        var element = this;
        while (element.node.nodeName != "svg" && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.plotbounds = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x0: bbox.x,
            x1: bbox.x + bbox.width,
            y0: bbox.y,
            y1: bbox.y + bbox.height
        };
    };

    Element.prototype.plotcenter = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x: bbox.x + bbox.width / 2,
            y: bbox.y + bbox.height / 2
        };
    };

    // Emulate IE style mouseenter/mouseleave events, since Microsoft always
    // does everything right.
    // See: http://www.dynamic-tools.net/toolbox/isMouseLeaveOrEnter/
    var events = ["mouseenter", "mouseleave"];

    for (i in events) {
        (function (event_name) {
            var event_name = events[i];
            Element.prototype[event_name] = function (fn, scope) {
                if (Snap.is(fn, "function")) {
                    var fn2 = function (event) {
                        if (event.type != "mouseover" && event.type != "mouseout") {
                            return;
                        }

                        var reltg = event.relatedTarget ? event.relatedTarget :
                            event.type == "mouseout" ? event.toElement : event.fromElement;
                        while (reltg && reltg != this.node) reltg = reltg.parentNode;

                        if (reltg != this.node) {
                            return fn.apply(this, event);
                        }
                    };

                    if (event_name == "mouseenter") {
                        this.mouseover(fn2, scope);
                    } else {
                        this.mouseout(fn2, scope);
                    }
                }
                return this;
            };
        })(events[i]);
    }


    Element.prototype.mousewheel = function (fn, scope) {
        if (Snap.is(fn, "function")) {
            var el = this;
            var fn2 = function (event) {
                fn.apply(el, [event]);
            };
        }

        this.node.addEventListener(
            /Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel",
            fn2);

        return this;
    };


    // Snap's attr function can be too slow for things like panning/zooming.
    // This is a function to directly update element attributes without going
    // through eve.
    Element.prototype.attribute = function(key, val) {
        if (val === undefined) {
            return this.node.getAttribute(key);
        } else {
            this.node.setAttribute(key, val);
            return this;
        }
    };

    Element.prototype.init_gadfly = function() {
        this.mouseenter(Gadfly.plot_mouseover)
            .mousemove(Gadfly.plot_mousemove)
            .mouseleave(Gadfly.plot_mouseout)
            .dblclick(Gadfly.plot_dblclick)
            .mousewheel(Gadfly.guide_background_scroll)
            .drag(Gadfly.guide_background_drag_onmove,
                  Gadfly.guide_background_drag_onstart,
                  Gadfly.guide_background_drag_onend);
        this.mouseenter(function (event) {
            init_pan_zoom(this.plotroot());
        });
        return this;
    };
});


Gadfly.plot_mousemove = function(event, x_px, y_px) {
    var root = this.plotroot();
    if (root.data("crosshair")) {
        px_per_mm = root.data("px_per_mm");
        bB = root.select('boundingbox').node.getAttribute('value').split(' ');
        uB = root.select('unitbox').node.getAttribute('value').split(' ');
        xscale = root.data("xscale");
        yscale = root.data("yscale");
        xtranslate = root.data("tx");
        ytranslate = root.data("ty");

        xoff_mm = bB[0].substr(0,bB[0].length-2)/1;
        yoff_mm = bB[1].substr(0,bB[1].length-2)/1;
        xoff_unit = uB[0]/1;
        yoff_unit = uB[1]/1;
        mm_per_xunit = bB[2].substr(0,bB[2].length-2) / uB[2];
        mm_per_yunit = bB[3].substr(0,bB[3].length-2) / uB[3];

        x_unit = ((x_px / px_per_mm - xtranslate) / xscale - xoff_mm) / mm_per_xunit + xoff_unit;
        y_unit = ((y_px / px_per_mm - ytranslate) / yscale - yoff_mm) / mm_per_yunit + yoff_unit;

        root.select('.crosshair').select('.primitive').select('text')
                .node.innerHTML = x_unit.toPrecision(3)+","+y_unit.toPrecision(3);
    };
};

Gadfly.helpscreen_visible = function(event) {
    helpscreen_visible(this.plotroot());
};
var helpscreen_visible = function(root) {
    root.select(".helpscreen").animate({opacity: 1.0}, 250);
};

Gadfly.helpscreen_hidden = function(event) {
    helpscreen_hidden(this.plotroot());
};
var helpscreen_hidden = function(root) {
    root.select(".helpscreen").animate({opacity: 0.0}, 250);
};

// When the plot is moused over, emphasize the grid lines.
Gadfly.plot_mouseover = function(event) {
    var root = this.plotroot();

    var keyboard_help = function(event) {
        if (event.which == 191) { // ?
            helpscreen_visible(root);
        }
    };
    root.data("keyboard_help", keyboard_help);
    window.addEventListener("keydown", keyboard_help);

    var keyboard_pan_zoom = function(event) {
        var bounds = root.plotbounds(),
            width = bounds.x1 - bounds.x0;
            height = bounds.y1 - bounds.y0;
        if (event.which == 187 || event.which == 73) { // plus or i
            increase_zoom_by_position(root, 0.1, true);
        } else if (event.which == 189 || event.which == 79) { // minus or o
            increase_zoom_by_position(root, -0.1, true);
        } else if (event.which == 39 || event.which == 76) { // right-arrow or l
            set_plot_pan_zoom(root, root.data("tx")-width/10, root.data("ty"),
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 40 || event.which == 74) { // down-arrow or j
            set_plot_pan_zoom(root, root.data("tx"), root.data("ty")-height/10,
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 37 || event.which == 72) { // left-arrow or h
            set_plot_pan_zoom(root, root.data("tx")+width/10, root.data("ty"),
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 38 || event.which == 75) { // up-arrow or k
            set_plot_pan_zoom(root, root.data("tx"), root.data("ty")+height/10,
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 82) { // r
            set_plot_pan_zoom(root, 0.0, 0.0, 1.0, 1.0);
        } else if (event.which == 191) { // ?
            helpscreen_hidden(root);
        } else if (event.which == 67) { // c
            root.data("crosshair",!root.data("crosshair"));
            root.select(".crosshair")
                .animate({opacity: root.data("crosshair") ? 1.0 : 0.0}, 250);
        }
    };
    root.data("keyboard_pan_zoom", keyboard_pan_zoom);
    window.addEventListener("keyup", keyboard_pan_zoom);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    if (xgridlines) {
        xgridlines.data("unfocused_strokedash",
                        xgridlines.attribute("stroke-dasharray").replace(/(\d)(,|$)/g, "$1mm$2"));
        var destcolor = root.data("focused_xgrid_color");
        xgridlines.attribute("stroke-dasharray", "none")
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    if (ygridlines) {
        ygridlines.data("unfocused_strokedash",
                        ygridlines.attribute("stroke-dasharray").replace(/(\d)(,|$)/g, "$1mm$2"));
        var destcolor = root.data("focused_ygrid_color");
        ygridlines.attribute("stroke-dasharray", "none")
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    root.select(".crosshair")
        .animate({opacity: root.data("crosshair") ? 1.0 : 0.0}, 250);
    root.select(".questionmark").animate({opacity: 1.0}, 250);
};

// Reset pan and zoom on double click
Gadfly.plot_dblclick = function(event) {
  set_plot_pan_zoom(this.plotroot(), 0.0, 0.0, 1.0, 1.0);
};

// Unemphasize grid lines on mouse out.
Gadfly.plot_mouseout = function(event) {
    var root = this.plotroot();

    window.removeEventListener("keyup", root.data("keyboard_pan_zoom"));
    root.data("keyboard_pan_zoom", undefined);
    window.removeEventListener("keydown", root.data("keyboard_help"));
    root.data("keyboard_help", undefined);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    if (xgridlines) {
        var destcolor = root.data("unfocused_xgrid_color");
        xgridlines.attribute("stroke-dasharray", xgridlines.data("unfocused_strokedash"))
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    if (ygridlines) {
        var destcolor = root.data("unfocused_ygrid_color");
        ygridlines.attribute("stroke-dasharray", ygridlines.data("unfocused_strokedash"))
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    root.select(".crosshair").animate({opacity: 0.0}, 250);
    root.select(".questionmark").animate({opacity: 0.0}, 250);
    helpscreen_hidden(root);
};


var set_geometry_transform = function(root, tx, ty, xscale, yscale) {
    var xscalable = root.hasClass("xscalable"),
        yscalable = root.hasClass("yscalable");

    var old_xscale = root.data("xscale"),
        old_yscale = root.data("yscale");

    var xscale = xscalable ? xscale : 1.0,
        yscale = yscalable ? yscale : 1.0;

    tx = xscalable ? tx : 0.0;
    ty = yscalable ? ty : 0.0;

    var t = new Snap.Matrix().translate(tx, ty).scale(xscale, yscale);
    root.selectAll(".geometry, image").forEach(function (element, i) {
            element.transform(t);
        });

    var t = new Snap.Matrix().scale(1.0/xscale, 1.0/yscale);
    root.selectAll('.marker').forEach(function (element, i) {
        element.selectAll('.primitive').forEach(function (element, i) {
            element.transform(t);
        }) });

    bounds = root.plotbounds();
    px_per_mm = root.data("px_per_mm");

    if (yscalable) {
        var xfixed_t = new Snap.Matrix().translate(0, ty).scale(1.0, yscale);
        root.selectAll(".xfixed")
            .forEach(function (element, i) {
                element.transform(xfixed_t);
            });

        ylabels = root.select(".ylabels");
        if (ylabels) {
            ylabels.transform(xfixed_t)
                   .selectAll("g")
                   .forEach(function (element, i) {
                       if (element.attribute("gadfly:inscale") == "true") {
                           unscale_t = new Snap.Matrix();
                           unscale_t.scale(1, 1/yscale);
                           element.select("text").transform(unscale_t);

                           var y = element.attr("transform").globalMatrix.f / px_per_mm;
                           element.attr("visibility",
                               bounds.y0 <= y && y <= bounds.y1 ? "visible" : "hidden");
                       }
                   });
        }
    }

    if (xscalable) {
        var yfixed_t = new Snap.Matrix().translate(tx, 0).scale(xscale, 1.0);
        var xtrans = new Snap.Matrix().translate(tx, 0);
        root.selectAll(".yfixed")
            .forEach(function (element, i) {
                element.transform(yfixed_t);
            });

        xlabels = root.select(".xlabels");
        if (xlabels) {
            xlabels.transform(yfixed_t)
                   .selectAll("g")
                   .forEach(function (element, i) {
                       if (element.attribute("gadfly:inscale") == "true") {
                           unscale_t = new Snap.Matrix();
                           unscale_t.scale(1/xscale, 1);
                           element.select("text").transform(unscale_t);

                           var x = element.attr("transform").globalMatrix.e / px_per_mm;
                           element.attr("visibility",
                               bounds.x0 <= x && x <= bounds.x1 ? "visible" : "hidden");
                           }
                   });
        }
    }
};


// Find the most appropriate tick scale and update label visibility.
var update_tickscale = function(root, scale, axis) {
    if (!root.hasClass(axis + "scalable")) return;

    var tickscales = root.data(axis + "tickscales");
    var best_tickscale = 1.0;
    var best_tickscale_dist = Infinity;
    for (tickscale in tickscales) {
        var dist = Math.abs(Math.log(tickscale) - Math.log(scale));
        if (dist < best_tickscale_dist) {
            best_tickscale_dist = dist;
            best_tickscale = tickscale;
        }
    }

    if (best_tickscale != root.data(axis + "tickscale")) {
        root.data(axis + "tickscale", best_tickscale);
        var mark_inscale_gridlines = function (element, i) {
            if (element.attribute("gadfly:inscale") == null) { return; }
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        var mark_inscale_labels = function (element, i) {
            if (element.attribute("gadfly:inscale") == null) { return; }
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        root.select("." + axis + "gridlines").selectAll("g").forEach(mark_inscale_gridlines);
        root.select("." + axis + "labels").selectAll("g").forEach(mark_inscale_labels);
    }
};


var set_plot_pan_zoom = function(root, tx, ty, xscale, yscale) {
    var old_xscale = root.data("xscale"),
        old_yscale = root.data("yscale");
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    // compute the viewport derived from tx, ty, xscale, and yscale
    var x_min = -width * xscale - (xscale * width - width),
        x_max = width * xscale,
        y_min = -height * yscale - (yscale * height - height),
        y_max = height * yscale;

    var x0 = bounds.x0 - xscale * bounds.x0,
        y0 = bounds.y0 - yscale * bounds.y0;

    var tx = Math.max(Math.min(tx - x0, x_max), x_min),
        ty = Math.max(Math.min(ty - y0, y_max), y_min);

    tx += x0;
    ty += y0;

    // when the scale changes, we may need to alter which set of
    // ticks are being displayed
    if (xscale != old_xscale) {
        update_tickscale(root, xscale, "x");
    }
    if (yscale != old_yscale) {
        update_tickscale(root, yscale, "y");
    }

    set_geometry_transform(root, tx, ty, xscale, yscale);

    root.data("xscale", xscale);
    root.data("yscale", yscale);
    root.data("tx", tx);
    root.data("ty", ty);
};


var scale_centered_translation = function(root, xscale, yscale) {
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var xscale0 = root.data("xscale"),
        yscale0 = root.data("yscale");

    // how off from center the current view is
    var xoff = tx0 - (bounds.x0 * (1 - xscale0) + (width * (1 - xscale0)) / 2),
        yoff = ty0 - (bounds.y0 * (1 - yscale0) + (height * (1 - yscale0)) / 2);

    // rescale offsets
    xoff = xoff * xscale / xscale0;
    yoff = yoff * yscale / yscale0;

    // adjust for the panel position being scaled
    var x_edge_adjust = bounds.x0 * (1 - xscale),
        y_edge_adjust = bounds.y0 * (1 - yscale);

    return {
        x: xoff + x_edge_adjust + (width - width * xscale) / 2,
        y: yoff + y_edge_adjust + (height - height * yscale) / 2
    };
};


// Initialize data for panning zooming if it isn't already.
var init_pan_zoom = function(root) {
    if (root.data("zoompan-ready")) {
        return;
    }

    root.data("crosshair",false);

    // The non-scaling-stroke trick. Rather than try to correct for the
    // stroke-width when zooming, we force it to a fixed value.
    var px_per_mm = root.node.getCTM().a;

    // Drag events report deltas in pixels, which we'd like to convert to
    // millimeters.
    root.data("px_per_mm", px_per_mm);

    root.selectAll("path")
        .forEach(function (element, i) {
        sw = element.asPX("stroke-width") * px_per_mm;
        if (sw > 0) {
            element.attribute("stroke-width", sw);
            element.attribute("vector-effect", "non-scaling-stroke");
        }
    });

    // Store ticks labels original tranformation
    root.selectAll(".xlabels > g, .ylabels > g")
        .forEach(function (element, i) {
            var lm = element.transform().localMatrix;
            element.data("static_transform",
                new Snap.Matrix(lm.a, lm.b, lm.c, lm.d, lm.e, lm.f));
        });

    var xgridlines = root.select(".xgridlines");
    var ygridlines = root.select(".ygridlines");
    var xlabels = root.select(".xlabels");
    var ylabels = root.select(".ylabels");

    if (root.data("tx") === undefined) root.data("tx", 0);
    if (root.data("ty") === undefined) root.data("ty", 0);
    if (root.data("xscale") === undefined) root.data("xscale", 1.0);
    if (root.data("yscale") === undefined) root.data("yscale", 1.0);
    if (root.data("xtickscales") === undefined) {

        // index all the tick scales that are listed
        var xtickscales = {};
        var ytickscales = {};
        var add_x_tick_scales = function (element, i) {
            if (element.attribute("gadfly:scale")==null) { return; }
            xtickscales[element.attribute("gadfly:scale")] = true;
        };
        var add_y_tick_scales = function (element, i) {
            if (element.attribute("gadfly:scale")==null) { return; }
            ytickscales[element.attribute("gadfly:scale")] = true;
        };

        if (xgridlines) xgridlines.selectAll("g").forEach(add_x_tick_scales);
        if (ygridlines) ygridlines.selectAll("g").forEach(add_y_tick_scales);
        if (xlabels) xlabels.selectAll("g").forEach(add_x_tick_scales);
        if (ylabels) ylabels.selectAll("g").forEach(add_y_tick_scales);

        root.data("xtickscales", xtickscales);
        root.data("ytickscales", ytickscales);
        root.data("xtickscale", 1.0);
        root.data("ytickscale", 1.0);  // ???
    }

    var min_scale = 1.0, max_scale = 1.0;
    for (scale in xtickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    for (scale in ytickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    root.data("min_scale", min_scale);
    root.data("max_scale", max_scale);

    // store the original positions of labels
    if (xlabels) {
        xlabels.selectAll("g")
               .forEach(function (element, i) {
                   element.data("x", element.asPX("x"));
               });
    }

    if (ylabels) {
        ylabels.selectAll("g")
               .forEach(function (element, i) {
                   element.data("y", element.asPX("y"));
               });
    }

    // mark grid lines and ticks as in or out of scale.
    var mark_inscale = function (element, i) {
        if (element.attribute("gadfly:scale") == null) { return; }
        element.attribute("gadfly:inscale", element.attribute("gadfly:scale") == 1.0);
    };

    if (xgridlines) xgridlines.selectAll("g").forEach(mark_inscale);
    if (ygridlines) ygridlines.selectAll("g").forEach(mark_inscale);
    if (xlabels) xlabels.selectAll("g").forEach(mark_inscale);
    if (ylabels) ylabels.selectAll("g").forEach(mark_inscale);

    // figure out the upper ond lower bounds on panning using the maximum
    // and minum grid lines
    var bounds = root.plotbounds();
    var pan_bounds = {
        x0: 0.0,
        y0: 0.0,
        x1: 0.0,
        y1: 0.0
    };

    if (xgridlines) {
        xgridlines
            .selectAll("g")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var bbox = element.node.getBBox();
                    if (bounds.x1 - bbox.x < pan_bounds.x0) {
                        pan_bounds.x0 = bounds.x1 - bbox.x;
                    }
                    if (bounds.x0 - bbox.x > pan_bounds.x1) {
                        pan_bounds.x1 = bounds.x0 - bbox.x;
                    }
                    element.attr("visibility", "visible");
                }
            });
    }

    if (ygridlines) {
        ygridlines
            .selectAll("g")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var bbox = element.node.getBBox();
                    if (bounds.y1 - bbox.y < pan_bounds.y0) {
                        pan_bounds.y0 = bounds.y1 - bbox.y;
                    }
                    if (bounds.y0 - bbox.y > pan_bounds.y1) {
                        pan_bounds.y1 = bounds.y0 - bbox.y;
                    }
                    element.attr("visibility", "visible");
                }
            });
    }

    // nudge these values a little
    pan_bounds.x0 -= 5;
    pan_bounds.x1 += 5;
    pan_bounds.y0 -= 5;
    pan_bounds.y1 += 5;
    root.data("pan_bounds", pan_bounds);

    root.data("zoompan-ready", true)
};


// drag actions, i.e. zooming and panning
var pan_action = {
    start: function(root, x, y, event) {
        root.data("dx", 0);
        root.data("dy", 0);
        root.data("tx0", root.data("tx"));
        root.data("ty0", root.data("ty"));
    },
    update: function(root, dx, dy, x, y, event) {
        var px_per_mm = root.data("px_per_mm");
        dx /= px_per_mm;
        dy /= px_per_mm;

        var tx0 = root.data("tx"),
            ty0 = root.data("ty");

        var dx0 = root.data("dx"),
            dy0 = root.data("dy");

        root.data("dx", dx);
        root.data("dy", dy);

        dx = dx - dx0;
        dy = dy - dy0;

        var tx = tx0 + dx,
            ty = ty0 + dy;

        set_plot_pan_zoom(root, tx, ty, root.data("xscale"), root.data("yscale"));
    },
    end: function(root, event) {

    },
    cancel: function(root) {
        set_plot_pan_zoom(root, root.data("tx0"), root.data("ty0"),
                root.data("xscale"), root.data("yscale"));
    }
};

var zoom_box;
var zoom_action = {
    start: function(root, x, y, event) {
        var bounds = root.plotbounds();
        var width = bounds.x1 - bounds.x0,
            height = bounds.y1 - bounds.y0;
        var xscalable = root.hasClass("xscalable"),
            yscalable = root.hasClass("yscalable");
        var px_per_mm = root.data("px_per_mm");
        x = xscalable ? x / px_per_mm : bounds.x0;
        y = yscalable ? y / px_per_mm : bounds.y0;
        var w = xscalable ? 0 : width;
        var h = yscalable ? 0 : height;
        zoom_box = root.rect(x, y, w, h).attr({
            "fill": "#000",
            "opacity": 0.25
        });
    },
    update: function(root, dx, dy, x, y, event) {
        var xscalable = root.hasClass("xscalable"),
            yscalable = root.hasClass("yscalable");
        var px_per_mm = root.data("px_per_mm");
        var bounds = root.plotbounds();
        if (yscalable) {
            y /= px_per_mm;
            y = Math.max(bounds.y0, y);
            y = Math.min(bounds.y1, y);
        } else {
            y = bounds.y1;
        }
        if (xscalable) {
            x /= px_per_mm;
            x = Math.max(bounds.x0, x);
            x = Math.min(bounds.x1, x);
        } else {
            x = bounds.x1;
        }

        dx = x - zoom_box.attr("x");
        dy = y - zoom_box.attr("y");
        var xoffset = 0,
            yoffset = 0;
        if (dx < 0) {
            xoffset = dx;
            dx = -1 * dx;
        }
        if (dy < 0) {
            yoffset = dy;
            dy = -1 * dy;
        }
        if (isNaN(dy)) {
            dy = 0.0;
        }
        if (isNaN(dx)) {
            dx = 0.0;
        }
        zoom_box.transform("T" + xoffset + "," + yoffset);
        zoom_box.attr("width", dx);
        zoom_box.attr("height", dy);
    },
    end: function(root, event) {
        var xscalable = root.hasClass("xscalable"),
            yscalable = root.hasClass("yscalable");
        var zoom_bounds = zoom_box.getBBox();
        if (zoom_bounds.width * zoom_bounds.height <= 0) {
            return;
        }
        var plot_bounds = root.plotbounds();
        var xzoom_factor = 1.0,
            yzoom_factor = 1.0;
        if (xscalable) {
            xzoom_factor = (plot_bounds.x1 - plot_bounds.x0) / zoom_bounds.width;
        }
        if (yscalable) {
            yzoom_factor = (plot_bounds.y1 - plot_bounds.y0) / zoom_bounds.height;
        }
        var tx = (root.data("tx") - zoom_bounds.x) * xzoom_factor + plot_bounds.x0,
            ty = (root.data("ty") - zoom_bounds.y) * yzoom_factor + plot_bounds.y0;
        set_plot_pan_zoom(root, tx, ty,
                root.data("xscale") * xzoom_factor, root.data("yscale") * yzoom_factor);
        zoom_box.remove();
    },
    cancel: function(root) {
        zoom_box.remove();
    }
};


Gadfly.guide_background_drag_onstart = function(x, y, event) {
    var root = this.plotroot();
    var scalable = root.hasClass("xscalable") || root.hasClass("yscalable");
    var zoomable = !event.altKey && !event.ctrlKey && event.shiftKey && scalable;
    var panable = !event.altKey && !event.ctrlKey && !event.shiftKey && scalable;
    var drag_action = zoomable ? zoom_action :
                      panable  ? pan_action :
                                 undefined;
    root.data("drag_action", drag_action);
    if (drag_action) {
        var cancel_drag_action = function(event) {
            if (event.which == 27) { // esc key
                drag_action.cancel(root);
                root.data("drag_action", undefined);
            }
        };
        window.addEventListener("keyup", cancel_drag_action);
        root.data("cancel_drag_action", cancel_drag_action);
        drag_action.start(root, x, y, event);
    }
};


Gadfly.guide_background_drag_onmove = function(dx, dy, x, y, event) {
    var root = this.plotroot();
    var drag_action = root.data("drag_action");
    if (drag_action) {
        drag_action.update(root, dx, dy, x, y, event);
    }
};


Gadfly.guide_background_drag_onend = function(event) {
    var root = this.plotroot();
    window.removeEventListener("keyup", root.data("cancel_drag_action"));
    root.data("cancel_drag_action", undefined);
    var drag_action = root.data("drag_action");
    if (drag_action) {
        drag_action.end(root, event);
    }
    root.data("drag_action", undefined);
};


Gadfly.guide_background_scroll = function(event) {
    if (event.shiftKey) {
        increase_zoom_by_position(this.plotroot(), 0.001 * event.wheelDelta);
        event.preventDefault();
    }
};

// Map slider position x to scale y using the function y = a*exp(b*x)+c.
// The constants a, b, and c are solved using the constraint that the function
// should go through the points (0; min_scale), (0.5; 1), and (1; max_scale).
var scale_from_slider_position = function(position, min_scale, max_scale) {
    if (min_scale==max_scale) { return 1; }
    var a = (1 - 2 * min_scale + min_scale * min_scale) / (min_scale + max_scale - 2),
        b = 2 * Math.log((max_scale - 1) / (1 - min_scale)),
        c = (min_scale * max_scale - 1) / (min_scale + max_scale - 2);
    return a * Math.exp(b * position) + c;
}

// inverse of scale_from_slider_position
var slider_position_from_scale = function(scale, min_scale, max_scale) {
    if (min_scale==max_scale) { return min_scale; }
    var a = (1 - 2 * min_scale + min_scale * min_scale) / (min_scale + max_scale - 2),
        b = 2 * Math.log((max_scale - 1) / (1 - min_scale)),
        c = (min_scale * max_scale - 1) / (min_scale + max_scale - 2);
    return 1 / b * Math.log((scale - c) / a);
}

var increase_zoom_by_position = function(root, delta_position, animate) {
    var old_xscale = root.data("xscale"),
        old_yscale = root.data("yscale"),
        min_scale = root.data("min_scale"),
        max_scale = root.data("max_scale");
    var xposition = slider_position_from_scale(old_xscale, min_scale, max_scale),
        yposition = slider_position_from_scale(old_yscale, min_scale, max_scale);
    xposition += (root.hasClass("xscalable") ? delta_position : 0.0);
    yposition += (root.hasClass("yscalable") ? delta_position : 0.0);
    old_xscale = scale_from_slider_position(xposition, min_scale, max_scale);
    old_yscale = scale_from_slider_position(yposition, min_scale, max_scale);
    var new_xscale = Math.max(min_scale, Math.min(old_xscale, max_scale)),
        new_yscale = Math.max(min_scale, Math.min(old_yscale, max_scale));
    if (animate) {
        Snap.animate(
            [old_xscale, old_yscale],
            [new_xscale, new_yscale],
            function (new_scale) {
                update_plot_scale(root, new_scale[0], new_scale[1]);
            },
            200);
    } else {
        update_plot_scale(root, new_xscale, new_yscale);
    }
}


var update_plot_scale = function(root, new_xscale, new_yscale) {
    var trans = scale_centered_translation(root, new_xscale, new_yscale);
    set_plot_pan_zoom(root, trans.x, trans.y, new_xscale, new_yscale);
};


var toggle_color_class = function(root, color_class, ison) {
    var escaped_color_class = color_class.replace(/([^0-9a-zA-z])/g,"\\$1");
    var guides = root.selectAll(".guide." + escaped_color_class + ",.guide ." + escaped_color_class);
    var geoms = root.selectAll(".geometry." + escaped_color_class + ",.geometry ." + escaped_color_class);
    if (ison) {
        guides.animate({opacity: 0.5}, 250);
        geoms.animate({opacity: 0.0}, 250);
    } else {
        guides.animate({opacity: 1.0}, 250);
        geoms.animate({opacity: 1.0}, 250);
    }
};


Gadfly.colorkey_swatch_click = function(event) {
    var root = this.plotroot();
    var color_class = this.data("color_class");

    if (event.shiftKey) {
        root.selectAll(".colorkey g")
            .forEach(function (element) {
                var other_color_class = element.data("color_class");
                if (typeof other_color_class !== 'undefined' && other_color_class != color_class) {
                    toggle_color_class(root, other_color_class,
                                       element.attr("opacity") == 1.0);
                }
            });
    } else {
        toggle_color_class(root, color_class, this.attr("opacity") == 1.0);
    }
};


return Gadfly;

}));


//@ sourceURL=gadfly.js

(function (glob, factory) {
    // AMD support
      if (typeof require === "function" && typeof define === "function" && define.amd) {
        require(["Snap.svg", "Gadfly"], function (Snap, Gadfly) {
            factory(Snap, Gadfly);
        });
      } else {
          factory(glob.Snap, glob.Gadfly);
      }
})(window, function (Snap, Gadfly) {
    var fig = Snap("#img-79db7dcd");
fig.select("#img-79db7dcd-5")
   .init_gadfly();
fig.select("#img-79db7dcd-8")
   .plotroot().data("unfocused_ygrid_color", "#D0D0E0")
;
fig.select("#img-79db7dcd-8")
   .plotroot().data("focused_ygrid_color", "#A0A0A0")
;
fig.select("#img-79db7dcd-120")
   .plotroot().data("unfocused_xgrid_color", "#D0D0E0")
;
fig.select("#img-79db7dcd-120")
   .plotroot().data("focused_xgrid_color", "#A0A0A0")
;
fig.select("#img-79db7dcd-244")
   .mouseenter(Gadfly.helpscreen_visible)
.mouseleave(Gadfly.helpscreen_hidden)
;
    });
]]> </script>
</svg>




### Sensitivity Analysis


```julia
# First we need to create a sensitivity table with hcat() using both the input and output vectors.
s_table = hcat(Profit, Revenue, Expenses)

#We then need to convert to a DataFrame
s_table = DataFrame(s_table)
names!(s_table, [:Profit, :Revenue, :Expenses])
```




<table class="data-frame"><thead><tr><th></th><th>Profit</th><th>Revenue</th><th>Expenses</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>1,000 rows × 3 columns</p><tr><th>1</th><td>1.84124e6</td><td>3.76385e6</td><td>1.92261e6</td></tr><tr><th>2</th><td>1.41565e6</td><td>3.1978e6</td><td>1.78215e6</td></tr><tr><th>3</th><td>1.21054e6</td><td>3.17957e6</td><td>1.96902e6</td></tr><tr><th>4</th><td>1.06875e6</td><td>3.20076e6</td><td>2.13202e6</td></tr><tr><th>5</th><td>8.76592e5</td><td>2.91161e6</td><td>2.03502e6</td></tr><tr><th>6</th><td>5.27052e5</td><td>3.01349e6</td><td>2.48644e6</td></tr><tr><th>7</th><td>1.62556e6</td><td>3.18229e6</td><td>1.55673e6</td></tr><tr><th>8</th><td>1.16029e6</td><td>3.25232e6</td><td>2.09203e6</td></tr><tr><th>9</th><td>9.52739e5</td><td>3.3828e6</td><td>2.43006e6</td></tr><tr><th>10</th><td>1.18224e6</td><td>2.76563e6</td><td>1.58339e6</td></tr><tr><th>11</th><td>1.3709e6</td><td>3.05273e6</td><td>1.68182e6</td></tr><tr><th>12</th><td>4.02693e5</td><td>2.73484e6</td><td>2.33215e6</td></tr><tr><th>13</th><td>922341.0</td><td>3.58351e6</td><td>2.66117e6</td></tr><tr><th>14</th><td>1.03986e6</td><td>3.36103e6</td><td>2.32117e6</td></tr><tr><th>15</th><td>1.47142e6</td><td>3.87776e6</td><td>2.40634e6</td></tr><tr><th>16</th><td>1.04472e6</td><td>3.03329e6</td><td>1.98857e6</td></tr><tr><th>17</th><td>1.15058e6</td><td>3.02969e6</td><td>1.87911e6</td></tr><tr><th>18</th><td>5.51627e5</td><td>2.71137e6</td><td>2.15974e6</td></tr><tr><th>19</th><td>1.38243e6</td><td>3.23514e6</td><td>1.8527e6</td></tr><tr><th>20</th><td>1.03446e6</td><td>3.40563e6</td><td>2.37116e6</td></tr><tr><th>21</th><td>717692.0</td><td>2.76465e6</td><td>2.04696e6</td></tr><tr><th>22</th><td>9.55816e5</td><td>2.90703e6</td><td>1.95121e6</td></tr><tr><th>23</th><td>1.62626e6</td><td>3.74564e6</td><td>2.11937e6</td></tr><tr><th>24</th><td>1.61947e6</td><td>3.73109e6</td><td>2.11162e6</td></tr><tr><th>25</th><td>1.40675e6</td><td>3.2451e6</td><td>1.83835e6</td></tr><tr><th>26</th><td>1.5922e6</td><td>3.21848e6</td><td>1.62628e6</td></tr><tr><th>27</th><td>1.22262e6</td><td>3.22193e6</td><td>1.99931e6</td></tr><tr><th>28</th><td>1.34201e6</td><td>3.21047e6</td><td>1.86846e6</td></tr><tr><th>29</th><td>1.25961e6</td><td>3.49429e6</td><td>2.23468e6</td></tr><tr><th>30</th><td>1.05311e6</td><td>3.0764e6</td><td>2.02329e6</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table>




```julia
# To produce a sensitivity tornado chart, we need to select the output against which the inputs are measured for effect.
sensitivity_chrt(s_table, 1, 3)
```

    2×6 DataFrame
    │ Row │ name     │ correlation │ abs_cor  │ PPMC      │ cont_var  │ impact   │
    │     │ [90mAny[39m      │ [90mAny[39m         │ [90mAny[39m      │ [90mAny[39m       │ [90mAny[39m       │ [90mAny[39m      │
    ├─────┼──────────┼─────────────┼──────────┼───────────┼───────────┼──────────┤
    │ 1   │ Revenue  │ 0.64953     │ 0.64953  │ 0.662533  │ 0.462486  │ Positive │
    │ 2   │ Expenses │ -0.700237   │ 0.700237 │ -0.715093 │ -0.537514 │ Negative │





<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:gadfly="http://www.gadflyjl.org/ns"
     version="1.2"
     width="141.42mm" height="100mm" viewBox="0 0 141.42 100"
     stroke="none"
     fill="#000000"
     stroke-width="0.3"
     font-size="3.88"

     id="img-deb8fff3">
<defs>
  <marker id="arrow" markerWidth="15" markerHeight="7" refX="5" refY="3.5" orient="auto" markerUnits="strokeWidth">
    <path d="M0,0 L15,3.5 L0,7 z" stroke="context-stroke" fill="context-stroke"/>
  </marker>
</defs>
<g class="plotroot xscalable" id="img-deb8fff3-1">
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="#000000" stroke-opacity="0.000" id="img-deb8fff3-2">
    <g transform="translate(74.78,88.39)">
      <g class="primitive">
        <text text-anchor="middle" dy="0.6em">% Contribution to Variance</text>
      </g>
    </g>
  </g>
  <g class="guide xlabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="img-deb8fff3-3">
    <g transform="translate(-82.97,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.5</text>
      </g>
    </g>
    <g transform="translate(-60.43,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.0</text>
      </g>
    </g>
    <g transform="translate(-37.9,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.5</text>
      </g>
    </g>
    <g transform="translate(-15.36,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.0</text>
      </g>
    </g>
    <g transform="translate(7.18,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.5</text>
      </g>
    </g>
    <g transform="translate(29.71,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.0</text>
      </g>
    </g>
    <g transform="translate(52.25,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.5</text>
      </g>
    </g>
    <g transform="translate(74.78,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.0</text>
      </g>
    </g>
    <g transform="translate(97.32,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.5</text>
      </g>
    </g>
    <g transform="translate(119.85,84.39)" visibility="visible" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.0</text>
      </g>
    </g>
    <g transform="translate(142.39,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.5</text>
      </g>
    </g>
    <g transform="translate(164.93,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.0</text>
      </g>
    </g>
    <g transform="translate(187.46,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.5</text>
      </g>
    </g>
    <g transform="translate(210,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.0</text>
      </g>
    </g>
    <g transform="translate(232.53,84.39)" visibility="hidden" gadfly:scale="1.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.5</text>
      </g>
    </g>
    <g transform="translate(-60.43,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.0</text>
      </g>
    </g>
    <g transform="translate(-55.92,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.9</text>
      </g>
    </g>
    <g transform="translate(-51.42,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.8</text>
      </g>
    </g>
    <g transform="translate(-46.91,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.7</text>
      </g>
    </g>
    <g transform="translate(-42.4,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.6</text>
      </g>
    </g>
    <g transform="translate(-37.9,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.5</text>
      </g>
    </g>
    <g transform="translate(-33.39,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.4</text>
      </g>
    </g>
    <g transform="translate(-28.88,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.3</text>
      </g>
    </g>
    <g transform="translate(-24.37,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.2</text>
      </g>
    </g>
    <g transform="translate(-19.87,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.1</text>
      </g>
    </g>
    <g transform="translate(-15.36,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.0</text>
      </g>
    </g>
    <g transform="translate(-10.85,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.9</text>
      </g>
    </g>
    <g transform="translate(-6.35,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.8</text>
      </g>
    </g>
    <g transform="translate(-1.84,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.7</text>
      </g>
    </g>
    <g transform="translate(2.67,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.6</text>
      </g>
    </g>
    <g transform="translate(7.18,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.5</text>
      </g>
    </g>
    <g transform="translate(11.68,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.4</text>
      </g>
    </g>
    <g transform="translate(16.19,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.3</text>
      </g>
    </g>
    <g transform="translate(20.7,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.2</text>
      </g>
    </g>
    <g transform="translate(25.2,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.1</text>
      </g>
    </g>
    <g transform="translate(29.71,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.0</text>
      </g>
    </g>
    <g transform="translate(34.22,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.9</text>
      </g>
    </g>
    <g transform="translate(38.73,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.8</text>
      </g>
    </g>
    <g transform="translate(43.23,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.7</text>
      </g>
    </g>
    <g transform="translate(47.74,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.6</text>
      </g>
    </g>
    <g transform="translate(52.25,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.5</text>
      </g>
    </g>
    <g transform="translate(56.75,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.4</text>
      </g>
    </g>
    <g transform="translate(61.26,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.3</text>
      </g>
    </g>
    <g transform="translate(65.77,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.2</text>
      </g>
    </g>
    <g transform="translate(70.28,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.1</text>
      </g>
    </g>
    <g transform="translate(74.78,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.0</text>
      </g>
    </g>
    <g transform="translate(79.29,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.1</text>
      </g>
    </g>
    <g transform="translate(83.8,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.2</text>
      </g>
    </g>
    <g transform="translate(88.3,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.3</text>
      </g>
    </g>
    <g transform="translate(92.81,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.4</text>
      </g>
    </g>
    <g transform="translate(97.32,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.5</text>
      </g>
    </g>
    <g transform="translate(101.83,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.6</text>
      </g>
    </g>
    <g transform="translate(106.33,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.7</text>
      </g>
    </g>
    <g transform="translate(110.84,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.8</text>
      </g>
    </g>
    <g transform="translate(115.35,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.9</text>
      </g>
    </g>
    <g transform="translate(119.85,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.0</text>
      </g>
    </g>
    <g transform="translate(124.36,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.1</text>
      </g>
    </g>
    <g transform="translate(128.87,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.2</text>
      </g>
    </g>
    <g transform="translate(133.38,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.3</text>
      </g>
    </g>
    <g transform="translate(137.88,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.4</text>
      </g>
    </g>
    <g transform="translate(142.39,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.5</text>
      </g>
    </g>
    <g transform="translate(146.9,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.6</text>
      </g>
    </g>
    <g transform="translate(151.4,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.7</text>
      </g>
    </g>
    <g transform="translate(155.91,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.8</text>
      </g>
    </g>
    <g transform="translate(160.42,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.9</text>
      </g>
    </g>
    <g transform="translate(164.93,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.0</text>
      </g>
    </g>
    <g transform="translate(169.43,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.1</text>
      </g>
    </g>
    <g transform="translate(173.94,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.2</text>
      </g>
    </g>
    <g transform="translate(178.45,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.3</text>
      </g>
    </g>
    <g transform="translate(182.95,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.4</text>
      </g>
    </g>
    <g transform="translate(187.46,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.5</text>
      </g>
    </g>
    <g transform="translate(191.97,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.6</text>
      </g>
    </g>
    <g transform="translate(196.48,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.7</text>
      </g>
    </g>
    <g transform="translate(200.98,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.8</text>
      </g>
    </g>
    <g transform="translate(205.49,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.9</text>
      </g>
    </g>
    <g transform="translate(210,84.39)" visibility="hidden" gadfly:scale="10.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.0</text>
      </g>
    </g>
    <g transform="translate(-105.5,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-4</text>
      </g>
    </g>
    <g transform="translate(-15.36,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2</text>
      </g>
    </g>
    <g transform="translate(74.78,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0</text>
      </g>
    </g>
    <g transform="translate(164.93,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2</text>
      </g>
    </g>
    <g transform="translate(255.07,84.39)" visibility="hidden" gadfly:scale="0.5">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">4</text>
      </g>
    </g>
    <g transform="translate(-60.43,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-3.0</text>
      </g>
    </g>
    <g transform="translate(-51.42,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.8</text>
      </g>
    </g>
    <g transform="translate(-42.4,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.6</text>
      </g>
    </g>
    <g transform="translate(-33.39,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.4</text>
      </g>
    </g>
    <g transform="translate(-24.37,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.2</text>
      </g>
    </g>
    <g transform="translate(-15.36,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-2.0</text>
      </g>
    </g>
    <g transform="translate(-6.35,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.8</text>
      </g>
    </g>
    <g transform="translate(2.67,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.6</text>
      </g>
    </g>
    <g transform="translate(11.68,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.4</text>
      </g>
    </g>
    <g transform="translate(20.7,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.2</text>
      </g>
    </g>
    <g transform="translate(29.71,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-1.0</text>
      </g>
    </g>
    <g transform="translate(38.73,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.8</text>
      </g>
    </g>
    <g transform="translate(47.74,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.6</text>
      </g>
    </g>
    <g transform="translate(56.75,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.4</text>
      </g>
    </g>
    <g transform="translate(65.77,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">-0.2</text>
      </g>
    </g>
    <g transform="translate(74.78,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.0</text>
      </g>
    </g>
    <g transform="translate(83.8,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.2</text>
      </g>
    </g>
    <g transform="translate(92.81,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.4</text>
      </g>
    </g>
    <g transform="translate(101.83,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.6</text>
      </g>
    </g>
    <g transform="translate(110.84,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">0.8</text>
      </g>
    </g>
    <g transform="translate(119.85,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.0</text>
      </g>
    </g>
    <g transform="translate(128.87,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.2</text>
      </g>
    </g>
    <g transform="translate(137.88,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.4</text>
      </g>
    </g>
    <g transform="translate(146.9,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.6</text>
      </g>
    </g>
    <g transform="translate(155.91,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">1.8</text>
      </g>
    </g>
    <g transform="translate(164.93,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.0</text>
      </g>
    </g>
    <g transform="translate(173.94,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.2</text>
      </g>
    </g>
    <g transform="translate(182.95,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.4</text>
      </g>
    </g>
    <g transform="translate(191.97,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.6</text>
      </g>
    </g>
    <g transform="translate(200.98,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">2.8</text>
      </g>
    </g>
    <g transform="translate(210,84.39)" visibility="hidden" gadfly:scale="5.0">
      <g class="primitive">
        <text text-anchor="middle" dy="-0em">3.0</text>
      </g>
    </g>
  </g>
  <g class="guide colorkey" id="img-deb8fff3-4">
    <g fill="#4C404B" font-size="2.82" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" id="img-deb8fff3-5">
      <g transform="translate(125.67,45.66)" id="img-deb8fff3-6" class="color_Positive">
        <g class="primitive">
          <text dy="0.35em">Positive</text>
        </g>
      </g>
      <g transform="translate(125.67,49.29)" id="img-deb8fff3-7" class="color_Negative">
        <g class="primitive">
          <text dy="0.35em">Negative</text>
        </g>
      </g>
    </g>
    <g stroke="#000000" stroke-opacity="0.000" id="img-deb8fff3-8">
      <g transform="translate(123.76,45.66)" id="img-deb8fff3-9" class="color_Positive" fill="#FF0000">
        <path d="M-0.91,-0.91 L 0.91 -0.91 0.91 0.91 -0.91 0.91 z" class="primitive"/>
      </g>
      <g transform="translate(123.76,49.29)" id="img-deb8fff3-10" class="color_Negative" fill="#00BFFF">
        <path d="M-0.91,-0.91 L 0.91 -0.91 0.91 0.91 -0.91 0.91 z" class="primitive"/>
      </g>
    </g>
    <g fill="#362A35" font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" stroke="#000000" stroke-opacity="0.000" id="img-deb8fff3-11">
      <g transform="translate(122.85,41.84)" id="img-deb8fff3-12">
        <g class="primitive">
          <text dy="-0em">impact</text>
        </g>
      </g>
    </g>
  </g>
  <g clip-path="url(#img-deb8fff3-13)">
    <g id="img-deb8fff3-14">
      <g pointer-events="visible" fill="#000000" fill-opacity="0.000" stroke="#000000" stroke-opacity="0.000" class="guide background" id="img-deb8fff3-15">
        <g transform="translate(74.78,45.66)" id="img-deb8fff3-16">
          <path d="M-47.07,-35.05 L 47.07 -35.05 47.07 35.05 -47.07 35.05 z" class="primitive"/>
        </g>
      </g>
      <g class="guide ygridlines xfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" visibility="visible" id="img-deb8fff3-17">
        <g transform="translate(74.78,45.66)" id="img-deb8fff3-18" gadfly:scale="1.0">
          <path fill="none" d="M-47.07,0 L 47.07 0" class="primitive"/>
        </g>
      </g>
      <g class="guide xgridlines yfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="img-deb8fff3-19">
        <g transform="translate(-82.97,45.66)" id="img-deb8fff3-20" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-60.43,45.66)" id="img-deb8fff3-21" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-37.9,45.66)" id="img-deb8fff3-22" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-15.36,45.66)" id="img-deb8fff3-23" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(7.18,45.66)" id="img-deb8fff3-24" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(29.71,45.66)" id="img-deb8fff3-25" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(52.25,45.66)" id="img-deb8fff3-26" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(74.78,45.66)" id="img-deb8fff3-27" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(97.32,45.66)" id="img-deb8fff3-28" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(119.85,45.66)" id="img-deb8fff3-29" gadfly:scale="1.0" visibility="visible">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(142.39,45.66)" id="img-deb8fff3-30" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(164.93,45.66)" id="img-deb8fff3-31" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(187.46,45.66)" id="img-deb8fff3-32" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(210,45.66)" id="img-deb8fff3-33" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(232.53,45.66)" id="img-deb8fff3-34" gadfly:scale="1.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-60.43,45.66)" id="img-deb8fff3-35" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-55.92,45.66)" id="img-deb8fff3-36" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-51.42,45.66)" id="img-deb8fff3-37" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-46.91,45.66)" id="img-deb8fff3-38" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-42.4,45.66)" id="img-deb8fff3-39" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-37.9,45.66)" id="img-deb8fff3-40" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-33.39,45.66)" id="img-deb8fff3-41" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-28.88,45.66)" id="img-deb8fff3-42" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-24.37,45.66)" id="img-deb8fff3-43" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-19.87,45.66)" id="img-deb8fff3-44" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-15.36,45.66)" id="img-deb8fff3-45" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-10.85,45.66)" id="img-deb8fff3-46" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-6.35,45.66)" id="img-deb8fff3-47" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-1.84,45.66)" id="img-deb8fff3-48" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(2.67,45.66)" id="img-deb8fff3-49" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(7.18,45.66)" id="img-deb8fff3-50" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(11.68,45.66)" id="img-deb8fff3-51" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(16.19,45.66)" id="img-deb8fff3-52" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(20.7,45.66)" id="img-deb8fff3-53" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(25.2,45.66)" id="img-deb8fff3-54" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(29.71,45.66)" id="img-deb8fff3-55" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(34.22,45.66)" id="img-deb8fff3-56" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(38.73,45.66)" id="img-deb8fff3-57" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(43.23,45.66)" id="img-deb8fff3-58" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(47.74,45.66)" id="img-deb8fff3-59" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(52.25,45.66)" id="img-deb8fff3-60" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(56.75,45.66)" id="img-deb8fff3-61" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(61.26,45.66)" id="img-deb8fff3-62" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(65.77,45.66)" id="img-deb8fff3-63" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(70.28,45.66)" id="img-deb8fff3-64" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(74.78,45.66)" id="img-deb8fff3-65" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(79.29,45.66)" id="img-deb8fff3-66" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(83.8,45.66)" id="img-deb8fff3-67" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(88.3,45.66)" id="img-deb8fff3-68" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(92.81,45.66)" id="img-deb8fff3-69" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(97.32,45.66)" id="img-deb8fff3-70" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(101.83,45.66)" id="img-deb8fff3-71" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(106.33,45.66)" id="img-deb8fff3-72" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(110.84,45.66)" id="img-deb8fff3-73" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(115.35,45.66)" id="img-deb8fff3-74" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(119.85,45.66)" id="img-deb8fff3-75" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(124.36,45.66)" id="img-deb8fff3-76" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(128.87,45.66)" id="img-deb8fff3-77" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(133.38,45.66)" id="img-deb8fff3-78" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(137.88,45.66)" id="img-deb8fff3-79" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(142.39,45.66)" id="img-deb8fff3-80" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(146.9,45.66)" id="img-deb8fff3-81" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(151.4,45.66)" id="img-deb8fff3-82" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(155.91,45.66)" id="img-deb8fff3-83" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(160.42,45.66)" id="img-deb8fff3-84" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(164.93,45.66)" id="img-deb8fff3-85" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(169.43,45.66)" id="img-deb8fff3-86" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(173.94,45.66)" id="img-deb8fff3-87" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(178.45,45.66)" id="img-deb8fff3-88" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(182.95,45.66)" id="img-deb8fff3-89" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(187.46,45.66)" id="img-deb8fff3-90" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(191.97,45.66)" id="img-deb8fff3-91" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(196.48,45.66)" id="img-deb8fff3-92" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(200.98,45.66)" id="img-deb8fff3-93" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(205.49,45.66)" id="img-deb8fff3-94" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(210,45.66)" id="img-deb8fff3-95" gadfly:scale="10.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-105.5,45.66)" id="img-deb8fff3-96" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-15.36,45.66)" id="img-deb8fff3-97" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(74.78,45.66)" id="img-deb8fff3-98" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(164.93,45.66)" id="img-deb8fff3-99" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(255.07,45.66)" id="img-deb8fff3-100" gadfly:scale="0.5" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-60.43,45.66)" id="img-deb8fff3-101" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-51.42,45.66)" id="img-deb8fff3-102" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-42.4,45.66)" id="img-deb8fff3-103" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-33.39,45.66)" id="img-deb8fff3-104" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-24.37,45.66)" id="img-deb8fff3-105" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-15.36,45.66)" id="img-deb8fff3-106" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(-6.35,45.66)" id="img-deb8fff3-107" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(2.67,45.66)" id="img-deb8fff3-108" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(11.68,45.66)" id="img-deb8fff3-109" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(20.7,45.66)" id="img-deb8fff3-110" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(29.71,45.66)" id="img-deb8fff3-111" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(38.73,45.66)" id="img-deb8fff3-112" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(47.74,45.66)" id="img-deb8fff3-113" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(56.75,45.66)" id="img-deb8fff3-114" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(65.77,45.66)" id="img-deb8fff3-115" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(74.78,45.66)" id="img-deb8fff3-116" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(83.8,45.66)" id="img-deb8fff3-117" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(92.81,45.66)" id="img-deb8fff3-118" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(101.83,45.66)" id="img-deb8fff3-119" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(110.84,45.66)" id="img-deb8fff3-120" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(119.85,45.66)" id="img-deb8fff3-121" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(128.87,45.66)" id="img-deb8fff3-122" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(137.88,45.66)" id="img-deb8fff3-123" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(146.9,45.66)" id="img-deb8fff3-124" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(155.91,45.66)" id="img-deb8fff3-125" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(164.93,45.66)" id="img-deb8fff3-126" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(173.94,45.66)" id="img-deb8fff3-127" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(182.95,45.66)" id="img-deb8fff3-128" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(191.97,45.66)" id="img-deb8fff3-129" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(200.98,45.66)" id="img-deb8fff3-130" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
        <g transform="translate(210,45.66)" id="img-deb8fff3-131" gadfly:scale="5.0" visibility="hidden">
          <path fill="none" d="M0,-35.05 L 0 35.05" class="primitive"/>
        </g>
      </g>
      <g class="plotpanel" id="img-deb8fff3-132">
        <metadata>
          <boundingbox value="27.71166666666666mm 10.611666666666665mm 94.14302290397617mm 70.10333333333334mm"/>
          <unitbox value="-1.0443739279107709 2.5 2.0887478558215418 -2.0"/>
        </metadata>
        <g shape-rendering="crispEdges" stroke-width="0.3" id="img-deb8fff3-133">
          <g stroke="#000000" stroke-opacity="0.000" class="geometry" id="img-deb8fff3-134">
            <g transform="translate(62.67,31.67)" id="img-deb8fff3-135" fill="#00BFFF">
              <path d="M-12.11,-15.76 L 12.11 -15.76 12.11 15.76 -12.11 15.76 z" class="primitive"/>
            </g>
            <g transform="translate(85.21,66.72)" id="img-deb8fff3-136" fill="#FF0000">
              <path d="M-10.42,-15.76 L 10.42 -15.76 10.42 15.76 -10.42 15.76 z" class="primitive"/>
            </g>
          </g>
        </g>
      </g>
      <g fill-opacity="0" class="guide crosshair" id="img-deb8fff3-137">
        <g class="text_box" fill="#000000" id="img-deb8fff3-138">
          <g transform="translate(114.8,11.14)" id="img-deb8fff3-139">
            <g class="primitive">
              <text text-anchor="end" dy="0.6em"></text>
            </g>
          </g>
        </g>
      </g>
      <g fill-opacity="0" class="guide helpscreen" id="img-deb8fff3-140">
        <g class="text_box" id="img-deb8fff3-141">
          <g fill="#000000" id="img-deb8fff3-142">
            <g transform="translate(74.78,45.66)" id="img-deb8fff3-143">
              <path d="M-27.48,-9.93 L 27.48 -9.93 27.48 9.93 -27.48 9.93 z" class="primitive"/>
            </g>
          </g>
          <g fill="#FFFF62" font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" id="img-deb8fff3-144">
            <g transform="translate(74.78,38.44)" id="img-deb8fff3-145">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">h,j,k,l,arrows,drag to pan</text>
              </g>
            </g>
            <g transform="translate(74.78,42.05)" id="img-deb8fff3-146">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">i,o,+,-,scroll,shift-drag to zoom</text>
              </g>
            </g>
            <g transform="translate(74.78,45.66)" id="img-deb8fff3-147">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">r,dbl-click to reset</text>
              </g>
            </g>
            <g transform="translate(74.78,49.28)" id="img-deb8fff3-148">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">c for coordinates</text>
              </g>
            </g>
            <g transform="translate(74.78,52.89)" id="img-deb8fff3-149">
              <g class="primitive">
                <text text-anchor="middle" dy="0.35em">? for help</text>
              </g>
            </g>
          </g>
        </g>
      </g>
      <g fill-opacity="0" class="guide questionmark" id="img-deb8fff3-150">
        <g class="text_box" fill="#000000" id="img-deb8fff3-151">
          <g transform="translate(121.85,11.14)" id="img-deb8fff3-152">
            <g class="primitive">
              <text text-anchor="end" dy="0.6em">?</text>
            </g>
          </g>
        </g>
      </g>
    </g>
  </g>
  <g class="guide ylabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="img-deb8fff3-153">
    <g transform="translate(26.71,63.19)" id="img-deb8fff3-154" gadfly:scale="1.0" visibility="visible">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">Revenue</text>
      </g>
    </g>
    <g transform="translate(26.71,28.14)" id="img-deb8fff3-155" gadfly:scale="1.0" visibility="visible">
      <g class="primitive">
        <text text-anchor="end" dy="0.35em">Expenses</text>
      </g>
    </g>
  </g>
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="#000000" stroke-opacity="0.000" id="img-deb8fff3-156">
    <g transform="translate(8.81,43.66)" id="img-deb8fff3-157">
      <g class="primitive">
        <text text-anchor="middle" dy="0.35em" transform="rotate(-90,0, 2)">Input</text>
      </g>
    </g>
  </g>
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="#000000" stroke-opacity="0.000" id="img-deb8fff3-158">
    <g transform="translate(74.78,5)" id="img-deb8fff3-159">
      <g class="primitive">
        <text text-anchor="middle" dy="0.6em">Variables with Biggest Impact</text>
      </g>
    </g>
  </g>
</g>
<defs>
  <clipPath id="img-deb8fff3-13">
    <path d="M27.71,10.61 L 121.85 10.61 121.85 80.72 27.71 80.72" />
  </clipPath>
</defs>
<script> <![CDATA[
(function(N){var k=/[\.\/]/,L=/\s*,\s*/,C=function(a,d){return a-d},a,v,y={n:{}},M=function(){for(var a=0,d=this.length;a<d;a++)if("undefined"!=typeof this[a])return this[a]},A=function(){for(var a=this.length;--a;)if("undefined"!=typeof this[a])return this[a]},w=function(k,d){k=String(k);var f=v,n=Array.prototype.slice.call(arguments,2),u=w.listeners(k),p=0,b,q=[],e={},l=[],r=a;l.firstDefined=M;l.lastDefined=A;a=k;for(var s=v=0,x=u.length;s<x;s++)"zIndex"in u[s]&&(q.push(u[s].zIndex),0>u[s].zIndex&&
(e[u[s].zIndex]=u[s]));for(q.sort(C);0>q[p];)if(b=e[q[p++] ],l.push(b.apply(d,n)),v)return v=f,l;for(s=0;s<x;s++)if(b=u[s],"zIndex"in b)if(b.zIndex==q[p]){l.push(b.apply(d,n));if(v)break;do if(p++,(b=e[q[p] ])&&l.push(b.apply(d,n)),v)break;while(b)}else e[b.zIndex]=b;else if(l.push(b.apply(d,n)),v)break;v=f;a=r;return l};w._events=y;w.listeners=function(a){a=a.split(k);var d=y,f,n,u,p,b,q,e,l=[d],r=[];u=0;for(p=a.length;u<p;u++){e=[];b=0;for(q=l.length;b<q;b++)for(d=l[b].n,f=[d[a[u] ],d["*"] ],n=2;n--;)if(d=
f[n])e.push(d),r=r.concat(d.f||[]);l=e}return r};w.on=function(a,d){a=String(a);if("function"!=typeof d)return function(){};for(var f=a.split(L),n=0,u=f.length;n<u;n++)(function(a){a=a.split(k);for(var b=y,f,e=0,l=a.length;e<l;e++)b=b.n,b=b.hasOwnProperty(a[e])&&b[a[e] ]||(b[a[e] ]={n:{}});b.f=b.f||[];e=0;for(l=b.f.length;e<l;e++)if(b.f[e]==d){f=!0;break}!f&&b.f.push(d)})(f[n]);return function(a){+a==+a&&(d.zIndex=+a)}};w.f=function(a){var d=[].slice.call(arguments,1);return function(){w.apply(null,
[a,null].concat(d).concat([].slice.call(arguments,0)))}};w.stop=function(){v=1};w.nt=function(k){return k?(new RegExp("(?:\\.|\\/|^)"+k+"(?:\\.|\\/|$)")).test(a):a};w.nts=function(){return a.split(k)};w.off=w.unbind=function(a,d){if(a){var f=a.split(L);if(1<f.length)for(var n=0,u=f.length;n<u;n++)w.off(f[n],d);else{for(var f=a.split(k),p,b,q,e,l=[y],n=0,u=f.length;n<u;n++)for(e=0;e<l.length;e+=q.length-2){q=[e,1];p=l[e].n;if("*"!=f[n])p[f[n] ]&&q.push(p[f[n] ]);else for(b in p)p.hasOwnProperty(b)&&
q.push(p[b]);l.splice.apply(l,q)}n=0;for(u=l.length;n<u;n++)for(p=l[n];p.n;){if(d){if(p.f){e=0;for(f=p.f.length;e<f;e++)if(p.f[e]==d){p.f.splice(e,1);break}!p.f.length&&delete p.f}for(b in p.n)if(p.n.hasOwnProperty(b)&&p.n[b].f){q=p.n[b].f;e=0;for(f=q.length;e<f;e++)if(q[e]==d){q.splice(e,1);break}!q.length&&delete p.n[b].f}}else for(b in delete p.f,p.n)p.n.hasOwnProperty(b)&&p.n[b].f&&delete p.n[b].f;p=p.n}}}else w._events=y={n:{}}};w.once=function(a,d){var f=function(){w.unbind(a,f);return d.apply(this,
arguments)};return w.on(a,f)};w.version="0.4.2";w.toString=function(){return"You are running Eve 0.4.2"};"undefined"!=typeof module&&module.exports?module.exports=w:"function"===typeof define&&define.amd?define("eve",[],function(){return w}):N.eve=w})(this);
(function(N,k){"function"===typeof define&&define.amd?define("Snap.svg",["eve"],function(L){return k(N,L)}):k(N,N.eve)})(this,function(N,k){var L=function(a){var k={},y=N.requestAnimationFrame||N.webkitRequestAnimationFrame||N.mozRequestAnimationFrame||N.oRequestAnimationFrame||N.msRequestAnimationFrame||function(a){setTimeout(a,16)},M=Array.isArray||function(a){return a instanceof Array||"[object Array]"==Object.prototype.toString.call(a)},A=0,w="M"+(+new Date).toString(36),z=function(a){if(null==
a)return this.s;var b=this.s-a;this.b+=this.dur*b;this.B+=this.dur*b;this.s=a},d=function(a){if(null==a)return this.spd;this.spd=a},f=function(a){if(null==a)return this.dur;this.s=this.s*a/this.dur;this.dur=a},n=function(){delete k[this.id];this.update();a("mina.stop."+this.id,this)},u=function(){this.pdif||(delete k[this.id],this.update(),this.pdif=this.get()-this.b)},p=function(){this.pdif&&(this.b=this.get()-this.pdif,delete this.pdif,k[this.id]=this)},b=function(){var a;if(M(this.start)){a=[];
for(var b=0,e=this.start.length;b<e;b++)a[b]=+this.start[b]+(this.end[b]-this.start[b])*this.easing(this.s)}else a=+this.start+(this.end-this.start)*this.easing(this.s);this.set(a)},q=function(){var l=0,b;for(b in k)if(k.hasOwnProperty(b)){var e=k[b],f=e.get();l++;e.s=(f-e.b)/(e.dur/e.spd);1<=e.s&&(delete k[b],e.s=1,l--,function(b){setTimeout(function(){a("mina.finish."+b.id,b)})}(e));e.update()}l&&y(q)},e=function(a,r,s,x,G,h,J){a={id:w+(A++).toString(36),start:a,end:r,b:s,s:0,dur:x-s,spd:1,get:G,
set:h,easing:J||e.linear,status:z,speed:d,duration:f,stop:n,pause:u,resume:p,update:b};k[a.id]=a;r=0;for(var K in k)if(k.hasOwnProperty(K)&&(r++,2==r))break;1==r&&y(q);return a};e.time=Date.now||function(){return+new Date};e.getById=function(a){return k[a]||null};e.linear=function(a){return a};e.easeout=function(a){return Math.pow(a,1.7)};e.easein=function(a){return Math.pow(a,0.48)};e.easeinout=function(a){if(1==a)return 1;if(0==a)return 0;var b=0.48-a/1.04,e=Math.sqrt(0.1734+b*b);a=e-b;a=Math.pow(Math.abs(a),
1/3)*(0>a?-1:1);b=-e-b;b=Math.pow(Math.abs(b),1/3)*(0>b?-1:1);a=a+b+0.5;return 3*(1-a)*a*a+a*a*a};e.backin=function(a){return 1==a?1:a*a*(2.70158*a-1.70158)};e.backout=function(a){if(0==a)return 0;a-=1;return a*a*(2.70158*a+1.70158)+1};e.elastic=function(a){return a==!!a?a:Math.pow(2,-10*a)*Math.sin(2*(a-0.075)*Math.PI/0.3)+1};e.bounce=function(a){a<1/2.75?a*=7.5625*a:a<2/2.75?(a-=1.5/2.75,a=7.5625*a*a+0.75):a<2.5/2.75?(a-=2.25/2.75,a=7.5625*a*a+0.9375):(a-=2.625/2.75,a=7.5625*a*a+0.984375);return a};
return N.mina=e}("undefined"==typeof k?function(){}:k),C=function(){function a(c,t){if(c){if(c.tagName)return x(c);if(y(c,"array")&&a.set)return a.set.apply(a,c);if(c instanceof e)return c;if(null==t)return c=G.doc.querySelector(c),x(c)}return new s(null==c?"100%":c,null==t?"100%":t)}function v(c,a){if(a){"#text"==c&&(c=G.doc.createTextNode(a.text||""));"string"==typeof c&&(c=v(c));if("string"==typeof a)return"xlink:"==a.substring(0,6)?c.getAttributeNS(m,a.substring(6)):"xml:"==a.substring(0,4)?c.getAttributeNS(la,
a.substring(4)):c.getAttribute(a);for(var da in a)if(a[h](da)){var b=J(a[da]);b?"xlink:"==da.substring(0,6)?c.setAttributeNS(m,da.substring(6),b):"xml:"==da.substring(0,4)?c.setAttributeNS(la,da.substring(4),b):c.setAttribute(da,b):c.removeAttribute(da)}}else c=G.doc.createElementNS(la,c);return c}function y(c,a){a=J.prototype.toLowerCase.call(a);return"finite"==a?isFinite(c):"array"==a&&(c instanceof Array||Array.isArray&&Array.isArray(c))?!0:"null"==a&&null===c||a==typeof c&&null!==c||"object"==
a&&c===Object(c)||$.call(c).slice(8,-1).toLowerCase()==a}function M(c){if("function"==typeof c||Object(c)!==c)return c;var a=new c.constructor,b;for(b in c)c[h](b)&&(a[b]=M(c[b]));return a}function A(c,a,b){function m(){var e=Array.prototype.slice.call(arguments,0),f=e.join("\u2400"),d=m.cache=m.cache||{},l=m.count=m.count||[];if(d[h](f)){a:for(var e=l,l=f,B=0,H=e.length;B<H;B++)if(e[B]===l){e.push(e.splice(B,1)[0]);break a}return b?b(d[f]):d[f]}1E3<=l.length&&delete d[l.shift()];l.push(f);d[f]=c.apply(a,
e);return b?b(d[f]):d[f]}return m}function w(c,a,b,m,e,f){return null==e?(c-=b,a-=m,c||a?(180*I.atan2(-a,-c)/C+540)%360:0):w(c,a,e,f)-w(b,m,e,f)}function z(c){return c%360*C/180}function d(c){var a=[];c=c.replace(/(?:^|\s)(\w+)\(([^)]+)\)/g,function(c,b,m){m=m.split(/\s*,\s*|\s+/);"rotate"==b&&1==m.length&&m.push(0,0);"scale"==b&&(2<m.length?m=m.slice(0,2):2==m.length&&m.push(0,0),1==m.length&&m.push(m[0],0,0));"skewX"==b?a.push(["m",1,0,I.tan(z(m[0])),1,0,0]):"skewY"==b?a.push(["m",1,I.tan(z(m[0])),
0,1,0,0]):a.push([b.charAt(0)].concat(m));return c});return a}function f(c,t){var b=O(c),m=new a.Matrix;if(b)for(var e=0,f=b.length;e<f;e++){var h=b[e],d=h.length,B=J(h[0]).toLowerCase(),H=h[0]!=B,l=H?m.invert():0,E;"t"==B&&2==d?m.translate(h[1],0):"t"==B&&3==d?H?(d=l.x(0,0),B=l.y(0,0),H=l.x(h[1],h[2]),l=l.y(h[1],h[2]),m.translate(H-d,l-B)):m.translate(h[1],h[2]):"r"==B?2==d?(E=E||t,m.rotate(h[1],E.x+E.width/2,E.y+E.height/2)):4==d&&(H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.rotate(h[1],H,l)):m.rotate(h[1],
h[2],h[3])):"s"==B?2==d||3==d?(E=E||t,m.scale(h[1],h[d-1],E.x+E.width/2,E.y+E.height/2)):4==d?H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.scale(h[1],h[1],H,l)):m.scale(h[1],h[1],h[2],h[3]):5==d&&(H?(H=l.x(h[3],h[4]),l=l.y(h[3],h[4]),m.scale(h[1],h[2],H,l)):m.scale(h[1],h[2],h[3],h[4])):"m"==B&&7==d&&m.add(h[1],h[2],h[3],h[4],h[5],h[6])}return m}function n(c,t){if(null==t){var m=!0;t="linearGradient"==c.type||"radialGradient"==c.type?c.node.getAttribute("gradientTransform"):"pattern"==c.type?c.node.getAttribute("patternTransform"):
c.node.getAttribute("transform");if(!t)return new a.Matrix;t=d(t)}else t=a._.rgTransform.test(t)?J(t).replace(/\.{3}|\u2026/g,c._.transform||aa):d(t),y(t,"array")&&(t=a.path?a.path.toString.call(t):J(t)),c._.transform=t;var b=f(t,c.getBBox(1));if(m)return b;c.matrix=b}function u(c){c=c.node.ownerSVGElement&&x(c.node.ownerSVGElement)||c.node.parentNode&&x(c.node.parentNode)||a.select("svg")||a(0,0);var t=c.select("defs"),t=null==t?!1:t.node;t||(t=r("defs",c.node).node);return t}function p(c){return c.node.ownerSVGElement&&
x(c.node.ownerSVGElement)||a.select("svg")}function b(c,a,m){function b(c){if(null==c)return aa;if(c==+c)return c;v(B,{width:c});try{return B.getBBox().width}catch(a){return 0}}function h(c){if(null==c)return aa;if(c==+c)return c;v(B,{height:c});try{return B.getBBox().height}catch(a){return 0}}function e(b,B){null==a?d[b]=B(c.attr(b)||0):b==a&&(d=B(null==m?c.attr(b)||0:m))}var f=p(c).node,d={},B=f.querySelector(".svg---mgr");B||(B=v("rect"),v(B,{x:-9E9,y:-9E9,width:10,height:10,"class":"svg---mgr",
fill:"none"}),f.appendChild(B));switch(c.type){case "rect":e("rx",b),e("ry",h);case "image":e("width",b),e("height",h);case "text":e("x",b);e("y",h);break;case "circle":e("cx",b);e("cy",h);e("r",b);break;case "ellipse":e("cx",b);e("cy",h);e("rx",b);e("ry",h);break;case "line":e("x1",b);e("x2",b);e("y1",h);e("y2",h);break;case "marker":e("refX",b);e("markerWidth",b);e("refY",h);e("markerHeight",h);break;case "radialGradient":e("fx",b);e("fy",h);break;case "tspan":e("dx",b);e("dy",h);break;default:e(a,
b)}f.removeChild(B);return d}function q(c){y(c,"array")||(c=Array.prototype.slice.call(arguments,0));for(var a=0,b=0,m=this.node;this[a];)delete this[a++];for(a=0;a<c.length;a++)"set"==c[a].type?c[a].forEach(function(c){m.appendChild(c.node)}):m.appendChild(c[a].node);for(var h=m.childNodes,a=0;a<h.length;a++)this[b++]=x(h[a]);return this}function e(c){if(c.snap in E)return E[c.snap];var a=this.id=V(),b;try{b=c.ownerSVGElement}catch(m){}this.node=c;b&&(this.paper=new s(b));this.type=c.tagName;this.anims=
{};this._={transform:[]};c.snap=a;E[a]=this;"g"==this.type&&(this.add=q);if(this.type in{g:1,mask:1,pattern:1})for(var e in s.prototype)s.prototype[h](e)&&(this[e]=s.prototype[e])}function l(c){this.node=c}function r(c,a){var b=v(c);a.appendChild(b);return x(b)}function s(c,a){var b,m,f,d=s.prototype;if(c&&"svg"==c.tagName){if(c.snap in E)return E[c.snap];var l=c.ownerDocument;b=new e(c);m=c.getElementsByTagName("desc")[0];f=c.getElementsByTagName("defs")[0];m||(m=v("desc"),m.appendChild(l.createTextNode("Created with Snap")),
b.node.appendChild(m));f||(f=v("defs"),b.node.appendChild(f));b.defs=f;for(var ca in d)d[h](ca)&&(b[ca]=d[ca]);b.paper=b.root=b}else b=r("svg",G.doc.body),v(b.node,{height:a,version:1.1,width:c,xmlns:la});return b}function x(c){return!c||c instanceof e||c instanceof l?c:c.tagName&&"svg"==c.tagName.toLowerCase()?new s(c):c.tagName&&"object"==c.tagName.toLowerCase()&&"image/svg+xml"==c.type?new s(c.contentDocument.getElementsByTagName("svg")[0]):new e(c)}a.version="0.3.0";a.toString=function(){return"Snap v"+
this.version};a._={};var G={win:N,doc:N.document};a._.glob=G;var h="hasOwnProperty",J=String,K=parseFloat,U=parseInt,I=Math,P=I.max,Q=I.min,Y=I.abs,C=I.PI,aa="",$=Object.prototype.toString,F=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\))\s*$/i;a._.separator=
RegExp("[,\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]+");var S=RegExp("[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*"),X={hs:1,rg:1},W=RegExp("([a-z])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)",
"ig"),ma=RegExp("([rstm])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)","ig"),Z=RegExp("(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*",
"ig"),na=0,ba="S"+(+new Date).toString(36),V=function(){return ba+(na++).toString(36)},m="http://www.w3.org/1999/xlink",la="http://www.w3.org/2000/svg",E={},ca=a.url=function(c){return"url('#"+c+"')"};a._.$=v;a._.id=V;a.format=function(){var c=/\{([^\}]+)\}/g,a=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,b=function(c,b,m){var h=m;b.replace(a,function(c,a,b,m,t){a=a||m;h&&(a in h&&(h=h[a]),"function"==typeof h&&t&&(h=h()))});return h=(null==h||h==m?c:h)+""};return function(a,m){return J(a).replace(c,
function(c,a){return b(c,a,m)})}}();a._.clone=M;a._.cacher=A;a.rad=z;a.deg=function(c){return 180*c/C%360};a.angle=w;a.is=y;a.snapTo=function(c,a,b){b=y(b,"finite")?b:10;if(y(c,"array"))for(var m=c.length;m--;){if(Y(c[m]-a)<=b)return c[m]}else{c=+c;m=a%c;if(m<b)return a-m;if(m>c-b)return a-m+c}return a};a.getRGB=A(function(c){if(!c||(c=J(c)).indexOf("-")+1)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};if("none"==c)return{r:-1,g:-1,b:-1,hex:"none",toString:ka};!X[h](c.toLowerCase().substring(0,
2))&&"#"!=c.charAt()&&(c=T(c));if(!c)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};var b,m,e,f,d;if(c=c.match(F)){c[2]&&(e=U(c[2].substring(5),16),m=U(c[2].substring(3,5),16),b=U(c[2].substring(1,3),16));c[3]&&(e=U((d=c[3].charAt(3))+d,16),m=U((d=c[3].charAt(2))+d,16),b=U((d=c[3].charAt(1))+d,16));c[4]&&(d=c[4].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b*=2.55),m=K(d[1]),"%"==d[1].slice(-1)&&(m*=2.55),e=K(d[2]),"%"==d[2].slice(-1)&&(e*=2.55),"rgba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),
d[3]&&"%"==d[3].slice(-1)&&(f/=100));if(c[5])return d=c[5].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsb2rgb(b,m,e,f);if(c[6])return d=c[6].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),
"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsla"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsl2rgb(b,m,e,f);b=Q(I.round(b),255);m=Q(I.round(m),255);e=Q(I.round(e),255);f=Q(P(f,0),1);c={r:b,g:m,b:e,toString:ka};c.hex="#"+(16777216|e|m<<8|b<<16).toString(16).slice(1);c.opacity=y(f,"finite")?f:1;return c}return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka}},a);a.hsb=A(function(c,b,m){return a.hsb2rgb(c,b,m).hex});a.hsl=A(function(c,b,m){return a.hsl2rgb(c,
b,m).hex});a.rgb=A(function(c,a,b,m){if(y(m,"finite")){var e=I.round;return"rgba("+[e(c),e(a),e(b),+m.toFixed(2)]+")"}return"#"+(16777216|b|a<<8|c<<16).toString(16).slice(1)});var T=function(c){var a=G.doc.getElementsByTagName("head")[0]||G.doc.getElementsByTagName("svg")[0];T=A(function(c){if("red"==c.toLowerCase())return"rgb(255, 0, 0)";a.style.color="rgb(255, 0, 0)";a.style.color=c;c=G.doc.defaultView.getComputedStyle(a,aa).getPropertyValue("color");return"rgb(255, 0, 0)"==c?null:c});return T(c)},
qa=function(){return"hsb("+[this.h,this.s,this.b]+")"},ra=function(){return"hsl("+[this.h,this.s,this.l]+")"},ka=function(){return 1==this.opacity||null==this.opacity?this.hex:"rgba("+[this.r,this.g,this.b,this.opacity]+")"},D=function(c,b,m){null==b&&y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&(m=c.b,b=c.g,c=c.r);null==b&&y(c,string)&&(m=a.getRGB(c),c=m.r,b=m.g,m=m.b);if(1<c||1<b||1<m)c/=255,b/=255,m/=255;return[c,b,m]},oa=function(c,b,m,e){c=I.round(255*c);b=I.round(255*b);m=I.round(255*m);c={r:c,
g:b,b:m,opacity:y(e,"finite")?e:1,hex:a.rgb(c,b,m),toString:ka};y(e,"finite")&&(c.opacity=e);return c};a.color=function(c){var b;y(c,"object")&&"h"in c&&"s"in c&&"b"in c?(b=a.hsb2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):y(c,"object")&&"h"in c&&"s"in c&&"l"in c?(b=a.hsl2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):(y(c,"string")&&(c=a.getRGB(c)),y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&!("error"in c)?(b=a.rgb2hsl(c),c.h=b.h,c.s=b.s,c.l=b.l,b=a.rgb2hsb(c),c.v=b.b):(c={hex:"none"},
c.r=c.g=c.b=c.h=c.s=c.v=c.l=-1,c.error=1));c.toString=ka;return c};a.hsb2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"b"in c&&(b=c.b,a=c.s,c=c.h,m=c.o);var e,h,d;c=360*c%360/60;d=b*a;a=d*(1-Y(c%2-1));b=e=h=b-d;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.hsl2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"l"in c&&(b=c.l,a=c.s,c=c.h);if(1<c||1<a||1<b)c/=360,a/=100,b/=100;var e,h,d;c=360*c%360/60;d=2*a*(0.5>b?b:1-b);a=d*(1-Y(c%2-1));b=e=
h=b-d/2;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.rgb2hsb=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e;m=P(c,a,b);e=m-Q(c,a,b);c=((0==e?0:m==c?(a-b)/e:m==a?(b-c)/e+2:(c-a)/e+4)+360)%6*60/360;return{h:c,s:0==e?0:e/m,b:m,toString:qa}};a.rgb2hsl=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e,h;m=P(c,a,b);e=Q(c,a,b);h=m-e;c=((0==h?0:m==c?(a-b)/h:m==a?(b-c)/h+2:(c-a)/h+4)+360)%6*60/360;m=(m+e)/2;return{h:c,s:0==h?0:0.5>m?h/(2*m):h/(2-2*
m),l:m,toString:ra}};a.parsePathString=function(c){if(!c)return null;var b=a.path(c);if(b.arr)return a.path.clone(b.arr);var m={a:7,c:6,o:2,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,u:3,z:0},e=[];y(c,"array")&&y(c[0],"array")&&(e=a.path.clone(c));e.length||J(c).replace(W,function(c,a,b){var h=[];c=a.toLowerCase();b.replace(Z,function(c,a){a&&h.push(+a)});"m"==c&&2<h.length&&(e.push([a].concat(h.splice(0,2))),c="l",a="m"==a?"l":"L");"o"==c&&1==h.length&&e.push([a,h[0] ]);if("r"==c)e.push([a].concat(h));else for(;h.length>=
m[c]&&(e.push([a].concat(h.splice(0,m[c]))),m[c]););});e.toString=a.path.toString;b.arr=a.path.clone(e);return e};var O=a.parseTransformString=function(c){if(!c)return null;var b=[];y(c,"array")&&y(c[0],"array")&&(b=a.path.clone(c));b.length||J(c).replace(ma,function(c,a,m){var e=[];a.toLowerCase();m.replace(Z,function(c,a){a&&e.push(+a)});b.push([a].concat(e))});b.toString=a.path.toString;return b};a._.svgTransform2string=d;a._.rgTransform=RegExp("^[a-z][\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*-?\\.?\\d",
"i");a._.transform2matrix=f;a._unit2px=b;a._.getSomeDefs=u;a._.getSomeSVG=p;a.select=function(c){return x(G.doc.querySelector(c))};a.selectAll=function(c){c=G.doc.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};setInterval(function(){for(var c in E)if(E[h](c)){var a=E[c],b=a.node;("svg"!=a.type&&!b.ownerSVGElement||"svg"==a.type&&(!b.parentNode||"ownerSVGElement"in b.parentNode&&!b.ownerSVGElement))&&delete E[c]}},1E4);(function(c){function m(c){function a(c,
b){var m=v(c.node,b);(m=(m=m&&m.match(d))&&m[2])&&"#"==m.charAt()&&(m=m.substring(1))&&(f[m]=(f[m]||[]).concat(function(a){var m={};m[b]=ca(a);v(c.node,m)}))}function b(c){var a=v(c.node,"xlink:href");a&&"#"==a.charAt()&&(a=a.substring(1))&&(f[a]=(f[a]||[]).concat(function(a){c.attr("xlink:href","#"+a)}))}var e=c.selectAll("*"),h,d=/^\s*url\(("|'|)(.*)\1\)\s*$/;c=[];for(var f={},l=0,E=e.length;l<E;l++){h=e[l];a(h,"fill");a(h,"stroke");a(h,"filter");a(h,"mask");a(h,"clip-path");b(h);var t=v(h.node,
"id");t&&(v(h.node,{id:h.id}),c.push({old:t,id:h.id}))}l=0;for(E=c.length;l<E;l++)if(e=f[c[l].old])for(h=0,t=e.length;h<t;h++)e[h](c[l].id)}function e(c,a,b){return function(m){m=m.slice(c,a);1==m.length&&(m=m[0]);return b?b(m):m}}function d(c){return function(){var a=c?"<"+this.type:"",b=this.node.attributes,m=this.node.childNodes;if(c)for(var e=0,h=b.length;e<h;e++)a+=" "+b[e].name+'="'+b[e].value.replace(/"/g,'\\"')+'"';if(m.length){c&&(a+=">");e=0;for(h=m.length;e<h;e++)3==m[e].nodeType?a+=m[e].nodeValue:
1==m[e].nodeType&&(a+=x(m[e]).toString());c&&(a+="</"+this.type+">")}else c&&(a+="/>");return a}}c.attr=function(c,a){if(!c)return this;if(y(c,"string"))if(1<arguments.length){var b={};b[c]=a;c=b}else return k("snap.util.getattr."+c,this).firstDefined();for(var m in c)c[h](m)&&k("snap.util.attr."+m,this,c[m]);return this};c.getBBox=function(c){if(!a.Matrix||!a.path)return this.node.getBBox();var b=this,m=new a.Matrix;if(b.removed)return a._.box();for(;"use"==b.type;)if(c||(m=m.add(b.transform().localMatrix.translate(b.attr("x")||
0,b.attr("y")||0))),b.original)b=b.original;else var e=b.attr("xlink:href"),b=b.original=b.node.ownerDocument.getElementById(e.substring(e.indexOf("#")+1));var e=b._,h=a.path.get[b.type]||a.path.get.deflt;try{if(c)return e.bboxwt=h?a.path.getBBox(b.realPath=h(b)):a._.box(b.node.getBBox()),a._.box(e.bboxwt);b.realPath=h(b);b.matrix=b.transform().localMatrix;e.bbox=a.path.getBBox(a.path.map(b.realPath,m.add(b.matrix)));return a._.box(e.bbox)}catch(d){return a._.box()}};var f=function(){return this.string};
c.transform=function(c){var b=this._;if(null==c){var m=this;c=new a.Matrix(this.node.getCTM());for(var e=n(this),h=[e],d=new a.Matrix,l=e.toTransformString(),b=J(e)==J(this.matrix)?J(b.transform):l;"svg"!=m.type&&(m=m.parent());)h.push(n(m));for(m=h.length;m--;)d.add(h[m]);return{string:b,globalMatrix:c,totalMatrix:d,localMatrix:e,diffMatrix:c.clone().add(e.invert()),global:c.toTransformString(),total:d.toTransformString(),local:l,toString:f}}c instanceof a.Matrix?this.matrix=c:n(this,c);this.node&&
("linearGradient"==this.type||"radialGradient"==this.type?v(this.node,{gradientTransform:this.matrix}):"pattern"==this.type?v(this.node,{patternTransform:this.matrix}):v(this.node,{transform:this.matrix}));return this};c.parent=function(){return x(this.node.parentNode)};c.append=c.add=function(c){if(c){if("set"==c.type){var a=this;c.forEach(function(c){a.add(c)});return this}c=x(c);this.node.appendChild(c.node);c.paper=this.paper}return this};c.appendTo=function(c){c&&(c=x(c),c.append(this));return this};
c.prepend=function(c){if(c){if("set"==c.type){var a=this,b;c.forEach(function(c){b?b.after(c):a.prepend(c);b=c});return this}c=x(c);var m=c.parent();this.node.insertBefore(c.node,this.node.firstChild);this.add&&this.add();c.paper=this.paper;this.parent()&&this.parent().add();m&&m.add()}return this};c.prependTo=function(c){c=x(c);c.prepend(this);return this};c.before=function(c){if("set"==c.type){var a=this;c.forEach(function(c){var b=c.parent();a.node.parentNode.insertBefore(c.node,a.node);b&&b.add()});
this.parent().add();return this}c=x(c);var b=c.parent();this.node.parentNode.insertBefore(c.node,this.node);this.parent()&&this.parent().add();b&&b.add();c.paper=this.paper;return this};c.after=function(c){c=x(c);var a=c.parent();this.node.nextSibling?this.node.parentNode.insertBefore(c.node,this.node.nextSibling):this.node.parentNode.appendChild(c.node);this.parent()&&this.parent().add();a&&a.add();c.paper=this.paper;return this};c.insertBefore=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,
c.node);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.insertAfter=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,c.node.nextSibling);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.remove=function(){var c=this.parent();this.node.parentNode&&this.node.parentNode.removeChild(this.node);delete this.paper;this.removed=!0;c&&c.add();return this};c.select=function(c){return x(this.node.querySelector(c))};c.selectAll=
function(c){c=this.node.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};c.asPX=function(c,a){null==a&&(a=this.attr(c));return+b(this,c,a)};c.use=function(){var c,a=this.node.id;a||(a=this.id,v(this.node,{id:a}));c="linearGradient"==this.type||"radialGradient"==this.type||"pattern"==this.type?r(this.type,this.node.parentNode):r("use",this.node.parentNode);v(c.node,{"xlink:href":"#"+a});c.original=this;return c};var l=/\S+/g;c.addClass=function(c){var a=(c||
"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h,d;if(a.length){for(e=0;d=a[e++];)h=m.indexOf(d),~h||m.push(d);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.removeClass=function(c){var a=(c||"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h;if(m.length){for(e=0;h=a[e++];)h=m.indexOf(h),~h&&m.splice(h,1);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.hasClass=function(c){return!!~(this.node.className.baseVal.match(l)||[]).indexOf(c)};
c.toggleClass=function(c,a){if(null!=a)return a?this.addClass(c):this.removeClass(c);var b=(c||"").match(l)||[],m=this.node,e=m.className.baseVal,h=e.match(l)||[],d,f,E;for(d=0;E=b[d++];)f=h.indexOf(E),~f?h.splice(f,1):h.push(E);b=h.join(" ");e!=b&&(m.className.baseVal=b);return this};c.clone=function(){var c=x(this.node.cloneNode(!0));v(c.node,"id")&&v(c.node,{id:c.id});m(c);c.insertAfter(this);return c};c.toDefs=function(){u(this).appendChild(this.node);return this};c.pattern=c.toPattern=function(c,
a,b,m){var e=r("pattern",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,c=c.x);v(e.node,{x:c,y:a,width:b,height:m,patternUnits:"userSpaceOnUse",id:e.id,viewBox:[c,a,b,m].join(" ")});e.node.appendChild(this.node);return e};c.marker=function(c,a,b,m,e,h){var d=r("marker",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,e=c.refX||c.cx,h=c.refY||c.cy,c=c.x);v(d.node,{viewBox:[c,a,b,m].join(" "),markerWidth:b,markerHeight:m,
orient:"auto",refX:e||0,refY:h||0,id:d.id});d.node.appendChild(this.node);return d};var E=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);this.attr=c;this.dur=a;b&&(this.easing=b);m&&(this.callback=m)};a._.Animation=E;a.animation=function(c,a,b,m){return new E(c,a,b,m)};c.inAnim=function(){var c=[],a;for(a in this.anims)this.anims[h](a)&&function(a){c.push({anim:new E(a._attrs,a.dur,a.easing,a._callback),mina:a,curStatus:a.status(),status:function(c){return a.status(c)},stop:function(){a.stop()}})}(this.anims[a]);
return c};a.animate=function(c,a,b,m,e,h){"function"!=typeof e||e.length||(h=e,e=L.linear);var d=L.time();c=L(c,a,d,d+m,L.time,b,e);h&&k.once("mina.finish."+c.id,h);return c};c.stop=function(){for(var c=this.inAnim(),a=0,b=c.length;a<b;a++)c[a].stop();return this};c.animate=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);c instanceof E&&(m=c.callback,b=c.easing,a=b.dur,c=c.attr);var d=[],f=[],l={},t,ca,n,T=this,q;for(q in c)if(c[h](q)){T.equal?(n=T.equal(q,J(c[q])),t=n.from,ca=
n.to,n=n.f):(t=+T.attr(q),ca=+c[q]);var la=y(t,"array")?t.length:1;l[q]=e(d.length,d.length+la,n);d=d.concat(t);f=f.concat(ca)}t=L.time();var p=L(d,f,t,t+a,L.time,function(c){var a={},b;for(b in l)l[h](b)&&(a[b]=l[b](c));T.attr(a)},b);T.anims[p.id]=p;p._attrs=c;p._callback=m;k("snap.animcreated."+T.id,p);k.once("mina.finish."+p.id,function(){delete T.anims[p.id];m&&m.call(T)});k.once("mina.stop."+p.id,function(){delete T.anims[p.id]});return T};var T={};c.data=function(c,b){var m=T[this.id]=T[this.id]||
{};if(0==arguments.length)return k("snap.data.get."+this.id,this,m,null),m;if(1==arguments.length){if(a.is(c,"object")){for(var e in c)c[h](e)&&this.data(e,c[e]);return this}k("snap.data.get."+this.id,this,m[c],c);return m[c]}m[c]=b;k("snap.data.set."+this.id,this,b,c);return this};c.removeData=function(c){null==c?T[this.id]={}:T[this.id]&&delete T[this.id][c];return this};c.outerSVG=c.toString=d(1);c.innerSVG=d()})(e.prototype);a.parse=function(c){var a=G.doc.createDocumentFragment(),b=!0,m=G.doc.createElement("div");
c=J(c);c.match(/^\s*<\s*svg(?:\s|>)/)||(c="<svg>"+c+"</svg>",b=!1);m.innerHTML=c;if(c=m.getElementsByTagName("svg")[0])if(b)a=c;else for(;c.firstChild;)a.appendChild(c.firstChild);m.innerHTML=aa;return new l(a)};l.prototype.select=e.prototype.select;l.prototype.selectAll=e.prototype.selectAll;a.fragment=function(){for(var c=Array.prototype.slice.call(arguments,0),b=G.doc.createDocumentFragment(),m=0,e=c.length;m<e;m++){var h=c[m];h.node&&h.node.nodeType&&b.appendChild(h.node);h.nodeType&&b.appendChild(h);
"string"==typeof h&&b.appendChild(a.parse(h).node)}return new l(b)};a._.make=r;a._.wrap=x;s.prototype.el=function(c,a){var b=r(c,this.node);a&&b.attr(a);return b};k.on("snap.util.getattr",function(){var c=k.nt(),c=c.substring(c.lastIndexOf(".")+1),a=c.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});return pa[h](a)?this.node.ownerDocument.defaultView.getComputedStyle(this.node,null).getPropertyValue(a):v(this.node,c)});var pa={"alignment-baseline":0,"baseline-shift":0,clip:0,"clip-path":0,
"clip-rule":0,color:0,"color-interpolation":0,"color-interpolation-filters":0,"color-profile":0,"color-rendering":0,cursor:0,direction:0,display:0,"dominant-baseline":0,"enable-background":0,fill:0,"fill-opacity":0,"fill-rule":0,filter:0,"flood-color":0,"flood-opacity":0,font:0,"font-family":0,"font-size":0,"font-size-adjust":0,"font-stretch":0,"font-style":0,"font-variant":0,"font-weight":0,"glyph-orientation-horizontal":0,"glyph-orientation-vertical":0,"image-rendering":0,kerning:0,"letter-spacing":0,
"lighting-color":0,marker:0,"marker-end":0,"marker-mid":0,"marker-start":0,mask:0,opacity:0,overflow:0,"pointer-events":0,"shape-rendering":0,"stop-color":0,"stop-opacity":0,stroke:0,"stroke-dasharray":0,"stroke-dashoffset":0,"stroke-linecap":0,"stroke-linejoin":0,"stroke-miterlimit":0,"stroke-opacity":0,"stroke-width":0,"text-anchor":0,"text-decoration":0,"text-rendering":0,"unicode-bidi":0,visibility:0,"word-spacing":0,"writing-mode":0};k.on("snap.util.attr",function(c){var a=k.nt(),b={},a=a.substring(a.lastIndexOf(".")+
1);b[a]=c;var m=a.replace(/-(\w)/gi,function(c,a){return a.toUpperCase()}),a=a.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});pa[h](a)?this.node.style[m]=null==c?aa:c:v(this.node,b)});a.ajax=function(c,a,b,m){var e=new XMLHttpRequest,h=V();if(e){if(y(a,"function"))m=b,b=a,a=null;else if(y(a,"object")){var d=[],f;for(f in a)a.hasOwnProperty(f)&&d.push(encodeURIComponent(f)+"="+encodeURIComponent(a[f]));a=d.join("&")}e.open(a?"POST":"GET",c,!0);a&&(e.setRequestHeader("X-Requested-With","XMLHttpRequest"),
e.setRequestHeader("Content-type","application/x-www-form-urlencoded"));b&&(k.once("snap.ajax."+h+".0",b),k.once("snap.ajax."+h+".200",b),k.once("snap.ajax."+h+".304",b));e.onreadystatechange=function(){4==e.readyState&&k("snap.ajax."+h+"."+e.status,m,e)};if(4==e.readyState)return e;e.send(a);return e}};a.load=function(c,b,m){a.ajax(c,function(c){c=a.parse(c.responseText);m?b.call(m,c):b(c)})};a.getElementByPoint=function(c,a){var b,m,e=G.doc.elementFromPoint(c,a);if(G.win.opera&&"svg"==e.tagName){b=
e;m=b.getBoundingClientRect();b=b.ownerDocument;var h=b.body,d=b.documentElement;b=m.top+(g.win.pageYOffset||d.scrollTop||h.scrollTop)-(d.clientTop||h.clientTop||0);m=m.left+(g.win.pageXOffset||d.scrollLeft||h.scrollLeft)-(d.clientLeft||h.clientLeft||0);h=e.createSVGRect();h.x=c-m;h.y=a-b;h.width=h.height=1;b=e.getIntersectionList(h,null);b.length&&(e=b[b.length-1])}return e?x(e):null};a.plugin=function(c){c(a,e,s,G,l)};return G.win.Snap=a}();C.plugin(function(a,k,y,M,A){function w(a,d,f,b,q,e){null==
d&&"[object SVGMatrix]"==z.call(a)?(this.a=a.a,this.b=a.b,this.c=a.c,this.d=a.d,this.e=a.e,this.f=a.f):null!=a?(this.a=+a,this.b=+d,this.c=+f,this.d=+b,this.e=+q,this.f=+e):(this.a=1,this.c=this.b=0,this.d=1,this.f=this.e=0)}var z=Object.prototype.toString,d=String,f=Math;(function(n){function k(a){return a[0]*a[0]+a[1]*a[1]}function p(a){var d=f.sqrt(k(a));a[0]&&(a[0]/=d);a[1]&&(a[1]/=d)}n.add=function(a,d,e,f,n,p){var k=[[],[],[] ],u=[[this.a,this.c,this.e],[this.b,this.d,this.f],[0,0,1] ];d=[[a,
e,n],[d,f,p],[0,0,1] ];a&&a instanceof w&&(d=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1] ]);for(a=0;3>a;a++)for(e=0;3>e;e++){for(f=n=0;3>f;f++)n+=u[a][f]*d[f][e];k[a][e]=n}this.a=k[0][0];this.b=k[1][0];this.c=k[0][1];this.d=k[1][1];this.e=k[0][2];this.f=k[1][2];return this};n.invert=function(){var a=this.a*this.d-this.b*this.c;return new w(this.d/a,-this.b/a,-this.c/a,this.a/a,(this.c*this.f-this.d*this.e)/a,(this.b*this.e-this.a*this.f)/a)};n.clone=function(){return new w(this.a,this.b,this.c,this.d,this.e,
this.f)};n.translate=function(a,d){return this.add(1,0,0,1,a,d)};n.scale=function(a,d,e,f){null==d&&(d=a);(e||f)&&this.add(1,0,0,1,e,f);this.add(a,0,0,d,0,0);(e||f)&&this.add(1,0,0,1,-e,-f);return this};n.rotate=function(b,d,e){b=a.rad(b);d=d||0;e=e||0;var l=+f.cos(b).toFixed(9);b=+f.sin(b).toFixed(9);this.add(l,b,-b,l,d,e);return this.add(1,0,0,1,-d,-e)};n.x=function(a,d){return a*this.a+d*this.c+this.e};n.y=function(a,d){return a*this.b+d*this.d+this.f};n.get=function(a){return+this[d.fromCharCode(97+
a)].toFixed(4)};n.toString=function(){return"matrix("+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)].join()+")"};n.offset=function(){return[this.e.toFixed(4),this.f.toFixed(4)]};n.determinant=function(){return this.a*this.d-this.b*this.c};n.split=function(){var b={};b.dx=this.e;b.dy=this.f;var d=[[this.a,this.c],[this.b,this.d] ];b.scalex=f.sqrt(k(d[0]));p(d[0]);b.shear=d[0][0]*d[1][0]+d[0][1]*d[1][1];d[1]=[d[1][0]-d[0][0]*b.shear,d[1][1]-d[0][1]*b.shear];b.scaley=f.sqrt(k(d[1]));
p(d[1]);b.shear/=b.scaley;0>this.determinant()&&(b.scalex=-b.scalex);var e=-d[0][1],d=d[1][1];0>d?(b.rotate=a.deg(f.acos(d)),0>e&&(b.rotate=360-b.rotate)):b.rotate=a.deg(f.asin(e));b.isSimple=!+b.shear.toFixed(9)&&(b.scalex.toFixed(9)==b.scaley.toFixed(9)||!b.rotate);b.isSuperSimple=!+b.shear.toFixed(9)&&b.scalex.toFixed(9)==b.scaley.toFixed(9)&&!b.rotate;b.noRotation=!+b.shear.toFixed(9)&&!b.rotate;return b};n.toTransformString=function(a){a=a||this.split();if(+a.shear.toFixed(9))return"m"+[this.get(0),
this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)];a.scalex=+a.scalex.toFixed(4);a.scaley=+a.scaley.toFixed(4);a.rotate=+a.rotate.toFixed(4);return(a.dx||a.dy?"t"+[+a.dx.toFixed(4),+a.dy.toFixed(4)]:"")+(1!=a.scalex||1!=a.scaley?"s"+[a.scalex,a.scaley,0,0]:"")+(a.rotate?"r"+[+a.rotate.toFixed(4),0,0]:"")}})(w.prototype);a.Matrix=w;a.matrix=function(a,d,f,b,k,e){return new w(a,d,f,b,k,e)}});C.plugin(function(a,v,y,M,A){function w(h){return function(d){k.stop();d instanceof A&&1==d.node.childNodes.length&&
("radialGradient"==d.node.firstChild.tagName||"linearGradient"==d.node.firstChild.tagName||"pattern"==d.node.firstChild.tagName)&&(d=d.node.firstChild,b(this).appendChild(d),d=u(d));if(d instanceof v)if("radialGradient"==d.type||"linearGradient"==d.type||"pattern"==d.type){d.node.id||e(d.node,{id:d.id});var f=l(d.node.id)}else f=d.attr(h);else f=a.color(d),f.error?(f=a(b(this).ownerSVGElement).gradient(d))?(f.node.id||e(f.node,{id:f.id}),f=l(f.node.id)):f=d:f=r(f);d={};d[h]=f;e(this.node,d);this.node.style[h]=
x}}function z(a){k.stop();a==+a&&(a+="px");this.node.style.fontSize=a}function d(a){var b=[];a=a.childNodes;for(var e=0,f=a.length;e<f;e++){var l=a[e];3==l.nodeType&&b.push(l.nodeValue);"tspan"==l.tagName&&(1==l.childNodes.length&&3==l.firstChild.nodeType?b.push(l.firstChild.nodeValue):b.push(d(l)))}return b}function f(){k.stop();return this.node.style.fontSize}var n=a._.make,u=a._.wrap,p=a.is,b=a._.getSomeDefs,q=/^url\(#?([^)]+)\)$/,e=a._.$,l=a.url,r=String,s=a._.separator,x="";k.on("snap.util.attr.mask",
function(a){if(a instanceof v||a instanceof A){k.stop();a instanceof A&&1==a.node.childNodes.length&&(a=a.node.firstChild,b(this).appendChild(a),a=u(a));if("mask"==a.type)var d=a;else d=n("mask",b(this)),d.node.appendChild(a.node);!d.node.id&&e(d.node,{id:d.id});e(this.node,{mask:l(d.id)})}});(function(a){k.on("snap.util.attr.clip",a);k.on("snap.util.attr.clip-path",a);k.on("snap.util.attr.clipPath",a)})(function(a){if(a instanceof v||a instanceof A){k.stop();if("clipPath"==a.type)var d=a;else d=
n("clipPath",b(this)),d.node.appendChild(a.node),!d.node.id&&e(d.node,{id:d.id});e(this.node,{"clip-path":l(d.id)})}});k.on("snap.util.attr.fill",w("fill"));k.on("snap.util.attr.stroke",w("stroke"));var G=/^([lr])(?:\(([^)]*)\))?(.*)$/i;k.on("snap.util.grad.parse",function(a){a=r(a);var b=a.match(G);if(!b)return null;a=b[1];var e=b[2],b=b[3],e=e.split(/\s*,\s*/).map(function(a){return+a==a?+a:a});1==e.length&&0==e[0]&&(e=[]);b=b.split("-");b=b.map(function(a){a=a.split(":");var b={color:a[0]};a[1]&&
(b.offset=parseFloat(a[1]));return b});return{type:a,params:e,stops:b}});k.on("snap.util.attr.d",function(b){k.stop();p(b,"array")&&p(b[0],"array")&&(b=a.path.toString.call(b));b=r(b);b.match(/[ruo]/i)&&(b=a.path.toAbsolute(b));e(this.node,{d:b})})(-1);k.on("snap.util.attr.#text",function(a){k.stop();a=r(a);for(a=M.doc.createTextNode(a);this.node.firstChild;)this.node.removeChild(this.node.firstChild);this.node.appendChild(a)})(-1);k.on("snap.util.attr.path",function(a){k.stop();this.attr({d:a})})(-1);
k.on("snap.util.attr.class",function(a){k.stop();this.node.className.baseVal=a})(-1);k.on("snap.util.attr.viewBox",function(a){a=p(a,"object")&&"x"in a?[a.x,a.y,a.width,a.height].join(" "):p(a,"array")?a.join(" "):a;e(this.node,{viewBox:a});k.stop()})(-1);k.on("snap.util.attr.transform",function(a){this.transform(a);k.stop()})(-1);k.on("snap.util.attr.r",function(a){"rect"==this.type&&(k.stop(),e(this.node,{rx:a,ry:a}))})(-1);k.on("snap.util.attr.textpath",function(a){k.stop();if("text"==this.type){var d,
f;if(!a&&this.textPath){for(a=this.textPath;a.node.firstChild;)this.node.appendChild(a.node.firstChild);a.remove();delete this.textPath}else if(p(a,"string")?(d=b(this),a=u(d.parentNode).path(a),d.appendChild(a.node),d=a.id,a.attr({id:d})):(a=u(a),a instanceof v&&(d=a.attr("id"),d||(d=a.id,a.attr({id:d})))),d)if(a=this.textPath,f=this.node,a)a.attr({"xlink:href":"#"+d});else{for(a=e("textPath",{"xlink:href":"#"+d});f.firstChild;)a.appendChild(f.firstChild);f.appendChild(a);this.textPath=u(a)}}})(-1);
k.on("snap.util.attr.text",function(a){if("text"==this.type){for(var b=this.node,d=function(a){var b=e("tspan");if(p(a,"array"))for(var f=0;f<a.length;f++)b.appendChild(d(a[f]));else b.appendChild(M.doc.createTextNode(a));b.normalize&&b.normalize();return b};b.firstChild;)b.removeChild(b.firstChild);for(a=d(a);a.firstChild;)b.appendChild(a.firstChild)}k.stop()})(-1);k.on("snap.util.attr.fontSize",z)(-1);k.on("snap.util.attr.font-size",z)(-1);k.on("snap.util.getattr.transform",function(){k.stop();
return this.transform()})(-1);k.on("snap.util.getattr.textpath",function(){k.stop();return this.textPath})(-1);(function(){function b(d){return function(){k.stop();var b=M.doc.defaultView.getComputedStyle(this.node,null).getPropertyValue("marker-"+d);return"none"==b?b:a(M.doc.getElementById(b.match(q)[1]))}}function d(a){return function(b){k.stop();var d="marker"+a.charAt(0).toUpperCase()+a.substring(1);if(""==b||!b)this.node.style[d]="none";else if("marker"==b.type){var f=b.node.id;f||e(b.node,{id:b.id});
this.node.style[d]=l(f)}}}k.on("snap.util.getattr.marker-end",b("end"))(-1);k.on("snap.util.getattr.markerEnd",b("end"))(-1);k.on("snap.util.getattr.marker-start",b("start"))(-1);k.on("snap.util.getattr.markerStart",b("start"))(-1);k.on("snap.util.getattr.marker-mid",b("mid"))(-1);k.on("snap.util.getattr.markerMid",b("mid"))(-1);k.on("snap.util.attr.marker-end",d("end"))(-1);k.on("snap.util.attr.markerEnd",d("end"))(-1);k.on("snap.util.attr.marker-start",d("start"))(-1);k.on("snap.util.attr.markerStart",
d("start"))(-1);k.on("snap.util.attr.marker-mid",d("mid"))(-1);k.on("snap.util.attr.markerMid",d("mid"))(-1)})();k.on("snap.util.getattr.r",function(){if("rect"==this.type&&e(this.node,"rx")==e(this.node,"ry"))return k.stop(),e(this.node,"rx")})(-1);k.on("snap.util.getattr.text",function(){if("text"==this.type||"tspan"==this.type){k.stop();var a=d(this.node);return 1==a.length?a[0]:a}})(-1);k.on("snap.util.getattr.#text",function(){return this.node.textContent})(-1);k.on("snap.util.getattr.viewBox",
function(){k.stop();var b=e(this.node,"viewBox");if(b)return b=b.split(s),a._.box(+b[0],+b[1],+b[2],+b[3])})(-1);k.on("snap.util.getattr.points",function(){var a=e(this.node,"points");k.stop();if(a)return a.split(s)})(-1);k.on("snap.util.getattr.path",function(){var a=e(this.node,"d");k.stop();return a})(-1);k.on("snap.util.getattr.class",function(){return this.node.className.baseVal})(-1);k.on("snap.util.getattr.fontSize",f)(-1);k.on("snap.util.getattr.font-size",f)(-1)});C.plugin(function(a,v,y,
M,A){function w(a){return a}function z(a){return function(b){return+b.toFixed(3)+a}}var d={"+":function(a,b){return a+b},"-":function(a,b){return a-b},"/":function(a,b){return a/b},"*":function(a,b){return a*b}},f=String,n=/[a-z]+$/i,u=/^\s*([+\-\/*])\s*=\s*([\d.eE+\-]+)\s*([^\d\s]+)?\s*$/;k.on("snap.util.attr",function(a){if(a=f(a).match(u)){var b=k.nt(),b=b.substring(b.lastIndexOf(".")+1),q=this.attr(b),e={};k.stop();var l=a[3]||"",r=q.match(n),s=d[a[1] ];r&&r==l?a=s(parseFloat(q),+a[2]):(q=this.asPX(b),
a=s(this.asPX(b),this.asPX(b,a[2]+l)));isNaN(q)||isNaN(a)||(e[b]=a,this.attr(e))}})(-10);k.on("snap.util.equal",function(a,b){var q=f(this.attr(a)||""),e=f(b).match(u);if(e){k.stop();var l=e[3]||"",r=q.match(n),s=d[e[1] ];if(r&&r==l)return{from:parseFloat(q),to:s(parseFloat(q),+e[2]),f:z(r)};q=this.asPX(a);return{from:q,to:s(q,this.asPX(a,e[2]+l)),f:w}}})(-10)});C.plugin(function(a,v,y,M,A){var w=y.prototype,z=a.is;w.rect=function(a,d,k,p,b,q){var e;null==q&&(q=b);z(a,"object")&&"[object Object]"==
a?e=a:null!=a&&(e={x:a,y:d,width:k,height:p},null!=b&&(e.rx=b,e.ry=q));return this.el("rect",e)};w.circle=function(a,d,k){var p;z(a,"object")&&"[object Object]"==a?p=a:null!=a&&(p={cx:a,cy:d,r:k});return this.el("circle",p)};var d=function(){function a(){this.parentNode.removeChild(this)}return function(d,k){var p=M.doc.createElement("img"),b=M.doc.body;p.style.cssText="position:absolute;left:-9999em;top:-9999em";p.onload=function(){k.call(p);p.onload=p.onerror=null;b.removeChild(p)};p.onerror=a;
b.appendChild(p);p.src=d}}();w.image=function(f,n,k,p,b){var q=this.el("image");if(z(f,"object")&&"src"in f)q.attr(f);else if(null!=f){var e={"xlink:href":f,preserveAspectRatio:"none"};null!=n&&null!=k&&(e.x=n,e.y=k);null!=p&&null!=b?(e.width=p,e.height=b):d(f,function(){a._.$(q.node,{width:this.offsetWidth,height:this.offsetHeight})});a._.$(q.node,e)}return q};w.ellipse=function(a,d,k,p){var b;z(a,"object")&&"[object Object]"==a?b=a:null!=a&&(b={cx:a,cy:d,rx:k,ry:p});return this.el("ellipse",b)};
w.path=function(a){var d;z(a,"object")&&!z(a,"array")?d=a:a&&(d={d:a});return this.el("path",d)};w.group=w.g=function(a){var d=this.el("g");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.svg=function(a,d,k,p,b,q,e,l){var r={};z(a,"object")&&null==d?r=a:(null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l]));return this.el("svg",r)};w.mask=function(a){var d=
this.el("mask");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.ptrn=function(a,d,k,p,b,q,e,l){if(z(a,"object"))var r=a;else arguments.length?(r={},null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l])):r={patternUnits:"userSpaceOnUse"};return this.el("pattern",r)};w.use=function(a){return null!=a?(make("use",this.node),a instanceof v&&(a.attr("id")||
a.attr({id:ID()}),a=a.attr("id")),this.el("use",{"xlink:href":a})):v.prototype.use.call(this)};w.text=function(a,d,k){var p={};z(a,"object")?p=a:null!=a&&(p={x:a,y:d,text:k||""});return this.el("text",p)};w.line=function(a,d,k,p){var b={};z(a,"object")?b=a:null!=a&&(b={x1:a,x2:k,y1:d,y2:p});return this.el("line",b)};w.polyline=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polyline",d)};
w.polygon=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polygon",d)};(function(){function d(){return this.selectAll("stop")}function n(b,d){var f=e("stop"),k={offset:+d+"%"};b=a.color(b);k["stop-color"]=b.hex;1>b.opacity&&(k["stop-opacity"]=b.opacity);e(f,k);this.node.appendChild(f);return this}function u(){if("linearGradient"==this.type){var b=e(this.node,"x1")||0,d=e(this.node,"x2")||
1,f=e(this.node,"y1")||0,k=e(this.node,"y2")||0;return a._.box(b,f,math.abs(d-b),math.abs(k-f))}b=this.node.r||0;return a._.box((this.node.cx||0.5)-b,(this.node.cy||0.5)-b,2*b,2*b)}function p(a,d){function f(a,b){for(var d=(b-u)/(a-w),e=w;e<a;e++)h[e].offset=+(+u+d*(e-w)).toFixed(2);w=a;u=b}var n=k("snap.util.grad.parse",null,d).firstDefined(),p;if(!n)return null;n.params.unshift(a);p="l"==n.type.toLowerCase()?b.apply(0,n.params):q.apply(0,n.params);n.type!=n.type.toLowerCase()&&e(p.node,{gradientUnits:"userSpaceOnUse"});
var h=n.stops,n=h.length,u=0,w=0;n--;for(var v=0;v<n;v++)"offset"in h[v]&&f(v,h[v].offset);h[n].offset=h[n].offset||100;f(n,h[n].offset);for(v=0;v<=n;v++){var y=h[v];p.addStop(y.color,y.offset)}return p}function b(b,k,p,q,w){b=a._.make("linearGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{x1:k,y1:p,x2:q,y2:w});return b}function q(b,k,p,q,w,h){b=a._.make("radialGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{cx:k,cy:p,r:q});null!=w&&null!=h&&e(b.node,{fx:w,fy:h});
return b}var e=a._.$;w.gradient=function(a){return p(this.defs,a)};w.gradientLinear=function(a,d,e,f){return b(this.defs,a,d,e,f)};w.gradientRadial=function(a,b,d,e,f){return q(this.defs,a,b,d,e,f)};w.toString=function(){var b=this.node.ownerDocument,d=b.createDocumentFragment(),b=b.createElement("div"),e=this.node.cloneNode(!0);d.appendChild(b);b.appendChild(e);a._.$(e,{xmlns:"http://www.w3.org/2000/svg"});b=b.innerHTML;d.removeChild(d.firstChild);return b};w.clear=function(){for(var a=this.node.firstChild,
b;a;)b=a.nextSibling,"defs"!=a.tagName?a.parentNode.removeChild(a):w.clear.call({node:a}),a=b}})()});C.plugin(function(a,k,y,M){function A(a){var b=A.ps=A.ps||{};b[a]?b[a].sleep=100:b[a]={sleep:100};setTimeout(function(){for(var d in b)b[L](d)&&d!=a&&(b[d].sleep--,!b[d].sleep&&delete b[d])});return b[a]}function w(a,b,d,e){null==a&&(a=b=d=e=0);null==b&&(b=a.y,d=a.width,e=a.height,a=a.x);return{x:a,y:b,width:d,w:d,height:e,h:e,x2:a+d,y2:b+e,cx:a+d/2,cy:b+e/2,r1:F.min(d,e)/2,r2:F.max(d,e)/2,r0:F.sqrt(d*
d+e*e)/2,path:s(a,b,d,e),vb:[a,b,d,e].join(" ")}}function z(){return this.join(",").replace(N,"$1")}function d(a){a=C(a);a.toString=z;return a}function f(a,b,d,h,f,k,l,n,p){if(null==p)return e(a,b,d,h,f,k,l,n);if(0>p||e(a,b,d,h,f,k,l,n)<p)p=void 0;else{var q=0.5,O=1-q,s;for(s=e(a,b,d,h,f,k,l,n,O);0.01<Z(s-p);)q/=2,O+=(s<p?1:-1)*q,s=e(a,b,d,h,f,k,l,n,O);p=O}return u(a,b,d,h,f,k,l,n,p)}function n(b,d){function e(a){return+(+a).toFixed(3)}return a._.cacher(function(a,h,l){a instanceof k&&(a=a.attr("d"));
a=I(a);for(var n,p,D,q,O="",s={},c=0,t=0,r=a.length;t<r;t++){D=a[t];if("M"==D[0])n=+D[1],p=+D[2];else{q=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6]);if(c+q>h){if(d&&!s.start){n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c);O+=["C"+e(n.start.x),e(n.start.y),e(n.m.x),e(n.m.y),e(n.x),e(n.y)];if(l)return O;s.start=O;O=["M"+e(n.x),e(n.y)+"C"+e(n.n.x),e(n.n.y),e(n.end.x),e(n.end.y),e(D[5]),e(D[6])].join();c+=q;n=+D[5];p=+D[6];continue}if(!b&&!d)return n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c)}c+=q;n=+D[5];p=+D[6]}O+=
D.shift()+D}s.end=O;return n=b?c:d?s:u(n,p,D[0],D[1],D[2],D[3],D[4],D[5],1)},null,a._.clone)}function u(a,b,d,e,h,f,k,l,n){var p=1-n,q=ma(p,3),s=ma(p,2),c=n*n,t=c*n,r=q*a+3*s*n*d+3*p*n*n*h+t*k,q=q*b+3*s*n*e+3*p*n*n*f+t*l,s=a+2*n*(d-a)+c*(h-2*d+a),t=b+2*n*(e-b)+c*(f-2*e+b),x=d+2*n*(h-d)+c*(k-2*h+d),c=e+2*n*(f-e)+c*(l-2*f+e);a=p*a+n*d;b=p*b+n*e;h=p*h+n*k;f=p*f+n*l;l=90-180*F.atan2(s-x,t-c)/S;return{x:r,y:q,m:{x:s,y:t},n:{x:x,y:c},start:{x:a,y:b},end:{x:h,y:f},alpha:l}}function p(b,d,e,h,f,n,k,l){a.is(b,
"array")||(b=[b,d,e,h,f,n,k,l]);b=U.apply(null,b);return w(b.min.x,b.min.y,b.max.x-b.min.x,b.max.y-b.min.y)}function b(a,b,d){return b>=a.x&&b<=a.x+a.width&&d>=a.y&&d<=a.y+a.height}function q(a,d){a=w(a);d=w(d);return b(d,a.x,a.y)||b(d,a.x2,a.y)||b(d,a.x,a.y2)||b(d,a.x2,a.y2)||b(a,d.x,d.y)||b(a,d.x2,d.y)||b(a,d.x,d.y2)||b(a,d.x2,d.y2)||(a.x<d.x2&&a.x>d.x||d.x<a.x2&&d.x>a.x)&&(a.y<d.y2&&a.y>d.y||d.y<a.y2&&d.y>a.y)}function e(a,b,d,e,h,f,n,k,l){null==l&&(l=1);l=(1<l?1:0>l?0:l)/2;for(var p=[-0.1252,
0.1252,-0.3678,0.3678,-0.5873,0.5873,-0.7699,0.7699,-0.9041,0.9041,-0.9816,0.9816],q=[0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],s=0,c=0;12>c;c++)var t=l*p[c]+l,r=t*(t*(-3*a+9*d-9*h+3*n)+6*a-12*d+6*h)-3*a+3*d,t=t*(t*(-3*b+9*e-9*f+3*k)+6*b-12*e+6*f)-3*b+3*e,s=s+q[c]*F.sqrt(r*r+t*t);return l*s}function l(a,b,d){a=I(a);b=I(b);for(var h,f,l,n,k,s,r,O,x,c,t=d?0:[],w=0,v=a.length;w<v;w++)if(x=a[w],"M"==x[0])h=k=x[1],f=s=x[2];else{"C"==x[0]?(x=[h,f].concat(x.slice(1)),
h=x[6],f=x[7]):(x=[h,f,h,f,k,s,k,s],h=k,f=s);for(var G=0,y=b.length;G<y;G++)if(c=b[G],"M"==c[0])l=r=c[1],n=O=c[2];else{"C"==c[0]?(c=[l,n].concat(c.slice(1)),l=c[6],n=c[7]):(c=[l,n,l,n,r,O,r,O],l=r,n=O);var z;var K=x,B=c;z=d;var H=p(K),J=p(B);if(q(H,J)){for(var H=e.apply(0,K),J=e.apply(0,B),H=~~(H/8),J=~~(J/8),U=[],A=[],F={},M=z?0:[],P=0;P<H+1;P++){var C=u.apply(0,K.concat(P/H));U.push({x:C.x,y:C.y,t:P/H})}for(P=0;P<J+1;P++)C=u.apply(0,B.concat(P/J)),A.push({x:C.x,y:C.y,t:P/J});for(P=0;P<H;P++)for(K=
0;K<J;K++){var Q=U[P],L=U[P+1],B=A[K],C=A[K+1],N=0.001>Z(L.x-Q.x)?"y":"x",S=0.001>Z(C.x-B.x)?"y":"x",R;R=Q.x;var Y=Q.y,V=L.x,ea=L.y,fa=B.x,ga=B.y,ha=C.x,ia=C.y;if(W(R,V)<X(fa,ha)||X(R,V)>W(fa,ha)||W(Y,ea)<X(ga,ia)||X(Y,ea)>W(ga,ia))R=void 0;else{var $=(R*ea-Y*V)*(fa-ha)-(R-V)*(fa*ia-ga*ha),aa=(R*ea-Y*V)*(ga-ia)-(Y-ea)*(fa*ia-ga*ha),ja=(R-V)*(ga-ia)-(Y-ea)*(fa-ha);if(ja){var $=$/ja,aa=aa/ja,ja=+$.toFixed(2),ba=+aa.toFixed(2);R=ja<+X(R,V).toFixed(2)||ja>+W(R,V).toFixed(2)||ja<+X(fa,ha).toFixed(2)||
ja>+W(fa,ha).toFixed(2)||ba<+X(Y,ea).toFixed(2)||ba>+W(Y,ea).toFixed(2)||ba<+X(ga,ia).toFixed(2)||ba>+W(ga,ia).toFixed(2)?void 0:{x:$,y:aa}}else R=void 0}R&&F[R.x.toFixed(4)]!=R.y.toFixed(4)&&(F[R.x.toFixed(4)]=R.y.toFixed(4),Q=Q.t+Z((R[N]-Q[N])/(L[N]-Q[N]))*(L.t-Q.t),B=B.t+Z((R[S]-B[S])/(C[S]-B[S]))*(C.t-B.t),0<=Q&&1>=Q&&0<=B&&1>=B&&(z?M++:M.push({x:R.x,y:R.y,t1:Q,t2:B})))}z=M}else z=z?0:[];if(d)t+=z;else{H=0;for(J=z.length;H<J;H++)z[H].segment1=w,z[H].segment2=G,z[H].bez1=x,z[H].bez2=c;t=t.concat(z)}}}return t}
function r(a){var b=A(a);if(b.bbox)return C(b.bbox);if(!a)return w();a=I(a);for(var d=0,e=0,h=[],f=[],l,n=0,k=a.length;n<k;n++)l=a[n],"M"==l[0]?(d=l[1],e=l[2],h.push(d),f.push(e)):(d=U(d,e,l[1],l[2],l[3],l[4],l[5],l[6]),h=h.concat(d.min.x,d.max.x),f=f.concat(d.min.y,d.max.y),d=l[5],e=l[6]);a=X.apply(0,h);l=X.apply(0,f);h=W.apply(0,h);f=W.apply(0,f);f=w(a,l,h-a,f-l);b.bbox=C(f);return f}function s(a,b,d,e,h){if(h)return[["M",+a+ +h,b],["l",d-2*h,0],["a",h,h,0,0,1,h,h],["l",0,e-2*h],["a",h,h,0,0,1,
-h,h],["l",2*h-d,0],["a",h,h,0,0,1,-h,-h],["l",0,2*h-e],["a",h,h,0,0,1,h,-h],["z"] ];a=[["M",a,b],["l",d,0],["l",0,e],["l",-d,0],["z"] ];a.toString=z;return a}function x(a,b,d,e,h){null==h&&null==e&&(e=d);a=+a;b=+b;d=+d;e=+e;if(null!=h){var f=Math.PI/180,l=a+d*Math.cos(-e*f);a+=d*Math.cos(-h*f);var n=b+d*Math.sin(-e*f);b+=d*Math.sin(-h*f);d=[["M",l,n],["A",d,d,0,+(180<h-e),0,a,b] ]}else d=[["M",a,b],["m",0,-e],["a",d,e,0,1,1,0,2*e],["a",d,e,0,1,1,0,-2*e],["z"] ];d.toString=z;return d}function G(b){var e=
A(b);if(e.abs)return d(e.abs);Q(b,"array")&&Q(b&&b[0],"array")||(b=a.parsePathString(b));if(!b||!b.length)return[["M",0,0] ];var h=[],f=0,l=0,n=0,k=0,p=0;"M"==b[0][0]&&(f=+b[0][1],l=+b[0][2],n=f,k=l,p++,h[0]=["M",f,l]);for(var q=3==b.length&&"M"==b[0][0]&&"R"==b[1][0].toUpperCase()&&"Z"==b[2][0].toUpperCase(),s,r,w=p,c=b.length;w<c;w++){h.push(s=[]);r=b[w];p=r[0];if(p!=p.toUpperCase())switch(s[0]=p.toUpperCase(),s[0]){case "A":s[1]=r[1];s[2]=r[2];s[3]=r[3];s[4]=r[4];s[5]=r[5];s[6]=+r[6]+f;s[7]=+r[7]+
l;break;case "V":s[1]=+r[1]+l;break;case "H":s[1]=+r[1]+f;break;case "R":for(var t=[f,l].concat(r.slice(1)),u=2,v=t.length;u<v;u++)t[u]=+t[u]+f,t[++u]=+t[u]+l;h.pop();h=h.concat(P(t,q));break;case "O":h.pop();t=x(f,l,r[1],r[2]);t.push(t[0]);h=h.concat(t);break;case "U":h.pop();h=h.concat(x(f,l,r[1],r[2],r[3]));s=["U"].concat(h[h.length-1].slice(-2));break;case "M":n=+r[1]+f,k=+r[2]+l;default:for(u=1,v=r.length;u<v;u++)s[u]=+r[u]+(u%2?f:l)}else if("R"==p)t=[f,l].concat(r.slice(1)),h.pop(),h=h.concat(P(t,
q)),s=["R"].concat(r.slice(-2));else if("O"==p)h.pop(),t=x(f,l,r[1],r[2]),t.push(t[0]),h=h.concat(t);else if("U"==p)h.pop(),h=h.concat(x(f,l,r[1],r[2],r[3])),s=["U"].concat(h[h.length-1].slice(-2));else for(t=0,u=r.length;t<u;t++)s[t]=r[t];p=p.toUpperCase();if("O"!=p)switch(s[0]){case "Z":f=+n;l=+k;break;case "H":f=s[1];break;case "V":l=s[1];break;case "M":n=s[s.length-2],k=s[s.length-1];default:f=s[s.length-2],l=s[s.length-1]}}h.toString=z;e.abs=d(h);return h}function h(a,b,d,e){return[a,b,d,e,d,
e]}function J(a,b,d,e,h,f){var l=1/3,n=2/3;return[l*a+n*d,l*b+n*e,l*h+n*d,l*f+n*e,h,f]}function K(b,d,e,h,f,l,n,k,p,s){var r=120*S/180,q=S/180*(+f||0),c=[],t,x=a._.cacher(function(a,b,c){var d=a*F.cos(c)-b*F.sin(c);a=a*F.sin(c)+b*F.cos(c);return{x:d,y:a}});if(s)v=s[0],t=s[1],l=s[2],u=s[3];else{t=x(b,d,-q);b=t.x;d=t.y;t=x(k,p,-q);k=t.x;p=t.y;F.cos(S/180*f);F.sin(S/180*f);t=(b-k)/2;v=(d-p)/2;u=t*t/(e*e)+v*v/(h*h);1<u&&(u=F.sqrt(u),e*=u,h*=u);var u=e*e,w=h*h,u=(l==n?-1:1)*F.sqrt(Z((u*w-u*v*v-w*t*t)/
(u*v*v+w*t*t)));l=u*e*v/h+(b+k)/2;var u=u*-h*t/e+(d+p)/2,v=F.asin(((d-u)/h).toFixed(9));t=F.asin(((p-u)/h).toFixed(9));v=b<l?S-v:v;t=k<l?S-t:t;0>v&&(v=2*S+v);0>t&&(t=2*S+t);n&&v>t&&(v-=2*S);!n&&t>v&&(t-=2*S)}if(Z(t-v)>r){var c=t,w=k,G=p;t=v+r*(n&&t>v?1:-1);k=l+e*F.cos(t);p=u+h*F.sin(t);c=K(k,p,e,h,f,0,n,w,G,[t,c,l,u])}l=t-v;f=F.cos(v);r=F.sin(v);n=F.cos(t);t=F.sin(t);l=F.tan(l/4);e=4/3*e*l;l*=4/3*h;h=[b,d];b=[b+e*r,d-l*f];d=[k+e*t,p-l*n];k=[k,p];b[0]=2*h[0]-b[0];b[1]=2*h[1]-b[1];if(s)return[b,d,k].concat(c);
c=[b,d,k].concat(c).join().split(",");s=[];k=0;for(p=c.length;k<p;k++)s[k]=k%2?x(c[k-1],c[k],q).y:x(c[k],c[k+1],q).x;return s}function U(a,b,d,e,h,f,l,k){for(var n=[],p=[[],[] ],s,r,c,t,q=0;2>q;++q)0==q?(r=6*a-12*d+6*h,s=-3*a+9*d-9*h+3*l,c=3*d-3*a):(r=6*b-12*e+6*f,s=-3*b+9*e-9*f+3*k,c=3*e-3*b),1E-12>Z(s)?1E-12>Z(r)||(s=-c/r,0<s&&1>s&&n.push(s)):(t=r*r-4*c*s,c=F.sqrt(t),0>t||(t=(-r+c)/(2*s),0<t&&1>t&&n.push(t),s=(-r-c)/(2*s),0<s&&1>s&&n.push(s)));for(r=q=n.length;q--;)s=n[q],c=1-s,p[0][q]=c*c*c*a+3*
c*c*s*d+3*c*s*s*h+s*s*s*l,p[1][q]=c*c*c*b+3*c*c*s*e+3*c*s*s*f+s*s*s*k;p[0][r]=a;p[1][r]=b;p[0][r+1]=l;p[1][r+1]=k;p[0].length=p[1].length=r+2;return{min:{x:X.apply(0,p[0]),y:X.apply(0,p[1])},max:{x:W.apply(0,p[0]),y:W.apply(0,p[1])}}}function I(a,b){var e=!b&&A(a);if(!b&&e.curve)return d(e.curve);var f=G(a),l=b&&G(b),n={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},k={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},p=function(a,b,c){if(!a)return["C",b.x,b.y,b.x,b.y,b.x,b.y];a[0]in{T:1,Q:1}||(b.qx=b.qy=null);
switch(a[0]){case "M":b.X=a[1];b.Y=a[2];break;case "A":a=["C"].concat(K.apply(0,[b.x,b.y].concat(a.slice(1))));break;case "S":"C"==c||"S"==c?(c=2*b.x-b.bx,b=2*b.y-b.by):(c=b.x,b=b.y);a=["C",c,b].concat(a.slice(1));break;case "T":"Q"==c||"T"==c?(b.qx=2*b.x-b.qx,b.qy=2*b.y-b.qy):(b.qx=b.x,b.qy=b.y);a=["C"].concat(J(b.x,b.y,b.qx,b.qy,a[1],a[2]));break;case "Q":b.qx=a[1];b.qy=a[2];a=["C"].concat(J(b.x,b.y,a[1],a[2],a[3],a[4]));break;case "L":a=["C"].concat(h(b.x,b.y,a[1],a[2]));break;case "H":a=["C"].concat(h(b.x,
b.y,a[1],b.y));break;case "V":a=["C"].concat(h(b.x,b.y,b.x,a[1]));break;case "Z":a=["C"].concat(h(b.x,b.y,b.X,b.Y))}return a},s=function(a,b){if(7<a[b].length){a[b].shift();for(var c=a[b];c.length;)q[b]="A",l&&(u[b]="A"),a.splice(b++,0,["C"].concat(c.splice(0,6)));a.splice(b,1);v=W(f.length,l&&l.length||0)}},r=function(a,b,c,d,e){a&&b&&"M"==a[e][0]&&"M"!=b[e][0]&&(b.splice(e,0,["M",d.x,d.y]),c.bx=0,c.by=0,c.x=a[e][1],c.y=a[e][2],v=W(f.length,l&&l.length||0))},q=[],u=[],c="",t="",x=0,v=W(f.length,
l&&l.length||0);for(;x<v;x++){f[x]&&(c=f[x][0]);"C"!=c&&(q[x]=c,x&&(t=q[x-1]));f[x]=p(f[x],n,t);"A"!=q[x]&&"C"==c&&(q[x]="C");s(f,x);l&&(l[x]&&(c=l[x][0]),"C"!=c&&(u[x]=c,x&&(t=u[x-1])),l[x]=p(l[x],k,t),"A"!=u[x]&&"C"==c&&(u[x]="C"),s(l,x));r(f,l,n,k,x);r(l,f,k,n,x);var w=f[x],z=l&&l[x],y=w.length,U=l&&z.length;n.x=w[y-2];n.y=w[y-1];n.bx=$(w[y-4])||n.x;n.by=$(w[y-3])||n.y;k.bx=l&&($(z[U-4])||k.x);k.by=l&&($(z[U-3])||k.y);k.x=l&&z[U-2];k.y=l&&z[U-1]}l||(e.curve=d(f));return l?[f,l]:f}function P(a,
b){for(var d=[],e=0,h=a.length;h-2*!b>e;e+=2){var f=[{x:+a[e-2],y:+a[e-1]},{x:+a[e],y:+a[e+1]},{x:+a[e+2],y:+a[e+3]},{x:+a[e+4],y:+a[e+5]}];b?e?h-4==e?f[3]={x:+a[0],y:+a[1]}:h-2==e&&(f[2]={x:+a[0],y:+a[1]},f[3]={x:+a[2],y:+a[3]}):f[0]={x:+a[h-2],y:+a[h-1]}:h-4==e?f[3]=f[2]:e||(f[0]={x:+a[e],y:+a[e+1]});d.push(["C",(-f[0].x+6*f[1].x+f[2].x)/6,(-f[0].y+6*f[1].y+f[2].y)/6,(f[1].x+6*f[2].x-f[3].x)/6,(f[1].y+6*f[2].y-f[3].y)/6,f[2].x,f[2].y])}return d}y=k.prototype;var Q=a.is,C=a._.clone,L="hasOwnProperty",
N=/,?([a-z]),?/gi,$=parseFloat,F=Math,S=F.PI,X=F.min,W=F.max,ma=F.pow,Z=F.abs;M=n(1);var na=n(),ba=n(0,1),V=a._unit2px;a.path=A;a.path.getTotalLength=M;a.path.getPointAtLength=na;a.path.getSubpath=function(a,b,d){if(1E-6>this.getTotalLength(a)-d)return ba(a,b).end;a=ba(a,d,1);return b?ba(a,b).end:a};y.getTotalLength=function(){if(this.node.getTotalLength)return this.node.getTotalLength()};y.getPointAtLength=function(a){return na(this.attr("d"),a)};y.getSubpath=function(b,d){return a.path.getSubpath(this.attr("d"),
b,d)};a._.box=w;a.path.findDotsAtSegment=u;a.path.bezierBBox=p;a.path.isPointInsideBBox=b;a.path.isBBoxIntersect=q;a.path.intersection=function(a,b){return l(a,b)};a.path.intersectionNumber=function(a,b){return l(a,b,1)};a.path.isPointInside=function(a,d,e){var h=r(a);return b(h,d,e)&&1==l(a,[["M",d,e],["H",h.x2+10] ],1)%2};a.path.getBBox=r;a.path.get={path:function(a){return a.attr("path")},circle:function(a){a=V(a);return x(a.cx,a.cy,a.r)},ellipse:function(a){a=V(a);return x(a.cx||0,a.cy||0,a.rx,
a.ry)},rect:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height,a.rx,a.ry)},image:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height)},line:function(a){return"M"+[a.attr("x1")||0,a.attr("y1")||0,a.attr("x2"),a.attr("y2")]},polyline:function(a){return"M"+a.attr("points")},polygon:function(a){return"M"+a.attr("points")+"z"},deflt:function(a){a=a.node.getBBox();return s(a.x,a.y,a.width,a.height)}};a.path.toRelative=function(b){var e=A(b),h=String.prototype.toLowerCase;if(e.rel)return d(e.rel);
a.is(b,"array")&&a.is(b&&b[0],"array")||(b=a.parsePathString(b));var f=[],l=0,n=0,k=0,p=0,s=0;"M"==b[0][0]&&(l=b[0][1],n=b[0][2],k=l,p=n,s++,f.push(["M",l,n]));for(var r=b.length;s<r;s++){var q=f[s]=[],x=b[s];if(x[0]!=h.call(x[0]))switch(q[0]=h.call(x[0]),q[0]){case "a":q[1]=x[1];q[2]=x[2];q[3]=x[3];q[4]=x[4];q[5]=x[5];q[6]=+(x[6]-l).toFixed(3);q[7]=+(x[7]-n).toFixed(3);break;case "v":q[1]=+(x[1]-n).toFixed(3);break;case "m":k=x[1],p=x[2];default:for(var c=1,t=x.length;c<t;c++)q[c]=+(x[c]-(c%2?l:
n)).toFixed(3)}else for(f[s]=[],"m"==x[0]&&(k=x[1]+l,p=x[2]+n),q=0,c=x.length;q<c;q++)f[s][q]=x[q];x=f[s].length;switch(f[s][0]){case "z":l=k;n=p;break;case "h":l+=+f[s][x-1];break;case "v":n+=+f[s][x-1];break;default:l+=+f[s][x-2],n+=+f[s][x-1]}}f.toString=z;e.rel=d(f);return f};a.path.toAbsolute=G;a.path.toCubic=I;a.path.map=function(a,b){if(!b)return a;var d,e,h,f,l,n,k;a=I(a);h=0;for(l=a.length;h<l;h++)for(k=a[h],f=1,n=k.length;f<n;f+=2)d=b.x(k[f],k[f+1]),e=b.y(k[f],k[f+1]),k[f]=d,k[f+1]=e;return a};
a.path.toString=z;a.path.clone=d});C.plugin(function(a,v,y,C){var A=Math.max,w=Math.min,z=function(a){this.items=[];this.bindings={};this.length=0;this.type="set";if(a)for(var f=0,n=a.length;f<n;f++)a[f]&&(this[this.items.length]=this.items[this.items.length]=a[f],this.length++)};v=z.prototype;v.push=function(){for(var a,f,n=0,k=arguments.length;n<k;n++)if(a=arguments[n])f=this.items.length,this[f]=this.items[f]=a,this.length++;return this};v.pop=function(){this.length&&delete this[this.length--];
return this.items.pop()};v.forEach=function(a,f){for(var n=0,k=this.items.length;n<k&&!1!==a.call(f,this.items[n],n);n++);return this};v.animate=function(d,f,n,u){"function"!=typeof n||n.length||(u=n,n=L.linear);d instanceof a._.Animation&&(u=d.callback,n=d.easing,f=n.dur,d=d.attr);var p=arguments;if(a.is(d,"array")&&a.is(p[p.length-1],"array"))var b=!0;var q,e=function(){q?this.b=q:q=this.b},l=0,r=u&&function(){l++==this.length&&u.call(this)};return this.forEach(function(a,l){k.once("snap.animcreated."+
a.id,e);b?p[l]&&a.animate.apply(a,p[l]):a.animate(d,f,n,r)})};v.remove=function(){for(;this.length;)this.pop().remove();return this};v.bind=function(a,f,k){var u={};if("function"==typeof f)this.bindings[a]=f;else{var p=k||a;this.bindings[a]=function(a){u[p]=a;f.attr(u)}}return this};v.attr=function(a){var f={},k;for(k in a)if(this.bindings[k])this.bindings[k](a[k]);else f[k]=a[k];a=0;for(k=this.items.length;a<k;a++)this.items[a].attr(f);return this};v.clear=function(){for(;this.length;)this.pop()};
v.splice=function(a,f,k){a=0>a?A(this.length+a,0):a;f=A(0,w(this.length-a,f));var u=[],p=[],b=[],q;for(q=2;q<arguments.length;q++)b.push(arguments[q]);for(q=0;q<f;q++)p.push(this[a+q]);for(;q<this.length-a;q++)u.push(this[a+q]);var e=b.length;for(q=0;q<e+u.length;q++)this.items[a+q]=this[a+q]=q<e?b[q]:u[q-e];for(q=this.items.length=this.length-=f-e;this[q];)delete this[q++];return new z(p)};v.exclude=function(a){for(var f=0,k=this.length;f<k;f++)if(this[f]==a)return this.splice(f,1),!0;return!1};
v.insertAfter=function(a){for(var f=this.items.length;f--;)this.items[f].insertAfter(a);return this};v.getBBox=function(){for(var a=[],f=[],k=[],u=[],p=this.items.length;p--;)if(!this.items[p].removed){var b=this.items[p].getBBox();a.push(b.x);f.push(b.y);k.push(b.x+b.width);u.push(b.y+b.height)}a=w.apply(0,a);f=w.apply(0,f);k=A.apply(0,k);u=A.apply(0,u);return{x:a,y:f,x2:k,y2:u,width:k-a,height:u-f,cx:a+(k-a)/2,cy:f+(u-f)/2}};v.clone=function(a){a=new z;for(var f=0,k=this.items.length;f<k;f++)a.push(this.items[f].clone());
return a};v.toString=function(){return"Snap\u2018s set"};v.type="set";a.set=function(){var a=new z;arguments.length&&a.push.apply(a,Array.prototype.slice.call(arguments,0));return a}});C.plugin(function(a,v,y,C){function A(a){var b=a[0];switch(b.toLowerCase()){case "t":return[b,0,0];case "m":return[b,1,0,0,1,0,0];case "r":return 4==a.length?[b,0,a[2],a[3] ]:[b,0];case "s":return 5==a.length?[b,1,1,a[3],a[4] ]:3==a.length?[b,1,1]:[b,1]}}function w(b,d,f){d=q(d).replace(/\.{3}|\u2026/g,b);b=a.parseTransformString(b)||
[];d=a.parseTransformString(d)||[];for(var k=Math.max(b.length,d.length),p=[],v=[],h=0,w,z,y,I;h<k;h++){y=b[h]||A(d[h]);I=d[h]||A(y);if(y[0]!=I[0]||"r"==y[0].toLowerCase()&&(y[2]!=I[2]||y[3]!=I[3])||"s"==y[0].toLowerCase()&&(y[3]!=I[3]||y[4]!=I[4])){b=a._.transform2matrix(b,f());d=a._.transform2matrix(d,f());p=[["m",b.a,b.b,b.c,b.d,b.e,b.f] ];v=[["m",d.a,d.b,d.c,d.d,d.e,d.f] ];break}p[h]=[];v[h]=[];w=0;for(z=Math.max(y.length,I.length);w<z;w++)w in y&&(p[h][w]=y[w]),w in I&&(v[h][w]=I[w])}return{from:u(p),
to:u(v),f:n(p)}}function z(a){return a}function d(a){return function(b){return+b.toFixed(3)+a}}function f(b){return a.rgb(b[0],b[1],b[2])}function n(a){var b=0,d,f,k,n,h,p,q=[];d=0;for(f=a.length;d<f;d++){h="[";p=['"'+a[d][0]+'"'];k=1;for(n=a[d].length;k<n;k++)p[k]="val["+b++ +"]";h+=p+"]";q[d]=h}return Function("val","return Snap.path.toString.call(["+q+"])")}function u(a){for(var b=[],d=0,f=a.length;d<f;d++)for(var k=1,n=a[d].length;k<n;k++)b.push(a[d][k]);return b}var p={},b=/[a-z]+$/i,q=String;
p.stroke=p.fill="colour";v.prototype.equal=function(a,b){return k("snap.util.equal",this,a,b).firstDefined()};k.on("snap.util.equal",function(e,k){var r,s;r=q(this.attr(e)||"");var x=this;if(r==+r&&k==+k)return{from:+r,to:+k,f:z};if("colour"==p[e])return r=a.color(r),s=a.color(k),{from:[r.r,r.g,r.b,r.opacity],to:[s.r,s.g,s.b,s.opacity],f:f};if("transform"==e||"gradientTransform"==e||"patternTransform"==e)return k instanceof a.Matrix&&(k=k.toTransformString()),a._.rgTransform.test(k)||(k=a._.svgTransform2string(k)),
w(r,k,function(){return x.getBBox(1)});if("d"==e||"path"==e)return r=a.path.toCubic(r,k),{from:u(r[0]),to:u(r[1]),f:n(r[0])};if("points"==e)return r=q(r).split(a._.separator),s=q(k).split(a._.separator),{from:r,to:s,f:function(a){return a}};aUnit=r.match(b);s=q(k).match(b);return aUnit&&aUnit==s?{from:parseFloat(r),to:parseFloat(k),f:d(aUnit)}:{from:this.asPX(e),to:this.asPX(e,k),f:z}})});C.plugin(function(a,v,y,C){var A=v.prototype,w="createTouch"in C.doc;v="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel".split(" ");
var z={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},d=function(a,b){var d="y"==a?"scrollTop":"scrollLeft",e=b&&b.node?b.node.ownerDocument:C.doc;return e[d in e.documentElement?"documentElement":"body"][d]},f=function(){this.returnValue=!1},n=function(){return this.originalEvent.preventDefault()},u=function(){this.cancelBubble=!0},p=function(){return this.originalEvent.stopPropagation()},b=function(){if(C.doc.addEventListener)return function(a,b,e,f){var k=w&&z[b]?z[b]:b,l=function(k){var l=
d("y",f),q=d("x",f);if(w&&z.hasOwnProperty(b))for(var r=0,u=k.targetTouches&&k.targetTouches.length;r<u;r++)if(k.targetTouches[r].target==a||a.contains(k.targetTouches[r].target)){u=k;k=k.targetTouches[r];k.originalEvent=u;k.preventDefault=n;k.stopPropagation=p;break}return e.call(f,k,k.clientX+q,k.clientY+l)};b!==k&&a.addEventListener(b,l,!1);a.addEventListener(k,l,!1);return function(){b!==k&&a.removeEventListener(b,l,!1);a.removeEventListener(k,l,!1);return!0}};if(C.doc.attachEvent)return function(a,
b,e,h){var k=function(a){a=a||h.node.ownerDocument.window.event;var b=d("y",h),k=d("x",h),k=a.clientX+k,b=a.clientY+b;a.preventDefault=a.preventDefault||f;a.stopPropagation=a.stopPropagation||u;return e.call(h,a,k,b)};a.attachEvent("on"+b,k);return function(){a.detachEvent("on"+b,k);return!0}}}(),q=[],e=function(a){for(var b=a.clientX,e=a.clientY,f=d("y"),l=d("x"),n,p=q.length;p--;){n=q[p];if(w)for(var r=a.touches&&a.touches.length,u;r--;){if(u=a.touches[r],u.identifier==n.el._drag.id||n.el.node.contains(u.target)){b=
u.clientX;e=u.clientY;(a.originalEvent?a.originalEvent:a).preventDefault();break}}else a.preventDefault();b+=l;e+=f;k("snap.drag.move."+n.el.id,n.move_scope||n.el,b-n.el._drag.x,e-n.el._drag.y,b,e,a)}},l=function(b){a.unmousemove(e).unmouseup(l);for(var d=q.length,f;d--;)f=q[d],f.el._drag={},k("snap.drag.end."+f.el.id,f.end_scope||f.start_scope||f.move_scope||f.el,b);q=[]};for(y=v.length;y--;)(function(d){a[d]=A[d]=function(e,f){a.is(e,"function")&&(this.events=this.events||[],this.events.push({name:d,
f:e,unbind:b(this.node||document,d,e,f||this)}));return this};a["un"+d]=A["un"+d]=function(a){for(var b=this.events||[],e=b.length;e--;)if(b[e].name==d&&(b[e].f==a||!a)){b[e].unbind();b.splice(e,1);!b.length&&delete this.events;break}return this}})(v[y]);A.hover=function(a,b,d,e){return this.mouseover(a,d).mouseout(b,e||d)};A.unhover=function(a,b){return this.unmouseover(a).unmouseout(b)};var r=[];A.drag=function(b,d,f,h,n,p){function u(r,v,w){(r.originalEvent||r).preventDefault();this._drag.x=v;
this._drag.y=w;this._drag.id=r.identifier;!q.length&&a.mousemove(e).mouseup(l);q.push({el:this,move_scope:h,start_scope:n,end_scope:p});d&&k.on("snap.drag.start."+this.id,d);b&&k.on("snap.drag.move."+this.id,b);f&&k.on("snap.drag.end."+this.id,f);k("snap.drag.start."+this.id,n||h||this,v,w,r)}if(!arguments.length){var v;return this.drag(function(a,b){this.attr({transform:v+(v?"T":"t")+[a,b]})},function(){v=this.transform().local})}this._drag={};r.push({el:this,start:u});this.mousedown(u);return this};
A.undrag=function(){for(var b=r.length;b--;)r[b].el==this&&(this.unmousedown(r[b].start),r.splice(b,1),k.unbind("snap.drag.*."+this.id));!r.length&&a.unmousemove(e).unmouseup(l);return this}});C.plugin(function(a,v,y,C){y=y.prototype;var A=/^\s*url\((.+)\)/,w=String,z=a._.$;a.filter={};y.filter=function(d){var f=this;"svg"!=f.type&&(f=f.paper);d=a.parse(w(d));var k=a._.id(),u=z("filter");z(u,{id:k,filterUnits:"userSpaceOnUse"});u.appendChild(d.node);f.defs.appendChild(u);return new v(u)};k.on("snap.util.getattr.filter",
function(){k.stop();var d=z(this.node,"filter");if(d)return(d=w(d).match(A))&&a.select(d[1])});k.on("snap.util.attr.filter",function(d){if(d instanceof v&&"filter"==d.type){k.stop();var f=d.node.id;f||(z(d.node,{id:d.id}),f=d.id);z(this.node,{filter:a.url(f)})}d&&"none"!=d||(k.stop(),this.node.removeAttribute("filter"))});a.filter.blur=function(d,f){null==d&&(d=2);return a.format('<feGaussianBlur stdDeviation="{def}"/>',{def:null==f?d:[d,f]})};a.filter.blur.toString=function(){return this()};a.filter.shadow=
function(d,f,k,u,p){"string"==typeof k&&(p=u=k,k=4);"string"!=typeof u&&(p=u,u="#000");null==k&&(k=4);null==p&&(p=1);null==d&&(d=0,f=2);null==f&&(f=d);u=a.color(u||"#000");return a.format('<feGaussianBlur in="SourceAlpha" stdDeviation="{blur}"/><feOffset dx="{dx}" dy="{dy}" result="offsetblur"/><feFlood flood-color="{color}"/><feComposite in2="offsetblur" operator="in"/><feComponentTransfer><feFuncA type="linear" slope="{opacity}"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>',
{color:u,dx:d,dy:f,blur:k,opacity:p})};a.filter.shadow.toString=function(){return this()};a.filter.grayscale=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {b} {h} 0 0 0 0 0 1 0"/>',{a:0.2126+0.7874*(1-d),b:0.7152-0.7152*(1-d),c:0.0722-0.0722*(1-d),d:0.2126-0.2126*(1-d),e:0.7152+0.2848*(1-d),f:0.0722-0.0722*(1-d),g:0.2126-0.2126*(1-d),h:0.0722+0.9278*(1-d)})};a.filter.grayscale.toString=function(){return this()};a.filter.sepia=
function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {h} {i} 0 0 0 0 0 1 0"/>',{a:0.393+0.607*(1-d),b:0.769-0.769*(1-d),c:0.189-0.189*(1-d),d:0.349-0.349*(1-d),e:0.686+0.314*(1-d),f:0.168-0.168*(1-d),g:0.272-0.272*(1-d),h:0.534-0.534*(1-d),i:0.131+0.869*(1-d)})};a.filter.sepia.toString=function(){return this()};a.filter.saturate=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="saturate" values="{amount}"/>',{amount:1-
d})};a.filter.saturate.toString=function(){return this()};a.filter.hueRotate=function(d){return a.format('<feColorMatrix type="hueRotate" values="{angle}"/>',{angle:d||0})};a.filter.hueRotate.toString=function(){return this()};a.filter.invert=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="table" tableValues="{amount} {amount2}"/><feFuncG type="table" tableValues="{amount} {amount2}"/><feFuncB type="table" tableValues="{amount} {amount2}"/></feComponentTransfer>',{amount:d,
amount2:1-d})};a.filter.invert.toString=function(){return this()};a.filter.brightness=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}"/><feFuncG type="linear" slope="{amount}"/><feFuncB type="linear" slope="{amount}"/></feComponentTransfer>',{amount:d})};a.filter.brightness.toString=function(){return this()};a.filter.contrast=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}" intercept="{amount2}"/><feFuncG type="linear" slope="{amount}" intercept="{amount2}"/><feFuncB type="linear" slope="{amount}" intercept="{amount2}"/></feComponentTransfer>',
{amount:d,amount2:0.5-d/2})};a.filter.contrast.toString=function(){return this()}});return C});

]]> </script>
<script> <![CDATA[

(function (glob, factory) {
    // AMD support
    if (typeof define === "function" && define.amd) {
        // Define as an anonymous module
        define("Gadfly", ["Snap.svg"], function (Snap) {
            return factory(Snap);
        });
    } else {
        // Browser globals (glob is window)
        // Snap adds itself to window
        glob.Gadfly = factory(glob.Snap);
    }
}(this, function (Snap) {

var Gadfly = {};

// Get an x/y coordinate value in pixels
var xPX = function(fig, x) {
    var client_box = fig.node.getBoundingClientRect();
    return x * fig.node.viewBox.baseVal.width / client_box.width;
};

var yPX = function(fig, y) {
    var client_box = fig.node.getBoundingClientRect();
    return y * fig.node.viewBox.baseVal.height / client_box.height;
};


Snap.plugin(function (Snap, Element, Paper, global) {
    // Traverse upwards from a snap element to find and return the first
    // note with the "plotroot" class.
    Element.prototype.plotroot = function () {
        var element = this;
        while (!element.hasClass("plotroot") && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.svgroot = function () {
        var element = this;
        while (element.node.nodeName != "svg" && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.plotbounds = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x0: bbox.x,
            x1: bbox.x + bbox.width,
            y0: bbox.y,
            y1: bbox.y + bbox.height
        };
    };

    Element.prototype.plotcenter = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x: bbox.x + bbox.width / 2,
            y: bbox.y + bbox.height / 2
        };
    };

    // Emulate IE style mouseenter/mouseleave events, since Microsoft always
    // does everything right.
    // See: http://www.dynamic-tools.net/toolbox/isMouseLeaveOrEnter/
    var events = ["mouseenter", "mouseleave"];

    for (i in events) {
        (function (event_name) {
            var event_name = events[i];
            Element.prototype[event_name] = function (fn, scope) {
                if (Snap.is(fn, "function")) {
                    var fn2 = function (event) {
                        if (event.type != "mouseover" && event.type != "mouseout") {
                            return;
                        }

                        var reltg = event.relatedTarget ? event.relatedTarget :
                            event.type == "mouseout" ? event.toElement : event.fromElement;
                        while (reltg && reltg != this.node) reltg = reltg.parentNode;

                        if (reltg != this.node) {
                            return fn.apply(this, event);
                        }
                    };

                    if (event_name == "mouseenter") {
                        this.mouseover(fn2, scope);
                    } else {
                        this.mouseout(fn2, scope);
                    }
                }
                return this;
            };
        })(events[i]);
    }


    Element.prototype.mousewheel = function (fn, scope) {
        if (Snap.is(fn, "function")) {
            var el = this;
            var fn2 = function (event) {
                fn.apply(el, [event]);
            };
        }

        this.node.addEventListener(
            /Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel",
            fn2);

        return this;
    };


    // Snap's attr function can be too slow for things like panning/zooming.
    // This is a function to directly update element attributes without going
    // through eve.
    Element.prototype.attribute = function(key, val) {
        if (val === undefined) {
            return this.node.getAttribute(key);
        } else {
            this.node.setAttribute(key, val);
            return this;
        }
    };

    Element.prototype.init_gadfly = function() {
        this.mouseenter(Gadfly.plot_mouseover)
            .mousemove(Gadfly.plot_mousemove)
            .mouseleave(Gadfly.plot_mouseout)
            .dblclick(Gadfly.plot_dblclick)
            .mousewheel(Gadfly.guide_background_scroll)
            .drag(Gadfly.guide_background_drag_onmove,
                  Gadfly.guide_background_drag_onstart,
                  Gadfly.guide_background_drag_onend);
        this.mouseenter(function (event) {
            init_pan_zoom(this.plotroot());
        });
        return this;
    };
});


Gadfly.plot_mousemove = function(event, x_px, y_px) {
    var root = this.plotroot();
    if (root.data("crosshair")) {
        px_per_mm = root.data("px_per_mm");
        bB = root.select('boundingbox').node.getAttribute('value').split(' ');
        uB = root.select('unitbox').node.getAttribute('value').split(' ');
        xscale = root.data("xscale");
        yscale = root.data("yscale");
        xtranslate = root.data("tx");
        ytranslate = root.data("ty");

        xoff_mm = bB[0].substr(0,bB[0].length-2)/1;
        yoff_mm = bB[1].substr(0,bB[1].length-2)/1;
        xoff_unit = uB[0]/1;
        yoff_unit = uB[1]/1;
        mm_per_xunit = bB[2].substr(0,bB[2].length-2) / uB[2];
        mm_per_yunit = bB[3].substr(0,bB[3].length-2) / uB[3];

        x_unit = ((x_px / px_per_mm - xtranslate) / xscale - xoff_mm) / mm_per_xunit + xoff_unit;
        y_unit = ((y_px / px_per_mm - ytranslate) / yscale - yoff_mm) / mm_per_yunit + yoff_unit;

        root.select('.crosshair').select('.primitive').select('text')
                .node.innerHTML = x_unit.toPrecision(3)+","+y_unit.toPrecision(3);
    };
};

Gadfly.helpscreen_visible = function(event) {
    helpscreen_visible(this.plotroot());
};
var helpscreen_visible = function(root) {
    root.select(".helpscreen").animate({opacity: 1.0}, 250);
};

Gadfly.helpscreen_hidden = function(event) {
    helpscreen_hidden(this.plotroot());
};
var helpscreen_hidden = function(root) {
    root.select(".helpscreen").animate({opacity: 0.0}, 250);
};

// When the plot is moused over, emphasize the grid lines.
Gadfly.plot_mouseover = function(event) {
    var root = this.plotroot();

    var keyboard_help = function(event) {
        if (event.which == 191) { // ?
            helpscreen_visible(root);
        }
    };
    root.data("keyboard_help", keyboard_help);
    window.addEventListener("keydown", keyboard_help);

    var keyboard_pan_zoom = function(event) {
        var bounds = root.plotbounds(),
            width = bounds.x1 - bounds.x0;
            height = bounds.y1 - bounds.y0;
        if (event.which == 187 || event.which == 73) { // plus or i
            increase_zoom_by_position(root, 0.1, true);
        } else if (event.which == 189 || event.which == 79) { // minus or o
            increase_zoom_by_position(root, -0.1, true);
        } else if (event.which == 39 || event.which == 76) { // right-arrow or l
            set_plot_pan_zoom(root, root.data("tx")-width/10, root.data("ty"),
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 40 || event.which == 74) { // down-arrow or j
            set_plot_pan_zoom(root, root.data("tx"), root.data("ty")-height/10,
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 37 || event.which == 72) { // left-arrow or h
            set_plot_pan_zoom(root, root.data("tx")+width/10, root.data("ty"),
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 38 || event.which == 75) { // up-arrow or k
            set_plot_pan_zoom(root, root.data("tx"), root.data("ty")+height/10,
                    root.data("xscale"), root.data("yscale"));
        } else if (event.which == 82) { // r
            set_plot_pan_zoom(root, 0.0, 0.0, 1.0, 1.0);
        } else if (event.which == 191) { // ?
            helpscreen_hidden(root);
        } else if (event.which == 67) { // c
            root.data("crosshair",!root.data("crosshair"));
            root.select(".crosshair")
                .animate({opacity: root.data("crosshair") ? 1.0 : 0.0}, 250);
        }
    };
    root.data("keyboard_pan_zoom", keyboard_pan_zoom);
    window.addEventListener("keyup", keyboard_pan_zoom);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    if (xgridlines) {
        xgridlines.data("unfocused_strokedash",
                        xgridlines.attribute("stroke-dasharray").replace(/(\d)(,|$)/g, "$1mm$2"));
        var destcolor = root.data("focused_xgrid_color");
        xgridlines.attribute("stroke-dasharray", "none")
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    if (ygridlines) {
        ygridlines.data("unfocused_strokedash",
                        ygridlines.attribute("stroke-dasharray").replace(/(\d)(,|$)/g, "$1mm$2"));
        var destcolor = root.data("focused_ygrid_color");
        ygridlines.attribute("stroke-dasharray", "none")
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    root.select(".crosshair")
        .animate({opacity: root.data("crosshair") ? 1.0 : 0.0}, 250);
    root.select(".questionmark").animate({opacity: 1.0}, 250);
};

// Reset pan and zoom on double click
Gadfly.plot_dblclick = function(event) {
  set_plot_pan_zoom(this.plotroot(), 0.0, 0.0, 1.0, 1.0);
};

// Unemphasize grid lines on mouse out.
Gadfly.plot_mouseout = function(event) {
    var root = this.plotroot();

    window.removeEventListener("keyup", root.data("keyboard_pan_zoom"));
    root.data("keyboard_pan_zoom", undefined);
    window.removeEventListener("keydown", root.data("keyboard_help"));
    root.data("keyboard_help", undefined);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    if (xgridlines) {
        var destcolor = root.data("unfocused_xgrid_color");
        xgridlines.attribute("stroke-dasharray", xgridlines.data("unfocused_strokedash"))
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    if (ygridlines) {
        var destcolor = root.data("unfocused_ygrid_color");
        ygridlines.attribute("stroke-dasharray", ygridlines.data("unfocused_strokedash"))
                  .selectAll("path")
                  .animate({stroke: destcolor}, 250);
    }

    root.select(".crosshair").animate({opacity: 0.0}, 250);
    root.select(".questionmark").animate({opacity: 0.0}, 250);
    helpscreen_hidden(root);
};


var set_geometry_transform = function(root, tx, ty, xscale, yscale) {
    var xscalable = root.hasClass("xscalable"),
        yscalable = root.hasClass("yscalable");

    var old_xscale = root.data("xscale"),
        old_yscale = root.data("yscale");

    var xscale = xscalable ? xscale : 1.0,
        yscale = yscalable ? yscale : 1.0;

    tx = xscalable ? tx : 0.0;
    ty = yscalable ? ty : 0.0;

    var t = new Snap.Matrix().translate(tx, ty).scale(xscale, yscale);
    root.selectAll(".geometry, image").forEach(function (element, i) {
            element.transform(t);
        });

    var t = new Snap.Matrix().scale(1.0/xscale, 1.0/yscale);
    root.selectAll('.marker').forEach(function (element, i) {
        element.selectAll('.primitive').forEach(function (element, i) {
            element.transform(t);
        }) });

    bounds = root.plotbounds();
    px_per_mm = root.data("px_per_mm");

    if (yscalable) {
        var xfixed_t = new Snap.Matrix().translate(0, ty).scale(1.0, yscale);
        root.selectAll(".xfixed")
            .forEach(function (element, i) {
                element.transform(xfixed_t);
            });

        ylabels = root.select(".ylabels");
        if (ylabels) {
            ylabels.transform(xfixed_t)
                   .selectAll("g")
                   .forEach(function (element, i) {
                       if (element.attribute("gadfly:inscale") == "true") {
                           unscale_t = new Snap.Matrix();
                           unscale_t.scale(1, 1/yscale);
                           element.select("text").transform(unscale_t);

                           var y = element.attr("transform").globalMatrix.f / px_per_mm;
                           element.attr("visibility",
                               bounds.y0 <= y && y <= bounds.y1 ? "visible" : "hidden");
                       }
                   });
        }
    }

    if (xscalable) {
        var yfixed_t = new Snap.Matrix().translate(tx, 0).scale(xscale, 1.0);
        var xtrans = new Snap.Matrix().translate(tx, 0);
        root.selectAll(".yfixed")
            .forEach(function (element, i) {
                element.transform(yfixed_t);
            });

        xlabels = root.select(".xlabels");
        if (xlabels) {
            xlabels.transform(yfixed_t)
                   .selectAll("g")
                   .forEach(function (element, i) {
                       if (element.attribute("gadfly:inscale") == "true") {
                           unscale_t = new Snap.Matrix();
                           unscale_t.scale(1/xscale, 1);
                           element.select("text").transform(unscale_t);

                           var x = element.attr("transform").globalMatrix.e / px_per_mm;
                           element.attr("visibility",
                               bounds.x0 <= x && x <= bounds.x1 ? "visible" : "hidden");
                           }
                   });
        }
    }
};


// Find the most appropriate tick scale and update label visibility.
var update_tickscale = function(root, scale, axis) {
    if (!root.hasClass(axis + "scalable")) return;

    var tickscales = root.data(axis + "tickscales");
    var best_tickscale = 1.0;
    var best_tickscale_dist = Infinity;
    for (tickscale in tickscales) {
        var dist = Math.abs(Math.log(tickscale) - Math.log(scale));
        if (dist < best_tickscale_dist) {
            best_tickscale_dist = dist;
            best_tickscale = tickscale;
        }
    }

    if (best_tickscale != root.data(axis + "tickscale")) {
        root.data(axis + "tickscale", best_tickscale);
        var mark_inscale_gridlines = function (element, i) {
            if (element.attribute("gadfly:inscale") == null) { return; }
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        var mark_inscale_labels = function (element, i) {
            if (element.attribute("gadfly:inscale") == null) { return; }
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        root.select("." + axis + "gridlines").selectAll("g").forEach(mark_inscale_gridlines);
        root.select("." + axis + "labels").selectAll("g").forEach(mark_inscale_labels);
    }
};


var set_plot_pan_zoom = function(root, tx, ty, xscale, yscale) {
    var old_xscale = root.data("xscale"),
        old_yscale = root.data("yscale");
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    // compute the viewport derived from tx, ty, xscale, and yscale
    var x_min = -width * xscale - (xscale * width - width),
        x_max = width * xscale,
        y_min = -height * yscale - (yscale * height - height),
        y_max = height * yscale;

    var x0 = bounds.x0 - xscale * bounds.x0,
        y0 = bounds.y0 - yscale * bounds.y0;

    var tx = Math.max(Math.min(tx - x0, x_max), x_min),
        ty = Math.max(Math.min(ty - y0, y_max), y_min);

    tx += x0;
    ty += y0;

    // when the scale changes, we may need to alter which set of
    // ticks are being displayed
    if (xscale != old_xscale) {
        update_tickscale(root, xscale, "x");
    }
    if (yscale != old_yscale) {
        update_tickscale(root, yscale, "y");
    }

    set_geometry_transform(root, tx, ty, xscale, yscale);

    root.data("xscale", xscale);
    root.data("yscale", yscale);
    root.data("tx", tx);
    root.data("ty", ty);
};


var scale_centered_translation = function(root, xscale, yscale) {
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var xscale0 = root.data("xscale"),
        yscale0 = root.data("yscale");

    // how off from center the current view is
    var xoff = tx0 - (bounds.x0 * (1 - xscale0) + (width * (1 - xscale0)) / 2),
        yoff = ty0 - (bounds.y0 * (1 - yscale0) + (height * (1 - yscale0)) / 2);

    // rescale offsets
    xoff = xoff * xscale / xscale0;
    yoff = yoff * yscale / yscale0;

    // adjust for the panel position being scaled
    var x_edge_adjust = bounds.x0 * (1 - xscale),
        y_edge_adjust = bounds.y0 * (1 - yscale);

    return {
        x: xoff + x_edge_adjust + (width - width * xscale) / 2,
        y: yoff + y_edge_adjust + (height - height * yscale) / 2
    };
};


// Initialize data for panning zooming if it isn't already.
var init_pan_zoom = function(root) {
    if (root.data("zoompan-ready")) {
        return;
    }

    root.data("crosshair",false);

    // The non-scaling-stroke trick. Rather than try to correct for the
    // stroke-width when zooming, we force it to a fixed value.
    var px_per_mm = root.node.getCTM().a;

    // Drag events report deltas in pixels, which we'd like to convert to
    // millimeters.
    root.data("px_per_mm", px_per_mm);

    root.selectAll("path")
        .forEach(function (element, i) {
        sw = element.asPX("stroke-width") * px_per_mm;
        if (sw > 0) {
            element.attribute("stroke-width", sw);
            element.attribute("vector-effect", "non-scaling-stroke");
        }
    });

    // Store ticks labels original tranformation
    root.selectAll(".xlabels > g, .ylabels > g")
        .forEach(function (element, i) {
            var lm = element.transform().localMatrix;
            element.data("static_transform",
                new Snap.Matrix(lm.a, lm.b, lm.c, lm.d, lm.e, lm.f));
        });

    var xgridlines = root.select(".xgridlines");
    var ygridlines = root.select(".ygridlines");
    var xlabels = root.select(".xlabels");
    var ylabels = root.select(".ylabels");

    if (root.data("tx") === undefined) root.data("tx", 0);
    if (root.data("ty") === undefined) root.data("ty", 0);
    if (root.data("xscale") === undefined) root.data("xscale", 1.0);
    if (root.data("yscale") === undefined) root.data("yscale", 1.0);
    if (root.data("xtickscales") === undefined) {

        // index all the tick scales that are listed
        var xtickscales = {};
        var ytickscales = {};
        var add_x_tick_scales = function (element, i) {
            if (element.attribute("gadfly:scale")==null) { return; }
            xtickscales[element.attribute("gadfly:scale")] = true;
        };
        var add_y_tick_scales = function (element, i) {
            if (element.attribute("gadfly:scale")==null) { return; }
            ytickscales[element.attribute("gadfly:scale")] = true;
        };

        if (xgridlines) xgridlines.selectAll("g").forEach(add_x_tick_scales);
        if (ygridlines) ygridlines.selectAll("g").forEach(add_y_tick_scales);
        if (xlabels) xlabels.selectAll("g").forEach(add_x_tick_scales);
        if (ylabels) ylabels.selectAll("g").forEach(add_y_tick_scales);

        root.data("xtickscales", xtickscales);
        root.data("ytickscales", ytickscales);
        root.data("xtickscale", 1.0);
        root.data("ytickscale", 1.0);  // ???
    }

    var min_scale = 1.0, max_scale = 1.0;
    for (scale in xtickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    for (scale in ytickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    root.data("min_scale", min_scale);
    root.data("max_scale", max_scale);

    // store the original positions of labels
    if (xlabels) {
        xlabels.selectAll("g")
               .forEach(function (element, i) {
                   element.data("x", element.asPX("x"));
               });
    }

    if (ylabels) {
        ylabels.selectAll("g")
               .forEach(function (element, i) {
                   element.data("y", element.asPX("y"));
               });
    }

    // mark grid lines and ticks as in or out of scale.
    var mark_inscale = function (element, i) {
        if (element.attribute("gadfly:scale") == null) { return; }
        element.attribute("gadfly:inscale", element.attribute("gadfly:scale") == 1.0);
    };

    if (xgridlines) xgridlines.selectAll("g").forEach(mark_inscale);
    if (ygridlines) ygridlines.selectAll("g").forEach(mark_inscale);
    if (xlabels) xlabels.selectAll("g").forEach(mark_inscale);
    if (ylabels) ylabels.selectAll("g").forEach(mark_inscale);

    // figure out the upper ond lower bounds on panning using the maximum
    // and minum grid lines
    var bounds = root.plotbounds();
    var pan_bounds = {
        x0: 0.0,
        y0: 0.0,
        x1: 0.0,
        y1: 0.0
    };

    if (xgridlines) {
        xgridlines
            .selectAll("g")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var bbox = element.node.getBBox();
                    if (bounds.x1 - bbox.x < pan_bounds.x0) {
                        pan_bounds.x0 = bounds.x1 - bbox.x;
                    }
                    if (bounds.x0 - bbox.x > pan_bounds.x1) {
                        pan_bounds.x1 = bounds.x0 - bbox.x;
                    }
                    element.attr("visibility", "visible");
                }
            });
    }

    if (ygridlines) {
        ygridlines
            .selectAll("g")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var bbox = element.node.getBBox();
                    if (bounds.y1 - bbox.y < pan_bounds.y0) {
                        pan_bounds.y0 = bounds.y1 - bbox.y;
                    }
                    if (bounds.y0 - bbox.y > pan_bounds.y1) {
                        pan_bounds.y1 = bounds.y0 - bbox.y;
                    }
                    element.attr("visibility", "visible");
                }
            });
    }

    // nudge these values a little
    pan_bounds.x0 -= 5;
    pan_bounds.x1 += 5;
    pan_bounds.y0 -= 5;
    pan_bounds.y1 += 5;
    root.data("pan_bounds", pan_bounds);

    root.data("zoompan-ready", true)
};


// drag actions, i.e. zooming and panning
var pan_action = {
    start: function(root, x, y, event) {
        root.data("dx", 0);
        root.data("dy", 0);
        root.data("tx0", root.data("tx"));
        root.data("ty0", root.data("ty"));
    },
    update: function(root, dx, dy, x, y, event) {
        var px_per_mm = root.data("px_per_mm");
        dx /= px_per_mm;
        dy /= px_per_mm;

        var tx0 = root.data("tx"),
            ty0 = root.data("ty");

        var dx0 = root.data("dx"),
            dy0 = root.data("dy");

        root.data("dx", dx);
        root.data("dy", dy);

        dx = dx - dx0;
        dy = dy - dy0;

        var tx = tx0 + dx,
            ty = ty0 + dy;

        set_plot_pan_zoom(root, tx, ty, root.data("xscale"), root.data("yscale"));
    },
    end: function(root, event) {

    },
    cancel: function(root) {
        set_plot_pan_zoom(root, root.data("tx0"), root.data("ty0"),
                root.data("xscale"), root.data("yscale"));
    }
};

var zoom_box;
var zoom_action = {
    start: function(root, x, y, event) {
        var bounds = root.plotbounds();
        var width = bounds.x1 - bounds.x0,
            height = bounds.y1 - bounds.y0;
        var xscalable = root.hasClass("xscalable"),
            yscalable = root.hasClass("yscalable");
        var px_per_mm = root.data("px_per_mm");
        x = xscalable ? x / px_per_mm : bounds.x0;
        y = yscalable ? y / px_per_mm : bounds.y0;
        var w = xscalable ? 0 : width;
        var h = yscalable ? 0 : height;
        zoom_box = root.rect(x, y, w, h).attr({
            "fill": "#000",
            "opacity": 0.25
        });
    },
    update: function(root, dx, dy, x, y, event) {
        var xscalable = root.hasClass("xscalable"),
            yscalable = root.hasClass("yscalable");
        var px_per_mm = root.data("px_per_mm");
        var bounds = root.plotbounds();
        if (yscalable) {
            y /= px_per_mm;
            y = Math.max(bounds.y0, y);
            y = Math.min(bounds.y1, y);
        } else {
            y = bounds.y1;
        }
        if (xscalable) {
            x /= px_per_mm;
            x = Math.max(bounds.x0, x);
            x = Math.min(bounds.x1, x);
        } else {
            x = bounds.x1;
        }

        dx = x - zoom_box.attr("x");
        dy = y - zoom_box.attr("y");
        var xoffset = 0,
            yoffset = 0;
        if (dx < 0) {
            xoffset = dx;
            dx = -1 * dx;
        }
        if (dy < 0) {
            yoffset = dy;
            dy = -1 * dy;
        }
        if (isNaN(dy)) {
            dy = 0.0;
        }
        if (isNaN(dx)) {
            dx = 0.0;
        }
        zoom_box.transform("T" + xoffset + "," + yoffset);
        zoom_box.attr("width", dx);
        zoom_box.attr("height", dy);
    },
    end: function(root, event) {
        var xscalable = root.hasClass("xscalable"),
            yscalable = root.hasClass("yscalable");
        var zoom_bounds = zoom_box.getBBox();
        if (zoom_bounds.width * zoom_bounds.height <= 0) {
            return;
        }
        var plot_bounds = root.plotbounds();
        var xzoom_factor = 1.0,
            yzoom_factor = 1.0;
        if (xscalable) {
            xzoom_factor = (plot_bounds.x1 - plot_bounds.x0) / zoom_bounds.width;
        }
        if (yscalable) {
            yzoom_factor = (plot_bounds.y1 - plot_bounds.y0) / zoom_bounds.height;
        }
        var tx = (root.data("tx") - zoom_bounds.x) * xzoom_factor + plot_bounds.x0,
            ty = (root.data("ty") - zoom_bounds.y) * yzoom_factor + plot_bounds.y0;
        set_plot_pan_zoom(root, tx, ty,
                root.data("xscale") * xzoom_factor, root.data("yscale") * yzoom_factor);
        zoom_box.remove();
    },
    cancel: function(root) {
        zoom_box.remove();
    }
};


Gadfly.guide_background_drag_onstart = function(x, y, event) {
    var root = this.plotroot();
    var scalable = root.hasClass("xscalable") || root.hasClass("yscalable");
    var zoomable = !event.altKey && !event.ctrlKey && event.shiftKey && scalable;
    var panable = !event.altKey && !event.ctrlKey && !event.shiftKey && scalable;
    var drag_action = zoomable ? zoom_action :
                      panable  ? pan_action :
                                 undefined;
    root.data("drag_action", drag_action);
    if (drag_action) {
        var cancel_drag_action = function(event) {
            if (event.which == 27) { // esc key
                drag_action.cancel(root);
                root.data("drag_action", undefined);
            }
        };
        window.addEventListener("keyup", cancel_drag_action);
        root.data("cancel_drag_action", cancel_drag_action);
        drag_action.start(root, x, y, event);
    }
};


Gadfly.guide_background_drag_onmove = function(dx, dy, x, y, event) {
    var root = this.plotroot();
    var drag_action = root.data("drag_action");
    if (drag_action) {
        drag_action.update(root, dx, dy, x, y, event);
    }
};


Gadfly.guide_background_drag_onend = function(event) {
    var root = this.plotroot();
    window.removeEventListener("keyup", root.data("cancel_drag_action"));
    root.data("cancel_drag_action", undefined);
    var drag_action = root.data("drag_action");
    if (drag_action) {
        drag_action.end(root, event);
    }
    root.data("drag_action", undefined);
};


Gadfly.guide_background_scroll = function(event) {
    if (event.shiftKey) {
        increase_zoom_by_position(this.plotroot(), 0.001 * event.wheelDelta);
        event.preventDefault();
    }
};

// Map slider position x to scale y using the function y = a*exp(b*x)+c.
// The constants a, b, and c are solved using the constraint that the function
// should go through the points (0; min_scale), (0.5; 1), and (1; max_scale).
var scale_from_slider_position = function(position, min_scale, max_scale) {
    if (min_scale==max_scale) { return 1; }
    var a = (1 - 2 * min_scale + min_scale * min_scale) / (min_scale + max_scale - 2),
        b = 2 * Math.log((max_scale - 1) / (1 - min_scale)),
        c = (min_scale * max_scale - 1) / (min_scale + max_scale - 2);
    return a * Math.exp(b * position) + c;
}

// inverse of scale_from_slider_position
var slider_position_from_scale = function(scale, min_scale, max_scale) {
    if (min_scale==max_scale) { return min_scale; }
    var a = (1 - 2 * min_scale + min_scale * min_scale) / (min_scale + max_scale - 2),
        b = 2 * Math.log((max_scale - 1) / (1 - min_scale)),
        c = (min_scale * max_scale - 1) / (min_scale + max_scale - 2);
    return 1 / b * Math.log((scale - c) / a);
}

var increase_zoom_by_position = function(root, delta_position, animate) {
    var old_xscale = root.data("xscale"),
        old_yscale = root.data("yscale"),
        min_scale = root.data("min_scale"),
        max_scale = root.data("max_scale");
    var xposition = slider_position_from_scale(old_xscale, min_scale, max_scale),
        yposition = slider_position_from_scale(old_yscale, min_scale, max_scale);
    xposition += (root.hasClass("xscalable") ? delta_position : 0.0);
    yposition += (root.hasClass("yscalable") ? delta_position : 0.0);
    old_xscale = scale_from_slider_position(xposition, min_scale, max_scale);
    old_yscale = scale_from_slider_position(yposition, min_scale, max_scale);
    var new_xscale = Math.max(min_scale, Math.min(old_xscale, max_scale)),
        new_yscale = Math.max(min_scale, Math.min(old_yscale, max_scale));
    if (animate) {
        Snap.animate(
            [old_xscale, old_yscale],
            [new_xscale, new_yscale],
            function (new_scale) {
                update_plot_scale(root, new_scale[0], new_scale[1]);
            },
            200);
    } else {
        update_plot_scale(root, new_xscale, new_yscale);
    }
}


var update_plot_scale = function(root, new_xscale, new_yscale) {
    var trans = scale_centered_translation(root, new_xscale, new_yscale);
    set_plot_pan_zoom(root, trans.x, trans.y, new_xscale, new_yscale);
};


var toggle_color_class = function(root, color_class, ison) {
    var escaped_color_class = color_class.replace(/([^0-9a-zA-z])/g,"\\$1");
    var guides = root.selectAll(".guide." + escaped_color_class + ",.guide ." + escaped_color_class);
    var geoms = root.selectAll(".geometry." + escaped_color_class + ",.geometry ." + escaped_color_class);
    if (ison) {
        guides.animate({opacity: 0.5}, 250);
        geoms.animate({opacity: 0.0}, 250);
    } else {
        guides.animate({opacity: 1.0}, 250);
        geoms.animate({opacity: 1.0}, 250);
    }
};


Gadfly.colorkey_swatch_click = function(event) {
    var root = this.plotroot();
    var color_class = this.data("color_class");

    if (event.shiftKey) {
        root.selectAll(".colorkey g")
            .forEach(function (element) {
                var other_color_class = element.data("color_class");
                if (typeof other_color_class !== 'undefined' && other_color_class != color_class) {
                    toggle_color_class(root, other_color_class,
                                       element.attr("opacity") == 1.0);
                }
            });
    } else {
        toggle_color_class(root, color_class, this.attr("opacity") == 1.0);
    }
};


return Gadfly;

}));


//@ sourceURL=gadfly.js

(function (glob, factory) {
    // AMD support
      if (typeof require === "function" && typeof define === "function" && define.amd) {
        require(["Snap.svg", "Gadfly"], function (Snap, Gadfly) {
            factory(Snap, Gadfly);
        });
      } else {
          factory(glob.Snap, glob.Gadfly);
      }
})(window, function (Snap, Gadfly) {
    var fig = Snap("#img-deb8fff3");
fig.select("#img-deb8fff3-4")
   .drag(function() {}, function() {}, function() {});
fig.select("#img-deb8fff3-6")
   .data("color_class", "color_Positive")
.click(Gadfly.colorkey_swatch_click)
;
fig.select("#img-deb8fff3-7")
   .data("color_class", "color_Negative")
.click(Gadfly.colorkey_swatch_click)
;
fig.select("#img-deb8fff3-9")
   .data("color_class", "color_Positive")
.click(Gadfly.colorkey_swatch_click)
;
fig.select("#img-deb8fff3-10")
   .data("color_class", "color_Negative")
.click(Gadfly.colorkey_swatch_click)
;
fig.select("#img-deb8fff3-14")
   .init_gadfly();
fig.select("#img-deb8fff3-17")
   .plotroot().data("unfocused_ygrid_color", "#D0D0E0")
;
fig.select("#img-deb8fff3-17")
   .plotroot().data("focused_ygrid_color", "#A0A0A0")
;
fig.select("#img-deb8fff3-19")
   .plotroot().data("unfocused_xgrid_color", "#D0D0E0")
;
fig.select("#img-deb8fff3-19")
   .plotroot().data("focused_xgrid_color", "#A0A0A0")
;
fig.select("#img-deb8fff3-151")
   .mouseenter(Gadfly.helpscreen_visible)
.mouseleave(Gadfly.helpscreen_hidden)
;
    });
]]> </script>
</svg>





```julia

```
