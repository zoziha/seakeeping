!> stack 实数队列
module seakeeping_collection_stack_real

    use seakeeping_kinds, only: rk => sk_real_kind
    implicit none

    private
    public :: stack_real, stack_real_iterator

    !> 节点
    type node
        private
        type(node), pointer :: prev => null()
        type(node), pointer :: next => null()
        real(rk) :: item !! content of the node
    contains
        procedure :: clear => node_clear
    end type node

    !> 堆栈
    type stack_real
        private
        integer :: num_nodes = 0 !! number of nodes in the stack_real
        type(node), pointer :: head => null() !! head of the stack_real
        type(node), pointer :: tail => null() !! tail of the stack_real
    contains
        procedure :: push => stack_real_push
        procedure :: pop => stack_real_pop
        procedure :: iterator
        procedure :: size => stack_real_size
        procedure :: clear => stack_real_clear
    end type stack_real

    !> 迭代器
    type stack_real_iterator
        private
        type(node), pointer :: ptr => null()
    contains
        procedure :: next => stack_real_iterator_next
        procedure :: clear => stack_real_iterator_clear
    end type stack_real_iterator

contains

    !> Initialize the node from a new item
    pure function init_node(new_item) result(new_node)
        real(rk), intent(in) :: new_item
        type(node) :: new_node

        new_node%item = new_item

    end function init_node

    !> Clear the node
    pure subroutine node_clear(self)
        class(node), intent(inout) :: self

        nullify (self%prev)
        nullify (self%next)

    end subroutine node_clear

    !> push an item to the stack_real
    pure subroutine stack_real_push(self, item)
        class(stack_real), intent(inout) :: self
        real(rk), intent(in) :: item

        if (associated(self%tail)) then
            allocate (self%tail%next, source=init_node(item))
            self%tail%next%prev => self%tail
            self%tail => self%tail%next
        else
            allocate (self%head, source=init_node(item))
            self%tail => self%head
        end if
        self%num_nodes = self%num_nodes + 1

    end subroutine stack_real_push

    !> pop an item from the stack_real
    subroutine stack_real_pop(self, item)
        class(stack_real), intent(inout) :: self
        real(rk), intent(out), optional :: item
        type(node), pointer :: curr_node

        if (associated(self%tail)) then
            if (present(item)) then
                item = self%tail%item
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

    end subroutine stack_real_pop

    !> Get an stack_real_iterator for the stack_real
    type(stack_real_iterator) function iterator(self) result(iter)
        class(stack_real), intent(in) :: self

        iter%ptr => self%head

    end function iterator

    !> Get the size of the stack_real
    pure integer function stack_real_size(self) result(size)
        class(stack_real), intent(in) :: self

        size = self%num_nodes

    end function stack_real_size

    !> Clear the stack_real
    pure subroutine stack_real_clear(self)
        class(stack_real), intent(inout) :: self
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

    end subroutine stack_real_clear

    !> Clear the stack_real_iterator
    pure subroutine stack_real_iterator_clear(self)
        class(stack_real_iterator), intent(inout) :: self

        nullify (self%ptr)

    end subroutine stack_real_iterator_clear

    !> Get the next item from the stack_real_iterator
    subroutine stack_real_iterator_next(self, item)
        class(stack_real_iterator), intent(inout) :: self
        real(rk), intent(out) :: item

        if (associated(self%ptr)) then
            item = self%ptr%item
            self%ptr => self%ptr%next
        end if

    end subroutine stack_real_iterator_next

end module seakeeping_collection_stack_real

