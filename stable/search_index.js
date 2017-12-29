var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Miniball.jl",
    "title": "Miniball.jl",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Miniball.jl-1",
    "page": "Miniball.jl",
    "title": "Miniball.jl",
    "category": "section",
    "text": "This is a Julia package for finding the smallest enclosing sphere for a set of points in an arbitrary number of dimensions.  The implementation is based on Bernd Gärtner's C++ Miniball but is implemented entirely in Julia.  The original C++ implementation is licensed under GNU General Public License (GPLv3), which is why this implementation also has the same license."
},

{
    "location": "index.html#Typical-useage-1",
    "page": "Miniball.jl",
    "title": "Typical useage",
    "category": "section",
    "text": "This package has a simple interface.  Callball = miniball(points)where points is a 2D array of size n × d representing n points in d dimensions.  The resulting object ball has two fields – ball.center and ball.squared_radius which contain details about the resulting miniball.  The minball function covers most use cases, but descriptions of all functions including internals can be found below.  DocTestSetup = quote\n    using Miniball\nend"
},

{
    "location": "index.html#Miniball.miniball-Union{Tuple{Array{F,2}}, Tuple{F}} where F<:AbstractFloat",
    "page": "Miniball.jl",
    "title": "Miniball.miniball",
    "category": "Method",
    "text": "miniball(points)\n\nCalculate the miniball (minimal enclosing hypersphere) of a set of points.\n\nParameters\n\npoints: Array{AbstractFloat, 2}\n    A 2D array of points, which is used to calculate the miniball.  The first dimension of the array corresponds to different points while the second dimension corresponds to the coordinate in each of N dimensions.\n\nReturns\n\ncontainer: MBContainer\n    MBContainer type, which holds all the calculated values.\n\nExample\n\n2D-points (x, y):     points = rand(100, 2)     ball = miniball(points)\n\n3D-points (x, y, z):     points = rand(100, 3)     ball = miniball(points)\n\n\n\n"
},

{
    "location": "index.html#Miniball.MBContainer",
    "page": "Miniball.jl",
    "title": "Miniball.MBContainer",
    "category": "Type",
    "text": "MBContainer container\n\n\n\n"
},

{
    "location": "index.html#Miniball.calculate_miniball-Tuple{Miniball.MBContainer}",
    "page": "Miniball.jl",
    "title": "Miniball.calculate_miniball",
    "category": "Method",
    "text": "calculate_miniball(container)\n\nFunction for creating the support vector. This function finds the furthest point from the current center: the pivot point. The pivot point is added into the support vector, which is then used to create the miniball.\n\n\n\n"
},

{
    "location": "index.html#Miniball.currier-Tuple{Any}",
    "page": "Miniball.jl",
    "title": "Miniball.currier",
    "category": "Method",
    "text": "currier(dim)\n\nCurrier function for creating a loop list in push_fsize_not_zero function. This function's only purpose is to reduce the amount of memory used.\n\n\n\n"
},

{
    "location": "index.html#Miniball.find_pivot-Union{Tuple{F}, Tuple{I,Array{F,2},Array{F,1},F,I}, Tuple{I}} where F<:AbstractFloat where I<:Integer",
    "page": "Miniball.jl",
    "title": "Miniball.find_pivot",
    "category": "Method",
    "text": "find_pivot(len, points, center, arr_squared_r, dim)\n\nFind a pivot point, which is used for calculating the new miniball.\n\n\n\n"
},

{
    "location": "index.html#Miniball.inside_current_ball-Union{Tuple{Array{F,1},Array{F,1},F,I}, Tuple{F}, Tuple{I}} where F<:AbstractFloat where I<:Integer",
    "page": "Miniball.jl",
    "title": "Miniball.inside_current_ball",
    "category": "Method",
    "text": "inside_current_ball(coords, center, squared_radius, dim)\n\nCheck if the given point is already inside the current miniball.\n\n\n\n"
},

