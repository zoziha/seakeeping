!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping units conversion <br>
!> 耐波性单位换算
module seakeeping_units

    use seakeeping_kinds, only: rk
    use seakeeping_constants, only: Pi
    private :: rk, Pi

contains

    !> Convert radians to degrees <br>
    !> 弧度转换为度
    elemental real(rk) function r2d(r)
        real(rk), intent(in) :: r
        real(rk), parameter :: r2dx = 180.0_rk/Pi

        r2d = r*r2dx

    end function r2d

    !> Convert degrees to radians <br>
    !> 度转换为弧度
    elemental real(rk) function d2r(d)
        real(rk), intent(in) :: d
        real(rk), parameter :: d2rx = Pi/180.0_rk

        d2r = d*d2rx

    end function d2r

    !> Convert knots to m/s <br>
    !> 节转换为米/秒
    elemental real(rk) function kn2ms(v)
        real(rk), intent(in) :: v
        real(rk), parameter :: para = 1852.0_rk/3600_rk

        kn2ms = v*para

    end function kn2ms

    !> Convert m/s to knots <br>
    !> 米/秒转换为节
    elemental real(rk) function ms2kn(v)
        real(rk), intent(in) :: v
        real(rk), parameter :: para = 3600_rk/1852.0_rk

        ms2kn = v*para

    end function ms2kn

end module seakeeping_units
