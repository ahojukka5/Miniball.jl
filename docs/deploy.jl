# This file is a part of project JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/Miniball.jl/blob/master/LICENSE

using Documenter
using Miniball

deploydocs(
    repo = "github.com/JuliaFEM/Miniball.jl.git",
    julia = "0.6",
    target = "build",
    deps = nothing,
    make = nothing)
