!> 蛙跳法测试
module test_seakeeping_leapfrog

    use testdrive, only: new_unittest, unittest_type, error_type, check
    use seakeeping_module, only: rk => sk_real_kind, leapfrog, leapfrog_init, leapfrog_final
    implicit none

    private
    public :: collect_leapfrog

contains

    subroutine collect_leapfrog(testsuite)
        type(unittest_type), intent(out), allocatable :: testsuite(:)

        allocate (testsuite, source=[ &
                  new_unittest('leapfrog', test_leapfrog) &
                  ])

    end subroutine collect_leapfrog

    subroutine test_leapfrog(error)
        type(error_type), allocatable, intent(out) :: error
        real(rk) :: x(3), v(3), a(3), dt, t
        integer :: i
        real(rk), parameter :: x0(*) = [0.0_rk, 0.0_rk, -4.9_rk], &
                               v0(*) = [0.0_rk, 0.0_rk, -9.79999924_rk], &
                               a0(*) = [0.0_rk, 0.0_rk, -9.8_rk]

        dt = 0.1_rk
        t = 0
        x = 0
        v = 0

        call leapfrog_init(func, x, v, a, t, dt, 3)

        do while (t < 1.00_rk)
            call leapfrog(func, x, v, a, t, 1, dt, 3)
        end do

        call leapfrog_final(v, a, dt, 3)

        call check(error, t, 1.00_rk, more='leapfrog: t')
        if (allocated(error)) return

        do i = 1, 3
            call check(error, x(i), x0(i), more='leapfrog: x')
            if (allocated(error)) return
            call check(error, v(i), v0(i), more='leapfrog: v')
            if (allocated(error)) return
            call check(error, a(i), a0(i), more='leapfrog: a')
            if (allocated(error)) return
        end do

    contains

        !> 三维自由落体运动
        subroutine func(t, x, v, a)
            real(rk), intent(in) :: x(3), v(3), t
            real(rk), intent(out) :: a(3)

            a = [0.0_rk, 0.0_rk, -9.8_rk]

        end subroutine func

    end subroutine test_leapfrog

end module test_seakeeping_leapfrog
