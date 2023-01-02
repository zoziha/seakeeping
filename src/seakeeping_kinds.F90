!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping kinds <br>
!> 耐波性例程浮点数、复数精度
module seakeeping_kinds

    use, intrinsic :: iso_fortran_env, only: real32, real64
    private :: real32, real64

#ifdef REAL32
    integer, parameter :: rk = real32
#elif REAL64
    integer, parameter :: rk = real64
#else
    integer, parameter :: rk = real64
#endif

end module seakeeping_kinds
