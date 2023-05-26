!> 基于 hs, tz 的不规则波系参数，设定 ittc 双参数谱，计算有效波高
!> 计算从 0.3 至 1.84 rad/s 的有效波高
program ittc

    use seakeeping_module, only: ittc_waveheight, pi
    implicit none

    integer, parameter :: nfreq = 50  ! 频率点数, 增加可提高 4*sqrt(m0) 的精度
    real, parameter :: df = 0.005    ! 频率间隔, Hz
    real, parameter :: tz = 5.0     ! 零上交越周期
    real, parameter :: hs = 2.0   ! 有义波高
    real, parameter :: omega_start = 0.3

    real :: omega, wave_height, m0
    integer :: i

    m0 = 0
    write (*, '(4a)') 'frequency (rad/s)', 'significant wave height (m)'

    do i = 1, nfreq
        omega = 2.0*pi*(i - 1)*df + omega_start

        ! 计算有效波高
        call ittc_waveheight(omega, tz, hs, wave_height)

        ! 输出结果
        write (*, '(4es9.2)') omega, wave_height   !! 后续可计及随机方向和相位
                                                   !! 低频段和高频段可能需要一定的截断，以适用后续工作
        m0 = m0 + (wave_height/4)**2*df*2*pi
    end do

    write (*, '(a, es9.2)') 'm0 = ', m0
    write (*, '(a, es9.2)') 'hs = ', 4*sqrt(m0)

end program ittc
