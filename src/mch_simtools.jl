#CORRELATION AND SIMULATION TOOLS FOR MC HAMMER
#by Eric Torkia, 2019-2022 (Please join the team so I don't have to do this alone)

# mch_simtools contains simulation tools and functions to obtain outputs from simulation arrays generated by MCHammer


"""
      cormat(ArrayName, RankOrder=1)

Cormat calculates a symetric correlation matrix using both PPMC and Rank Order. Rank Order is default because this is what it used in the Iman-Conover method for correlating of simulated variables.

`RankOrder = 1` calculates the Spearman rank order correlation used in MCHammer (this argument is optional and defaults to Spearman)

`RankOrder = 0` calculates the Pearson Product Moment Correlation

"""
function cormat(ArrayName, RankOrder=1)
cor_mat = []
M_Size = size(ArrayName,2)

#Converting to a data frame is necessary (and simpler) to perform rankings
if typeof(ArrayName) == Array{Float64,2}
      ArrayName = DataFrame(ArrayName, :auto)
end

if RankOrder == 1
      for i=1:M_Size
      cor_vector = []
            for i2=1:M_Size
             cor_i = cor(tiedrank(ArrayName[!, i]),tiedrank(ArrayName[!, i2]));
             push!(cor_vector,cor_i)
             #print(cov_i)
            end
       push!(cor_mat,cor_vector)
      end
else
      for i=1:M_Size
      cor_vector = []
            for i2=1:M_Size
             cor_i = cor(ArrayName[!,i], ArrayName[!,i2]);
             push!(cor_vector,cor_i)
             #print(cov_i)
      end
      push!(cor_mat,cor_vector)
      end
end

return hcat(cor_mat...)
end

"""
      covmat(ArrayName)

Calculates the covariance matrix.

"""
function covmat(ArrayName)
M_Size = size(ArrayName,2)
cov_mat = []

if typeof(ArrayName) == Array{Float64,2}
      ArrayName = DataFrame(ArrayName, :auto)

end
      for i=1:M_Size
            for i2=1:M_Size
             cov_i = cov(ArrayName[!,i],ArrayName[!,i2]);
             push!(cov_mat,cov_i)
             #print(cov_i)
            end
      end
return reshape(cov_mat, M_Size, M_Size)
end

#Correlation using Iman-Conover
"""
      corvar(ArrayName, n_trials, correl_matrix)

The corvar function correlates simulation inputs unsing the Iman Conover Method. Your array must contain >2 simulated inputs. **Remember to hcat() your inputs into tables reflecting your input correlation matrices.**

**n_trials**: is the number of trials in the simulation. This must be consistent.

**correl_matrix**: must be defined as a Square Positive Definite correlation matrix. This can be calculated from histroical data using `cormat()` function.
"""

function corvar(ArrayName, n_trials, correl_matrix)

if typeof(ArrayName) == Array{Float64,2}
      ArrayName = DataFrame(ArrayName, :auto)

end

#Define how many columns of ISNs are required
array_dims = size(ArrayName,2)

#calc cholesky transform to transfer correlation to ISNs
P = cholesky(correl_matrix)

#Normal() Returns Standard Normals (ISNs)
R = rand(Normal(),n_trials,array_dims)
ISN_Matrix = R*P.U
ISN_Matrix_DF = DataFrame(ISN_Matrix, :auto)

#apply ranks to create independant correlation rankings matrix
ISN_Ranked = []
for i = 1:array_dims
      temp_ranks = ordinalrank(ISN_Matrix_DF[!,i])
      push!(ISN_Ranked, temp_ranks)
end
ISN_Ranked_DF = DataFrame(ISN_Ranked, :auto)
#Results_Ranked = []
#println(ISN_Ranked_DF)

#Reindex the array of samples using the ISN_Ranks. Sort(Array)[OrderingVector]
final_array=[]
for i = 1:array_dims
      sorted_array = sort(ArrayName[!,i])[ISN_Ranked[i]]
      push!(final_array, sorted_array)
end
Final_DF=DataFrame(final_array, :auto)
end

# GetCertainty
"""
      GetCertainty(ArrayName, x, AboveBelow=0)

This function returns the percentage of trials Above (1) or Below(0) a target value of x.
"""
function GetCertainty(ArrayName, x, AboveBelow=0)
      if AboveBelow == 1
            certainty = count(i ->(i>=x), ArrayName)/size(ArrayName,1)
      else
            certainty = count(i ->(i<=x), ArrayName)/size(ArrayName,1)

      end
      return certainty
end


"""
      cmd(x)

Shell /Dos Command wrapper to run batch and shell commands in script. This is used to process SQL from the command line or perform system level operation in a script using a command prompt.
"""
cmd(x) = run(`cmd /C $x`)

"""
    function  truncate_digit(num, digits=2)
Truncation algorithim to remove decimals (ported by anonymous author from Maple) e.g.

      0.066 = 0.06
      0.063 = 0.06

"""
function  truncate_digit(num, digits=2)
    if num == 0.0 then
        return num
    else
        e = ceil(log10(abs(num)))
        scale = 10^(digits - e)
        return trunc(num * scale) / scale
    end
end

#fractiles function calculates percentiles at equal increments.
"""
      fractiles(ArrayName, Increment=0.1)

The fractiles function calculates percentiles at equal increments. The default optional argument for Increments is 0.1 for deciles but can be set to anything such as 0.05 for quintiles or 0.01 for percentiles.
"""
function fractiles(ArrayName, Increment=0.1)
names = map(i -> "P" * string(i), collect(0:Increment:1)*100)
P_Vals = collect(0:Increment:1)
#convert(Array{Float64}, ArrayName)
fractiles = quantile(collect(Float64, ArrayName), P_Vals)
return hcat(names, fractiles)
end



#convert(Array{Float64}, ArrayName)
# convert(Array{Int64}, collect(0:Increment:1)*100)



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
# test_logNormal = [rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials) rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials)]
