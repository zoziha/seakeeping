!> 基于 hs, tm 的不规则波系参数，设定 ittc 双参数谱，计算波频段的有效波幅
!> 计算从 0.3 至 1.84 rad/s 的有效波幅
program ittc

    use seakeeping_module, only: ittc_waveamplitude, pi
    implicit none

    integer, parameter :: nfreq = 50  ! 频率点数, 增加可提高 4*sqrt(m0) 的精度
    real, parameter :: df = 0.005    ! 频率间隔, Hz
    real, parameter :: tm = 5.0     ! 平均周期
    real, parameter :: hs = 2.0   ! 有义波高
    real, parameter :: omega_start = 0.3

    real :: omega, wave_amplitude, m0, phase, wave_elevation
    integer :: i

    m0 = 0
    wave_elevation = 0
    write (*, '(4a)') 'frequency (rad/s)', 'significant wave amplitude (m)'

    do i = 1, nfreq
        omega = 2.0*pi*(i - 1)*df + omega_start

        ! 计算有效波幅
        call ittc_waveamplitude(omega, 2*pi*df, tm, hs, wave_amplitude)

        ! 输出结果
        write (*, '(4es9.2)') omega, wave_amplitude     !! 后续可计及随机方向和相位
                                                        !! 低频段和高频段可能需要一定的截断，以适用后续工作
        m0 = m0 + wave_amplitude**2/2

        ! 二维原点0时刻波面生成(测试)
        call random_number(phase)
        phase = phase*2*pi
        wave_elevation = wave_elevation + wave_amplitude*cos(omega*0 + phase)
    end do

    write (*, '(a, es9.2)') 'm0 = ', m0
    write (*, '(a, es9.2)') 'hs = ', 4*sqrt(m0)
    write (*, '(a, es9.2)') 'wave elevation at origin = ', wave_elevation ! 应该在 [-1.x, 1.x] 内，x 为小于 5 的整数

end program ittc
