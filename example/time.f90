program main

    use seakeeping_kinds, only: rk
    use seakeeping_time, only: tic, toc
    implicit none
    integer :: seed
    call tic(seed)
    call toc(seed)
    call sleep(2)
    call toc(seed)
    call toc(seed, is_second=.true.)
    call toc(seed, 'test')

end program main
