# 船舶耐波性包

[![Seakeeping](https://img.shields.io/badge/Seakeeping-v1.5.0-blueviolet)][1]
[![License](https://img.shields.io/badge/License-BSD--3-important)](LICENSE)
[![Builder](https://img.shields.io/badge/Builder-fpm^0.6.0_|_meson-blue)][2]
[![Compiler](https://img.shields.io/badge/Compiler-GFortran^10.3.0-brightgreen)][3]
[![Fortran](https://img.shields.io/badge/Fortran-^2018-purple)](https://fortran-lang.org/)

[1]: https://gitee.com/ship-motions/seakeeping
[2]: https://github.com/fortran-lang/fpm
[3]: https://fortran-lang.org/compilers

基于编程经验，对特定领域编写更详实的表达型代码，有助于从底层提高代码的可读性、可维护性、可描述性。

于是，形成了这个包，用于表达、计算船舶耐波性问题。事实证明，本包的确提高了我的编码效率与代码复用。

备注：基于 `fpm` 程序的模块抖落特性，没有被 `use` 的模块将不参与源码编译，可以相对提高编译效率。

## 选择性编译

`fpm` 支持树抖落特性，可以通过 `-no-prune` 选项控制，默认是开启的。同时，`fpm` 从 `0.7.0` 开始支持了预处理器。

若需要完整地单独构建本包为链接库 `seakeeping`，可以使用以下 `flag`：

```sh
cd seakeeping
fpm build --flag "-cpp"           # ifort 将 -cpp 换成 -fpp
fpm build --flag "-cpp -DREAL32"  # 编译单精度链接库
```

此处的 `openblas` 根据自己的需求可以换成 `lapack`、`blas` 或其他。

若需要在其他 `fpm` 项目中引用 `seakeeping` 包，可以启用树抖落命令，在顶级 app 项目的 `fpm.toml` 中声明：

**启用 openblas**

```toml
[build]
link = ['openblas']  # 或者 link = ['blas', 'lapack']
```

**启用预处理器**

```toml
[preprocess]
[preprocess.cpp]
```

对应：gfortran，`--flag "-cpp"`；ifort（Unix），`--flag "-fpp"`；ifort（Windows），`--flag "/fpp"`。

**使用单精度**

```toml
[preprocess]
[preprocess.cpp]
macros = ['REAL32']
```

对应：`--flag "-cpp DREAL32"`。


## 其他包

这里列举其他适用于船舶耐波性问题的包：

- minpack/nlopt-f：非线性方程组求解；
- fftw/fftpack：快速傅里叶变换；
- fgsl/gsl：通用数学函数；
- toml-f：配置文件，终端；
- M_CLI2：命令行；
- test-drive：单元测试；
- root-fortran：根查找；
- polyroot-fortran：多项式根查找；
- quadrature-fortran：多维高斯-勒让德积分；
- VTKFortran/H5part：存储与可视化；
- Source Codes in Fortran90: Fortran 90 代码。

此外，还有 CAE 模型的解析和数值模型可视化，技术细节层面如函数积分、统计、排序、特殊函数等内容。
