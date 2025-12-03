#STOCHASTIC MODELING FUNCTIONS FOR MC HAMMER
#by Eric Torkia, 2019-2025 (Please join the team so I don't have to do this alone)

using LinearAlgebra, DataFrames, Plots, GraphRecipes
using Measures, Colors , Distributions

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


#Analytic Solve function for Markov Chains
"""
    markov_solve(T; state_names=nothing)

Solve a Markov chain analytically. The function automatically detects
whether the chain is **ergodic** (no absorbing states) or **absorbing**.

# Arguments
- `T`            :: Square transition matrix (rows sum to 1).
- `state_names`  :: Optional vector of state names. When provided, a
                    DataFrame is returned; otherwise raw arrays are returned.

# Behavior
## Ergodic case
Computes the long-run steady-state distribution using the augmented
matrix method. Returns a DataFrame with:

    State | Probability | Type="Ergodic"

## Absorbing case
Reorders the matrix into the canonical form `[Q R; 0 I]`, computes:

- Fundamental matrix: `N = (I - Q)⁻¹`
- Absorption probabilities: `B = N * R`
- Expected steps to absorption: `t = N * 1`

Returns a single DataFrame:

    State | <one column per absorbing state> | ExpectedSteps | Type

with transient states first and absorbing states last.

# Returns
- DataFrame with labeled results (if `state_names` provided)
- Raw arrays otherwise

"""
function markov_solve(T::AbstractMatrix; state_names=nothing)

    n = size(T, 1)
    @assert n == size(T, 2) "Transition matrix T must be square."

    tol = 1e-12
    absorbing_mask = [
        isapprox(T[i,i], 1.0; atol=tol) &&
        isapprox(sum(T[i,:]) - T[i,i], 0.0; atol=1e-10)
        for i in 1:n
    ]

    # ------------------------------------------------------------
    # ABSORBING CASE
    # ------------------------------------------------------------
    if any(absorbing_mask)

        transient_ix = findall(!, absorbing_mask)
        absorbing_ix = findall(absorbing_mask)

        # permutation: transient states first, then absorbing states
        perm = vcat(transient_ix, absorbing_ix)
        Tp   = T[perm, perm]

        m = length(transient_ix)
        a = length(absorbing_ix)

        # Q: transient→transient, R: transient→absorbing
        Q = Tp[1:m, 1:m]
        R = Tp[1:m, m+1:end]

        I_m = Matrix(I, m, m)
        N   = inv(I_m - Q)          # fundamental matrix

        # Absorption probabilities for transient states
        B_tr = N * R

        # Full absorption matrix including absorbing rows (identity block)
        B_full = vcat(B_tr, Matrix(I, a, a))

        # Expected steps: only for transient states, 0 for absorbing
        t_full = zeros(n)
        t_full[transient_ix] .= (N * ones(m))

        # If no state names, return raw numeric results
        if state_names === nothing
            t_perm = t_full[perm]
            return (B = B_full, t = t_perm)
        end

        # ------- With state names: build a single merged DataFrame -------

        # Reorder names to match permuted matrix
        all_names       = state_names[perm]
        absorbing_names = state_names[absorbing_ix]

        # Type column in original order, then permuted
        type_col = fill("Transient", n)
        for i in absorbing_ix
            type_col[i] = "Absorbing"
        end
        type_perm = type_col[perm]

        # Permute expected steps to match state order
        t_perm = t_full[perm]

        # Build merged DataFrame:
        # State | <one column per absorbing state> | ExpectedSteps | Type
        df = DataFrame(State = all_names)

        for (j, name) in enumerate(absorbing_names)
            df[!, Symbol(name)] = B_full[:, j]
        end

        df.ExpectedSteps = t_perm
        df.Type          = type_perm

        return df
    end

    # ------------------------------------------------------------
    # ERGODIC CASE
    # ------------------------------------------------------------
    I_n = Matrix(I, n, n)
    C   = zeros(n, n)
    C[end, :] .= 1.0

    A = transpose(I_n - T) + C
    π = inv(A)[:, end]
    π ./= sum(π)

    if state_names !== nothing
        df = DataFrame(State      = state_names,
                       Probability = π,
                       Type        = fill("Ergodic", n))
        return df
    else
        return π
    end
end



## markov_ts: Discrete step markov chain

