# This file is a part of JuliaFEM/MiniBall.jl.
# License is GPL: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

using Base.Test
using Miniball

"""
    random_points(center, radius, n, boundary::Bool)

Create array of random points
"""
function random_points(center, radius, n, boundary::Bool)
    dims = length(center), n
    dim = length(center)
    pts = zeros(n, dim)
    for row in indices(pts,1)
        dir = normalize(randn(dim))
        r = boundary ? radius : rand() * radius
        pts[row,:] .= center + r*dir
    end
    pts
end

"""
    random_ball(center, radius, n, boundary::Bool)

Create array of random points
"""
function random_ball(dim)
    scale_factor = rand(1:1000, 1, 1)[1]
    center = randn(dim) .* scale_factor
    radius = rand() * scale_factor
    center, radius
end

"""
    leq_approx(small, big)

less then/equal approximation
"""
function leq_approx(small, big, test_type)
    if small <= big
        return true
    end
    l = isapprox(small, big, atol=1e-8, rtol=1e-8)
    if l == false
        println(rpad(test_type, 20), " LEQ failed, smaller: ", rpad(small, 20), ", bigger: ", rpad(big, 20), ", diff: ", rpad(big - small, 20))
    end
    l
end

"""
    check_points_approx_inside(center, radius, pts)

less then/equal approximation
"""
function check_points_approx_inside(center, radius, pts)
    for row in indices(pts,1)
        pt = @view pts[row,:]
        r = norm(pt - center)
        if !leq_approx(r, radius, "Point inside ball")
            return false
        end
    end
    true
end


@testset "Random tests" begin
    srand()
    for dim in 1:8
        for n in 1:100
            for boundary in [true, false]
                center, radius = random_ball(dim)
                pts = random_points(center, radius, n, boundary)
                ball = miniball(pts, check=false)
                r = sqrt(ball.squared_radius)

                inside = check_points_approx_inside(ball.center, r, pts)
                if inside
                    @test inside
                else
                    @test_broken inside
                end
                is_smaller = leq_approx(r, radius, "Radius")
                if is_smaller
                    @test is_smaller
                else
                    @test_broken is_smaller
                end
            end
        end
    end
end
