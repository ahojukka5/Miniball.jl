# This file is a part of JuliaFEM/MiniBall.
# License is MIT: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

cd(dirname(@__FILE__)) do
    here = dirname(@__FILE__)
    run(`wget http://www.inf.ethz.ch/personal/gaertner/miniball/Miniball.hpp`)
    try
      run(`mkdir $here/downloads`)
    end
    run(`mv Miniball.hpp $here/downloads`)
    run(`wget http://www.inf.ethz.ch/personal/gaertner/miniball/license.html`)
    run(`mv license.html $here/downloads`)
end
