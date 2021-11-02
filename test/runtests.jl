using PyPlot2Igor
using Test

@testset "PyPlot2Igor.jl" begin
    target_file = joinpath(@__DIR__, "igor.itx")
    source_file = joinpath(@__DIR__, "plotting_script.jl")
    pyplot2igor(source_file, target_file)
end