!> author: 左志华
!> date: 2022-09-17
!>
!> String for seakeeping <br>
!> 耐波心性字符串
module seakeeping_string

    use, intrinsic :: iso_c_binding, only: newline => c_new_line
    use seakeeping_kinds, only: rk
    implicit none
    private

    public :: to_string, newline

contains

    !> Format other types to a string <br>
    !> 将其他类型转化为字符串
    pure function to_string(x, fmt) result(s)
        class(*), intent(in) :: x                   !! Input object <br>
                                                    !! 输入类型
        character(*), intent(in), optional :: fmt   !! format string <br>
                                                    !! 格式化字符串
        character(:), allocatable :: s
        character(128) :: s_

        if (present(fmt)) s = "("//fmt//")"
        select type (x)
        type is (integer)
            if (present(fmt)) then
                write (s_, s) x
            else
                write (s_, *) x
            end if
            s = trim(s_)
        type is (logical)
            if (present(fmt)) then
                write (s_, s) x
                s = trim(s_)
            else
                if (x) then
                    s = "T"
                else
                    s = "F"
                end if
            end if
        type is (real(rk))
            if (present(fmt)) then
                write (s_, s) x
            else
                write (s_, *) x
            end if
            s = trim(s_)
        class default
            s = "[*]"
        end select

    end function to_string

end module seakeeping_string