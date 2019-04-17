#CORRELATION AND SIMULATION TOOLS FOR MC HAMMER
#by Eric Torkia, April 17th 2019

using Distributions
using StatsBase
using DataFrames
using LinearAlgebra
using Random

function cormat(ArrayName, RankOrder)
cor_mat = []
M_Size = size(ArrayName,2)
if RankOrder == 1
      for i=1:M_Size
      cor_vector = []
            for i2=1:M_Size
             cor_i = cor(tiedrank(ArrayName[i]),tiedrank(ArrayName[i2]));
             push!(cor_vector,cor_i)
             #print(cov_i)
            end
       push!(cor_mat,cor_vector)
      end
else
      for i=1:M_Size
      cor_vector = []
            for i2=1:M_Size
             cor_i = cor(ArrayName[i], ArrayName[i2]);
             push!(cor_vector,cor_i)
             #print(cov_i)
      end
      push!(cor_mat,cor_vector)
      end
end

return hcat(cor_mat...)
end

function covmat(ArrayName)
M_Size = size(ArrayName,2)
cov_mat = []
      for i=1:M_Size
            for i2=1:M_Size
             cov_i = cov(ArrayName[i],ArrayName[i2]);
             push!(cov_mat,cov_i)
             #print(cov_i)
            end
      end
return reshape(cov_mat, M_Size, M_Size)
end

#corvar function correlates simulation inputs unsing the Iman Connover Method
function corvar(ArrayName, n_trials, correl_matrix)

#Define how many columns of ISNs are required
array_dims = length(ArrayName)

#calc cholesky transform to transfer correlation to ISNs
P = cholesky(correl_matrix)

#Normal() Returns Standard Normals (ISNs)
R = rand(Normal(),n_trials,array_dims)
ISN_Matrix = R*P.U
ISN_Matrix_DF = DataFrame(ISN_Matrix)

#apply ranks to create independant correlation rankings matrix
ISN_Ranked = []
for i = 1:array_dims
      temp_ranks = ordinalrank(ISN_Matrix_DF[i])
      push!(ISN_Ranked, temp_ranks)
end
ISN_Ranked_DF = DataFrame(ISN_Ranked)
#Results_Ranked = []
#println(ISN_Ranked_DF)

#Reindex the array of samples using the ISN_Ranks. Sort(Array)[OrderingVector]
final_array=[]
for i = 1:array_dims
      sorted_array = sort(ArrayName[i])[ISN_Ranked[i]]
      push!(final_array, sorted_array)
end
Final_DF=DataFrame(final_array)
end

function GetCertainty(ArrayName, x, AboveBelow)
      if AboveBelow == 1
            certainty = count(i ->(i>=x), ArrayName)/length(ArrayName)
      else
            certainty = count(i ->(i<=x), ArrayName)/length(ArrayName)
      end
      return certainty
end

cmd(x) = run(`cmd /C $x`)



#Testing Script
#--------------------------
#Must setup as vectors using commas in the []

#Final_Ranks = []
# for i = 1:array_dims
#       temp_ranks = ordinalrank(Final_DF[i])
#       push!(Final_Ranks, temp_ranks)
# end
# Final_Ranks_DF = DataFrame(Final_Ranks)

#Useful Variables
#Phi = (sqrt(5)+1)/2
# n_trials = 1000
# correl_matrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0;0 0 0 1 0.75 -0.7; 0 0 0 0.75 1 -0.95; 0 0 0 -0.7 -0.95 1 ]
#
# #Test Data
# test_logNormal = [rand(LogNormal(0, 0.5),n_trials), rand(Normal(3,2),n_trials), rand(Gamma(1, 0.5),n_trials), rand(LogNormal(0, 0.5),n_trials), rand(Normal(3,2),n_trials), rand(Gamma(1, 0.5),n_trials)]
 
