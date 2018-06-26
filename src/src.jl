# This file is a part of JuliaFEM/MiniBall.jl.
# License is GPL: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md
#
#              Smallest enclosing hypersphere
#
#   This miniball a pure julia implementations of C++ miniball presented in
#   https://www.inf.ethz.ch/personal/gaertner/miniball/MBContainer.hpp. This implementation
#   is as fast as the C++ code and has only approximately 3/5 number of lines.
#
#   The original C++ code is published under GNU General Public License
#

"""
MBContainer container
"""
 type MBContainer
    points :: Matrix{AbstractFloat}                  # Points in 2D array
    support_vector :: Vector{Vector{AbstractFloat}}  # Support point index
    fsize :: Int64                             # Number of forced points
    ssize :: Int64                             # Number of support points

    # Results
    center :: Vector{AbstractFloat}                  # Current center coordinates
    squared_radius :: AbstractFloat                  # Current squared radius
    c :: Matrix{AbstractFloat}
    arr_squared_r :: Vector{AbstractFloat}

    #  helper arrays
    q0 :: Vector{AbstractFloat}
    z :: Vector{AbstractFloat}
    f :: Vector{AbstractFloat}
    v :: Matrix{AbstractFloat}
    a :: Matrix{AbstractFloat}

end

function MBContainer(points)
    len, dim = size(points)
    ball = MBContainer(
        points, # Points in 2D array
        [], # Support point index
        1, # Number of forced points
        0, # Number of support points
        zeros(dim), # Current center coordinates
        -1.0, # Current squared radius
        zeros(dim + 1, dim), # C arr
        zeros(dim + 1), # sqr arr
        zeros(dim), # q0
        zeros(dim + 1), # z
        zeros(dim + 1), # f
        zeros(dim + 1, dim), # v
        zeros(dim + 1, dim), # a
        )
    return ball
end


"""
    new_center_and_radius!(pivot, container)

Function for creating a miniball. All the math related for calculating the
miniball can be found from the [1], Section 3, "The Primite Operation".

[1] B. Gaertner. Fast and Robust Smallest Enclosing Balls, ESA 1999. Online at:
    http://www.inf.ethz.ch/personal/gaertner/texts/own_work/esa99_final.pdf,
"""
function new_center_and_radius!(pivot, container)

    fsize = container.fsize
    ssize = container.ssize
    a = container.a
    d = size(container.points, 2)
    q0 = container.q0
    c = container.c
    z = container.z
    v = container.v
    f = container.f
    arr_squared_r = container.arr_squared_r
    squared_radius = container.squared_radius
    center = container.center

    if fsize == 1
        q0[:] = c[1,:] = pivot[:]
        arr_squared_r[1] = 0.0
    else
        return_val = true

        # set v_fsize to Q_fsize
        v[fsize, :] = pivot - q0

        # compute the a_{fsize,i}, if i < fsize
        # update v_fsize to Q_fsize - \bar{Q}_fsize
        for i=2:fsize-1
            a[fsize, i] = 2.0 * dot(v[i, :], v[fsize, :]) / z[i]
            v[fsize, :] -= a[fsize, i] * v[i, :]
        end

        e_var = norm(pivot[:]-c[fsize-1, :])^2 - arr_squared_r[fsize-1]
        z[fsize] = 2.0 * norm(v[fsize, :])^2
        # compute z_fsize and reject push if z_fsize is too small
        isapprox(z[fsize], 0.0) && return false
        f[fsize] = e_var / z[fsize]
        c[fsize, :] = c[fsize-1, :] + f[fsize] * v[fsize, :]
        arr_squared_r[fsize] = arr_squared_r[fsize-1] + 0.5 * e_var * f[fsize]
    end

    center[:] = c[fsize,:]
    container.squared_radius = container.arr_squared_r[fsize]
    container.fsize += 1
    container.ssize = container.fsize

 end


"""
    miniball_support_points(container, end_support_vector)

Recursive function for creating a miniball using the support vector.
"""
 function miniball_support_points(container, end_support_vector)

    @assert container.fsize == container.ssize
    dim = size(container.points, 2)
    container.fsize == dim + 2 && return nothing

    for (idx, support_point) in enumerate(container.support_vector)
        support_point == end_support_vector && break
        if norm(support_point - container.center)^2 > container.squared_radius
            new_center_and_radius!(support_point, container)
            miniball_support_points(container, support_point)
            container.fsize -= 1
            # Move the support points inside the support vector. The idea is to
            # move the points that are the furthest apart from each other to the
            # front of the vector. Closest points to gather are at the end of
            # the vector.
            splice!(container.support_vector, idx)
            unshift!(container.support_vector, support_point)
        end
    end
 end

function miniball(points; max_iterations=30, check=false, check_atol=1e-15, check_rtol=1e-15, debug=false)
    ball = MBContainer(points)
    fsize = ball.fsize
    support_vector = ball.support_vector
    r2_prev = -Inf
    for i=1:max_iterations
        center = vec(ball.center)
        pivot_idx = indmax(norm(points[k,:]-center) for k=1:size(points,1))
        pivot = points[pivot_idx, :]
        if !(pivot in support_vector)
            @assert fsize == 1
            new_center_and_radius!(pivot, ball)
            miniball_support_points(ball, pivot)
            ball.fsize -= 1
            dim = size(ball.points, 2)
            unshift!(ball.support_vector, pivot)
            if length(ball.support_vector) == (dim + 2)
                pop!(ball.support_vector)
            end
        end
        dr2 = ball.squared_radius - r2_prev
        if debug
            println("Radius: $(sqrt(ball.squared_radius)), ch: $dr2")
        end
        isapprox(dr2, 0.0) && break
        r2_prev = copy(ball.squared_radius)
    end
    if check
        ball_rad = sqrt(ball.squared_radius)
        for row in indices(points,1)
            pt = @view points[row,:]
            r_check = norm(pt - ball.center)
            r_check <= ball_rad ||
                isapprox(r_check, ball_rad, atol=check_atol, rtol=check_rtol) ||
                println("Cannot find miniball around points. This is probably due to rounding errors: ", r_check, " ", ball_rad)
        end
    end
    return ball
end
