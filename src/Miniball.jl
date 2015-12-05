# This file is a part of JuliaFEM/MiniBall.jl.
# License is GPL: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

module Miniball

#    try
#        using Cxx
#        include("cxx_miniball.jl")
#        const path_to_miniball = joinpath(Pkg.dir("MiniBall"),"deps/usr/include/Miniball.hpp")
#        cxxinclude(path_to_miniball)
#        export cxx_miniball
#    catch
#        println("No Cxx installed, only j_miniball available!")
#    end

    include("j_miniball.jl")
    export miniball

end # module
