!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping mathematics <br>
!> 耐波性数学
module seakeeping_math

    use, intrinsic :: ieee_arithmetic, only: ieee_is_nan
    use seakeeping_kinds, only: rk
    use seakeeping_constants, only: g, Pi, sqrt_eps
    implicit none
    private

    public :: cross_product, arg, heron_formula, angle, arange, linspace, is_close, unitize

    interface arange
        procedure :: arange_ik, arange_rk
    end interface arange

    interface linspace
        procedure :: linspace_ik, linspace_rk
    end interface linspace

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
    pure real(rk) function heron_formula(a, b, c) result(s)
        real(rk), intent(in) :: a, b, c     !! Length of the three sides of the triangle <br>
                                            !! 三边长 (m)

        associate (p => (a + b + c)/2)
            s = sqrt(p*(p - a)*(p - b)*(p - c))
        end associate

    end function heron_formula

    !> Calculate the angle of two vectors <br>
    !> 计算两向量的夹角
    pure real(rk) function angle(x, y)
        real(rk), intent(in), dimension(3) :: x, y  !! Two vectors <br>
                                                    !! 两向量

        angle = acos(dot_product(x, y)/(norm2(x)*norm2(y)))

    end function angle

    !> constructs a vector of integers from start to end with step <br>
    !> 从 start 到 end 构造一个整数向量，步长为 step
    pure function arange_ik(start, end, step) result(v)
        integer, intent(in) :: start
        integer, intent(in), optional :: end, step
        integer, allocatable :: v(:)

        integer start_, end_, step_
        integer i

        if (present(end)) then
            start_ = start
            end_ = end
        else
            start_ = 1
            end_ = start
        end if

        if (present(step)) then
            step_ = step
        else
            step_ = 1
        end if

        if (step_ /= 0) then
            step_ = sign(step_, end_ - start_)
        else
            step_ = sign(1, end_ - start_)
        end if

        allocate (v((end_ - start_)/step_ + 1))
        v = [(i, i=start_, end_, step_)]

    end function arange_ik

    !> constructs a vector of reals from start to end with step <br>
    !> 从 start 到 end 构造一个实数向量，步长为 step
    pure function arange_rk(start, end, step) result(v)
        real(rk), intent(in) :: start
        real(rk), intent(in), optional :: end, step
        real(rk), allocatable :: v(:)

        real(rk) :: start_, end_, step_
        integer :: i

        if (present(end)) then
            start_ = start
            end_ = end
        else
            start_ = 1.0_rk
            end_ = start
        end if

        if (present(step)) then
            step_ = step
        else
            step_ = 1.0_rk
        end if

        if (step_ /= 0.0_rk) then
            step_ = sign(step_, end_ - start_)
        else
            step_ = sign(1.0_rk, end_ - start_)
        end if

        allocate (v(floor((end_ - start_)/step_) + 1))
        v = [(start_ + (i - 1)*step_, i=1, size(v), 1)]

    end function arange_rk

    !> check if a and b are close <br>
    !> 检查a和b是否相近
    elemental logical function is_close(a, b, rel_tol, abs_tol, equal_nan) result(close)
        real(rk), intent(in) :: a, b
        real(rk), intent(in), optional :: rel_tol, abs_tol
        logical, intent(in), optional :: equal_nan
        logical :: equal_nan_
        real(rk) :: abs_tol_, rel_tol_

        if (present(equal_nan)) then
            equal_nan_ = equal_nan
        else
            equal_nan_ = .false.
        end if

        if (ieee_is_nan(a) .or. ieee_is_nan(b)) then
            close = merge(.true., .false., equal_nan_ .and. ieee_is_nan(a) .and. ieee_is_nan(b))
        else

            if (present(rel_tol)) then
                rel_tol_ = rel_tol
            else
                rel_tol_ = sqrt_eps
            end if

            if (present(abs_tol)) then
                abs_tol_ = abs_tol
            else
                abs_tol_ = 0.0_rk
            end if

            close = abs(a - b) <= max(abs(rel_tol_*max(abs(a), abs(b))), &
                                      abs(abs_tol_))
        end if

    end function is_close

    !> Unitize a vector <br>
    !> 单位化向量
    pure function unitize(x) result(y)
        real(rk), intent(in), dimension(3) :: x
        real(rk), dimension(3) :: y

        y = x/sqrt(sum(x*x))

    end function unitize

    !> constructs a vector of n linearly spaced numbers from start to end <br>
    !> 从 start 到 end 构造一个 n 个线性间隔的数字向量
    pure function linspace_rk(start, end, n) result(v)
        real(rk), intent(in) :: start, end
        integer, intent(in) :: n
        real(rk) :: v(max(n, 0))

        real(rk) :: step
        integer :: i

        if (n <= 0) then
            return
        elseif (n == 1) then
            v(1) = start
            return
        end if

        step = (end - start)/(n - 1)
        do concurrent(i=1:n)
            v(i) = start + (i - 1)*step
        end do

    end function linspace_rk

    !> returns a vector of n linearly spaced integers from start to end <br>
    !> 从 start 到 end 构造一个 n 个线性间隔的整数向量
    pure function linspace_ik(start, end, n) result(v)
        integer, intent(in) :: start, end
        integer, intent(in) :: n
        integer :: v(max(n, 0))

        integer :: step
        integer :: i

        if (n <= 0) then
            return
        elseif (n == 1) then
            v(1) = start
            return
        end if

        step = (end - start)/(n - 1)
        do concurrent(i=1:n)
            v(i) = start + (i - 1)*step
        end do

    end function linspace_ik

end module seakeeping_math
