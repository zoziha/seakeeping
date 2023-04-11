!> 耐波性常数
module seakeeping_constants
    use seakeeping_kinds
    real(kind=sk_real_kind), parameter :: pi = acos(-1.0_sk_real_kind)
    real(kind=sk_real_kind), parameter :: g = 9.80665_sk_real_kind
    real(kind=sk_real_kind), parameter :: rho_water(2) = [1000.0_sk_real_kind, 1025.0_sk_real_kind]
    real(kind=sk_real_kind), parameter :: rho_air = 1.205_sk_real_kind
    real(kind=sk_real_kind), parameter :: p_atm = 101325.0_sk_real_kind
    real(kind=sk_real_kind), parameter :: kn2ms = 1852.0_sk_real_kind/3600.0_sk_real_kind
    real(kind=sk_real_kind), parameter :: ms2kn = 3600.0_sk_real_kind/1852.0_sk_real_kind
end module seakeeping_constants
