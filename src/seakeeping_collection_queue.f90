!> Queue 泛型队列 (通用但效率稍低)
module seakeeping_collection_queue

    implicit none

    private
    public :: queue, queue_iterator

    !> 节点
    type node
        private
        type(node), pointer :: next => null()
        class(*), allocatable :: item !! content of the node
    contains
        procedure :: clear => node_clear
    end type node

    !> 队列
    type queue
        private
        integer :: num_nodes = 0 !! number of nodes in the queue
        type(node), pointer :: head => null() !! head of the queue
        type(node), pointer :: tail => null() !! tail of the queue
    contains
        procedure :: enqueue => queue_enqueue
        procedure :: dequeue => queue_dequeue
        procedure :: iterator
        procedure :: size => queue_size
        procedure :: clear => queue_clear
    end type queue

    !> 迭代器
    type queue_iterator
        private
        type(node), pointer :: ptr => null()
    contains
        procedure :: next => queue_iterator_next
        procedure :: clear => queue_iterator_clear
    end type queue_iterator

contains

    !> Initialize the node from a new item
    pure function init_node(new_item) result(new_node)
        class(*), intent(in) :: new_item
        type(node) new_node

        allocate (new_node%item, source=new_item)

    end function init_node

    !> Clear the node
    pure subroutine node_clear(self)
        class(node), intent(inout) :: self

        if (allocated(self%item)) deallocate (self%item)
        nullify (self%next)

    end subroutine node_clear

    !> Enqueue an item to the queue
    pure subroutine queue_enqueue(self, item)
        class(queue), intent(inout) :: self
        class(*), intent(in) :: item

        if (associated(self%tail)) then
            allocate (self%tail%next, source=init_node(item))
            self%tail => self%tail%next
        else
            allocate (self%head, source=init_node(item))
            self%tail => self%head
        end if
        self%num_nodes = self%num_nodes + 1

    end subroutine queue_enqueue

    !> Dequeue an item from the queue
    subroutine queue_dequeue(self, item)
        class(queue), intent(inout) :: self
        class(*), intent(out), allocatable, optional :: item
        type(node), pointer :: curr_node

        if (associated(self%head)) then
            if (present(item)) then
                call move_alloc(self%head%item, item)
            else
                deallocate (self%head%item)
            end if
            curr_node => self%head
            self%head => self%head%next
            self%num_nodes = self%num_nodes - 1
            nullify (curr_node%next)
            deallocate (curr_node)
            if (self%num_nodes == 0) then
                nullify (self%head, self%tail)
            end if
        end if

    end subroutine queue_dequeue

    !> Get an queue_iterator for the queue
    type(queue_iterator)  function iterator(self) result(iter)
        class(queue), intent(in) :: self

        iter%ptr => self%head

    end function iterator

    !> Get the size of the queue
    pure integer function queue_size(self) result(size)
        class(queue), intent(in) :: self

        size = self%num_nodes

    end function queue_size

    !> Clear the queue
    pure subroutine queue_clear(self)
        class(queue), intent(inout) :: self
        type(node), pointer :: curr_node

        do while (self%num_nodes > 0)
            curr_node => self%head
            if (associated(curr_node%next)) self%head => self%head%next
            call curr_node%clear()
            deallocate (curr_node)
            self%num_nodes = self%num_nodes - 1
        end do
        nullify (self%head, self%tail)

    end subroutine queue_clear

    !> Clear the queue_iterator
    pure subroutine queue_iterator_clear(self)
        class(queue_iterator), intent(inout) :: self

        nullify (self%ptr)

    end subroutine queue_iterator_clear

    !> Get the next item from the queue_iterator
    subroutine queue_iterator_next(self, item)
        class(queue_iterator), intent(inout) :: self
        class(*), allocatable, intent(out) :: item

        if (associated(self%ptr)) then
            allocate (item, source=self%ptr%item)
            self%ptr => self%ptr%next
        end if

    end subroutine queue_iterator_next

end module seakeeping_collection_queue

