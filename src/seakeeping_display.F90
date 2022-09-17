!> author: 左志华
!> date: 2022-09-17
!>
!> Display routine for seakeeping <br>
!> 耐波性能计算结果显示例程
module seakeeping_display

    use, intrinsic :: iso_fortran_env, only: output_unit
    use seakeeping_kinds, only: rk
    implicit none
    private

    public :: disp

contains

    !> Displays dataset x <br>
    !> 显示数据集 x
    impure subroutine disp(x, header, fmt, unit)
        class(*), intent(in) :: x(..)                   !! Dataset to be displayed <br>
                                                        !! 待显示的数据集
        character(*), intent(in), optional :: header    !! Header of the dataset <br>
                                                        !! 数据集的标题
        character(*), intent(in), optional :: fmt       !! Format of the dataset <br>
                                                        !! 数据集的格式
        integer, intent(in), optional :: unit           !! File unit to outputted <br>
                                                        !! 输出到的文件单元
        character(:), allocatable :: fmt_
        integer :: unit_, i

        if (present(fmt)) then
            fmt_ = '(*('//fmt//',:,", "))'
        else
            fmt_ = '(*(g0.4,:,", "))'
        end if

        if (present(unit)) then
            unit_ = unit
        else
            unit_ = output_unit
        end if

        if (present(header)) write (unit_, '(a)') header

        select rank (x)
#ifdef __GFORTRAN__
        rank (0)    ! @note INTEL Fortran compiler does not support this code
            select type (x)
            type is (real(rk)); write (unit_, fmt_) x
            type is (integer); write (unit_, fmt_) x
            type is (logical); write (unit_, fmt_) x
            end select
#endif
        rank (1)
            select type (x)
            type is (real(rk)); write (unit_, fmt_) x(:)
            type is (integer); write (unit_, fmt_) x(:)
            type is (logical); write (unit_, fmt_) x(:)
            end select

        rank (2)
            do i = 1, size(x, 1)
                select type (x)
                type is (real(rk)); write (unit_, fmt_) x(i, :)
                type is (integer); write (unit_, fmt_) x(i, :)
                type is (logical); write (unit_, fmt_) x(i, :)
                end select
            end do

        rank default
            write (unit_, '(a,i0)') "*<Wranning>* Rank not supported: ", rank(x)

        end select

    end subroutine disp

end module seakeeping_display
