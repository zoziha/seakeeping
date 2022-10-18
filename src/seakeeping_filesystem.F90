!> author: 左志华
!> date: 2022-09-17
!>
!> Filesystem for seakeeping
module seakeeping_filesystem

    implicit none
    private

    public :: is_exist, countlines, operator(.join.), is_windows, windows_path, &
              mkdir, rmdir

    interface operator(.join.)
        procedure :: join_path
    end interface

contains

    !> Inquire whether a file/directory exists <br>
    !> 查询文件 / 文件夹路径是否存在
    impure elemental logical function is_exist(file, dir)
        character(*), intent(in) :: file    !! file name <br>
                                            !! 文件 / 文件夹名称
        logical, intent(in), optional :: dir!! is directory ? <br>
                                            !! 是否为文件夹 ?
#if defined __INTEL_COMPILER
        if (present(dir)) then
            if (dir) then
                inquire (directory=file, exist=is_exist)
                return
            end if
        end if
#endif
        inquire (file=file, exist=is_exist)

    end function is_exist

    !> Judge if the system is Windows operating system <br>
    !> 判断系统是否为 Windows 操作系统
    impure logical function is_windows()
        character(16) :: os_name
        logical, save :: is_windows_ = .false.
        logical, save :: is_first_run = .true.

        if (is_first_run) then
            call get_environment_variable("OS", os_name) ! GNU extension, IFORT extension
            is_windows_ = trim(os_name) == "Windows_NT"
            is_first_run = .false.
            is_windows = is_windows_
        else
            is_windows = is_windows_
        end if

    end function is_windows

    !> Counts the line number of text file <br>
    !> 计算文本文件行数
    impure integer function countlines(file)
        character(*), intent(in) :: file    !! file name <br>
                                            !! 文件名称
        integer :: istat, iunit

        open (newunit=iunit, file=file, status='old')
        countlines = 0
        do
            read (iunit, *, iostat=istat)
            if (is_iostat_end(istat)) exit
            countlines = countlines + 1
        end do
        close (iunit)

    end function countlines

    !> Replace file system separator for Windows <br>
    !> 将文件系统分隔符替换为 Windows 的分隔符
    pure function windows_path(path) result(winpath)
        character(*), intent(in) :: path    !! path name <br>
                                            !! 文件路径
        character(len(path)) :: winpath
        integer :: ik

        do concurrent(ik=1:len(path))
            if (path(ik:ik) == "/") then
                winpath(ik:ik) = "\"
            else
                winpath(ik:ik) = path(ik:ik)
            end if
        end do

    end function windows_path

    !> Merge the directory and file name into a complete path <br>
    !> 将路径中的目录和文件名合并成一个完整的路径
    impure function join_path(dir, file) result(path)
        character(*), intent(in) :: dir             !! Directory name <br>
                                                    !! 目录名
        character(*), intent(in) :: file            !! File name <br>
                                                    !! 文件名
        character(len(dir) + len(file) + 1) :: path !! Complete path <br>
                                                    !! 完整路径

        logical, save :: is_first_run = .true.
        character(1), save :: sep = "/"

        if (is_first_run) then
            if (is_windows()) sep = "\"
            is_first_run = .false.
        end if

        if (dir == "") then
            path = file
        else
            path = dir//sep//file
        end if

    end function join_path

    !> Make directory <br>
    !> 生成文件夹路径
    impure elemental subroutine mkdir(path)
        character(*), intent(in) :: path    !! path name <br>
                                            !! 文件夹路径
        integer :: exitstat
        if (is_windows()) then
            call execute_command_line("md "//windows_path(path), exitstat=exitstat)
        else
            call execute_command_line("mkdir -p "//path, exitstat=exitstat)
        end if

    end subroutine mkdir

    !> Remove directory <br>
    !> 删除文件夹路径
    impure elemental subroutine rmdir(path)
        character(*), intent(in) :: path    !! path name <br>
                                            !! 文件夹路径
        integer :: exitstat
        if (is_windows()) then
            call execute_command_line("rd /s /q "//windows_path(path), exitstat=exitstat)
        else
            call execute_command_line("rm -rf "//path, exitstat=exitstat)
        end if

    end subroutine rmdir

end module seakeeping_filesystem
