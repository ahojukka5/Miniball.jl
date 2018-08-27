# Deprecated
This repo has some nasty bug, see broken tests. After bug hunt a decission to refactor led to the rewriting of the package, which gave the opportunity to change the license. Development continues in  [BoundingSphere.jl](https://github.com/JuliaFEM/BoundingSphere.jl). Use that package instead.

[![JuliaFEMLogo](https://github.com/JuliaFEM/JuliaFEM.jl/blob/master/docs/logo/JuliaFEMLogo_128x128.png)](http://www.juliafem.org)

# Miniball.jl is a part of JuliaFEM

[![License](https://img.shields.io/github/license/JuliaFEM/Miniball.jl.svg?branch=master)](https://github.com/JuliaFEM/Miniball.jl/blob/master/LICENSE.md)[![Build Status](https://travis-ci.org/JuliaFEM/Miniball.jl.svg?branch=master)](https://travis-ci.org/JuliaFEM/Miniball.jl)[![](https://img.shields.io/badge/docs-stable-blue.svg)](http://juliafem.org/Miniball.jl/stable/)[![](https://img.shields.io/badge/docs-latest-blue.svg)](http://juliafem.org/Miniball.jl/latest/)[![Coverage Status](https://coveralls.io/repos/github/JuliaFEM/Miniball.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaFEM/Miniball.jl?branch=master)[![Issues](https://img.shields.io/github/issues/JuliaFEM/Miniball.jl.svg?branch=master)](https://github.com/JuliaFEM/Miniball.jl/issues)

This is a Julia package for finding the smallest enclosing sphere for a set of points in an arbitrary number of dimensions.  The implementation is based on Bernd Gärtner's [C++ Miniball](https://www.inf.ethz.ch/personal/gaertner/miniball.html) but is implemented entirely in Julia.  The original C++ implementation is licensed under [GNU General Public License (GPLv3)](http://www.gnu.org/copyleft/gpl.html), which is why this implementation also has the same license.

## Some examples of the usage

```julia
julia> using Miniball

julia> ball = miniball([1.0 0.0; 0.0 1.0])

julia> ball.center
[0.5,0.5]

julia> ball.squared_radius
0.5

julia> ball = miniball([-1.0 0.0; 1.0 0.0; 0.0 1.0; 0.0 -1.0])

julia> ball.center
([0.0,0.0],1.0)

julia> ball.squared_radius
1.0

julia> ball = miniball(rand(1000000,3))

julia> ball.center
 [0.502234, 0.495934, 0.504458]

julia> ball.squared_center
0.7283212748080066

```
Original Miniball documentation http://www-oldurls.inf.ethz.ch/personal/gaertner/miniball.html
