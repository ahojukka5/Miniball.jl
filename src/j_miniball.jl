# This file is a part of JuliaFEM/MiniBall.jl.
# License is MIT: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md
#
#              Smallest enclosing hypersphere
# 
#   This miniball a pure julia implementations of C++ miniball presented in 
#   https://www.inf.ethz.ch/personal/gaertner/miniball/Miniball.hpp. This implementation
#   is however about 3-8 times slower compared to the C++ code, but has only approximately 
#   1/2 number of lines.    
#
#   The original C++ code is published under GNU General Public License
#

"""
Calcualtes the square of a float; r^2
"""
function pow_2{F<:AbstractFloat}(r::F)
    return r ^ 2
end

"""
Currier function for creating a loop list in push_fsize_not_zero function
Functions only purpose is to reduce the used memory
"""
function currier(dim)
    ids = collect(2:dim)
    function inner(fsize)
        return_arr = filter(x-> x < fsize, ids)
        not_empty = size(return_arr)[1] == 0 ? true : false
        return return_arr, not_empty
    end
    return inner
end


"""
Miniball container
"""
 type Miniball{I<:Integer, F<:AbstractFloat}
    dim::I                                      # Dimensions
    len::I                                      # Number of points
    points::Array{F, 2}                         # Points in 2D array
    support_vector::Array{Array{F, 1}, 1}       # Support point index
    fsize::I                                    # Number of forced points                                   
    ssize::I                                    # Number of support points                               
  
    # Results
    center::Array{F, 1}                      # Current center coordinates
    squared_radius::F                            # Current squared radius
    c::Array{F, 2}              
    arr_squared_r::Array{F, 1}          

    #  helper arrays
    q0::Array{F, 1}
    z::Array{F, 1}
    f::Array{F, 1}
    v::Array{F, 2}
    a::Array{F, 2}
    idx_list::Function
 
   Miniball(len, dim, points) = new(dim,                        # Dimensions
                                    len,                        # Number of points
                                    points,                     # Points in 2D array
                                    [],                          # Support point index
                                    1,                          # Number of forced points  
                                    0,                          # Number of support points   
                                    zeros(F, (dim)),            # Current center coordinates
                                    -1.0,                       # Current squared radius
                                    zeros(F, (dim + 1, dim)),   # C arr
                                    zeros(F, (dim + 1)),        # sqr arr
                                    zeros(F, (dim)),            # q0
                                    zeros(F, (dim + 1)),        # z
                                    zeros(F, (dim + 1)),        # f
                                    zeros(F, (dim + 1, dim)),   # v 
                                    zeros(F, (dim + 1, dim)),   # a
                                    currier(dim))               # Loop function
end

Miniball{I<:Integer, F<:AbstractFloat}(dim::I, len::I, points::Array{F, 2}) = Miniball{I, F}(dim, len, points)

"""
Function for calculating miniball

Parameters
----------
    points: Array{AbstractFloat, 2}
        Takes a 2D array of points, which are used to calculate the miniball

Returns
-------
    container: Miniball
        Miniball type, which holds all the calculated values
        
Example
-------
2D-points (x, y)
    >> points = rand(100, 2)
    >> ball = j_miniball(points)
    
3D-points (x, y, z)
    >> points = rand(100, 3)
    >> ball = j_miniball(points)    
"""
 function j_miniball{F<:AbstractFloat}(points::Array{F, 2}; timeit=false)
     arr_dim, arr_len = size(points)
     ball = Miniball(arr_dim, arr_len, points)
     ball.center[:] = 0.0#ball.points[1, :]
     if timeit
        @time miniball_pivot(ball)
     else 
        miniball_pivot(ball)
    end
     return ball
 end
 
"""
Main loop for calculating miniball. Algorithm can be found from 
http://www.inf.ethz.ch/personal/gaertner/texts/own_work/esa99_final.pdf, 
from B. Gaertner, Fast and Robust Smallest Enclosing Balls, ESA 1999,
as a Algorithm 2: pivot_mb
"""
function miniball_pivot(container::Miniball)
    iter = 0
    old_sqr_r = calculate_miniball(container, iter)
    iter += 1
    while (old_sqr_r < container.squared_radius)
        old_sqr_r = calculate_miniball(container, iter)
        iter += 1
    end
 end
 
"""
Function for creating the support vector. Function searches the most furthest
point from the current center; the pivot point. Pivot point is added into support
vector, which again is used to create the miniball.
"""
 function calculate_miniball(container::Miniball, iter)
     dim   = container.dim
     len   = container.len
     arr_squared_r = container.squared_radius
     pivot = container.points[1, :]
     fsize = container.fsize
     support_vector = container.support_vector
     points = container.points
     old_sqr_r = container.squared_radius
     max_e = 0.0
     c = vec(container.center)
     @inbounds @simd for k=1:len
         p = vec(points[k, :])
         e = -arr_squared_r
         @inbounds for l=1:dim
            e += pow_2(p[l] - c[l])
         end
         if e > max_e
             max_e = e
             pivot = vec(container.points[k, :])
         end
     end
     if max_e > 0.0
         if !(pivot in support_vector)
             @assert container.fsize == 1
             if push!(pivot, container)
                 miniball_support_points(container, pivot)
                 container.fsize -= 1
                 pivot_move_to_front(pivot, container)
             end
         end
     end
    old_sqr_r
