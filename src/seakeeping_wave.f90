!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping wave theory <br>
!> 耐波性波浪理论
!>### 参考
!> 1. 船舶原理（上）<br>
!> 2. 如何让水中涟漪变成拍岸巨浪？水面波的形成原因和增强原理.
module seakeeping_wave

    use seakeeping_kinds, only: rk => sk_real_kind
    use seakeeping_constants, only: g, Pi, pi2
    implicit none

    public
    private :: rk, g, Pi, pi2

contains

    !> Wave number from wave frequency <br>
    !> 波频率计算波数
    elemental real(rk) function k01(w) result(k0)
        real(rk), intent(in) :: w

        k0 = w*w/g

    end function k01

    !> Wave number from wave length <br>
    !> 波长计算波数
    elemental real(rk) function k02(l) result(k0)
        real(rk), intent(in) :: l

        k0 = pi2/l

    end function k02

    !> Encountered wave frequency <br>
    !> 遭遇波频率
    elemental real(rk) function we(w, v, deg)
        real(rk), intent(in) :: w               !! Wave frequency <br>
                                                !! 波频率
        real(rk), intent(in) :: v               !! Ship speed <br>
                                                !! 船舶速度
        real(rk), intent(in), optional :: deg   !! Ship heading <br>
                                                !! 船舶航向

        if (present(deg)) then
            we = w + k01(w)*v*cos(deg)
        else
            we = w + k01(w)*v
        end if

    end function we

    !> Wavelength to length ratio <br>
    !> 波长与船长比
    elemental real(rk) function wlr(w, l)
        real(rk), intent(in) :: w   !! Wave frequency <br>
                                    !! 波频率
        real(rk), intent(in) :: l   !! Ship length <br>
                                    !! 船舶特征长度

        wlr = pi2/(k01(w)*l)

    end function wlr

    !> Wave frequency from wlr <br>
    !> 由波长与船长比计算波频率
    elemental real(rk) function wf(wlr, l)
        real(rk), intent(in) :: wlr !! Wavelength to length ratio <br>
                                    !! 波长与船长比
        real(rk), intent(in) :: l   !! Ship length <br>
                                    !! 船舶特征长度

        wf = sqrt(g*k02(wlr*l))

    end function wf

    !> Wave energy <br>
    !> 波能：动能 + 势能, \( energy = 0.5*ρ*A^2*g \)
    elemental real(rk) function wenergy(rho, a)
        real(rk), intent(in) :: rho !! Water density <br>
                                    !! 水密度
        real(rk), intent(in) :: a   !! Wave amplitude <br>
                                    !! 波幅

        wenergy = rho*g*a*a/2

    end function wenergy

    !> Wave amplitude <br>
    !> 单位波幅：\( \zeta = \sin(kx\cos\beta + ky\sin\beta + \omega t) \)
    real(rk) pure function zeta(k, x, y, w, t, beta)
        real(rk), intent(in) :: k, x, y, w, t, beta

        zeta = sin(k*x*cos(beta) + k*y*sin(beta) + w*t)

    end function zeta

    !> 深水波波速 \( v = \sqrt{\frac{g\lambda}{2\pi}} \)
    !>@note 确保水深大于半波长，造波机多次前后移动制造深水波，波长越大的后波将追赶前波，
    !> 最终水面波可叠加形成一条大浪
    real(rk) pure function vdeep(lambda)
        real(rk), intent(in) :: lambda

        vdeep = sqrt(g*lambda/(pi2))

    end function vdeep

    !> JONSWAP 波谱模型计算频段有义波高
    !> Ref: https://blog.csdn.net/yx171532/article/details/113847209
    pure subroutine jonswap_waveheight(omega, domega, tz, hs, wave_height)
        real(kind=rk), intent(in) :: omega  !! 波浪角频率, rad/s
        real(kind=rk), intent(in) :: domega     !! 采样频率, Hz
        real(kind=rk), intent(in) :: tz     !! 平均跨零周期, s, 海浪在水面上传播的距离
        real(kind=rk), intent(in) :: hs     !! 有义波高, m
        real(kind=rk), intent(out) :: wave_height !! 频段有义波高, m
        real(kind=rk) :: hsig, bw, wave_energy, fp

        real(kind=rk), parameter :: gamma = 3.3_rk !! 峰度系数(3~5), 标准值3.3
        real(kind=rk), parameter :: k = 0.6063_rk + 0.1164_rk*sqrt(gamma) - 0.01224_rk*gamma !! K=Tz/Tp

        fp = k/tz

        if (omega <= pi/tz) then
            ! 小尺度波动
            hsig = 0.07_rk*gamma*exp(-0.5_rk*((omega - pi2*fp)/(pi*gamma*fp))**2)*hs**2/omega**5
        else
            ! 大尺度波动
            hsig = 0.09_rk*gamma**2*exp(-1.25_rk*(tz*omega)**(-4))*hs**2/omega**4
        end if

        bw = domega*omega  ! 波能频带宽度
        wave_energy = hsig**2*bw  ! 波能
        wave_height = sqrt(wave_energy/pi2)

    end subroutine jonswap_waveheight

end module seakeeping_wave
