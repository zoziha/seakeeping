!> Queue 实数队列
module seakeeping_collection_queue_real

    use seakeeping_kinds, only: rk => sk_real_kind
    implicit none

    private
    public :: queue_real, queue_real_iterator

    !> 节点
    type node
        private
        type(node), pointer :: next => null()
        real(rk) :: item !! content of the node
    contains
        procedure :: clear => node_clear
    end type node

    !> 队列
    type queue_real
        private
        integer, public :: len = 0 !! number of nodes in the queue
        type(node), pointer :: head => null() !! head of the queue
        type(node), pointer :: tail => null() !! tail of the queue
    contains
        procedure :: enqueue => queue_enqueue
        procedure :: dequeue => queue_dequeue
        procedure :: iterator
        procedure :: clear => queue_clear
    end type queue_real

    !> 迭代器
    type queue_real_iterator
        private
        type(node), pointer :: ptr => null()
    contains
        procedure :: next => queue_iterator_next
        procedure :: clear => queue_iterator_clear
    end type queue_real_iterator

contains

    !> Initialize the node from a new item
    pure function init_node(new_item) result(new_node)
        real(rk), intent(in) :: new_item
        type(node) new_node

        new_node%item = new_item

    end function init_node

    !> Clear the node
    pure subroutine node_clear(self)
        class(node), intent(inout) :: self

        nullify (self%next)

    end subroutine node_clear

    !> Enqueue an item to the queue
    pure subroutine queue_enqueue(self, item)
        class(queue_real), intent(inout) :: self
        real(rk), intent(in) :: item

        if (associated(self%tail)) then
            allocate (self%tail%next, source=init_node(item))
            self%tail => self%tail%next
        else
            allocate (self%head, source=init_node(item))
            self%tail => self%head
        end if
        self%len = self%len + 1

    end subroutine queue_enqueue

    !> Dequeue an item from the queue
    pure subroutine queue_dequeue(self, item)
        class(queue_real), intent(inout) :: self
        real(rk), intent(out), optional :: item
        type(node), pointer :: curr_node

        if (associated(self%head)) then
            if (present(item)) then
                item = self%head%item
            end if
            curr_node => self%head
            self%head => self%head%next
            self%len = self%len - 1
            nullify (curr_node%next)
            deallocate (curr_node)
            if (self%len == 0) then
                nullify (self%head, self%tail)
            end if
        end if

    end subroutine queue_dequeue

    !> Get an queue_real_iterator for the queue
    type(queue_real_iterator) function iterator(self) result(iter)
        class(queue_real), intent(in) :: self

        iter%ptr => self%head

    end function iterator

    !> Clear the queue
    pure subroutine queue_clear(self)
        class(queue_real), intent(inout) :: self
        type(node), pointer :: curr_node

        do while (self%len > 0)
            curr_node => self%head
            if (associated(curr_node%next)) self%head => self%head%next
            call curr_node%clear()
            deallocate (curr_node)
            self%len = self%len - 1
        end do
        nullify (self%head, self%tail)

    end subroutine queue_clear

    !> Clear the queue_real_iterator
    pure subroutine queue_iterator_clear(self)
        class(queue_real_iterator), intent(inout) :: self

        nullify (self%ptr)

    end subroutine queue_iterator_clear

    !> Get the next item from the queue_real_iterator
    pure subroutine queue_iterator_next(self, item)
        class(queue_real_iterator), intent(inout) :: self
        real(rk), intent(out) :: item

        if (associated(self%ptr)) then
            item = self%ptr%item
            self%ptr => self%ptr%next
        end if

    end subroutine queue_iterator_next

end module seakeeping_collection_queue_real

