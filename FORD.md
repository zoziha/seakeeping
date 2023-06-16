---
project: Seakeeping
summary: 🌏船舶耐波性例程
src_dir: src
preprocess: false
project_website: https://gitee.com/ship-motions/seakeeping
project_download: https://gitee.com/ship-motions/seakeeping/releases
output_dir: _build/ford
page_dir: ford
author: 左志华
author_description: 哈尔滨工程大学-船舶与海洋结构物设计制造，在读学生
email: zuo.zhihua@qq.com
website: https://gitee.com/zoziha
display: public
graph: false
source: true
license: bsd
md_extensions: markdown.extensions.toc
parallel: 4
print_creation_date: true
creation_date: %Y-%m-%d %H:%M %z
---

![Language](https://img.shields.io/badge/-Fortran-734f96?logo=fortran&logoColor=white)
[![license](https://img.shields.io/badge/License-BSD--3-brightgreen)](LICENSE)
![Actions Status](https://github.com/zoziha/seakeeping/workflows/msys2-build/badge.svg)

`seakeeping` 是一个适用于船舶耐波性相关计算的函数包。

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

理论上，Meson 支持 Windows/macOS/Linux 下的 gfortran, macOS/Linux 下的 ifort。
若需要支持 Windows 下的 ifort, 可搭配 VS2022 进行编译。

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
