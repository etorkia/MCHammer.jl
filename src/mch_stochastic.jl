#STOCHASTIC MODELING FUNCTIONS FOR MC HAMMER
#by Eric Torkia, August 2020

#Markov Chains, Martingales and other useful stochastic processes

"""
    cmatrix(dimensions::Int64)

cmatrix produces an N x N matrix of 0s where the last row are all 1s.

3×3 Array{Float64,2}:
 0.0  0.0  0.0
 0.0  0.0  0.0
 1.0  1.0  1.0

"""
function cmatrix(dimensions::Int64)

#Create Vector with final value  = 1
    sample_array = zeros(dimensions-1)
    push!(sample_array, 1)

    #Add columns to Matrix
    cmatrix = sample_array

    for i = 1:(dimensions-1)
        cmatrix = hcat(cmatrix, sample_array)
    end
    return cmatrix

end


"""
    markov_a(t_matrix)

markov_a produces the calculated end state of a Markov chain using a sqaure transition matrix.

"""
function markov_a(t_matrix)
    md = size(t_matrix,1)
    IMatrix =  Matrix(I,md,md)
    analytic_markov  =  transpose(t_matrix - IMatrix) + cmatrix(md)
    analytic_markov = analytic_markov^-1
    return      analytic_markov[:,md]
end

#Support function to calculate the Markov chain values at specific point in the chain.
function markov_states(t_matrix, start_arr)
    states = size(t_matrix,1)
    state_mat = t_matrix .* start_arr
    new_state_arr = []

    for state = 1:states
        state_value = sum(state_mat[:,state])
        push!(new_state_arr, state_value)
    end
    return new_state_arr
end

## markov_ts


"""
    markov_ts(t_matrix, start_arr, trials=1)

*markov_ts* is a time-series method that allows you to see the transition states trial by trial.
Extremely useful for market share or account receivables problems where you want to see the states change over time.

*t_matrix* is the transition Matrix
*start_arr* is the starting values for the chain.
 *trials* is the number of iterations you want to run through the Markov Chain Process.



"""
function markov_ts(t_matrix, start_arr, trials=1)
    mts_1 = markov_states(t_matrix, start_arr) #Markov Chaine after 1 trial
    mts_series = mts_1 # setup the first column in the results
    mts_x = mts_1

    for trial = 2:trials
        mts_x = markov_states(t_matrix, mts_x)
        mts_series = hcat(mts_series, mts_x)
    end
    return mts_series
end

## Martingales

"""
    marty(Wager, GamesPlayed; GameWinProb = 0.5, CashInHand = Wager)

*In probability theory, a martingale is a sequence of random variables (i.e., a stochastic process) for which, at a particular time, the conditional expectation
of the next value in the sequence, given all prior values, is equal to the present value.* (Wikipedia)

The marty function is designed to simulate a Martigale such as that everytime a wager is lost, the next bet doubles the wagered amount to negate the previous loss.
The resulting vector is the balance of cash the gambler has in hand at any given point in the Martingale process.

*GameWinProb* is the estimated probability of winning.
*CashInHand* is the starting balance for the martigale. At times, this parameter can make a difference in whether your survive the process or go home broke.

"""
function marty(Wager, GamesPlayed; GameWinProb = 0.5, CashInHand = Wager)
    CurrentWager = Wager
    Balance = CashInHand
    BalResults = []
        for i = 1:GamesPlayed
            win_loose_sim = rand(Bernoulli(GameWinProb))

            if win_loose_sim == true
                    Balance = Balance + CurrentWager
                    CurrentWager = Wager
                elseif win_loose_sim == false
                    Balance = Balance - CurrentWager
                    CurrentWager = Wager * 2
            end
            push!(BalResults, Balance)
        end

#println("Gain/Loss after $GamesPlayed games: ", Balance - CashInHand,'$')
return BalResults
end
