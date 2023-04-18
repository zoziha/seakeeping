program test_leapfrog
    use seakeeping_module
    real :: x(3) = 0, v(3) = 0, a(3), t = 0.0 ! 初始值
    call leapfrog_init(func, x, v, a, t, 0.1, 3)
    call leapfrog(func, x, v, a, t, t + 1.0, 0.1, x, v, a, 3)
    call leapfrog_final(v, a, 0.1, 3) ! 将速度与位移、加速度同步（可选）
110 format('t = ', g0.3, ', x = ', 3(g0.3, ', '), 'v = ', 3(g0.3, ', '), 'a = ', 3(g0.3, ', '))
    print 110, t, x, v, a ! 时间积分结果
contains
    !> 三维自由落体运动
    subroutine func(t, x, v, a)
        real, intent(in) :: x(3), v(3), t
        real, intent(out) :: a(3)
        a = [0.0, 0.0, -9.8]
    end subroutine func
end program test_leapfrog
