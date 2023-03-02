program main
    use seakeeping_time, only: timer
    implicit none
    type(timer) :: time
    call time%tic
    print '(a)', time%nowtime()
    call time%toc
    call time%toc(is_second=.true.)
    call time%toc('test')
end program main
