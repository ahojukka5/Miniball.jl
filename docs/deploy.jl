# This file is a part of project JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/Miniball.jl/blob/master/LICENSE

using Documenter
using Miniball

deploydocs(
    deps = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/JuliaFEM/Miniball.jl.git")
