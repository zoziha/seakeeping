program test_leapfrog

    use seakeeping_module, only: leapfrog, leapfrog_init, leapfrog_final, rk => sk_real_kind
    implicit none

    real(rk) :: x(3) = 0, v(3) = 0, a(3), t = 0.0_rk ! 初始值
    real(rk) :: h = 0.1_rk ! 时间步长

    call leapfrog_init(func, x, v, a, t, h, 3)

    do while (t <= 1.01_rk)
        call leapfrog(func, x, v, a, t, 1, h, 3)
    end do

    call leapfrog_final(v, a, h, 3) ! 将速度与位移、加速度同步（可选）

110 format('t = ', g0.3, ', x = ', 3(g0.3, ', '), 'v = ', 3(g0.3, ', '), 'a = ', 3(g0.3, ', '))

    print *, t, x, v, a ! 时间积分结果
    print 110, t, [0.0_rk, 0.0_rk, -49000._rk - x(3)], &
        [0.0_rk, 0.0_rk, -980.665_rk - v(3)], &
        [0.0_rk, 0.0_rk, -9.8_rk - a(3)] ! 精确解与误差
    print *, (-49000.0_rk - x(3))/(-49000.0_rk)

contains

    !> 三维自由落体运动
    subroutine func(t, x, v, a)
        real(rk), intent(in) :: x(3), v(3), t
        real(rk), intent(out) :: a(3)

        a = [0.0_rk, 0.0_rk, -0.1_rk]

    end subroutine func

end program test_leapfrog
