# This file is a part of JuliaFEM/MiniBall.jl.
# License is GPL: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

module Miniball
    warn("Miniball.jl is no longer maintained. Use BoundingSphere.jl instead")

    include("src.jl")
    export miniball

end # module
