! This file is part of Seakeeping. SPDX-Identifier: BSD 3-Clause License.
program main

    use seakeeping_error, only: file_not_found_error, file_read_error, panic
    character(:), allocatable :: error  !! 错误信息

    call read_file('example/demo-file-read.f90', error)
    if (allocated(error)) then
        call panic(error, code=2)
    end if

contains

    !> 读取文件
    subroutine read_file(file, error)
        character(*), intent(in) :: file  !! 文件名
        character(:), allocatable, intent(out) :: error  !! 错误信息
        logical :: exist  !! 文件是否存在
        integer :: i, fid, istat

        inquire (file=file, exist=exist)
        if (.not. exist) then
            call file_not_found_error(error, file)
            return
        end if

        open (newunit=fid, file=file, action='read')
        read (fid, *, iostat=istat) i
        if (istat /= 0) then
            call file_read_error(error, file, 'read integer failed')
            close (fid)
            return
        end if
        close (fid)

    end subroutine read_file

end program main
