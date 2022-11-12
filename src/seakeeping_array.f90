!> author: 左志华
!> date: 2022-09-28
!> version: alpha
!>
!> Seakeeping linear algebra <br>
!> 耐波性线性代数
module seakeeping_array

    use seakeeping_kinds, only: rk
    use seakeeping_utils, only: optval
    private :: optval, rk

    interface diag
        procedure :: diag_real_rank2, diag_real_rank1
    end interface diag
    private :: diag_real_rank2, diag_real_rank1

contains

    !> constructs a vector of the diagonal elements of a matrix <br>
    !> 构建矩阵对角元素的向量
    pure function diag_real_rank2(a) result(v)
        real(rk), intent(in) :: a(:, :)
        real(rk) :: v(min(size(a, 1), size(a, 2)))
        integer :: i

        do concurrent(i=1:size(v))
            v(i) = a(i, i)
        end do

    end function diag_real_rank2

    !> constructs a matrix with the diagonal elements of a vector <br>
    !> 构建向量对角元素的矩阵
    pure function diag_real_rank1(v) result(a)
        real(rk), intent(in) :: v(:)
        real(rk) :: a(size(v), size(v))
        integer :: i, j

        do concurrent(j=1:size(v), i=1:size(v))
            if (i == j) then
                a(i, j) = v(i)
            else
                a(i, j) = 0.0_rk
            end if
        end do

    end function diag_real_rank1

    !> constructs the identity matrix <br>
    !> 构建单位矩阵
    pure function eye(m, n) result(a)
        integer, intent(in) :: m            !! number of rows
        integer, intent(in), optional :: n  !! number of columns
        integer, allocatable :: a(:, :)
        integer :: i, j, n_

        n_ = optval(n, m)
        allocate (a(m, n_))
        do concurrent(j=1:n_, i=1:m)
            if (i == j) then
                a(i, j) = 1
            else
                a(i, j) = 0
            end if
        end do

    end function eye

end module seakeeping_array
