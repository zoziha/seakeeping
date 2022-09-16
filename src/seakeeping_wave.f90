!> author: 左志华
!> date: 2022-09-16
!>
!> Seakeeping wave theory <br>
!> 耐波性波浪理论
module seakeeping_wave

    use seakeeping_kinds, only: rk
    use seakeeping_constants, only: g, Pi
    implicit none
    private

    public :: k0, we

contains

    !> Wave number from wave frequency <br>
    !> 波频率计算波数
    elemental real(rk) function k0(w)
        real(rk), intent(in) :: w

        k0 = w*w/g

    end function k0

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
            we = w + k0(w)*v*cos(deg)
        else
            we = w + k0(w)*v
        end if

    end function we

end module seakeeping_wave
