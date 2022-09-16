!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping constants <br>
!> 耐波性常数
module seakeeping_constants

    use seakeeping_kinds, only: rk
    implicit none
    private

    public :: g, Pi

    real(rk), parameter :: g = 9.806_rk
    real(rk), parameter :: Pi = acos(-1.0_rk)

end module seakeeping_constants
