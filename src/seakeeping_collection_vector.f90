!> Vector 泛型向量 (通用但效率稍低)
module seakeeping_collection_vector

    implicit none

    private
    public :: vector

    !> 节点
    type node
        private
        class(*), allocatable :: item  !! 泛型数据
    end type node

    !> Vector 泛型向量
    type vector
        private
        integer :: n  !! 有效向量长度
        type(node), allocatable :: items(:)  !! 泛型数组
    contains
        procedure :: init
        procedure :: push, pop
        procedure :: get, set
        procedure :: size
        procedure :: clear
        procedure, private :: extend
    end type vector

contains

    !> 初始化向量
    subroutine init(self)
        class(vector), intent(inout) :: self

        self%n = 0
        if (.not. allocated(self%items)) allocate (self%items(256))

    end subroutine init

    !> 向量扩容
    subroutine extend(self)
        class(vector), intent(inout) :: self
        type(node), allocatable :: tmp(:)
        intrinsic :: size

        allocate (tmp(size(self%items)))
        self%items = [self%items, tmp]

    end subroutine extend

    !> 向量压入
    subroutine push(self, item)
        class(vector), intent(inout) :: self
        class(*), intent(in) :: item
        intrinsic :: size

        if (self%n == size(self%items)) call self%extend()
        self%n = self%n + 1
        allocate (self%items(self%n)%item, source=item)

    end subroutine push

    !> 向量弹出
    subroutine pop(self, item)
        class(vector), intent(inout) :: self
        class(*), intent(out), optional, allocatable :: item

        if (self%n == 0) return
        if (present(item)) then
            call move_alloc(self%items(self%n)%item, item)
        else
            deallocate (self%items(self%n)%item)
        end if
        self%n = self%n - 1

    end subroutine pop

    !> 向量获取
    subroutine get(self, index, item)
        class(vector), intent(in) :: self
        integer, intent(in) :: index
        class(*), intent(out), allocatable :: item

        if (index < 1 .or. index > self%n) return
        allocate (item, source=self%items(index)%item)

    end subroutine get

    !> 向量设置
    subroutine set(self, index, item)
        class(vector), intent(inout) :: self
        integer, intent(in) :: index
        class(*), intent(in) :: item

        if (index < 1 .or. index > self%n) return
        allocate (self%items(index)%item, source=item)

    end subroutine set

    !> 向量长度
    pure function size(self) result(n)
        class(vector), intent(in) :: self
        integer :: n

        n = self%n

    end function size

    !> 向量清空
    subroutine clear(self)
        class(vector), intent(inout) :: self
        integer :: i

        deallocate (self%items)
        self%n = 0

    end subroutine clear

end module seakeeping_collection_vector
