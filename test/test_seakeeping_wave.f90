!> 波浪理论单元测试
module test_seakeeping_wave

    use testdrive, only: new_unittest, unittest_type, error_type, check
    use seakeeping_wave, only: ccwes_waveamplitude, ittc_tpwes_waveamplitude, ittc_spwes_waveamplitude
    use seakeeping_kinds, only: rk => sk_real_kind
    use seakeeping_constants, only: pi
    implicit none

    private
    public :: collect_wave

contains

    subroutine collect_wave(testsuite)
        type(unittest_type), intent(out), allocatable :: testsuite(:)

        allocate (testsuite, source=[ &
                  new_unittest('ccwes_waveamplitude', test_ccwes_waveamplitude), &
                  new_unittest('ittc_spwes_waveamplitude', test_ittc_spwes_waveamplitude), &
                  new_unittest('ittc_tpwes_waveamplitude', test_ittc_tpwes_waveamplitude) &
                  ])

    end subroutine collect_wave

    subroutine test_ccwes_waveamplitude(error)
        type(error_type), intent(out), allocatable :: error
        integer, parameter :: nfreq = 50  ! 频率点数, 增加可提高 4*sqrt(m0) 的精度
        real, parameter :: df = 0.05    ! 频率间隔, Hz
        real, parameter :: hs = 2.0   ! 有义波高
        real, parameter :: omega_start = 0.05

        real :: omega, wave_amplitude, m0
        integer :: i

        m0 = 0

        do i = 1, nfreq
            omega = 2.0*pi*(i - 1)*df + omega_start

            ! 计算有义波幅
            call ccwes_waveamplitude(omega, 2*pi*df, hs, wave_amplitude)

            m0 = m0 + wave_amplitude**2/2
        end do

        call check(error, 4*sqrt(m0), 1.98052275_rk)

    end subroutine test_ccwes_waveamplitude

    subroutine test_ittc_spwes_waveamplitude(error)
        type(error_type), intent(out), allocatable :: error
        integer, parameter :: nfreq = 50  ! 频率点数, 增加可提高 4*sqrt(m0) 的精度
        real, parameter :: df = 0.05    ! 频率间隔, Hz
        real, parameter :: hs = 2.0   ! 有义波高
        real, parameter :: omega_start = 0.05

        real :: omega, wave_amplitude, m0
        integer :: i

        m0 = 0

        do i = 1, nfreq
            omega = 2.0*pi*(i - 1)*df + omega_start

            ! 计算有义波幅
            call ittc_spwes_waveamplitude(omega, 2*pi*df, hs, wave_amplitude)

            m0 = m0 + wave_amplitude**2/2
        end do

        call check(error, 4*sqrt(m0), 1.97757983_rk)

    end subroutine test_ittc_spwes_waveamplitude

    subroutine test_ittc_tpwes_waveamplitude(error)
        type(error_type), intent(out), allocatable :: error
        integer, parameter :: nfreq = 50  ! 频率点数, 增加可提高 4*sqrt(m0) 的精度
        real, parameter :: df = 0.05    ! 频率间隔, Hz
        real, parameter :: tm = 5.0     ! 平均周期
        real, parameter :: hs = 2.0   ! 有义波高
        real, parameter :: omega_start = 0.1

        real :: omega, wave_amplitude, m0
        integer :: i

        m0 = 0

        do i = 1, nfreq
            omega = 2.0*pi*(i - 1)*df + omega_start

            ! 计算有义波幅
            call ittc_tpwes_waveamplitude(omega, 2*pi*df, tm, hs, wave_amplitude)

            m0 = m0 + wave_amplitude**2/2

        end do

        call check(error, 4*sqrt(m0), 1.98012602_rk)

    end subroutine test_ittc_tpwes_waveamplitude

end module test_seakeeping_wave
