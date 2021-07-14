#How to build your first Model

using StatsBase, Gadfly
using Distributions
using Random
using MCHammer


clearconsole()

#Key Variables
n_trials = 10000
Revenue = rand(TriangularDist(2500000,4000000,3000000), n_trials)
Expenses = rand(TriangularDist(1400000,3000000,2000000), n_trials)

#Uncorrelated Model (1)
Profit = Revenue - Expenses

#Apply correlation to random samples
Rev_Exp_Cor = -0.8
cor_matrix = [1 Rev_Exp_Cor; Rev_Exp_Cor 1]

#Join Trial into an array and apply correlation
Trials = hcat(Revenue, Expenses)
Trials = corvar(Trials, n_trials, cor_matrix)

#Correlated Model(2) - Create Correlated Results Array
Profit_C = Trials[!,1] -Trials[!,2]
Trials = hcat(Trials[!,1], Trials[!,2], Profit_C)
cormat(Trials,1)

#Plot Density
plot(x=[Profit Profit_C], Geom.density, color=["Uncorrelated","Correlated"], Guide.Title("Compare Results Methods"))

#Plot S-Curves
# plot(layer(ecdf(Profit),minimum(Profit), maximum(Profit), Theme(default_color="orange")),layer(ecdf(Profit_C), minimum(Profit_C), maximum(Profit_C)), Guide.Title("Compare Portfolio Methods"))
# s_table = hcat(Profit_C,Revenue, Expenses)
# sensitivity_chrt(s_table,1)


println("Probability of Making 1m or less (uncorrelated) :",GetCertainty(Profit, 1000000, 0))
println("Input Correlation: ", cor(Revenue,Expenses),"\n")
println("Probability of Making 1m or less (correlated) :",GetCertainty(Profit_C, 1000000, 0))
println("Input Correlation: ", cor(Trials[:, 1],Trials[:,2]))
println("\n")

println("Model Outputs: Revenue, Expenses, Profit, Profit_C")
Profit_C
