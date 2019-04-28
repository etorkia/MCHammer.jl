# Distributions not currently implemented in Julia

#Ported from https://github.com/colsmit/PyMetalog/blob/master/pymetalog/support.py
## Metalogs

function mlprobs(Array, Increment)
    ArrayLength = size(Array,1)
    SA = sort(Array,1,rev=false)
    ML_Probs = []

    
