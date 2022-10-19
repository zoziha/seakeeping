# Seakeeping Package

[![seakeeping](https://img.shields.io/badge/seakeeping-v1.2.0-blueviolet)][1]
[![license](https://img.shields.io/badge/License-BSD--3-important)](LICENSE)
[![fpm](https://img.shields.io/badge/Fortran--lang/fpm-^0.7.0-blue)][2]
[![Compiler](https://img.shields.io/badge/Compiler-GFortran^10.3.0-brightgreen)][3]

[1]: https://github.com/zoziha/seakeeping
[2]: https://github.com/fortran-lang/fpm
[3]: https://fortran-lang.org/compilers

Based on programming experience, writing more detailed and expressive code for a specific field helps to improve the readability, maintainability, and descriptiveness of the code from the bottom.

Therefore, this package is formed to express and calculate the seakeeping problem of ships.

Note: Based on the module shake-off feature of the `fpm` program, modules that are not `use` will not participate in the source code compilation, which can relatively improve the compilation efficiency.

## Other packages

Here are other packages that are suitable for marine seakeeping issues:

- minpack: solve nonlinear equations;
- fftw/fftpack: Fast Fourier Transform;
- fgsl/gsl: general mathematical functions;
- toml-f: configuration file, terminal;
- M_CLI2: command line;
- openblas: linear algebra;
- test-drive: unit test;
- root-fortran: root lookup;
- polyroot-fortran: polynomial root search;
- Source Codes in Fortran90: Fortran 90 code.

In addition, there are analysis of CAE models and visualization of numerical models, and technical details such as function integration, statistics, sorting, special functions, etc.
