!> author: 左志华
!> date: 2022-09-17
!>
!> Time for seakeeping <br>
!> 耐波性时间
module seakeeping_time

    use seakeeping_kinds, only: rk
    private :: rk

contains

    !> Start timer <br>
    !> 启动计时器
    impure subroutine tic(seed)
        integer, intent(out) :: seed
        call system_clock(seed)
    end subroutine tic

    !> Stop timer and return the time <br>
    !> 停止计时器并返回时间（秒计时）
    impure subroutine toc(seed, t)
        integer, intent(in) :: seed
        class(*), optional :: t
        integer :: time_now, time_rate

        call system_clock(time_now, time_rate)

        associate (dt => real(time_now - seed, rk)/time_rate)

            if (present(t)) then
                select type (t)
                type is (real(rk))
                    t = dt
                type is (integer)
                    t = nint(dt)
                type is (character(*))
                    write (*, "(2a,g0.3,a)") t, ', time elapsed: ', dt, "s"
                class default
                    write (*, '(a)') 'Error: unknown type of t in toc()'
                end select
            else
                write (*, "(a,g0.3,a)") 'Time elapsed: ', dt, " s"
            end if

        end associate

    end subroutine toc

    !> Get current time <br>
    !> 获得当前日期或时间
    impure character(23) function now() result(t)
        character(len=8) :: datstr
        character(len=10) :: timstr

        call date_and_time(datstr, timstr)

        t = datstr(1:4)//"-"// &
            datstr(5:6)//"-"// &
            datstr(7:8)//" "// &
            timstr(1:2)//":"// &
            timstr(3:4)//":"// &
            timstr(5:10)

    end function now

end module seakeeping_time
