!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping wave theory <br>
!> 耐波性波浪理论
!>### 参考
!> 1. 船舶原理（上）
module seakeeping_wave

    use seakeeping_kinds, only: rk
    use seakeeping_constants, only: g, Pi
    implicit none
    private

    public :: k01, k02, we, wlr, wf, wenergy

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

        k0 = 2*Pi/l

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

        wlr = 2*Pi/(k01(w)*l)

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

end module seakeeping_wave
