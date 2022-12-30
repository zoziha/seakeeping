! This file is part of Seakeeping. SPDX-Identifier: BSD 3-Clause License.
program main

    use seakeeping_error, only: general_error, panic
    character(:), allocatable :: error  !! 错误信息

    call do_somethings(1, 2, 4, error)
    if (allocated(error)) then
        call panic(error, code=4)
    end if

contains

    !> 某算法
    pure subroutine do_somethings(a, b, c, error)
        integer, intent(in) :: a, b, c
        character(:), allocatable, intent(out) :: error  !! 错误信息

        if (a + b /= c) then
            call general_error(error, 'a + b /= c')
            return
        end if

    end subroutine do_somethings

end program main
