#ifdef REAL32
#define dgesv sgesv
#define dgetrf sgetrf
#define dgetri sgetri
#define dgemm sgemm
#define zgesv cgesv
#define zgetrf cgetrf
#define zgetri cgetri
#define zgemm cgemm
#endif
!> author: 左志华
!> date: 2022-11-12
!> 线性代数
module seakeeping_linalg

    use seakeeping_kinds, only: rk
    private :: rk

    interface inv
        procedure :: rinv, cinv
    end interface inv
    private :: rinv, cinv

    interface gemm
        procedure :: rgemm, cgemmx
    end interface gemm
    private :: rgemm, cgemmx

    interface solve
        procedure :: rsolve, csolve
    end interface solve
    private :: rsolve, csolve

contains

    !> calculate inverse of a double precision matrix
    impure function rinv(a) result(b)
        real(rk), intent(in) :: a(:, :)
        real(rk) :: b(size(a, 2), size(a, 1))
        integer :: ipiv(size(a, 1)), info
        real(rk) :: work(size(a, 2))

        b = a
        ! http://www.netlib.org/lapack/explore-html/d8/ddc/group__real_g_ecomputational_ga8d99c11b94db3d5eac75cac46a0f2e17.html
        call dgetrf(size(a, 1), size(a, 2), b, size(a, 1), ipiv, info)

        ! http://www.netlib.org/lapack/explore-html/d8/ddc/group__real_g_ecomputational_ga1af62182327d0be67b1717db399d7d83.html
        call dgetri(size(a, 2), b, size(a, 1), ipiv, work, size(a, 2), info)

    end function rinv

    !> calculate inverse of a double precision matrix
    impure function cinv(a) result(b)
        complex(rk), intent(in) :: a(:, :)
        complex(rk) :: b(size(a, 2), size(a, 1))
        integer :: ipiv(size(a, 1)), info
        complex(rk) :: work(size(a, 2))

        b = a
        ! http://www.netlib.org/lapack/explore-html/d8/ddc/group__real_g_ecomputational_ga8d99c11b94db3d5eac75cac46a0f2e17.html
        call zgetrf(size(a, 1), size(a, 2), b, size(a, 1), ipiv, info)

        ! http://www.netlib.org/lapack/explore-html/d8/ddc/group__real_g_ecomputational_ga1af62182327d0be67b1717db399d7d83.html
        call zgetri(size(a, 2), b, size(a, 1), ipiv, work, size(a, 2), info)

    end function cinv

    !> solve linear system of double precision
    impure function rsolve(a, b) result(x)
        real(rk), intent(in) :: a(:, :), b(:, :)
        real(rk) :: x(size(b, 1), size(b, 2))

        real(rk) :: a_(size(a, 1), size(a, 2))
        integer :: ipiv(size(a, 1))
        integer :: info

        a_ = a; x = b
        ! http://www.netlib.org/lapack/explore-html/d0/db8/group__real_g_esolve_ga3b05fb3999b3d7351cb3101a1fd28e78.html
        call dgesv(size(a, 1), size(b, 2), a_, size(a, 1), ipiv, x, size(b, 1), info)

    end function rsolve

    !> solve linear system of double precision
    impure function csolve(a, b) result(x)
        complex(rk), intent(in) :: a(:, :), b(:, :)
        complex(rk) :: x(size(b, 1), size(b, 2))

        complex(rk) :: a_(size(a, 1), size(a, 2))
        integer :: ipiv(size(a, 1))
        integer :: info

        a_ = a; x = b
        ! http://www.netlib.org/lapack/explore-html/d0/db8/group__real_g_esolve_ga3b05fb3999b3d7351cb3101a1fd28e78.html
        call zgesv(size(a, 1), size(b, 2), a_, size(a, 1), ipiv, x, size(b, 1), info)

    end function csolve

    !> calculate determinant of a double precision matrix
    impure function det(a) result(d)
        real(rk), intent(in) :: a(:, :)
        real(rk) :: d
        real(rk) :: a_(size(a, 1), size(a, 2))
        integer :: ipiv(size(a, 1)), info, i

        a_ = a
        ! http://www.netlib.org/lapack/explore-html/d8/ddc/group__real_g_ecomputational_ga8d99c11b94db3d5eac75cac46a0f2e17.html
        call dgetrf(size(a, 1), size(a, 2), a_, size(a, 1), ipiv, info)

        d = 1.0_rk
        do i = 1, size(a, 2)
            if (ipiv(i) /= i) then
                d = -d*a_(i, i)
            else
                d = d*a_(i, i)
            end if
        end do

    end function det

    !> matrix multiplication of double precision matrices
    impure function rgemm(a, b) result(c)
        real(rk), intent(in) :: a(:, :), b(:, :)
        real(rk) :: c(size(a, 1), size(b, 2))
        integer :: m, n, k

        m = size(a, 1)
        n = size(b, 2)
        k = size(a, 2)
        ! http://www.netlib.org/lapack/explore-html/d1/d54/group__double__blas__level3_gaeda3cbd99c8fb834a60a6412878226e1.html
        call dgemm( &
            'N', 'N', &
            m, n, k, &
            1.0_rk, a, m, b, k, &
            0.0_rk, c, m)

    end function rgemm

    !> matrix multiplication of double precision complex matrices
    impure function cgemmx(a, b) result(c)
        complex(rk), intent(in) :: a(:, :), b(:, :)
        complex(rk) c(size(a, 1), size(b, 2))
        integer m, n, k

        m = size(a, 1)
        n = size(b, 2)
        k = size(a, 2)
        ! http://www.netlib.org/lapack/explore-html/d1/d54/group__double__blas__level3_gaeda3cbd99c8fb834a60a6412878226e1.html
        call zgemm( &
            'N', 'N', &
            m, n, k, &
            (1.0_rk, 0.0_rk), a, m, b, k, &
            (0.0_rk, 0.0_rk), c, m)

    end function cgemmx

end module seakeeping_linalg
