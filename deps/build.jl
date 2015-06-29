# This file is a part of JuliaFEM/MiniBall.
# License is MIT: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

using BinDeps

cd(dirname(@__FILE__)) do

    here = dirname(@__FILE__)
    @BinDeps.setup
    miniball = "Miniball"
    libminiball = library_dependency("libMiniball", aliases = ["libMiniball.so"])
    builddir = joinpath(BinDeps.builddir(libminiball), libminiball.name)
    srcdir = joinpath(BinDeps.srcdir(libminiball),miniball)
    libdir = joinpath(BinDeps.depsdir(libminiball),"usr","lib")

    run(`wget http://www.inf.ethz.ch/personal/gaertner/miniball/Miniball.hpp`)
    run(`mv Miniball.hpp Miniball.cpp`)

    provides(SimpleBuild,
             (@build_steps begin
                CreateDirectory(builddir)
                CreateDirectory(libdir)
                @build_steps begin
                  ChangeDirectory(builddir)
                  `cp ../../Miniball.cpp ./`  
                  `g++ -shared -fPIC Miniball.cpp -o libMiniball.so`
                  `cp libMiniball.so $libdir`
                  `rm $here/Miniball.cpp`
                end
              end),
             libminiball, os = :Unix)

    @BinDeps.install Dict(:libminiball => :libminiball)
end
