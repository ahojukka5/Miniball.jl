# This file is a part of JuliaFEM/MiniBall.
# License is MIT: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

cd(dirname(@__FILE__)) do
    here = dirname(@__FILE__)
    try
      run(`mkdir $here/downloads`)
    end
    try
      run(`mkdir $here/usr`)
      run(`mkdir $here/usr/include`)
    end
    cur = pwd()
    cd("$here/downloads")
    run(`wget -r --no-parent -nH --cut-dirs=2 -e robots=off --reject='index.html*'
          http://www.inf.ethz.ch/personal/gaertner/miniball/`)
    run(`cp miniball/Miniball.hpp $here/usr/include`)
    cd(cur)
end
