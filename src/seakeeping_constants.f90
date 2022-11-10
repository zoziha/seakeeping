!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping constants <br>
!> 耐波性常数
module seakeeping_constants

    use seakeeping_kinds, only: rk
    private :: rk

    real(rk), parameter :: g = 9.806_rk             !! Gravity acceleration <br>
                                                    !! 重力加速度
    real(rk), parameter :: Pi = acos(-1.0_rk)       !! Pi <br>
                                                    !! 圆周率
    real(rk), parameter :: rho_sw = 1025.0_rk       !! Density of seawater <br>
                                                    !! 海水密度
    real(rk), parameter :: rho_fw = 1000.0_rk       !! Density of freshwater <br>
                                                    !! 水密度
    real(rk), parameter :: rho_air = 1.205_rk       !! Density of air <br>
                                                    !! 空气密度
    real(rk), parameter :: p_atm = 101325.0_rk      !! Atmospheric pressure <br>
                                                    !! 大气压力
    real(rk), parameter :: sqrt_eps = sqrt(epsilon(1.0_rk))     !! sqrt(epsilon) <br>
                                                                !! 小量，平方根精度

end module seakeeping_constants
