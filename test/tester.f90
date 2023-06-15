!> 单元测试
program tester

    use, intrinsic :: iso_fortran_env, only: error_unit
    use testdrive, only: run_testsuite, new_testsuite, testsuite_type
    use test_seakeeping_leapfrog, only: collect_leapfrog
    use test_seakeeping_collection, only: collect_collection
    use test_seakeeping_wave, only: collect_wave
    implicit none

    integer :: stat, is
    type(testsuite_type), allocatable :: testsuites(:)
    character(len=*), parameter :: fmt = '("#", *(1x, a))'

    stat = 0

    allocate (testsuites, source=[ &
              new_testsuite("leapfrog", collect_leapfrog), &
              new_testsuite("wave", collect_wave), &
              new_testsuite("collection", collect_collection) &
              ])

    do is = 1, size(testsuites)
        write (error_unit, fmt) "Running testsuite:", testsuites(is)%name
        call run_testsuite(testsuites(is)%collect, error_unit, stat)
    end do

    if (stat > 0) then
        write (error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
        error stop
    else
        write (error_unit, fmt) "All tests passed!"
    end if

end program tester
