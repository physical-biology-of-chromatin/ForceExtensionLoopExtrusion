subroutine trialbound()

implicit none

include 'global.var'

integer ::n,nle,d,j
real*8  ::randomnumber


!choose randomly a node
n=int(Nchain*randomnumber())+1
nle=int(Nlef*randomnumber())+1

if ((contact(1,nle).ne.0).or.(state(n).ne.0).or.(boundary(n).ne.0)) return

do j=1,ikb
   if (randomnumber().ge.kb) return
end do

if (randomnumber().lt.0.5) then
   if (state(n-1).ne.0) return
   contact(1,nle)=1
   contact(2,nle)=n-1
   contact(3,nle)=n
   contact(4,nle)=MCS
   contact(5,nle)=int(2*randomnumber())
   state(n) = state(n)+1
   state(n-1) = state(n-1)+1
   dleg(:,nle)=voisxyz(:,config(2,n-1))
else
   if (state(n+1).ne.0) return
   contact(1,nle)=1
   contact(2,nle)=n
   contact(3,nle)=n+1
   contact(4,nle)=MCS
   contact(5,nle)=int(2*randomnumber())
   state(n) = state(n)+1
   state(n+1) = state(n+1)+1
   dleg(:,nle)=voisxyz(:,config(2,n))
end if

return

end subroutine
