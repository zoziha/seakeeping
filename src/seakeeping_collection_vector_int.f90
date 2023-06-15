!> Vector 整型向量
module seakeeping_collection_vector_int

    use seakeeping_kinds, only: rk => sk_real_kind
    implicit none

    private
    public :: vector_int

    !> Vector_int 整型向量
    type vector_int
        private
        integer, public :: len = 0  !! 有效向量长度
        integer, allocatable :: items(:)  !! 整型数组
    contains
        procedure :: init
        procedure :: push, pop
        procedure :: get, set
        procedure :: clear
        procedure, private :: extend
    end type vector_int

contains

    !> 初始化向量
    pure subroutine init(self)
        class(vector_int), intent(inout) :: self

        self%len = 0
        if (.not. allocated(self%items)) allocate (self%items(256))

    end subroutine init

    !> 向量扩容
    pure subroutine extend(self)
        class(vector_int), intent(inout) :: self
        integer, allocatable :: tmp(:)

        allocate (tmp(size(self%items)))
        self%items = [self%items, tmp]

    end subroutine extend

    !> 向量压入
    pure subroutine push(self, item)
        class(vector_int), intent(inout) :: self
        integer, intent(in) :: item

        if (self%len == size(self%items)) call self%extend()
        self%len = self%len + 1
        self%items(self%len) = item

    end subroutine push

    !> 向量弹出
    pure subroutine pop(self, item)
        class(vector_int), intent(inout) :: self
        integer, intent(out), optional :: item

        if (self%len == 0) return
        if (present(item)) item = self%items(self%len)
        self%len = self%len - 1

    end subroutine pop

    !> 向量获取
    pure subroutine get(self, index, item)
        class(vector_int), intent(in) :: self
        integer, intent(in) :: index
        integer, intent(out) :: item

        if (index < 1 .or. index > self%len) return
        item = self%items(index)

    end subroutine get

    !> 向量设置
    pure subroutine set(self, index, item)
        class(vector_int), intent(inout) :: self
        integer, intent(in) :: index
        integer, intent(in) :: item

        if (index < 1 .or. index > self%len) return
        self%items(index) = item

    end subroutine set

    !> 向量清空
    pure subroutine clear(self)
        class(vector_int), intent(inout) :: self

        deallocate (self%items)
        self%len = 0

    end subroutine clear

end module seakeeping_collection_vector_int
