# 船舶耐波性包

[![seakeeping](https://img.shields.io/badge/seakeeping-v1.3.0-blueviolet)][1]
[![license](https://img.shields.io/badge/License-BSD--3-important)](LICENSE)
[![fpm](https://img.shields.io/badge/Fortran--lang/fpm-^0.7.0-blue)][2]
[![Compiler](https://img.shields.io/badge/Compiler-GFortran^10.3.0-brightgreen)][3]

[1]: https://gitee.com/ship-motions/seakeeping
[2]: https://github.com/fortran-lang/fpm
[3]: https://fortran-lang.org/compilers

基于编程经验，对特定领域编写更详实的表达型代码，有助于从底层提高代码的可读性、可维护性、可描述性。

于是，形成了这个包，用于表达、计算船舶耐波性问题。

备注：基于 `fpm` 程序的模块抖落特性，没有被 `use` 的模块将不参与源码编译，可以相对提高编译效率。

## 其他包

这里列举其他适用于船舶耐波性问题的包：

- minpack：非线性方程组求解；
- fftw/fftpack：快速傅里叶变换；
- fgsl/gsl：通用数学函数；
- toml-f：配置文件，终端；
- M_CLI2：命令行；
- openblas：线性代数；
- test-drive：单元测试；
- root-fortran：根查找；
- polyroot-fortran：多项式根查找；
- Source Codes in Fortran90: Fortran 90 代码。

此外，还有 CAE 模型的解析和数值模型可视化，技术细节层面如函数积分、统计、排序、特殊函数等内容。
