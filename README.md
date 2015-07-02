[![JuliaFEMLogo](https://github.com/JuliaFEM/JuliaFEM.jl/blob/master/docs/logo/JuliaFEMLogo_128x128.png)](http://www.juliafem.org) 

# MiniBall.jl is a part of JuliaFEM

```julia
julia> using MiniBall

julia> miniball([1.0 0.0; 0.0 1.0])
([0.5,0.5],0.7071067811865476)

julia> miniball([-1.0 0.0; 1.0 0.0; 0.0 1.0; 0.0 -1.0])
([0.0,0.0],1.0)

julia> miniball([-1.0 0.0 0.0; 1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 -1.0 0.0])
([0.0,0.0,0.0],1.0)

julia> miniball(rand(1000000,3))
([0.503497331212874,0.4966413939942441,0.5004940446765603],0.8576670553673171)

julia> 
```
Here is the original Miniball documentation http://www-oldurls.inf.ethz.ch/personal/gaertner/miniball.html
[![Miniball log](http://www-oldurls.inf.ethz.ch/personal/gaertner/miniball/mb.gif)](http://www-oldurls.inf.ethz.ch/personal/gaertner/miniball.html)

MiniBall.jl is wrapped using [Cxx.jl](https://github.com/Keno/Cxx.jl)
