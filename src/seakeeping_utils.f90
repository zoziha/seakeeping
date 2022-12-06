!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping utilities <br>
!> 耐波性工具
module seakeeping_utils

    use seakeeping_kinds, only: rk
    private :: rk

    interface incr
        procedure :: incr_ik, incr_rk
    end interface incr
    private :: incr_ik, incr_rk

    interface swap
        procedure :: swap_ik, swap_rk
    end interface swap
    private :: swap_ik, swap_rk

    interface optval
        procedure :: optval_ik, optval_rk, optval_lk
    end interface optval
    private :: optval_ik, optval_rk, optval_lk

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

    !> 查询 key 是否存在与环境变量，如果存在则返回其值，否则返回默认值。
    !> @note 可使用 len(optenv('key', '')) == 0 以判断 key 在环境变量中不存在
    impure function optenv(key, default)
        character(*), intent(in) :: key       !! 名
        character(*), intent(in) :: default   !! 值
        character(:), allocatable :: optenv
        integer :: stat
        character(len=128) :: value

        call get_environment_variable(key, value, status=stat)
        if (stat == 0) then
            optenv = trim(value)
        else
            optenv = default
        end if

    end function optenv

    !> Bubble sort <br>
    !> 冒泡排序
    pure subroutine bubble_sort(unsorted)
        integer, intent(inout) :: unsorted(:)
        integer :: ik, jk, isize

        isize = size(unsorted)
        do ik = 1, isize

            do jk = ik, isize
                if (unsorted(ik) > unsorted(jk)) call swap_ik(unsorted(ik), unsorted(jk))
            end do

        end do

    end subroutine bubble_sort

end module seakeeping_utils
