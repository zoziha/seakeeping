!> 数据集例程
module test_seakeeping_collection

    use testdrive, only: new_unittest, unittest_type, error_type, check
    use seakeeping_module, only: rk => sk_real_kind, queue, queue_iterator, &
                                 queue_real, queue_real_iterator, &
                                 queue_int, queue_int_iterator, &
                                 stack, stack_iterator, &
                                 stack_real, stack_real_iterator, &
                                 stack_int, stack_int_iterator, &
                                 vector, vector_int, vector_real
    implicit none

    private
    public :: collect_collection

contains

    subroutine collect_collection(testsuite)
        type(unittest_type), intent(out), allocatable :: testsuite(:)

        allocate (testsuite, source=[ &
                  new_unittest('queue', test_queue), &
                  new_unittest('queue_int', test_queue_int), &
                  new_unittest('queue_real', test_queue_real), &
                  new_unittest('stack', test_stack), &
                  new_unittest('stack_int', test_stack_int), &
                  new_unittest('stack_real', test_stack_real), &
                  new_unittest('vector', test_vector), &
                  new_unittest('vector_int', test_vector_int), &
                  new_unittest('vector_real', test_vector_real) &
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

        call check(error, q%len, 1)
        if (allocated(error)) return

        select type (item)
        type is (integer)
            call check(error, item, 1)
            call q%clear()
            call iter%clear()
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

        call check(error, q%len, 1)
        if (allocated(error)) return

        call check(error, item, 1.0_rk)
        call q%clear()
        call iter%clear()

    end subroutine test_queue_real

    subroutine test_queue_int(error)
        type(error_type), intent(out), allocatable :: error
        type(queue_int) :: q
        type(queue_int_iterator) :: iter
        integer :: item

        call q%enqueue(1)
        iter = q%iterator()
        call iter%next(item)

        call check(error, q%len, 1)
        if (allocated(error)) return

        call check(error, item, 1)
        call q%clear()
        call iter%clear()

    end subroutine test_queue_int

    subroutine test_stack(error)
        type(error_type), intent(out), allocatable :: error
        type(stack) :: s
        type(stack_iterator) :: iter
        class(*), allocatable :: item

        call s%push(1)
        iter = s%iterator()
        call iter%next(item)

        call check(error, s%len, 1)
        if (allocated(error)) return

        select type (item)
        type is (integer)
            call check(error, item, 1)
            call s%clear()
            call iter%clear()
        end select

    end subroutine test_stack

    subroutine test_stack_real(error)
        type(error_type), intent(out), allocatable :: error
        type(stack_real) :: s
        type(stack_real_iterator) :: iter
        real(rk) :: item

        call s%push(1.0_rk)
        iter = s%iterator()
        call iter%next(item)

        call check(error, s%len, 1)
        if (allocated(error)) return

        call check(error, item, 1.0_rk)
        call s%clear()
        call iter%clear()

    end subroutine test_stack_real

    subroutine test_stack_int(error)
        type(error_type), intent(out), allocatable :: error
        type(stack_int) :: s
        type(stack_int_iterator) :: iter
        integer :: item

        call s%push(1)
        iter = s%iterator()
        call iter%next(item)

        call check(error, s%len, 1)
        if (allocated(error)) return

        call check(error, item, 1)
        call s%clear()
        call iter%clear()

    end subroutine test_stack_int

    subroutine test_vector(error)
        type(error_type), intent(out), allocatable :: error
        type(vector) :: v
        class(*), allocatable :: item

        call v%init()
        call v%push(1)
        call v%pop(item)

        call check(error, v%len, 0)
        if (allocated(error)) return

        select type (item)
        type is (integer)
            call check(error, item, 1)
            call v%clear()
        end select

    end subroutine test_vector

    subroutine test_vector_int(error)
        type(error_type), intent(out), allocatable :: error
        type(vector_int) :: v
        integer :: item

        call v%init()
        call v%push(1)
        call v%pop(item)

        call check(error, v%len, 0)
        if (allocated(error)) return

        call check(error, item, 1)
        call v%clear()

    end subroutine test_vector_int

    subroutine test_vector_real(error)
        type(error_type), intent(out), allocatable :: error
        type(vector_real) :: v
        real(rk) :: item

        call v%init()
        call v%push(1.0_rk)
        call v%pop(item)

        call check(error, v%len, 0)
        if (allocated(error)) return

        call check(error, item, 1.0_rk)
        call v%clear()

    end subroutine test_vector_real

end module test_seakeeping_collection
