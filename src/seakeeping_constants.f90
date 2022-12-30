! This file is part of Seakeeping. SPDX-Identifier: BSD 3-Clause License.
!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping constants <br>
!> 耐波性常数
module seakeeping_constants

    use seakeeping_kinds, only: rk
    private :: rk

    real(rk), parameter :: g = 9.806_rk                         !! Gravity acceleration <br>
                                                                !! 重力加速度
    real(rk), parameter :: Pi = acos(-1.0_rk)                   !! Pi <br>
                                                                !! 圆周率
    real(rk), parameter :: rho_water(2) = [1000.0_rk, 1025.0_rk]!! 水密度（1-淡水，2-海水）
    real(rk), parameter :: rho_air = 1.205_rk                   !! Density of air <br>
                                                                !! 空气密度
    real(rk), parameter :: p_atm = 101325.0_rk                  !! Atmospheric pressure <br>
                                                                !! 大气压力
    !> 机器数值常量
    !> 1. sqrt(epsilon)
    !> 2. 1/3
    !> 3. 2/3
    real(rk), parameter :: const(*) = [sqrt(epsilon(1.0_rk)), &
                                       1.0_rk/3.0_rk, &
                                       2.0_rk/3.0_rk]

    !> 输出格式
    !> 1. 字符+N数值
    !> 2. N数值
    !> 3. N(字符+数值)
    character(*), parameter :: fmt(*) = &
                               &[character(21) :: &
                                '(a, *(g0.4, :, ", "))', &
                                '(*(g0.4, :, ", "))', &
                                '(*(a, g0.4, :, ", "))']

end module seakeeping_constants
