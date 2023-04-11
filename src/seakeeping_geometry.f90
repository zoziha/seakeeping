!> author: 左志华
!> date: 2022-09-16
!> version: alpha
!>
!> Seakeeping geometry <br>
!> 耐波性几何学
module seakeeping_geometry

    use seakeeping_kinds
    use seakeeping_math, only: heron_formula

    interface centroid
        procedure :: centroid3l, centroid4l
    end interface centroid
    private :: centroid3l, centroid4l

    interface area
        procedure :: area3l, area4l
    end interface area
    private :: area3l, area4l

contains

    !> Centroid of a triangle <br>
    !> 三角形形心
    pure function centroid3l(a, b, c) result(cen)
        real(sk_real_kind), intent(in) :: a(3), b(3), c(3)
        real(sk_real_kind) :: cen(3)

        cen(:) = (a(:) + b(:) + c(:))/3

    end function centroid3l

    !> Centroid of a quadrilateral <br>
    !> 四边形形心
    pure function centroid4l(a, b, c, d) result(cen)
        real(sk_real_kind), intent(in) :: a(3), b(3), c(3), d(3)
        real(sk_real_kind) :: cen(3)

        cen = area3l(a, b, c)*centroid3l(a, b, c) + area3l(a, c, d)*centroid3l(a, c, d)

    end function centroid4l

    !> Area of a triangle <br>
    !> 三角形面积
    pure function area3l(a, b, c) result(area)
        real(sk_real_kind), intent(in) :: a(3), b(3), c(3)
        real(sk_real_kind) :: area

        associate (d1 => distance(a - b), &
                   d2 => distance(b - c), &
                   d3 => distance(c - a))
            area = heron_formula(d1, d2, d3)
        end associate

    end function area3l

    !> Area of a quadrilateral <br>
    !> 四边形面积
    pure function area4l(a, b, c, d) result(area)
        real(sk_real_kind), intent(in) :: a(3), b(3), c(3), d(3)
        real(sk_real_kind) :: area

        associate (d1 => distance(a - b), &
                   d2 => distance(b - c), &
                   d3 => distance(c - d), &
                   d4 => distance(d - a), &
                   dc => distance(a - c))
            area = heron_formula(d1, d2, dc) + heron_formula(dc, d3, d4)
        end associate

    end function area4l

    !> Distance between two points <br>
    !> 两点间距离, \( d = |\overrightarrow{ab} | \)
    pure function distance(a) result(dis)
        real(sk_real_kind), intent(in) :: a(3)
        real(sk_real_kind) :: dis

        dis = sqrt(a(1)*a(1) + a(2)*a(2) + a(3)*a(3))

    end function distance

    !> Unitize a vector <br>
    !> 单位化向量
    pure function unitize(x) result(y)
        real(sk_real_kind), intent(in), dimension(3) :: x
        real(sk_real_kind), dimension(3) :: y

        y = x/distance(x)

    end function unitize

end module seakeeping_geometry
