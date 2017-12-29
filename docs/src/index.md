# Miniball.jl

This is a Julia package for finding the smallest enclosing sphere for a set of points in an arbitrary number of dimensions.  The implementation is based on Bernd Gärtner's [C++ Miniball](https://www.inf.ethz.ch/personal/gaertner/miniball.html) but is implemented entirely in Julia.  The original C++ implementation is licensed under [GNU General Public License (GPLv3)](http://www.gnu.org/copyleft/gpl.html), which is why this implementation also has the same license.

```@contents
```

## Typical useage

This package has a simple interface.  Call

```julia
ball = miniball(points)
```

where `points` is a 2D array of size `n × d` representing `n` points in `d` dimensions.  The resulting object `ball` has two fields -- `ball.center` and `ball.squared_radius` which contain details about the resulting miniball.  

The `minball` function covers most use cases, but descriptions of all functions including internals can be found below.  

```@meta
DocTestSetup = quote
    using Miniball
end
```

## Types and functions


```@autodocs
Modules = [Miniball]
```


## Index

```@index
```
