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
    dim :: Int64                               # Dimensions
    len :: Int64                               # Number of points
    points :: Matrix{Float64}                  # Points in 2D array
    support_vector :: Vector{Vector{Float64}}  # Support point index
    fsize :: Int64                             # Number of forced points
    ssize :: Int64                             # Number of support points

    # Results
    center :: Vector{Float64}                  # Current center coordinates
    squared_radius :: Float64                  # Current squared radius
    c :: Matrix{Float64}
    arr_squared_r :: Vector{Float64}

    #  helper arrays
    q0 :: Vector{Float64}
    z :: Vector{Float64}
    f :: Vector{Float64}
    v :: Matrix{Float64}
    a :: Matrix{Float64}

end

function MBContainer(points)
    len, dim = size(points)
    ball = MBContainer(
        dim, # Dimensions
        len, # Number of points
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

Function for creating a miniball. All the math related
for calculating the miniball can be found from the
http://www.inf.ethz.ch/personal/gaertner/texts/own_work/esa99_final.pdf,
from B. Gaertner, Fast and Robust Smallest Enclosing Balls, ESA 1999,
from section 3. The Primitive Operation and after that.
"""
function new_center_and_radius!(pivot, container)

    fsize = container.fsize
    a = container.a
    d = container.dim
    q0 = container.q0
    c = container.c
    z = container.z
    v = container.v
    f = container.f
    arr_squared_r = container.arr_squared_r
    squared_radius = container.squared_radius

    if fsize == 1
        container.q0[:] = container.c[1,:] = pivot[:]
        container.arr_squared_r[1] = 0.0
    else
        return_val = true

        # set v_fsize to Q_fsize
        v[fsize, :] = pivot - q0

        g(x) = x < fsize
        idx_list = filter(g, 2:d)

        # compute the a_{fsize,i}, i< fsize
        # update v_fsize to Q_fsize-\bar{Q}_fsize
        for i in idx_list
            container.a[fsize, i] = 2.0 * dot(v[i, :], v[fsize, :]) / z[i]
            container.v[fsize, :] -= a[fsize, i] * v[i, :]
        end

        # compute z_fsize
        container.z[fsize] = 2*norm(container.v[fsize, :])^2
        # reject push if z_fsize too small
        z[fsize] < eps(Float64)*squared_radius && return false
        # update c and arr_squared_r
        e_var = norm(pivot[:]-c[fsize-1, :])^2 - arr_squared_r[fsize-1]
        container.f[fsize] = e_var / z[fsize]
        container.c[fsize, :] = c[fsize-1, :] + f[fsize] * v[fsize, :]
        container.arr_squared_r[fsize] = arr_squared_r[fsize-1] + 0.5 * e_var * f[fsize]
    end

    container.center[:] = container.c[fsize,:]
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
    container.fsize == container.dim + 2 && return nothing

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

function miniball(points; max_iterations=20)
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
             unshift!(ball.support_vector, pivot)
             if length(ball.support_vector) == (ball.dim + 2)
                 pop!(ball.support_vector)
             end
         end
         dr2 = ball.squared_radius - r2_prev
         println("Radius: $(sqrt(ball.squared_radius)), ch: $dr2")
         isapprox(dr2, 0.0) && break
         r2_prev = copy(ball.squared_radius)
     end
     return ball
end
