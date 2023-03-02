!> author: 左志华
!> date: 2022-09-17
!>
!> Time for seakeeping <br>
!> 耐波性时间
module seakeeping_time

    use seakeeping_kinds, only: rk
    private

    !> 计时器
    type, public :: timer
        integer, private :: seed
    contains
        procedure :: tic, toc, nowtime
    end type timer

contains

    !> Start timer <br>
    !> 启动计时器
    subroutine tic(self)
        class(timer), intent(inout) :: self
        call system_clock(self%seed)
    end subroutine tic

    !> Stop timer and return the time <br>
    !> 停止计时器并返回时间（秒计时）
    subroutine toc(self, t, is_second)
        class(timer), intent(in) :: self
        class(*), optional :: t
        logical, intent(in), optional :: is_second
        integer :: time_now, time_rate

        call system_clock(time_now, time_rate)

        associate (dt => real(time_now - self%seed, rk)/time_rate)

            if (present(t)) then
                select type (t)
                type is (real(rk))
                    t = dt
                type is (integer)
                    t = nint(dt)
                type is (character(*))
                    if (present(is_second)) then
                        if (is_second) then
                            write (*, "(2a,g0.3,a)") t, ', time elapsed: ', dt, "s"
                            return
                        end if
                    end if
                    write (*, "(3a)") t, ', time elapsed: ', format_time(dt)
                class default
                    write (*, '(a)') 'Error: unknown type of t in toc()'
                end select
            else
                if (present(is_second)) then
                    if (is_second) then
                        write (*, "(a,g0.3,a)") 'Time elapsed: ', dt, "s"
                        return
                    end if
                end if
                write (*, "(2a)") 'Time elapsed: ', format_time(dt)
            end if

        end associate

    contains

        !> Format time
        pure function format_time(dt) result(ans)
            real(rk), intent(in) :: dt  !! time in seconds
            character(len=23) :: ans
            integer :: hour, minute, second, millisecond
            hour = int(dt/3600)
            minute = int((dt - hour*3600)/60)
            second = int(dt - hour*3600 - minute*60)
            millisecond = nint((dt - hour*3600 - minute*60 - second)*1000)
            write (ans, "(i3.3,':',i2.2,':',i2.2,'.',i3.3)") hour, minute, second, millisecond
        end function format_time

    end subroutine toc

    !> Get current time <br>
    !> 获得当前日期或时间
    character(23) function nowtime(self) result(t)
        class(timer), intent(in) :: self
        character(len=8) :: datstr
        character(len=10) :: timstr

        call date_and_time(datstr, timstr)

        t = datstr(1:4)//"-"// &
            datstr(5:6)//"-"// &
            datstr(7:8)//" "// &
            timstr(1:2)//":"// &
            timstr(3:4)//":"// &
            timstr(5:10)

    end function nowtime

end module seakeeping_time
