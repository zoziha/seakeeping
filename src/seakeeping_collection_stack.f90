!> stack 泛型堆栈 (通用但效率稍低)
module seakeeping_collection_stack

    implicit none

    private
    public :: stack, stack_iterator

    !> 节点
    type node
        private
        type(node), pointer :: prev => null()
        type(node), pointer :: next => null()
        class(*), allocatable :: item !! content of the node
    contains
        procedure :: clear => node_clear
    end type node

    !> 堆栈
    type stack
        private
        integer :: num_nodes = 0 !! number of nodes in the stack
        type(node), pointer :: head => null() !! head of the stack
        type(node), pointer :: tail => null() !! tail of the stack
    contains
        procedure :: push => stack_push
        procedure :: pop => stack_pop
        procedure :: iterator
        procedure :: size => stack_size
        procedure :: clear => stack_clear
    end type stack

    !> 迭代器
    type stack_iterator
        private
        type(node), pointer :: ptr => null()
    contains
        procedure :: next => stack_iterator_next
        procedure :: clear => stack_iterator_clear
    end type stack_iterator

contains

    !> Initialize the node from a new item
    pure function init_node(new_item) result(new_node)
        class(*), intent(in) :: new_item
        type(node) :: new_node

        allocate (new_node%item, source=new_item)

    end function init_node

    !> Clear the node
    pure subroutine node_clear(self)
        class(node), intent(inout) :: self

        if (allocated(self%item)) deallocate (self%item)
        nullify (self%prev)
        nullify (self%next)

    end subroutine node_clear

    !> push an item to the stack
    pure subroutine stack_push(self, item)
        class(stack), intent(inout) :: self
        class(*), intent(in) :: item

        if (associated(self%tail)) then
            allocate (self%tail%next, source=init_node(item))
            self%tail%next%prev => self%tail
            self%tail => self%tail%next
        else
            allocate (self%head, source=init_node(item))
            self%tail => self%head
        end if
        self%num_nodes = self%num_nodes + 1

    end subroutine stack_push

    !> pop an item from the stack
    subroutine stack_pop(self, item)
        class(stack), intent(inout) :: self
        class(*), intent(out), allocatable, optional :: item
        type(node), pointer :: curr_node

        if (associated(self%tail)) then
            if (present(item)) then
                call move_alloc(self%tail%item, item)
            else
                deallocate (self%tail%item)
            end if
            curr_node => self%tail
            self%tail => curr_node%prev
            self%num_nodes = self%num_nodes - 1
            nullify (curr_node%prev, curr_node%next)
            deallocate (curr_node)
            if (self%num_nodes == 0) then
                nullify (self%head, self%tail)
            end if
        end if

    end subroutine stack_pop

    !> Get an stack_iterator for the stack
    type(stack_iterator)  function iterator(self) result(iter)
        class(stack), intent(in) :: self

        iter%ptr => self%head

    end function iterator

    !> Get the size of the stack
    pure integer function stack_size(self) result(size)
        class(stack), intent(in) :: self

        size = self%num_nodes

    end function stack_size

    !> Clear the stack
    pure subroutine stack_clear(self)
        class(stack), intent(inout) :: self
        type(node), pointer :: curr_node

        do while (self%num_nodes > 0)
            curr_node => self%head
            if (associated(curr_node%next)) then
                nullify (curr_node%next%prev)
                self%head => self%head%next
            end if
            call curr_node%clear()
            deallocate (curr_node)
            self%num_nodes = self%num_nodes - 1
        end do
        nullify (self%head, self%tail)

    end subroutine stack_clear

    !> Clear the stack_iterator
    pure subroutine stack_iterator_clear(self)
        class(stack_iterator), intent(inout) :: self

        nullify (self%ptr)

    end subroutine stack_iterator_clear

    !> Get the next item from the stack_iterator
    subroutine stack_iterator_next(self, item)
        class(stack_iterator), intent(inout) :: self
        class(*), allocatable, intent(out) :: item

        if (associated(self%ptr)) then
            allocate (item, source=self%ptr%item)
            self%ptr => self%ptr%next
        end if

    end subroutine stack_iterator_next

end module seakeeping_collection_stack

