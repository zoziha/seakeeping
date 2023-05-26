---
title: Wave Theory
---

# 波浪理论

## `zeta` 波浪高度计算

### 语法

```fortran
z = [[seakeeping_wave(module):zeta(function)]](k, x, y, w, t, beta, phase)
```

### 参数

| 参数 | 类型 | 说明 | 默认值 | 单位 |
| :---: | :---: | :---: | :---: | :---: |
| `k` | `real` | 波数 | - | - |
| `x` | `real` | x 轴坐标 | - | m |
| `y` | `real` | y 轴坐标 | - | m |
| `w` | `real` | 波浪角频率 | - | rad/s |
| `t` | `real` | 时间 | - | s |
| `beta` | `real` | 波浪方向 | - | rad |
| `phase` | `real` | 波浪相位 | - | rad |

### 返回值

| 类型 | 说明 | 单位 |
| :---: | :---: | :---: |
| `real` | 波浪高度 | m |

### 示例

无
