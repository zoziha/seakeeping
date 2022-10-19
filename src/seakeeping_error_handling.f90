!> author: 左志华
!> date: 2022-09-17
!>
!> Error handling for seakeeping <br>
!> 耐波性错误处理
module seakeeping_error_handling

    use, intrinsic :: iso_fortran_env, only: error_unit
    implicit none
    private

    public :: file_not_found_error, internal_error, file_parse_error, fatal_error, check

    integer, parameter :: interal_error_code = -1
    integer, parameter :: fatal_error_code = -2
    integer, parameter :: file_not_found_error_code = -3
    integer, parameter :: file_parse_error_code = -4

contains

    !> File not found error <br>
    !> 文件未找到错误
    subroutine file_not_found_error(file)
        character(*), intent(in) :: file    !! file name <br>
                                            !! 文件名

        write (error_unit, '(2a)') '*<FileNotFoundError>* ', file
        stop file_not_found_error_code

    end subroutine file_not_found_error

    !> Internal error <br>
    !> 内部错误
    subroutine internal_error(msg)
        character(*), intent(in) :: msg   !! error message <br>
                                          !! 错误信息

        write (error_unit, '(2a)') '*<InternalError>* ', msg
        stop interal_error_code

    end subroutine internal_error

    !> File parse error <br>
    !> 文件解析错误
    subroutine file_parse_error(file, msg)
        character(*), intent(in) :: file    !! file name <br>
                                            !! 文件名
        character(*), intent(in) :: msg     !! error message <br>
                                            !! 错误信息

        write (error_unit, '(4a)') '*<FileParseError>* ', file, ', ', msg
        stop file_parse_error_code

    end subroutine file_parse_error

    !> Fatal error <br>
    !> 致命错误
    subroutine fatal_error(msg)
        character(*), intent(in) :: msg   !! error message <br>
                                          !! 错误信息

        write (error_unit, '(2a)') '*<FatalError>* ', msg
        stop fatal_error_code

    end subroutine fatal_error

    !> Check if the condition is true <br>
    !> 检查条件是否为真
    subroutine check(condition, msg)
        logical, intent(in) :: condition   !! condition <br>
                                           !! 条件
        character(*), intent(in) :: msg    !! error message <br>
                                           !! 错误信息

        if (.not. condition) then
            call fatal_error(msg)
        end if

    end subroutine check

end module seakeeping_error_handling
