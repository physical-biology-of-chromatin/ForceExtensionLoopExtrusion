subroutine trialunbound()

implicit none

include 'global.var'

integer ::n,nle,id,j
real*8  ::randomnumber


!choose randomly a node
nle=int(Nlef*randomnumber())+1

if (contact(1,nle).eq.0) return

if (sum(dleg(:,nle)*dleg(:,nle)).gt.0.501) then
   ku = ku0*exp(Ksmc*(sqrt(sum(dleg(:,nle)*dleg(:,nle)))-sqrt(0.5))/Fu)
else
   ku = ku0
end if

iku=1
if (ku.gt.0.) then
    do while (ku**(1./real(iku)).lt.0.001)
        iku=iku+1
    end do
 end if
ku=ku**(1./real(iku))
do j=1,iku
   if (randomnumber().ge.ku) return
end do


n=contact(3,nle)
id=contact(2,nle)
contact(:,nle)=0
dleg(:,nle)=0.
state(id) = state(id)-1
state(n) = state(n)-1

return

end subroutine


