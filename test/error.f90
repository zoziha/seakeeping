program main

    use seakeeping_error
    character(:), allocatable :: error

    call check_file_read('test.txt', error)
    if (allocated(error)) then
        call warning(error)
    end if

    call check_file_exists('test.txt', error)
    if (allocated(error)) then
        call panic(error, 42)
    end if

contains

    subroutine check_file_exists(file, error)
        character(*), intent(in) :: file
        character(:), allocatable, intent(out) :: error

        call file_not_found_error(error, file)
        if (allocated(error)) return

    end subroutine check_file_exists

    subroutine check_file_read(file, error)
        character(*), intent(in) :: file
        character(:), allocatable, intent(out) :: error

        call file_read_error(error, file, 'file could not be read')
        if (allocated(error)) return

    end subroutine check_file_read

end program main
