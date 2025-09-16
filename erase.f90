subroutine erase()

implicit none

include 'global.var'

integer	::i,a,j,v,ic

do i=1,Nchain
    a=config(1,i)
    bittable(1,a)=0
end do
config=0



return

end subroutine
