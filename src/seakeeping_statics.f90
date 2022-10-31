!> author: 左志华
!> date: 2022-09-19
!>
!> Statics for seakeeping <br>
!> 耐波性静力学
module seakeeping_statics

    use seakeeping_kinds, only: rk
    use seakeeping_constants, only: g
    private :: rk, g

contains

    !> Hydrostatic pressure <br>
    !> 静水压
    pure real(rk) function hsp(rho, h) result(p)
        real(rk), intent(in) :: rho     !! Water density [kg/m^3] <br>
                                        !! 水密度 [kg/m^3]
        real(rk), intent(in) :: h       !! Water depth [m] <br>
                                        !! 水深 [m]

        p = rho*g*h

    end function hsp

    !> TPC <br>
    !> 每厘米吃水吨数 \( TPC = rho*Aw/100 \)
    elemental real(rk) function TPC(rho, Aw)
        real(rk), intent(in) :: rho !! Water density <br>
                                    !! 水密度
        real(rk), intent(in) :: Aw  !! waterline area <br>
                                    !! 水线面面积

        TPC = rho*Aw/100

    end function TPC

end module seakeeping_statics
