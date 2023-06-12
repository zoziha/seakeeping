---
title: Leap Frog Integration Method
---

# 蛙跳积分法

蛙跳积分法本身不可用于加速度受速度影响的物理过程，但蛙跳法计算量小，且属于中心差分法，具有适中的精度，
在力学模拟中十分合适！

1. `[[seakeeping_leapfrog(module):leapfrog_init(subroutine)]]` 计算初始时刻的加速度，并使得**速度前进半步长**，
并将初始时刻的位移、加速度及前进半步长的速度作为一组数据集合；
2. `[[seakeeping_leapfrog(module):leapfrog(subroutine)]]` 将数据集合中的位移、速度、加速度均**前进一步长**，
得到新的数据集合，并更新位移、加速度所对应的时间。
3. `[[seakeeping_leapfrog(module):leapfrog_final(subroutine)]]` 将数据集合中的**速度后退半步长**，
使得速度与位移、加速度对应的时间相同。

备注：由于在船舶力学领域，速度verlet积分法的应用场景有限，所以仅支持蛙跳积分法。
