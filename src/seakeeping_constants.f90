!> 耐波性常数
module seakeeping_constants

    use seakeeping_kinds, only: rk => sk_real_kind
    implicit none

    public
    private :: rk

    real(kind=rk), parameter :: pi = acos(-1.0_rk)
    real(kind=rk), parameter :: pi2 = 2.0_rk*pi
    real(kind=rk), parameter :: g = 9.80665_rk
    real(kind=rk), parameter :: rho_water(2) = [1000.0_rk, 1025.0_rk]
    real(kind=rk), parameter :: rho_air = 1.205_rk
    real(kind=rk), parameter :: p_atm = 101325.0_rk
    real(kind=rk), parameter :: kn2ms = 1852.0_rk/3600.0_rk
    real(kind=rk), parameter :: ms2kn = 3600.0_rk/1852.0_rk

end module seakeeping_constants
