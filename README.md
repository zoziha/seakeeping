# 船舶耐波性包

![seakeeping](https://img.shields.io/badge/Seakeeping-v2.5.20230611-blueviolet)
[![license](https://img.shields.io/badge/License-BSD--3-important)](LICENSE)
![Compiler](https://img.shields.io/badge/Compiler-MSYS2--GFortran^12.2.0-brightgreen)

基于编程经验，对特定领域编写更详实的表达型代码，有助于从底层提高代码的可读性、可维护性、可描述性。

于是，形成了这个包，用于表达、计算船舶耐波性问题。事实证明，本包的确提高了我的编码效率与代码复用。

除此之外，还有 fffc 通用函数库，kissfft-f 快速傅里叶变换库，以及其他一些包，可以用于船舶耐波性问题的求解。

## 使用 Meson 编译

本包也支持使用 `meson` 构建，可以使用 `meson` 的 `subproject` 功能，将 `seakeeping` 作为子项目引入。

```sh
> meson setup _build  # 配置 meson 构建目录
> meson compile -C _build  # 编译
```

在 `meson.build` 中，可以使用 `subproject` 函数引入 `seakeeping`：

```meson
seakeeping_dep = subproject('seakeeping').get_variable('seakeeping_dep')
```

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
