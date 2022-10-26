program main

    use seakeeping_kinds, only: rk
    use seakeeping_time, only: tic, toc
    implicit none
    integer :: seed
    call tic(seed)
    call toc(seed)
    call toc(seed)
    call toc(seed, 'test')

end program main
