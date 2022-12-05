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
    real(rk), parameter :: sqrt_eps = sqrt(epsilon(1.0_rk))     !! sqrt(epsilon) <br>
                                                                !! 小量，平方根精度
    !> 输出格式
    character(*), parameter :: fmt(*) = &
                               &[character(21) :: &
                                '(a, *(g0.4, :, ", "))', &
                                '(*(g0.4, :, ", "))', &
                                '(*(a, g0.4, :, ", "))']

end module seakeeping_constants
