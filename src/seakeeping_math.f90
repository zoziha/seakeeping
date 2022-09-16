!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping mathematics <br>
!> 耐波性数学
module seakeeping_math

    use seakeeping_kinds, only: rk
    use seakeeping_constants, only: g, Pi
    implicit none
    private

    public :: cross_product, arg, rad2deg

    complex(rk), parameter :: zero_cmplx = (0.0_rk, 0.0_rk)
    real(rk), parameter :: pi180 = 180.0_rk/Pi

contains

    !> Cross product <br>
    !> 向量叉积计算
    pure function cross_product(a, b) result(c)
        real(rk), intent(in) :: a(3), b(3)
        real(rk) :: c(3)

        c(1) = a(2)*b(3) - a(3)*b(2)
        c(2) = a(3)*b(1) - a(1)*b(3)
        c(3) = a(1)*b(2) - a(2)*b(1)

    end function cross_product

    !> Argument of a complex number <br>
    !> 复数的辐角
    !> @note cmplx%re 需要 gfortran 9 以上支持
    elemental real(rk) function arg(z)
        complex(rk), intent(in) :: z

        if (z == zero_cmplx) then
            arg = 0.0_rk
        else
            arg = atan2(z%im, z%re)
        end if

    end function arg

    !> Radians to degrees <br>
    !> 弧度转角度
    elemental real(rk) function rad2deg(rad)
        real(rk), intent(in) :: rad

        rad2deg = rad*pi180

    end function rad2deg

end module seakeeping_math
