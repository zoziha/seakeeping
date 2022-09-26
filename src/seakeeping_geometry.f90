!> author: 左志华
!> date: 2022-09-16
!> version: alpha
!>
!> Seakeeping geometry <br>
!> 耐波性几何学
module seakeeping_geometry

    use seakeeping_kinds, only: rk
    use seakeeping_math, only: heron_formula
    implicit none
    private

    public :: centroid, area, distance

    interface centroid
        procedure :: centroid3l, centroid4l
    end interface centroid

    interface area
        procedure :: area3l, area4l
    end interface area

contains

    !> Centroid of a triangle <br>
    !> 三角形形心
    pure function centroid3l(a, b, c) result(cen)
        real(rk), intent(in) :: a(3), b(3), c(3)
        real(rk) :: cen(3)

        cen(:) = (a(:) + b(:) + c(:))/3

    end function centroid3l

    !> Centroid of a quadrilateral <br>
    !> 四边形形心
    pure function centroid4l(a, b, c, d) result(cen)
        real(rk), intent(in) :: a(3), b(3), c(3), d(3)
        real(rk) :: cen(3)

        cen = area3l(a, b, c)*centroid3l(a, b, c) + area3l(a, c, d)*centroid3l(a, c, d)

    end function centroid4l

    !> Area of a triangle <br>
    !> 三角形面积
    pure function area3l(a, b, c) result(area)
        real(rk), intent(in) :: a(3), b(3), c(3)
        real(rk) :: area

        associate (d1 => distance(a, b), &
                   d2 => distance(b, c), &
                   d3 => distance(c, a))
            area = heron_formula(d1, d2, d3)
        end associate

    end function area3l

    !> Area of a quadrilateral <br>
    !> 四边形面积
    pure function area4l(a, b, c, d) result(area)
        real(rk), intent(in) :: a(3), b(3), c(3), d(3)
        real(rk) :: area

        associate (d1 => distance(a, b), &
                   d2 => distance(b, c), &
                   d3 => distance(c, d), &
                   d4 => distance(d, a), &
                   dc => distance(a, c))
            area = heron_formula(d1, d2, dc) + heron_formula(dc, d3, d4)
        end associate

    end function area4l

    !> Distance between two points <br>
    !> 两点间距离, \( d = |\overrightarrow{ab} | \)
    pure function distance(a, b) result(dis)
        real(rk), intent(in) :: a(3), b(3)
        real(rk) :: dis

        dis = sqrt(sum((a(:) - b(:))**2))

    end function distance

end module seakeeping_geometry
