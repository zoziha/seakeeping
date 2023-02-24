# Seakeeping Package

[![seakeeping](https://img.shields.io/badge/Seakeeping-v1.6.0-blueviolet)][1]
[![license](https://img.shields.io/badge/License-BSD--3-important)](LICENSE)
[![fpm](https://img.shields.io/badge/Fortran--lang/fpm-^0.6.0-blue)][2]
[![Compiler](https://img.shields.io/badge/Compiler-GFortran^10.3.0-brightgreen)][3]
[![Fortran](https://img.shields.io/badge/Fortran-^2018-purple)](https://fortran-lang.org/)

[1]: https://github.com/zoziha/seakeeping
[2]: https://github.com/fortran-lang/fpm
[3]: https://fortran-lang.org/compilers

Based on programming experience, writing more detailed and expressive code for a specific field helps
to improve the readability, maintainability, and descriptiveness of the code from the bottom.

Therefore, this package is formed to express and calculate the seakeeping problem of ships.
Facts have proved that this package has indeed improved my coding efficiency and code reuse

Note: Based on the module shake-off feature of the `fpm` program, modules that are not `use` will not participate in the source code compilation, which can relatively improve the compilation efficiency.

## Selective compilation

`fpm` supports tree shattering feature, which can be controlled by the `-no-prune` option,
which is enabled by default. Meanwhile, `fpm` supports preprocessors since `0.7.0`.

If you need to build this package completely as a link library `seakeeping`, you can use the following `flag`:

````sh
cd seakeeping
fpm build --flag "-cpp"          # ifort replaces -cpp with -fpp
fpm build --flag "-cpp -DREAL32" # Compile single precision link library
````

The `openblas` here can be changed to `lapack`, `blas` or others according to your own needs.

If you need to reference the `seakeeping` package in other `fpm` projects, you can enable the tree
shaking command, declared in the `fpm.toml` of the top-level app project:

**Enable openblas**

````toml
[build]
link = ['openblas'] # or link = ['blas', 'lapack']
````

**Enable preprocessor**

````toml
[preprocess]
[preprocess.cpp]
````

Corresponds to: gfortran, `--flag "-cpp"`; ifort (Unix), `--flag "-fpp"`; ifort (Windows), `--flag "/fpp"`.

**Use single precision**

````toml
[preprocess]
[preprocess.cpp]
macros = ['REAL32']
````

Corresponds to: `--flag "-cpp DREAL32"`.

## Other packages

Here are other packages that are suitable for marine seakeeping issues:

- minpack/nlopt-f: solve nonlinear equations;
- fftw/fftpack: Fast Fourier Transform;
- fgsl/gsl: general mathematical functions;
- toml-f: configuration file, terminal;
- M_CLI2: command line;
- test-drive: unit test;
- root-fortran: root lookup;
- polyroot-fortran: polynomial root search;
- quadrature-fortran: multidimensional Gauss-Legendre integral;
- VTKFortran/H5part: storage and visualization;
- Source Codes in Fortran90: Fortran 90 code.

In addition, there are analysis of CAE models and visualization of numerical models,
and technical details such as function integration, statistics, sorting, special functions, etc.
