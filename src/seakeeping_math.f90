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

    public :: cross_product, arg, heron_formula, angle

    complex(rk), parameter :: zero_cmplx = (0.0_rk, 0.0_rk)

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

    !> Heron's formula for the area of a triangle <br>
    !> 海伦公式计算三角形面积
    pure subroutine heron_formula(a, b, c, s)
        real(rk), intent(in) :: a, b, c     !! Length of the three sides of the triangle <br>
                                            !! 三边长 (m)
        real(rk), intent(out) :: s          !! Area of the triangle <br>
                                            !! 三角形面积 (m2)

        associate (p => (a + b + c)/2)
            s = sqrt(p*(p - a)*(p - b)*(p - c))
        end associate

    end subroutine heron_formula

    !> Calculate the angle of two vectors <br>
    !> 计算两向量的夹角
    pure real(rk) function angle(x, y)
        real(rk), intent(in), dimension(3) :: x, y  !! Two vectors <br>
                                                    !! 两向量

        angle = acos(dot_product(x, y)/(norm2(x)*norm2(y)))

    end function angle

end module seakeeping_math
