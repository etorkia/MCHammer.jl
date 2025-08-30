include("src/mch_LearningCurves.jl")
using .LearningCurves
using DataFrames
df = lc_curve(CrawfordMethod(), 50, 1, 10, 0.85; steps=1)
println(names(df))
println(size(df))