end

"""
Recursive function for creating a miniball using the support vector
"""
 function miniball_support_points{F<:AbstractFloat}(container::Miniball, end_support_vector::Array{F, 1})
    dim   = container.dim
    fsize = container.fsize
    ssize = container.ssize
    points = container.points
    center = vec(container.center)
    squared_radius = container.squared_radius
    
    @assert fsize == ssize
    if fsize == dim + 2
        return 
    end
    id_ = 1
    # @fastmath @inbounds 
    for (idx, support_point) in enumerate(container.support_vector)
        if support_point == end_support_vector
            break
        end
        if inside_current_ball(support_point, container.center, container.squared_radius, dim) 
            if push!(support_point, container)
                miniball_support_points(container, support_point) 
                container.fsize -= 1
                support_points_move_to_front(container, support_point, idx) 
            end
        end
        id_ += 1
    end
 end
 
 
"""
Moves the support points inside the support vector. Idea is to move the 
points, which are most furthest apart from each other to the front of
the vector. Points most closer to gather are at the end of the vector.
"""
function support_points_move_to_front{I<:Integer, F<:AbstractFloat}(container::Miniball, element::Array{F, 1}, id_::I) 
    splice!(container.support_vector, id_)
    unshift!(container.support_vector, element)
end

"""
Appends a pivot point to the front of the support vector
"""
function pivot_move_to_front{F<:AbstractFloat}(pivot::Array{F, 1}, container::Miniball)
    dim = container.dim
    unshift!(container.support_vector, vec(pivot))
    if length(container.support_vector) == (dim + 2)
        pop!(container.support_vector)
    end
 end
 
"""
Checks, if given point is already inside the current miniball
"""
 function inside_current_ball{I<:Integer, F<:AbstractFloat}(coords::Array{F, 1}, center::Array{F, 1}, squared_radius::F, dim::I)
    c = center
    p = coords
    e = -squared_radius
    for i=1:dim
        e += pow_2(p[i] - c[i])
    end
    return e > 0.0
 end
 
"""
Function for creating a miniball. All the math related
for calculating the miniball can be found from the 
http://www.inf.ethz.ch/personal/gaertner/texts/own_work/esa99_final.pdf, 
from B. Gaertner, Fast and Robust Smallest Enclosing Balls, ESA 1999,
from section 3. The Primitive Operation and after that.
"""
function push!{F<:AbstractFloat}(pivot::Array{F, 1}, container::Miniball)
    dim = container.dim
    return_value = true
    fsize = container.fsize
    
    if fsize == 1
        return_value = push_fsize_zero(pivot, container)
    else
        return_value = push_fsize_not_zero(pivot, container)
    end
    
    if return_value == true
        for i=1:dim
            container.center[i] = container.c[fsize, i]
        end
        container.squared_radius = container.arr_squared_r[fsize]
        container.fsize += 1         
        container.ssize = container.fsize     
    end
    return return_value
 end

"""
fsize == 1, insert pivot element to q0 and c vectors
"""
function push_fsize_zero(pivot::Array{Float64, 1}, container::Miniball)
     d = container.dim
     for i = 1:d
         container.q0[i] = pivot[i]
         container.c[1, i] = container.q0[i]
     end
     container.arr_squared_r[1] = 0.0
     return true
 end
 
"""
fsize != 1, calculate the miniball center and squared radius using the current
pivot element.
"""
 function push_fsize_not_zero(pivot::Array{Float64, 1}, container::Miniball)
    epsilon = pow_2(1e-21)
    d = container.dim
    q0 = container.q0

    # Arrayt
    c = container.c
    z = container.z

    arr_squared_r = container.arr_squared_r
    fsize = container.fsize
    squared_radius = container.squared_radius
    return_val = true
    
    # set v_fsize to Q_fsize
    container.v[fsize, :] = pivot - q0
    v = container.v
    # compute the a_{fsize,i}, i< fsize
    idx_list, not_empty = container.idx_list(fsize)
    dim_arr = collect(1:d)
    for i in idx_list
        container.a[fsize, i] = 0.0;
        for j = 1:d
            container.a[fsize, i] += v[i, j] * v[fsize, j]
        end
        container.a[fsize, i] *= 2 / z[i]
    end
    a = container.a
    # update v_fsize to Q_fsize-\bar{Q}_fsize
    for i in idx_list
        for j=1:d
            container.v[fsize, j] -= a[fsize, i] * v[i, j]
        end
    end
    # compute z_fsize
    container.z[fsize] = 0.0;
    for j=1:d
        container.z[fsize] += pow_2(container.v[fsize, j])
    end
    container.z[fsize] *= 2
    z = container.z
    # reject push if z_fsize too small
    if z[fsize] < epsilon*squared_radius
        return_val = false
    else
        # update c and arr_squared_r
        e = -arr_squared_r[fsize-1]
        for i=1:d
            e += pow_2(pivot[i]-c[fsize-1, i])
        end
        container.f[fsize] = e / z[fsize]
        f = container.f
        for i=1:d
            container.c[fsize, i] = c[fsize-1, i] + f[fsize] * v[fsize, i]
        end     
        container.arr_squared_r[fsize] = arr_squared_r[fsize-1] + e * f[fsize] / 2
    end
    return_val
 end
