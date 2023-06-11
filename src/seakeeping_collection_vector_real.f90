!> Vector 实数向量
module seakeeping_collection_vector_real

    use seakeeping_kinds, only: rk => sk_real_kind
    implicit none

    private
    public :: vector_real

    !> Vector_real 实数向量
    type vector_real
        private
        integer :: n  !! 有效向量长度
        real(rk), allocatable :: items(:)  !! 实数数组
    contains
        procedure :: init
        procedure :: push, pop
        procedure :: get, set
        procedure :: size
        procedure :: clear
        procedure, private :: extend
    end type vector_real

contains

    !> 初始化向量
    subroutine init(self)
        class(vector_real), intent(inout) :: self

        self%n = 0
        if (.not. allocated(self%items)) allocate (self%items(256))

    end subroutine init

    !> 向量扩容
    subroutine extend(self)
        class(vector_real), intent(inout) :: self
        real(rk), allocatable :: tmp(:)
        intrinsic :: size

        allocate (tmp(size(self%items)))
        self%items = [self%items, tmp]

    end subroutine extend

    !> 向量压入
    subroutine push(self, item)
        class(vector_real), intent(inout) :: self
        real(rk), intent(in) :: item
        intrinsic :: size

        if (self%n == size(self%items)) call self%extend()
        self%n = self%n + 1
        self%items(self%n) = item

    end subroutine push

    !> 向量弹出
    subroutine pop(self, item)
        class(vector_real), intent(inout) :: self
        real(rk), intent(out), optional :: item

        if (self%n == 0) return
        if (present(item)) item = self%items(self%n)
        self%n = self%n - 1

    end subroutine pop

    !> 向量获取
    subroutine get(self, index, item)
        class(vector_real), intent(in) :: self
        integer, intent(in) :: index
        real(rk), intent(out) :: item

        if (index < 1 .or. index > self%n) return
        item = self%items(index)

    end subroutine get

    !> 向量设置
    subroutine set(self, index, item)
        class(vector_real), intent(inout) :: self
        integer, intent(in) :: index
        real(rk), intent(in) :: item

        if (index < 1 .or. index > self%n) return
        self%items(index) = item

    end subroutine set

    !> 向量长度
    pure function size(self) result(n)
        class(vector_real), intent(in) :: self
        integer :: n

        n = self%n

    end function size

    !> 向量清空
    subroutine clear(self)
        class(vector_real), intent(inout) :: self
        integer :: i

        deallocate (self%items)
        self%n = 0

    end subroutine clear

end module seakeeping_collection_vector_real