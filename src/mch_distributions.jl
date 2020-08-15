#MCHAMMER Custom Distributions
#Distributions not currently implemented in Julia
#by Eric Torkia, August 2020


"""
    RiskEvent(Prob, Distribution, Trials)

Risk Events are defined as conditional distributions that will inflate the 0.

The RiskEvent() allows you to conditionally sample any distribution for as many trials as defined.

julia> RiskEvent(0.3, Normal(0,1), 10)
10-element Array{Float64,1}:
 -0.0
 -0.0
 -0.0
  1.4263681391845335
  0.07972964267827688
  0.0
 -1.333737934384415
  0.0
  0.0
 -0.0

"""
function RiskEvent(Prob, Distribution, Trials)
    C_dist = rand(Bernoulli(Prob),Trials) .* rand(Distribution,Trials)
    return C_dist
end


## Metalogs
#Ported from https://github.com/colsmit/PyMetalog/blob/master/pymetalog/support.py Metalogs

function mlprobs(Array, Increment)
    ArrayLength = size(Array,1)
    SA = sort(Array,1,rev=false)
    ML_Probs = []
end
