!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping utilities <br>
!> 耐波性工具
module seakeeping_utils

    use seakeeping_kinds, only: rk
    implicit none
    private

    public :: swap, incr, optval

    interface incr
        procedure :: incr_ik, incr_rk
    end interface incr

    interface optval
        procedure :: optval_ik, optval_rk, optval_lk
    end interface optval

contains

    !> Swap two variables <br>
    !> 交换两个变量
    elemental subroutine swap(a, b)
        real(rk), intent(inout) :: a, b
        real(rk) :: tmp

        tmp = a
        a = b
        b = tmp

    end subroutine swap

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

end module seakeeping_utils
