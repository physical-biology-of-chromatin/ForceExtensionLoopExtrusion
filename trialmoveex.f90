subroutine trialmoveex()

implicit none

include 'global.var'

integer ::n,nle,iv,j,s,id
real :: r
real*8  ::randomnumber

!choose randomly a node
nle=int(Nlef*randomnumber())+1
if(contact(1,nle).eq.0) return

if (sum(dleg(:,nle)*dleg(:,nle)).gt.0.501) then
   km = km0*exp(-Ksmc*(sqrt(sum(dleg(:,nle)*dleg(:,nle)))-sqrt(0.5))/Fe)
else
   km = km0
end if

ikm=1
if (km.gt.0.) then
    do while (km**(1./real(ikm)).lt.0.001)
        ikm=ikm+1
    end do
 end if
km=km**(1./real(ikm))
do j=1,ikm
   if (randomnumber().ge.km) return
end do

id=contact(2,nle)
n=contact(3,nle)
if (dir.eq.1) then
   if (contact(5,nle).eq.0) then
      if (boundary(id).gt.0) return
      if (state(id-1).eq.0) then
         contact(2,nle) = id-1
         state(id) = state(id)-1
         state(id-1) = state(id-1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,id-1))
      else
         if(randomnumber().ge.Perm) return
         contact(2,nle) = id-1
         state(id) = state(id)-1
         state(id-1) = state(id-1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,id-1))
      end if
   else
      if (boundary(n).gt.0) return
      if (state(n+1).eq.0) then
         contact(3,nle) = n+1
         state(n) = state(n)-1
         state(n+1) = state(n+1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,n))
      else
         if(randomnumber().ge.Perm) return
         contact(3,nle) = n+1
         state(n) = state(n)-1
         state(n+1) = state(n+1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,n))
      end if
   end if
elseif (dir.eq.2) then
   if (randomnumber().lt.0.5) then
      if (boundary(id).gt.0) return
      if (state(id-1).eq.0) then
         contact(2,nle) = id-1
         state(id) = state(id)-1
         state(id-1) = state(id-1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,id-1))
      else
         if(randomnumber().ge.Perm) return
         contact(2,nle) = id-1
         state(id) = state(id)-1
         state(id-1) = state(id-1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,id-1))
      end if
   else
      if (boundary(n).gt.0) return
      if (state(n+1).eq.0) then
         contact(3,nle) = n+1
         state(n) = state(n)-1
         state(n+1) = state(n+1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,n))
      else
         if(randomnumber().ge.Perm) return
         contact(3,nle) = n+1
         state(n) = state(n)-1
         state(n+1) = state(n+1)+1
         dleg(:,nle) = dleg(:,nle)+voisxyz(:,config(2,n))
      end if
   end if
end if


return

end subroutine

