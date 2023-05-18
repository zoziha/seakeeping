program test_leapfrog

    use seakeeping_module, only: leapfrog, leapfrog_init, leapfrog_final
    implicit none

    real :: x(3) = 0, v(3) = 0, a(3), t = 0.0 ! 初始值
    real :: h = 0.2 ! 时间步长

    call leapfrog_init(func, x, v, a, t, h, 3)

    do while (t < 100.0)
        call leapfrog(func, x, v, a, t, 10, h, x, v, a, 3)
    end do

    call leapfrog_final(v, a, h, 3) ! 将速度与位移、加速度同步（可选）

110 format('t = ', g0.3, ', x = ', 3(g0.3, ', '), 'v = ', 3(g0.3, ', '), 'a = ', 3(g0.3, ', '))

    print 110, t, x, v, a ! 时间积分结果
    print 110, t, [0.0, 0.0, -0.490E+5 - x(3)], [0.0, 0.0, -980.0 - v(3)], [0.0, 0.0, -9.8 - a(3)] ! 精确解与误差

contains

    !> 三维自由落体运动
    subroutine func(t, x, v, a)
        real, intent(in) :: x(3), v(3), t
        real, intent(out) :: a(3)

        a = [0.0, 0.0, -9.8]

    end subroutine func

end program test_leapfrog
