# This file is a part of project JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/Miniball.jl/blob/master/LICENSE

using Documenter
using Miniball

makedocs(
    modules = [Miniball],
    checkdocs = :all,
    strict = true)
