!> 耐波性数学
module seakeeping_math
    use seakeeping_kinds
contains
    !> 海伦公式计算三角形面积
    pure real(kind=sk_real_kind) function heron_formula(a, b, c) result(s)
        real(kind=sk_real_kind), intent(in) :: a, b, c     !! 三边长 (m)
        associate (p => (a + b + c)/2)
            s = sqrt(p*(p - a)*(p - b)*(p - c))
        end associate
    end function heron_formula
    !> 欧拉公式
    elemental complex(kind=sk_real_kind) function euler_formula(x)
        real(kind=sk_real_kind), intent(in) :: x
        euler_formula%re = cos(x)
        euler_formula%im = sin(x)
    end function euler_formula
    !> 计算两向量的夹角
    pure real(kind=sk_real_kind) function angle(x, y)
        real(kind=sk_real_kind), intent(in), dimension(3) :: x, y !! 两向量
        angle = acos(dot_product(x, y)/(norm2(x)*norm2(y)))
    end function angle
    !> 一元二次方程求根公式
    pure subroutine root_formula(a, b, c, x1, x2)
        real(kind=sk_real_kind), intent(in) :: a, b, c
        real(kind=sk_real_kind), intent(out), optional :: x1, x2
        if (b*b - 4*a*c < 0) return
        if (a > 0) then
            if (present(x1)) x1 = (-b - sqrt(b*b - 4*a*c))/(2*a)
            if (present(x2)) x2 = (-b + sqrt(b*b - 4*a*c))/(2*a)
        else
            if (present(x1)) x1 = (-b + sqrt(b*b - 4*a*c))/(2*a)
            if (present(x2)) x2 = (-b - sqrt(b*b - 4*a*c))/(2*a)
        end if
    end subroutine root_formula
end module seakeeping_math
