!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping utilities <br>
!> 耐波性工具
module seakeeping_utils

    use seakeeping_kinds, only: rk
    implicit none
    private

    public :: swap

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

end module seakeeping_utils
