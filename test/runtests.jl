using MCHammer
using Distributions
using Random

if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

@testset "Correlating Values" begin
    Random.seed!(1)
    TestMatrix = rand(Normal(),1000,5)
     @test cormat(TestMatrix) == "5×5 Array{Float64,2}:
  1.0         0.045012   0.00247197  -0.0455839   0.0126131
  0.045012    1.0        0.0534       0.0449149   0.0219751
  0.00247197  0.0534     1.0          0.0194396   0.0504692
 -0.0455839   0.0449149  0.0194396    1.0        -0.0301272
  0.0126131   0.0219751  0.0504692   -0.0301272   1.0"

 end

 @testset "Covariance Values" begin
     Random.seed!(1)
     TestMatrix = rand(Normal(),1000,5)
      @test covmat(TestMatrix) == "5×5 Array{Any,2}:
  1.00069    0.0286309  0.0102903  -0.0356815   0.0132867
  0.0286309  1.09233    0.0598539   0.0536936   0.0216141
  0.0102903  0.0598539  1.07241     0.0140108   0.0583517
 -0.0356815  0.0536936  0.0140108   0.942015   -0.0240827
  0.0132867  0.0216141  0.0583517  -0.0240827   1.02767"
end

@testset "Correlating Distributions" begin
    Random.seed!(1)
    n_trials = 1000
    sample_data = [rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials) rand(LogNormal(0, 0.5),n_trials) rand(Normal(3,2),n_trials) rand(Gamma(1, 0.5),n_trials)]

    test_cmatrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0;0 0 0 1 0.75 -0.7; 0 0 0 0.75 1 -0.95; 0 0 0 -0.7 -0.95 1 ]

    Random.seed!(1)
    @test cormat(corvar(sample_data, n_trials, test_cmatrix)) == "6×6 Array{Float64,2}:
  1.0          0.045012    0.00247197  -0.0455839  -0.0138308   0.0112554
  0.045012     1.0         0.0534       0.0449149   0.0592791  -0.0355262
  0.00247197   0.0534      1.0          0.0194396   0.0532426  -0.0468971
 -0.0455839    0.0449149   0.0194396    1.0         0.719585   -0.662708
 -0.0138308    0.0592791   0.0532426    0.719585    1.0        -0.939008
  0.0112554   -0.0355262  -0.0468971   -0.662708   -0.939008    1.0"
end

@testset "GetCertainty" begin
    Random.seed!(1)
    test = rand(Normal(),1000)
    @test GetCertainty(test, 0, 1) = 0.502
end

@testset "fractiles" begin
    Random.seed!(1)
    test = rand(Normal(),1000)
    @test fractiles(test, 0, 1) =+ "11×2 Array{Any,2}:
 "P0.0"    -3.882
 "P10.0"   -1.34325
 "P20.0"   -0.860748
 "P30.0"   -0.526089
 "P40.0"   -0.274806
 "P50.0"    0.00474446
 "P60.0"    0.218685
 "P70.0"    0.472055
 "P80.0"    0.800966
 "P90.0"    1.2504
 "P100.0"   3.12432"
end

@testset "truncate" begin
    Result_1 = truncate_digit(0.667)
    Result_2 = truncate_digit(0.661)
    @test  Result_1 == Result_2
end

@testset "GBMM" begin
    Random.seed!(1)
    @test GBMM(100000, 0.05,0.05,12) == "12×1 Array{Float64,2}:
 106486.4399226773
 113846.7611813516
 116137.16176312814
 121883.36579797923
 122864.3632374885
 130918.80622439094
 152488.25443945627
 142827.4651618234
 153753.52041326065
 164757.82535740297
 177804.24203041938
 195258.14301210243"
end


@testset "GBMMfit" begin
    Random.seed!(1)
    historical = rand(Normal(10,2.5),1000)
    GBMMfit(historical, 12) == "12×1 Array{Float64,2}:
 6.6992003689078325
 7.062760356166932
 7.103000620460403
 7.420415139367789
 8.514400412609032
 3.943937898162356
 4.146251875790493
 5.262045352529825
 0.7692838668172376
 1.2648073358011491
 1.5912440333414342
 2.1886864479965875"
end
