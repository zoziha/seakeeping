!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping units conversion <br>
!> 耐波性单位换算
module seakeeping_units

    use seakeeping_kinds, only: rk
    use seakeeping_constants, only: Pi
    implicit none
    private

    public :: r2d, d2r, kn, ms
    real(rk), parameter :: r2dx = 180.0_rk/Pi
    real(rk), parameter :: d2rx = Pi/180.0_rk

contains

    !> Convert radians to degrees <br>
    !> 弧度转换为度
    elemental real(rk) function r2d(r)
        real(rk), intent(in) :: r

        r2d = r*r2dx

    end function r2d

    !> Convert degrees to radians <br>
    !> 度转换为弧度
    elemental real(rk) function d2r(d)
        real(rk), intent(in) :: d

        d2r = d*d2rx

    end function d2r

    !> Convert knots to m/s <br>
    !> 节转换为米/秒
    elemental real(rk) function ms(v)
        real(rk), intent(in) :: v

        ms = v*0.514444_rk

    end function ms

    !> Convert m/s to knots <br>
    !> 米/秒转换为节
    elemental real(rk) function kn(v)
        real(rk), intent(in) :: v

        kn = v/0.514444_rk

    end function kn

end module seakeeping_units
