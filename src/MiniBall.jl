# This file is a part of JuliaFEM/MiniBall.jl.
# License is MIT: see https://github.com/JuliaFEM/MiniBall.jl/blob/master/LICENSE.md

module MiniBall
using Cxx

export miniball

const path_to_miniball = joinpath(Pkg.dir("MiniBall"),"deps/usr/include/Miniball.hpp")
cxxinclude(path_to_miniball)

cxx"""
#include <iostream>

/*
 * Function for allocating array for miniball
 *
 * Since arrays in Julia are comprehended as 1D arrays when trasported into
 * C++ (I guess) we'll allocate n dimensional array for miniball
 */
template <typename N>
N** allocate_c_arr(int length, int width, N * juliaArr) {
    N** output_arr = new N*[length];
    int index = 0;
    for (int i = 0; i < length; i++) {
        N* inner_arr = new N[width];
        for (int j = 0; j < width; j++) {
            inner_arr[j] = juliaArr[index];
            index += 1;
        }
        output_arr[i] = inner_arr;
    }
    return output_arr;
}

/*
 * Free allocated array
 *
 * Just in case...
 */
template <typename N>
void free_c_array(int length, N** c_arr) {
    for (int i = 0; i < length; i++)
        delete[] c_arr[i];
    delete[] c_arr;
}

/*
 * Calculates smallest enclosing sphere
 */
template <typename T>
double calc_mini(int n, int d, T**arr, T *outputArr) {
    double radius;
    typedef T* const* PointIterator;
    typedef const T* CoordIterator;
    typedef Miniball::Miniball <Miniball::CoordAccessor<PointIterator, CoordIterator> > MB;
    MB mb (n, arr, arr+d);
    const T* center = mb.center();
    for(int i=0; i<n; ++i, ++center) {
        outputArr[i] = *center;
    }
    radius = mb.squared_radius();
    return radius;
}
"""

allocate_jArr_to_cArr(length, width, juliaArr) = @cxxnew allocate_c_arr(length, width, juliaArr)
calc_miniball(length, width, arr, outputArr) = @cxx calc_mini(length, width, arr, outputArr)
free_cArr(length, c_arr) = @cxx free_c_array(length, c_arr)


"""
Smallest enclosing sphere
"""
function miniball{T}(arr::Array{T, 2})
    n, d = size(arr)
    output_arr = zeros(d)
    c_arr = allocate_jArr_to_cArr(n, d, pointer(arr'))
    squared_radius = calc_miniball(d, n, c_arr, pointer(output_arr))
    free_cArr(n, c_arr)
    radius = sqrt(squared_radius)
    return output_arr, radius
end

end # module