"""
    markov_ts(T, start_vec; trials=1, state_names=nothing)

Simulate the evolution of a Markov chain over a given number of time steps.

Arguments
---------
- `T`           :: n×n transition matrix (rows sum to 1).
- `start_vec`   :: length-n probability vector for the starting state.
- `trials`      :: number of transitions to simulate (default = 1).
- `state_names` :: optional vector of state names.

Behavior
--------
Computes:

    dist₁ = start_vec * T
    dist₂ = dist₁    * T
    ...
    distₖ = distₖ₋₁  * T

and stores each `distᵢ` as a column.

Returns
-------
- If `state_names === nothing`:
    An n×trials matrix of Float64.

- If `state_names` are provided:
    A DataFrame with columns:

        State | Type | 1 | 2 | ... | trials

    where:
    - Type = "Ergodic"      if the chain has no absorbing states
    - Type = "Transient"    for non-absorbing states in an absorbing chain
    - Type = "Absorbing"    for absorbing states in an absorbing chain
"""
function markov_ts(T::AbstractMatrix, start_vec; trials::Int=1, state_names=nothing)
    n = size(T, 1)
    @assert n == size(T, 2)  "Transition matrix T must be square."
    @assert length(start_vec) == n "start_vec must match number of states."
    @assert trials ≥ 1        "trials must be at least 1."

    # ensure Float64 and don't mutate caller input
    current = collect(float.(start_vec))

    # one-step evolution: vᵗ * T → as column-style vector
    step(T, v) = (v' * T)'

    # n × trials matrix to store time series
    series = Array{Float64}(undef, n, trials)

    # first step
    current = step(T, current)
    series[:, 1] .= current

    # remaining steps
    for k in 2:trials
        current = step(T, current)
        series[:, k] .= current
    end

    # if no state names, just return numeric matrix
    if state_names === nothing
        return series
    end

    # -------- classify states: Ergodic vs Absorbing (Transient/Absorbing) --------
    tol = 1e-12
    absorbing_mask = [
        isapprox(T[i,i], 1.0; atol=tol) &&
        isapprox(sum(T[i,:]) - T[i,i], 0.0; atol=1e-10)
        for i in 1:n
    ]

    type_col =
        if any(absorbing_mask)
            [absorbing_mask[i] ? "Absorbing" : "Transient" for i in 1:n]
        else
            fill("Ergodic", n)
        end

    # -------- build DataFrame: State | Type | 1 | 2 | ... | trials --------
    df = DataFrame()
    df.State = state_names
    df.Type  = type_col

    for k in 1:trials
        df[!, Symbol(k)] = series[:, k]
    end

    return df
end

#Plot function for markov_ts output
"""
    markov_ts_plot(ms; title="State Probabilities Over Time",
                      xlabel="Time Step",
                      ylabel="Probability",
                      states=nothing)

Plot the evolution of Markov chain state probabilities over time.

`ms` must be the DataFrame returned by `markov_ts`, with columns:

    State | Type | 1 | 2 | … | trials

The function:

  • automatically detects numeric step columns (e.g. "1", "2", …, "10"),
  • reshapes the data into a long, tidy format,
  • converts step labels to integer time indices,
  • plots one line per State.

Use the `states` keyword to restrict the plot to a subset of state names.
Keyword arguments allow customization of the plot title and axis labels.
"""
function markov_ts_plot(ms::DataFrame;
                        title  = "State Probabilities Over Time",
                        xlabel = "Time Step",
                        ylabel = "Probability",
                        states = nothing)  # optional subset of state names

    # Optionally filter to a subset of states
    if states !== nothing
        ms = filter(row -> row.State in states, ms)
    end

    # Detect numeric step columns by name (e.g. "1", "2", :3, …)
    all_cols  = names(ms)
    step_cols = [c for c in all_cols if tryparse(Int, string(c)) !== nothing]

    # (Optional but nice) sort step columns by step number
    step_cols = sort(step_cols; by = c -> parse(Int, string(c)))

    # Long format: State, Type, Step (like "1","2",…), Value
    ms_long = stack(ms, step_cols; variable_name = :Step, value_name = :Value)

    # Convert Step (e.g. "1", "2", …) to Int
    ms_long.StepNum = parse.(Int, string.(ms_long.Step))

    # Unique states to plot
    unique_states = unique(ms_long.State)

    # Base plot
    plt = plot(title = title, xlabel = xlabel, ylabel = ylabel, legend = :topright)

    # One series per state
    for s in unique_states
        sub = ms_long[ms_long.State .== s, :]
        plot!(plt,
              sub.StepNum,
              sub.Value,
              label = s,
              lw    = 2)
    end

    return plt
end



"""
    markov_state_graph(T, ms; state_names, title, size)

Draw a state transition graph for a Markov chain.

- `T`  :: transition matrix (used as edge weights)
- `ms` :: DataFrame returned by `markov_ts` (State, Type, 1, 2, ..., n)

The function:
  * takes the last numeric column in `ms` as the node weights
    (the final forecast step),
  * uses `state_names` as node labels,
  * and renders a directed graph with node size proportional
    to the final-period probability.

This works for both ergodic and absorbing chains. In absorbing chains,
transient states naturally shrink as probability mass moves into the
absorbing states.
"""
function markov_state_graph(T::AbstractMatrix, ms::DataFrame;
                            state_names,
                            title = "State Transition Graph",
                            size  = (1500, 1500),
                            circle_scale = 0.05)
                        
    # Final-step probabilities
    last_col = names(ms)[end]
    scores   = collect(ms[!, last_col])

    # Normalize to [0,1]
    wmin, wmax = extrema(scores)
    norm_scores = isapprox(wmin, wmax; atol=1e-12) ?
                  fill(0.5, length(scores)) :
                  (scores .- wmin) ./ (wmax - wmin)

    # Use only the *lighter* part of the Blues palette
    palette = cgrad(:coolwarm, 100)
    idx_min, idx_max = 35, 100  # avoid very dark & very light extremes

    node_colors = [palette[round(Int,
                        idx_min + v*(idx_max - idx_min))]
                   for v in norm_scores]

    # Two-line labels: state + probability rounded to 3 decimals
    labels = ["$(s)\n$(round(p, digits = 3))"
              for (s, p) in zip(state_names, scores)]

    plt = graphplot(
        T,
        names            = labels,
        marker           = :circle,
        markersize       = 0.05,
        markercolor      = node_colors,
        nodeshape        = :circle,
        nodesize         = circle_scale,
        curvature_scalar = 0.1,
        arrow            = arrow(:closed, :head, 1, 0.3),
        self_edge_size   = 0.5,
        fontsize         = 11,
        size             = size,
    )

    plot!(plt;
          title         = title,
          titlefont     = font(18),
          top_margin    = 0mm,
          bottom_margin = 5mm,
          left_margin   = 5mm,
          right_margin  = 5mm)

    return plt
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
