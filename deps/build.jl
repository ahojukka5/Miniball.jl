# This file is a part of JuliaFEM/MiniBall.
# License is MIT: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

cd(dirname(@__FILE__)) do
    here = dirname(@__FILE__)
    run(`wget http://www.inf.ethz.ch/personal/gaertner/miniball/Miniball.hpp`)
    run(`mkdir $here/downloads`)
    run(`mv Miniball.hpp $here/downloads`)
end
