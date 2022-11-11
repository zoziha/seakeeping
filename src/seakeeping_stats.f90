!> date: 2022-11-11
module seakeeping_stats

    use seakeeping_kinds, only: rk

contains

    !> 获取平均数
    pure real(rk) function mean(x)
        real(rk), intent(in) :: x(:)
        mean = sum(x)/size(x)
    end function mean

end module seakeeping_stats
