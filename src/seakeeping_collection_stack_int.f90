!> stack 整型堆栈
module seakeeping_collection_stack_int

    implicit none

    private
    public :: stack_int, stack_int_iterator

    !> 节点
    type node
        private
        type(node), pointer :: prev => null()
        type(node), pointer :: next => null()
        integer :: item !! content of the node
    contains
        procedure :: clear => node_clear
    end type node

    !> 堆栈
    type stack_int
        private
        integer, public :: len = 0 !! number of nodes in the stack_int
        type(node), pointer :: head => null() !! head of the stack_int
        type(node), pointer :: tail => null() !! tail of the stack_int
    contains
        procedure :: push => stack_int_push
        procedure :: pop => stack_int_pop
        procedure :: iterator
        procedure :: clear => stack_int_clear
    end type stack_int

    !> 迭代器
    type stack_int_iterator
        private
        type(node), pointer :: ptr => null()
    contains
        procedure :: next => stack_int_iterator_next
        procedure :: clear => stack_int_iterator_clear
    end type stack_int_iterator

contains

    !> Initialize the node from a new item
    pure function init_node(new_item) result(new_node)
        integer, intent(in) :: new_item
        type(node) :: new_node

        new_node%item = new_item

    end function init_node

    !> Clear the node
    pure subroutine node_clear(self)
        class(node), intent(inout) :: self

        nullify (self%prev)
        nullify (self%next)

    end subroutine node_clear

    !> push an item to the stack_int
    pure subroutine stack_int_push(self, item)
        class(stack_int), intent(inout) :: self
        integer, intent(in) :: item

        if (associated(self%tail)) then
            allocate (self%tail%next, source=init_node(item))
            self%tail%next%prev => self%tail
            self%tail => self%tail%next
        else
            allocate (self%head, source=init_node(item))
            self%tail => self%head
        end if
        self%len = self%len + 1

    end subroutine stack_int_push

    !> pop an item from the stack_int
    subroutine stack_int_pop(self, item)
        class(stack_int), intent(inout) :: self
        integer, intent(out), optional :: item
        type(node), pointer :: curr_node

        if (associated(self%tail)) then
            if (present(item)) then
                item = self%tail%item
            end if
            curr_node => self%tail
            self%tail => curr_node%prev
            self%len = self%len - 1
            nullify (curr_node%prev, curr_node%next)
            deallocate (curr_node)
            if (self%len == 0) then
                nullify (self%head, self%tail)
            end if
        end if

    end subroutine stack_int_pop

    !> Get an stack_int_iterator for the stack_int
    type(stack_int_iterator) function iterator(self) result(iter)
        class(stack_int), intent(in) :: self

        iter%ptr => self%head

    end function iterator

    !> Clear the stack_int
    pure subroutine stack_int_clear(self)
        class(stack_int), intent(inout) :: self
        type(node), pointer :: curr_node

        do while (self%len > 0)
            curr_node => self%head
            if (associated(curr_node%next)) then
                nullify (curr_node%next%prev)
                self%head => self%head%next
            end if
            call curr_node%clear()
            deallocate (curr_node)
            self%len = self%len - 1
        end do
        nullify (self%head, self%tail)

    end subroutine stack_int_clear

    !> Clear the stack_int_iterator
    pure subroutine stack_int_iterator_clear(self)
        class(stack_int_iterator), intent(inout) :: self

        nullify (self%ptr)

    end subroutine stack_int_iterator_clear

    !> Get the next item from the stack_int_iterator
    subroutine stack_int_iterator_next(self, item)
        class(stack_int_iterator), intent(inout) :: self
        integer, intent(out) :: item

        if (associated(self%ptr)) then
            item = self%ptr%item
            self%ptr => self%ptr%next
        end if

    end subroutine stack_int_iterator_next

end module seakeeping_collection_stack_int

