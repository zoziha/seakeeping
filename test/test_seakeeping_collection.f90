!> 数据集例程
module test_seakeeping_collection

    use testdrive, only: new_unittest, unittest_type, error_type, check
    use seakeeping_module, only: rk => sk_real_kind, queue, queue_iterator, &
                                 queue_real, queue_real_iterator, &
                                    queue_int, queue_int_iterator
    implicit none

    private
    public :: collect_collection

contains

    subroutine collect_collection(testsuite)
        type(unittest_type), intent(out), allocatable :: testsuite(:)

        allocate (testsuite, source=[ &
                  new_unittest('queue', test_queue), &
                  new_unittest('queue_int', test_queue_int), &
                  new_unittest('queue_real', test_queue_real) &
                  ])

    end subroutine collect_collection

    subroutine test_queue(error)
        type(error_type), intent(out), allocatable :: error
        type(queue) :: q
        type(queue_iterator) :: iter
        class(*), allocatable :: item

        call q%enqueue(1)
        iter = q%iterator()
        call iter%next(item)

        select type (item)
        type is (integer)
            call check(error, item, 1)
        end select

    end subroutine test_queue

    subroutine test_queue_real(error)
        type(error_type), intent(out), allocatable :: error
        type(queue_real) :: q
        type(queue_real_iterator) :: iter
        real(rk) :: item

        call q%enqueue(1.0_rk)
        iter = q%iterator()
        call iter%next(item)

        call check(error, item, 1.0_rk)

    end subroutine test_queue_real

    subroutine test_queue_int(error)
        type(error_type), intent(out), allocatable :: error
        type(queue_int) :: q
        type(queue_int_iterator) :: iter
        integer :: item

        call q%enqueue(1)
        iter = q%iterator()
        call iter%next(item)

        call check(error, item, 1)

    end subroutine test_queue_int

end module test_seakeeping_collection
