!> leapfrog 算法计算量相对较少，精度适中，可用于力学求解
module seakeeping_leapfrog

    use seakeeping_kinds, only: sk_real_kind
    implicit none

    private
    public :: leapfrog, leapfrog_init, leapfrog_final

contains

    !> 速度比位移、加速度快半步长，本例程仅用作力学求解，求解一段时间内的力学变化，并更新时间
    subroutine leapfrog(func, x0, v0, a0, t0, m, dt, x1, v1, a1, n)
        external :: func
        real(kind=sk_real_kind), intent(in), dimension(*) :: x0, v0, a0
        real(kind=sk_real_kind), intent(inout) :: t0
        integer, intent(in) :: m
        real(kind=sk_real_kind), intent(in) :: dt
        real(kind=sk_real_kind), intent(out), dimension(*) :: x1, v1, a1
        integer, intent(in) :: n

        real(kind=sk_real_kind) :: t, vtmp(n)
        integer :: i

        x1(:n) = x0(:n)
        v1(:n) = v0(:n)
        a1(:n) = a0(:n)

        do i = 1, m
            t = t0 + dt*i
            x1(:n) = x1(:n) + v1(:n)*dt
            vtmp = v1(:n) + a1(:n)*dt/2
            call func(t, x1, vtmp, a1)
            v1(:n) = v1(:n) + a1(:n)*dt
        end do

        t0 = t

    end subroutine leapfrog

    !> 初始化leapfrog算法，初始化加速度及推进速度半步长
    subroutine leapfrog_init(func, x0, v0, a0, t0, dt, n)
        external :: func
        real(kind=sk_real_kind), intent(in), dimension(*) :: x0
        real(kind=sk_real_kind), intent(inout), dimension(*) :: v0
        real(kind=sk_real_kind), intent(out), dimension(*) :: a0
        real(kind=sk_real_kind), intent(in) :: t0, dt
        integer, intent(in) :: n

        call func(t0, x0, v0, a0)
        v0(:n) = v0(:n) + a0(:n)*dt/2

    end subroutine leapfrog_init

    !> 速度后退半步长，使其与位移、加速度同步
    subroutine leapfrog_final(v0, a0, dt, n)
        real(kind=sk_real_kind), intent(inout), dimension(*) :: v0
        real(kind=sk_real_kind), intent(in), dimension(*) :: a0
        real(kind=sk_real_kind), intent(in) :: dt
        integer, intent(in) :: n

        v0(:n) = v0(:n) - a0(:n)*dt/2

    end subroutine leapfrog_final

end module seakeeping_leapfrog
