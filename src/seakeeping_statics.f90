!> 耐波性静力学
module seakeeping_statics
    use seakeeping_kinds
    use seakeeping_constants
contains
    !> 静水压
    pure real(kind=sk_real_kind) function hsp(rho, h) result(p)
        real(kind=sk_real_kind), intent(in) :: rho     !! 水密度 [kg/m^3]
        real(kind=sk_real_kind), intent(in) :: h       !! 水深 [m]
        p = rho*g*h
    end function hsp
    !> 每厘米吃水吨数 \( TPC = rho*Aw/100 \)
    elemental real(kind=sk_real_kind) function TPC(rho, Aw)
        real(kind=sk_real_kind), intent(in) :: rho !! 水密度
        real(kind=sk_real_kind), intent(in) :: Aw  !! 水线面面积
        TPC = rho*Aw/100
    end function TPC
end module seakeeping_statics
