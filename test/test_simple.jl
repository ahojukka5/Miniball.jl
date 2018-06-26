# This file is a part of JuliaFEM/MiniBall.jl.
# License is GPL: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

using Base.Test
using Miniball

@testset "2d standard ball" begin
    for T in subtypes(AbstractFloat)
        pts = T[1 0; 0 0; -1 0; 0 1; 0 -1]
        ball = miniball(pts)
        tol = 1e-15

        @inferred miniball(pts)

        # TODO This is troublesome, since julia does not change type here,
        # arrays are allocated as AbstractFloat. This test could be improved
        @test ball.squared_radius isa AbstractFloat
        @test eltype(ball.center) == AbstractFloat
        @test norm(ball.center) < eps(T)
        @test ball.squared_radius ≈ 1 atol=tol
    end
end
