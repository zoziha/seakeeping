!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping wave theory <br>
!> 耐波性波浪理论
!>### 参考
!> 1. 船舶原理（上）<br>
!> 2. 如何让水中涟漪变成拍岸巨浪？水面波的形成原因和增强原理.
module seakeeping_wave

    use seakeeping_kinds
    use seakeeping_constants

contains

    !> Wave number from wave frequency <br>
    !> 波频率计算波数
    elemental real(sk_real_kind) function k01(w) result(k0)
        real(sk_real_kind), intent(in) :: w

        k0 = w*w/g

    end function k01

    !> Wave number from wave length <br>
    !> 波长计算波数
    elemental real(sk_real_kind) function k02(l) result(k0)
        real(sk_real_kind), intent(in) :: l

        k0 = 2*Pi/l

    end function k02

    !> Encountered wave frequency <br>
    !> 遭遇波频率
    elemental real(sk_real_kind) function we(w, v, deg)
        real(sk_real_kind), intent(in) :: w               !! Wave frequency <br>
                                                !! 波频率
        real(sk_real_kind), intent(in) :: v               !! Ship speed <br>
                                                !! 船舶速度
        real(sk_real_kind), intent(in), optional :: deg   !! Ship heading <br>
                                                !! 船舶航向

        if (present(deg)) then
            we = w + k01(w)*v*cos(deg)
        else
            we = w + k01(w)*v
        end if

    end function we

    !> Wavelength to length ratio <br>
    !> 波长与船长比
    elemental real(sk_real_kind) function wlr(w, l)
        real(sk_real_kind), intent(in) :: w   !! Wave frequency <br>
                                    !! 波频率
        real(sk_real_kind), intent(in) :: l   !! Ship length <br>
                                    !! 船舶特征长度

        wlr = 2*Pi/(k01(w)*l)

    end function wlr

    !> Wave frequency from wlr <br>
    !> 由波长与船长比计算波频率
    elemental real(sk_real_kind) function wf(wlr, l)
        real(sk_real_kind), intent(in) :: wlr !! Wavelength to length ratio <br>
                                    !! 波长与船长比
        real(sk_real_kind), intent(in) :: l   !! Ship length <br>
                                    !! 船舶特征长度

        wf = sqrt(g*k02(wlr*l))

    end function wf

    !> Wave energy <br>
    !> 波能：动能 + 势能, \( energy = 0.5*ρ*A^2*g \)
    elemental real(sk_real_kind) function wenergy(rho, a)
        real(sk_real_kind), intent(in) :: rho !! Water density <br>
                                    !! 水密度
        real(sk_real_kind), intent(in) :: a   !! Wave amplitude <br>
                                    !! 波幅

        wenergy = rho*g*a*a/2

    end function wenergy

    !> Wave amplitude <br>
    !> 单位波幅：\( \zeta = \sin(kx\cos\beta + ky\sin\beta + \omega t) \)
    real(sk_real_kind) pure function zeta(k, x, y, w, t, beta)
        real(sk_real_kind), intent(in) :: k, x, y, w, t, beta

        zeta = sin(k*x*cos(beta) + k*y*sin(beta) + w*t)

    end function zeta

    !> 深水波波速 \( v = \sqrt{\frac{g\lambda}{2\pi}} \)
    !>@note 确保水深大于半波长，造波机多次前后移动制造深水波，波长越大的后波将追赶前波，
    !> 最终水面波可叠加形成一条大浪
    real(sk_real_kind) pure function vdeep(lambda)
        real(sk_real_kind), intent(in) :: lambda

        vdeep = sqrt(g*lambda/(2*Pi))

    end function vdeep

end module seakeeping_wave
