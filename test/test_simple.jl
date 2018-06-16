# This file is a part of JuliaFEM/MiniBall.jl.
# License is GPL: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

@testset "2d standard ball" begin
    for T in subtypes(AbstractFloat)
        pts = T[1 0; 0 0; -1 0; 0 1; 0 -1]
        ball = miniball(pts)
        @inferred miniball(pts)
        @test ball.squared_radius isa T
        @test eltype(ball.center) == T
        @test norm(ball.center) < eps(T)
        @test ball.squared_radius ≈ 1
    end
end
