!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping utilities <br>
!> 耐波性工具
module seakeeping_utils

    use, intrinsic :: iso_c_binding, only: c_int
    use seakeeping_kinds, only: rk
    implicit none
    private

    public :: swap, incr, optval, isatty, env_color

    interface incr
        procedure :: incr_ik, incr_rk
    end interface incr

    interface swap
        procedure :: swap_ik, swap_rk
    end interface swap

    interface optval
        procedure :: optval_ik, optval_rk, optval_lk
    end interface optval

    ! 从 Fortran-lang/fpm 借鉴来的 TTY 检测，GFortran 自带的终端检测在 Windows 下不可用
    interface
        function isatty() bind(c, name='c_isatty')
            import :: c_int
            integer(c_int) :: c_isatty
        end function isatty
    end interface

contains

    !> Swap two variables <br>
    !> 交换两个变量
    elemental subroutine swap_ik(a, b)
        integer, intent(inout) :: a, b
        integer :: tmp

        tmp = a
        a = b
        b = tmp

    end subroutine swap_ik

    !> Swap two variables <br>
    !> 交换两个变量
    elemental subroutine swap_rk(a, b)
        real(rk), intent(inout) :: a, b
        real(rk) :: tmp

        tmp = a
        a = b
        b = tmp

    end subroutine swap_rk

    !> Increment a variable <br>
    !> 增量一个变量
    elemental subroutine incr_rk(a, b)
        real(rk), intent(inout) :: a
        real(rk), intent(in), optional :: b

        if (present(b)) then
            a = a + b
        else
            a = a + 1.0_rk
        end if

    end subroutine incr_rk

    !> Increment a variable <br>
    !> 增量一个变量
    elemental subroutine incr_ik(a, b)
        integer, intent(inout) :: a
        integer, intent(in), optional :: b

        if (present(b)) then
            a = a + b
        else
            a = a + 1
        end if

    end subroutine incr_ik

    !> Optional value <br>
    !> 可选值
    !> @note 借鉴自 stdlib
    elemental real(rk) function optval_rk(a, b) result(optval)
        real(rk), intent(in), optional :: a
        real(rk), intent(in) :: b

        if (present(a)) then
            optval = a
        else
            optval = b
        end if

    end function optval_rk

    !> Optional value <br>
    !> 可选值
    !> @note 借鉴自 stdlib
    elemental integer function optval_ik(a, b) result(optval)
        integer, intent(in), optional :: a
        integer, intent(in) :: b

        if (present(a)) then
            optval = a
        else
            optval = b
        end if

    end function optval_ik

    !> Optional value <br>
    !> 可选值
    !> @note 借鉴自 stdlib
    elemental logical function optval_lk(a, b) result(optval)
        logical, intent(in), optional :: a
        logical, intent(in) :: b

        if (present(a)) then
            optval = a
        else
            optval = b
        end if

    end function optval_lk

    !> Get the value of the environment variable NO_COLOR to determine whether to enable console color <br>
    !> 获取环境变量 NO_COLOR 的值，确定是否启用控制台颜色
    !> @note NO_COLOR 存在，则 env_color 返回 .false.
    logical function env_color()
        integer :: color_status
        character(len=128) :: color_value

        call get_environment_variable("NO_COLOR", color_value, status=color_status)
        if (color_status == 0) then
            env_color = .false.
        else
            env_color = .true.
        end if

    end function env_color

end module seakeeping_utils
