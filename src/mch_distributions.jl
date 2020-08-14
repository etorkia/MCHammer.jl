# Distributions not currently implemented in Julia

#Ported from https://github.com/colsmit/PyMetalog/blob/master/pymetalog/support.py
## Metalogs

function mlprobs(Array, Increment)
    ArrayLength = size(Array,1)
    SA = sort(Array,1,rev=false)
    ML_Probs = []
end

"""
    RiskEvent(Prob, Distribution, Trials)

Risk Events are defines as conditional distributions that will inflate the 0....
"""
function RiskEvent(Prob, Distribution, Trials)
    C_dist = rand(Bernoulli(Prob),Trials) .* rand(Distribution,Trials)
    return C_dist
end
