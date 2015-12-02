[![JuliaFEMLogo](https://github.com/JuliaFEM/JuliaFEM.jl/blob/master/docs/logo/JuliaFEMLogo_128x128.png)](http://www.juliafem.org) 

# MiniBall.jl is a part of JuliaFEM


Julia package for a smallest enclosing sphere for points in arbitrary dimensions. Implementation is based on the Bernd Gärtner's C++ miniball (https://www.inf.ethz.ch/personal/gaertner/miniball.html). Presented implementation is pure Julia code, does not have any depencies and has the same speed as the C++ implementation.

## Some examples of the usage 

```julia
julia> using Miniball

# C++ miniball wrapper. Returns only the center and squared radius
julia> center, squared_radius = cxx_miniball([1.0 0.0; 0.0 1.0])

julia> center
[0.5,0.5]

julia> squared_radius
0.5

julia> cxx_miniball([-1.0 0.0; 1.0 0.0; 0.0 1.0; 0.0 -1.0])
([0.0,0.0],1.0)

julia> cxx_miniball([-1.0 0.0 0.0; 1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 -1.0 0.0])
([0.0,0.0,0.0],1.0)

julia> cxx_miniball(rand(1000000,3))
([0.503497331212874,0.4966413939942441,0.5004940446765603],0.8576670553673171)

# Julia miniball implementation. Returns a Miniball type
julia> ball = j_miniball(rand(1000, 3))

julia> ball.center
3-element Array{Float64,1}:
 0.518771
 0.52564 
 0.503871

julia> ball.squared_radius
0.5032690087547128
```
Here is the original Miniball documentation http://www-oldurls.inf.ethz.ch/personal/gaertner/miniball.html

[![Miniball log](http://www-oldurls.inf.ethz.ch/personal/gaertner/miniball/mb.gif)](http://www-oldurls.inf.ethz.ch/personal/gaertner/miniball.html)

MiniBall.jl is wrapped using [Cxx.jl](https://github.com/Keno/Cxx.jl)