{
    "location": "index.html#Miniball.miniball_pivot-Tuple{Miniball.MBContainer}",
    "page": "Miniball.jl",
    "title": "Miniball.miniball_pivot",
    "category": "Method",
    "text": "miniball_pivot(container)\n\nMain loop for calculating the miniball. The algorithm can be found at http://www.inf.ethz.ch/personal/gaertner/texts/own_work/esa99_final.pdf. It is from B. Gaertner, Fast and Robust Smallest Enclosing Balls, ESA 1999, as Algorithm 2: pivot_mb\n\n\n\n"
},

{
    "location": "index.html#Miniball.miniball_support_points-Union{Tuple{F}, Tuple{Miniball.MBContainer,Array{F,1}}} where F<:AbstractFloat",
    "page": "Miniball.jl",
    "title": "Miniball.miniball_support_points",
    "category": "Method",
    "text": "miniball_support_points(container, end_support_vector)\n\nRecursive function for creating a miniball using the support vector.\n\n\n\n"
},

{
    "location": "index.html#Miniball.new_center_and_radius!-Union{Tuple{Array{F,1},Miniball.MBContainer}, Tuple{F}} where F<:AbstractFloat",
    "page": "Miniball.jl",
    "title": "Miniball.new_center_and_radius!",
    "category": "Method",
    "text": "new_center_and_radius!(pivot, container)\n\nFunction for creating a miniball. All the math related for calculating the miniball can be found from the http://www.inf.ethz.ch/personal/gaertner/texts/own_work/esa99_final.pdf, from B. Gaertner, Fast and Robust Smallest Enclosing Balls, ESA 1999, from section 3. The Primitive Operation and after that.\n\n\n\n"
},

{
    "location": "index.html#Miniball.pivot_move_to_front-Union{Tuple{Array{F,1},Miniball.MBContainer}, Tuple{F}} where F<:AbstractFloat",
    "page": "Miniball.jl",
    "title": "Miniball.pivot_move_to_front",
    "category": "Method",
    "text": "pivot_move_to_front(pivot, container)\n\nAppends a pivot point to the front of the support vector.\n\n\n\n"
},

{
    "location": "index.html#Miniball.pow_2-Union{Tuple{F}, Tuple{F}} where F<:AbstractFloat",
    "page": "Miniball.jl",
    "title": "Miniball.pow_2",
    "category": "Method",
    "text": "pow_2(r)\n\nCalculates the square of a float: r^2\n\n\n\n"
},

{
    "location": "index.html#Miniball.push_fsize_not_zero-Tuple{Array{Float64,1},Miniball.MBContainer}",
    "page": "Miniball.jl",
    "title": "Miniball.push_fsize_not_zero",
    "category": "Method",
    "text": "push_fsize_not_zero(pivot, container)\n\nfsize != 1, calculate the miniball center and squared radius using the current pivot element.\n\n\n\n"
},

{
    "location": "index.html#Miniball.push_fsize_zero-Tuple{Array{Float64,1},Miniball.MBContainer}",
    "page": "Miniball.jl",
    "title": "Miniball.push_fsize_zero",
    "category": "Method",
    "text": "push_fsize_zero(pivot, container)\n\nfsize == 1, insert pivot element to q0 and c vectors\n\n\n\n"
},

{
    "location": "index.html#Miniball.support_points_move_to_front-Union{Tuple{F}, Tuple{I}, Tuple{Miniball.MBContainer,Array{F,1},I}} where F<:AbstractFloat where I<:Integer",
    "page": "Miniball.jl",
    "title": "Miniball.support_points_move_to_front",
    "category": "Method",
    "text": "support_points_move_to_front(container, element, id_)\n\nMoves the support points inside the support vector. The idea is to move the points that are the furthest apart from each other to the front of the vector. Closest points to gather are at the end of the vector.\n\n\n\n"
},

{
    "location": "index.html#Types-and-functions-1",
    "page": "Miniball.jl",
    "title": "Types and functions",
    "category": "section",
    "text": "Modules = [Miniball]"
},

{
    "location": "index.html#Index-1",
    "page": "Miniball.jl",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
