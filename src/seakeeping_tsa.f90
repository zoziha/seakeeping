!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping time series analysis
!> 耐波性时间序列分析
!> @note fft 存在许可证（LGPL）风险（即使 fft 存在风险，我希望本包其他例程不服从 LGPL 协议），
!> 借鉴了 https://people.math.sc.edu/Burkardt/f_src/fft_openmp/fft_openmp.html
module seakeeping_tsa

    use seakeeping_constants, only: Pi
    use seakeeping_kinds, only: rk
    use seakeeping_utils, only: optval
    private :: rk, Pi, step, optval

contains

    !> Automatic multiscale-based peak detection (AMPD) <br>
    !> 峰值查找算法
    !> @note
    !> - 由于移动窗体宽度的存在，序列两端的峰值不被查找，如果需要被查找需要填充最小值，extend = T
    !> - 暂无法实时查找
    !> - 查询谷值，可将信号翻转后再查找
    pure function AMPD(data, extend) result(location)
        real(rk), intent(in) :: data(:)                 !! Input data <br>
                                                        !! 数据
        logical, intent(in), optional :: extend         !! Extend data width to get two end peaks <br>
                                                        !! 是否增强数据宽度以获取两端最大峰值
        integer, allocatable :: location(:)             !! Peak position <br>
                                                        !! 峰值位置
        integer :: L, N, k, i, row_sum, min_index, extend_size
        integer, allocatable :: arr_row_sum(:)
        integer, allocatable :: p_data(:)
        logical :: extend_
        real(rk), allocatable :: data_(:)

        extend_ = optval(extend, .false.)

        ! 确定最佳窗体宽度
        N = size(data)
        L = N/2 + 1
        allocate (arr_row_sum(L))
        do k = 1, L
            row_sum = 0
            do i = k, N - k
                if (i - k == 0 .or. i + k == N + 1) cycle
                if (data(i) > data(i - k) .and. data(i) > data(i + k)) row_sum = row_sum - 1
            end do
            arr_row_sum(k) = row_sum
        end do
        min_index = minloc(arr_row_sum, dim=1) ! 通过最小值确定最佳窗体宽度，显著提升峰值特征，方便查找峰值

        ! 查找峰值
        if (extend_) then
            extend_size = min_index + 1
        else
            extend_size = 0
        end if
        N = N + extend_size*2
        allocate (p_data(N), source=0)
        if (extend_) then
            allocate (data_(N))
            associate (min => minval(data, dim=1))
                data_(:extend_size) = min
                data_(extend_size + 1:N - extend_size) = data(:)
                data_(N - extend_size + 1:) = min
            end associate
        else
            allocate (data_(N), source=data)
        end if
        do k = 1, min_index + 1
            do i = k, N - k
                if (i - k == 0 .or. i + k == N + 1) cycle
                if (data_(i) > data_(i - k) .and. data_(i) > data_(i + k)) p_data(i) = p_data(i) + 1
            end do
        end do

        allocate (location(0))
        do i = 1, N
            if (p_data(i) == min_index) location = [location, i]
        end do
        if (extend_) location = location - extend_size

    end function AMPD

    !> Init the FFT <br>
    !> 初始化 FFT 系数
    pure subroutine ffti(n, w)
        integer, intent(in) :: n
        real(rk), intent(out) :: w(n)
        real(rk) :: aw, arg
        integer :: i

        aw = 2*pi/real(n, rk)
        do concurrent(i=1:n/2)
            arg = aw*real(i - 1, rk)
            w(2*i - 1) = cos(arg)
            w(2*i) = sin(arg)
        end do

    end subroutine ffti

    !> FFT <br>
    !> 快速傅里叶变换
    !> @note 反向（backward）快速傅里叶变换结果需要正则化
    pure subroutine fft(n, x, y, w, back)
        integer, intent(in) :: n
        real(rk), intent(inout) :: x(2*n)
        real(rk), intent(out) :: y(2*n)
        real(rk), intent(in) :: w(n)
        logical, intent(in) :: back
        integer :: m, mj, i
        logical :: tgle

        m = int(log(real(n, rk))/log(1.99_rk))
        mj = 1
        tgle = .true.
        call step(n, mj, x(1), x((n/2)*2 + 1), y(1), y(mj*2 + 1), w, back)

        if (n == 2) return
        do i = 1, m - 2
            mj = mj*2
            if (tgle) then
                call step(n, mj, y(1), y((n/2)*2 + 1), x(1), x(mj*2 + 1), w, back)
                tgle = .false.
            else
                call step(n, mj, x(1), x((n/2)*2 + 1), y(1), y(mj*2 + 1), w, back)
                tgle = .true.
            end if
        end do

        if (tgle) x(:) = y(:)
        mj = n/2
        call step(n, mj, x(1), x((n/2)*2 + 1), y(1), y(mj*2 + 1), w, back)

    end subroutine fft

    !> FFT step <br>
    !> FFT 单步
    !> @note gfortran 启动并行 do concurrent：`-ftree-loop-vectorize -ftree-parallelize-loops=8`
    pure subroutine step(n, mj, a, b, c, d, w, back)
        integer, intent(in) :: n, mj
        real(rk), intent(in), dimension(n) :: a, b, w
        real(rk), intent(inout), dimension(n) :: c, d
        logical, intent(in) :: back
        integer :: mj2, lj, j, k, ja, jb, jc, jd, jw
        real(rk) :: wjw(2), ambr, ambu

        mj2 = 2*mj
        lj = n/mj2

        do concurrent(j=0:lj - 1)
            jw = j*mj
            ja = jw
            jb = ja
            jc = j*mj2
            jd = jc

            wjw(1) = w(jw*2 + 1)
            wjw(2) = w(jw*2 + 2)

            if (back) wjw(2) = -wjw(2)
            do k = 0, mj - 1
                c((jc + k)*2 + 1) = a((ja + k)*2 + 1) + b((jb + k)*2 + 1)
                c((jc + k)*2 + 2) = a((ja + k)*2 + 2) + b((jb + k)*2 + 2)

                ambr = a((ja + k)*2 + 1) - b((jb + k)*2 + 1)
                ambu = a((ja + k)*2 + 2) - b((jb + k)*2 + 2)

                d((jd + k)*2 + 1) = wjw(1)*ambr - wjw(2)*ambu
                d((jd + k)*2 + 2) = wjw(2)*ambr + wjw(1)*ambu
            end do
        end do

    end subroutine step

    !> FFT shift <br>
    !> FFT 位移
    pure function fftshift(x, back) result(y)
        real(rk), intent(in) :: x(:)
        logical, intent(in) :: back
        real(rk) :: y(size(x))

        if (back) then
            y = cshift(x, shift=-ceiling(0.5_rk*size(x)))
        else
            y = cshift(x, shift=-floor(0.5_rk*size(x)))
        end if

    end function fftshift

end module seakeeping_tsa
