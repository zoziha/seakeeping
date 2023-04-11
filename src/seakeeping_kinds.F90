!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping kinds <br>
!> 耐波性例程浮点数、复数精度
module seakeeping_kinds
#ifdef REAL64
    integer, parameter :: sk_real_kind = kind(0.0d0)
#else
    integer, parameter :: sk_real_kind = kind(0.0)
#endif
end module seakeeping_kinds
