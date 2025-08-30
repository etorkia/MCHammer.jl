
using Test
#include("LearningCurves.jl")
using .LearningCurves
using DataFrames

const a = 100.0
const p = 0.80
const N = 8

@testset "Analytic sanity checks" begin
    # Wright
    wr_cum = lc_analytic(WrightMethod(), a, N, p)
    @test isapprox(wr_cum, 409.6; atol=1e-6)
    @test isapprox(wr_cum/N, a * N^(log(p)/log(2)); atol=1e-6)  # Avg = 51.2

    # Crawford
    cr_sum = sum(a * i^(log(p)/log(2)) for i in 1:N)
    cr_cum = lc_analytic(CrawfordMethod(), a, N, p)
    @test isapprox(cr_cum, cr_sum; atol=1e-8)

    # Experience exponent = p directly
    ex_cum = lc_analytic(ExperienceMethod(), a, N, p)
    @test isapprox(ex_cum, a * N^p; atol=1e-9)
end

@testset "learn_rate (Wright) two-point avg vs unit" begin
    # Average-based points
    p_hat_avg = learn_rate(WrightMethod(), 1, 100.0, 8, 51.2; mode=:avg)
    @test isapprox(p_hat_avg, p; atol=1e-12)

    # Unit-based points
    b = log(p)/log(2)
    u1 = a * (1^(1+b) - 0^(1+b))          # 100
    u8 = a * (8^(1+b) - 7^(1+b))          # ~35.4573
    p_hat_unit = learn_rate(WrightMethod(), 1, u1, 8, u8; mode=:unit)
    @test isapprox(p_hat_unit, p; atol=1e-6)
end

@testset "learn_rate (Wright) autodetect with vectors" begin
    b = log(p)/log(2)
    ns = collect(1:8)
    ys_avg  = [a * n^b for n in ns]
    ys_unit = [a * (n^(1+b) - (n-1)^(1+b)) for n in ns]
    p_auto_avg  = learn_rate(WrightMethod(), ns, ys_avg;  mode=:auto)
    p_auto_unit = learn_rate(WrightMethod(), ns, ys_unit; mode=:auto)
    @test isapprox(p_auto_avg, p; atol=1e-4)
    @test isapprox(p_auto_unit, p; atol=1e-4)
end

@testset "learn_rate (Crawford & Experience)" begin
    # Crawford from per‑unit points (i, y(i))
    b = log(p)/log(2)
    y2 = a * 2^b
    y4 = a * 4^b
    p_hat_c = learn_rate(CrawfordMethod(), 2, y2, 4, y4)
    @test isapprox(p_hat_c, p; atol=1e-12)

    # Experience from averages (returns b which equals p here)
    p_hat_e = learn_rate(ExperienceMethod(), 1, a, 8, a*8^p)
    @test isapprox(p_hat_e, p; atol=1e-12)
end

@testset "lc_curve columns" begin
    df = lc_curve(WrightMethod(), a, 1, N, p; steps=1)
    @test names(df) == ["Units", "CumulativeCost", "Time", "AvgCost", "Method"]
    @test df.Method[end] == "Wright"
end

println("All tests passed ✅ (simplified API)")
