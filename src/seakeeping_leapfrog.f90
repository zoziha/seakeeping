!> leapfrog 算法计算量相对较少，精度适中，可用于力学求解
module seakeeping_leapfrog

    use seakeeping_kinds, only: rk => sk_real_kind
    implicit none

    private
    public :: leapfrog, leapfrog_init, leapfrog_final

contains

    !> 速度比位移、加速度快半步长，本例程仅用作力学求解，求解一段时间内的力学变化，并更新时间
    subroutine leapfrog(func, x, v, a, t, m, dt, n)
        external :: func
        real(kind=rk), intent(inout), dimension(*) :: x, v, a
        real(kind=rk), intent(inout) :: t
        integer, intent(in) :: m
        real(kind=rk), intent(in) :: dt
        integer, intent(in) :: n

        real(kind=rk) :: t0, vtmp(n)
        integer :: i

        do i = 1, m
            t0 = t + dt*i
            x(:n) = x(:n) + v(:n)*dt
            vtmp = v(:n) + a(:n)*dt/2
            call func(t, x, vtmp, a)
            v(:n) = v(:n) + a(:n)*dt
        end do

        if (m > 0) t = t0

    end subroutine leapfrog

    !> 初始化leapfrog算法，初始化加速度及推进速度半步长
    subroutine leapfrog_init(func, x0, v0, a0, t0, dt, n)
        external :: func
        real(kind=rk), intent(in), dimension(*) :: x0
        real(kind=rk), intent(inout), dimension(*) :: v0
        real(kind=rk), intent(out), dimension(*) :: a0
        real(kind=rk), intent(in) :: t0, dt
        integer, intent(in) :: n

        call func(t0, x0, v0, a0)
        v0(:n) = v0(:n) + a0(:n)*dt/2

    end subroutine leapfrog_init

    !> 速度后退半步长，使其与位移、加速度同步
    subroutine leapfrog_final(v0, a0, dt, n)
        real(kind=rk), intent(inout), dimension(*) :: v0
        real(kind=rk), intent(in), dimension(*) :: a0
        real(kind=rk), intent(in) :: dt
        integer, intent(in) :: n

        v0(:n) = v0(:n) - a0(:n)*dt/2

    end subroutine leapfrog_final

end module seakeeping_leapfrog
