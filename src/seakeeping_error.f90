!> 耐波性典型错误处理
module seakeeping_error

    use, intrinsic :: iso_c_binding, only: new_line => c_new_line
    use, intrinsic :: iso_fortran_env, only: error_unit
    private :: new_line, error_unit

contains

    !> 文件未找到错误
    pure subroutine file_not_found_error(error, file)
        character(:), allocatable, intent(out) :: error !! 错误信息
        character(*), intent(in) :: file                !! 文件名

        allocate (error, source='"'//file//'" could not be found, check if the file exists')

    end subroutine file_not_found_error

    !> 文件读取错误
    pure subroutine file_read_error(error, file, message)
        character(:), allocatable, intent(out) :: error !! 错误信息
        character(*), intent(in) :: file                !! 文件名
        character(*), intent(in) :: message             !! 错误信息

        allocate (error, source='"'//file//'" read error: '//message)

    end subroutine file_read_error

    !> 常规错误
    pure subroutine general_error(error, message)
        character(:), allocatable, intent(out) :: error !! 错误信息
        character(*), intent(in) :: message             !! 错误信息

        allocate (error, source=message)

    end subroutine general_error

    !> 警告
    subroutine warning(error)
        character(*), intent(in) :: error !! 警告信息

        print '(2a)', '<WARN>  ', error

    end subroutine warning

    !> 恐慌
    subroutine panic(error, code)
        character(*), intent(in) :: error       !! 恐慌信息
        integer, intent(in), optional :: code   !! 恐慌代码

        write (error_unit, '(2a)') '<ERROR> ', error
        if (present(code)) then
            stop code
        else
            stop 1
        end if

    end subroutine panic

end module seakeeping_error