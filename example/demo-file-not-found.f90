! This file is part of Seakeeping. SPDX-Identifier: BSD 3-Clause License.
program main

    use seakeeping_error, only: file_not_found_error, panic
    character(:), allocatable :: error  !! 错误信息

    call read_file('test.txt', error)
    if (allocated(error)) then
        call panic(error, code=1)
    end if

contains

    !> 读取文件
    subroutine read_file(file, error)
        character(*), intent(in) :: file  !! 文件名
        character(:), allocatable, intent(out) :: error  !! 错误信息
        logical :: exist  !! 文件是否存在
        integer :: i, fid

        inquire (file=file, exist=exist)
        if (.not. exist) then
            call file_not_found_error(error, file)
            return
        end if

        open (newunit=fid, file=file, action='read')
        read (fid, *) i
        close (fid)

    end subroutine read_file

end program main
