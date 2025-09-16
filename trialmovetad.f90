subroutine trialmovetad()

implicit none

include 'global.var'

integer ::n,iv,v,b,j,i,s,nv1,nv2,nm2,np1,en,cn2,cm2,nmove,en2,id,cc
real    ::dE,r,dx,dy,pos(3),z(3)
integer,dimension(:,:),allocatable ::nle
real*8  ::randomnumber

!choose randomly a node
n=int(Nchain*randomnumber())+1
en=config(1,n)
!test if allowed moved and move
s = state(n)

if (s.gt.0) then
   allocate (nle(s,2))
   i=0
   do j=1,Nlef
      if(contact(2,j).eq.n)then
         i=i+1
         nle(i,1)=j
         nle(i,2)=-1
      end if
      if(contact(3,j).eq.n)then
         i=i+1
         nle(i,1)=j
         nle(i,2)=+1
      end if
   end do
else
   allocate (nle(1,2))
end if
if (n.eq.1) then

    en2=config(1,2)
    cn2=opp(config(2,1))
    if (cn2.lt.config(2,2)) then
        cm2=config(2,2)
    else
        cm2=cn2
        cn2=config(2,2)
    end if
    iv=int(11*randomnumber())+1
    if (iv.ge.cn2) iv=iv+1
    if (iv.ge.cm2) iv=iv+1

    if (iv.eq.1) then
        v=en2
    else
        v=bittable(iv,en2)
    end if
    b=bittable(1,v)
    if ((b.eq.0).or.((b.eq.1).and.(en2.eq.v))) then
        cn2=config(2,1)

        dE=costhet(opp(iv),config(2,2))-costhet(cn2,config(2,2))

        pos=voisxyz(:,iv)+voisxyz(:,cn2)

        dE = dE - fext*(sqrt((eedz(3)-pos(3))**2+(eedz(2)-pos(2))**2)-sqrt(eedz(2)**2+(eedz(3)**2)))
        if (s.gt.0) then
           do i=1,s
              id=nle(i,1)
              z=dleg(:,id)+nle(i,2)*pos
              if (sum(z*z).gt.0.501) dE=dE+Ksmc*(sum(z*z)-0.5)*0.5
              if (sum(dleg(:,id)*dleg(:,id)).gt.0.501) dE=dE-Ksmc*(sum(dleg(:,id)*dleg(:,id))-0.5)*0.5
           end do
        end if

        if (randomnumber().lt.exp(-dE)) then
            bittable(1,en)=bittable(1,en)-1
            bittable(1,v)=bittable(1,v)+1

            config(1,1)=v
            config(2,1)=opp(iv)
            if (s.gt.0) then
               do i=1,s
                  id=nle(i,1)
                  z=dleg(:,id)+nle(i,2)*pos
                  dleg(:,id)=z
               end do
            end if
            eedz = eedz - pos
        end if
    end if

elseif (n.eq.Nchain) then

    en2=config(1,Nchain-1)
    cn2=config(2,Nchain-1)
    if (cn2.lt.opp(config(2,Nchain-2))) then
        cm2=opp(config(2,Nchain-2))
    else
        cm2=cn2
        cn2=opp(config(2,Nchain-2))
    end if

    iv=int(11*randomnumber())+1
    if (iv.ge.cn2) iv=iv+1
    if (iv.ge.cm2) iv=iv+1

    if (iv.eq.1) then
        v=en2
    else
        v=bittable(iv,en2)
    end if
    b=bittable(1,v)

    if ((b.eq.0).or.((b.eq.1).and.(en2.eq.v))) then
        cn2=config(2,Nchain-1)

        dE=costhet(config(2,Nchain-2),iv)-costhet(config(2,Nchain-2),cn2)

        pos=voisxyz(:,iv)-voisxyz(:,cn2)

        dE = dE - fext*(sqrt((eedz(3)+pos(3))**2+(eedz(2)+pos(2))**2)-sqrt(eedz(2)**2+(eedz(3)**2)))
        if (s.gt.0) then
           do i=1,s
              id=nle(i,1)
              z=dleg(:,id)+nle(i,2)*pos
              if (sum(z*z).gt.0.501) dE=dE+Ksmc*(sum(z*z)-0.5)*0.5
              if (sum(dleg(:,id)*dleg(:,id)).gt.0.501) dE=dE-Ksmc*(sum(dleg(:,id)*dleg(:,id))-0.5)*0.5
           end do
        end if

        if (randomnumber().lt.exp(-dE)) then
            bittable(1,en)=bittable(1,en)-1
            bittable(1,v)=bittable(1,v)+1

            config(1,Nchain)=v
            config(2,Nchain-1)=iv
            if (s.gt.0) then
               do i=1,s
                  id=nle(i,1)
                  z=dleg(:,id)+nle(i,2)*pos
                  dleg(:,id)=z
               end do
            end if
            eedz = eedz +pos
        end if
    end if
else
    cn2=config(2,n)
    cm2=config(2,n-1)
    en2=config(1,n-1)
    nm2=n-2
    np1=n+1

    if (voisnn(1,cm2,cn2).gt.1) then
        iv=int((voisnn(1,cm2,cn2)-1)*randomnumber())+1
        if (voisnn(2*iv,cm2,cn2).ge.cm2) iv=iv+1
        nv1=voisnn(2*iv,cm2,cn2)
        nv2=voisnn(2*iv+1,cm2,cn2)
        if (nv1.eq.1) then
            v=en2
        else
            v=bittable(nv1,en2)
        end if
        b=bittable(1,v)
        if ((b.eq.0).or.((b.eq.1).and.((v.eq.en2).or.(v.eq.config(1,np1))))) then

            if (n.eq.2) then
                dE=costhet(nv1,nv2)+costhet(nv2,config(2,np1))-costhet(cm2,cn2)-costhet(cn2,config(2,np1))
            elseif (n.eq.Nchain-1) then
                dE=costhet(config(2,nm2),nv1)+costhet(nv1,nv2)-costhet(config(2,nm2),cm2)-costhet(cm2,cn2)
            else
                dE=costhet(config(2,nm2),nv1)+costhet(nv1,nv2)+costhet(nv2,config(2,np1)) &
                    -costhet(config(2,nm2),cm2)-costhet(cm2,cn2)-costhet(cn2,config(2,np1))
            end if

            pos=voisxyz(:,nv1)-voisxyz(:,cm2)
               
            if (s.gt.0) then
               do i=1,s
                  id=nle(i,1)
                  z=dleg(:,id)+nle(i,2)*pos
                  if (sum(z*z).gt.0.501) dE=dE+Ksmc*(sum(z*z)-0.5)*0.5
                  if (sum(dleg(:,id)*dleg(:,id)).gt.0.501) dE=dE-Ksmc*(sum(dleg(:,id)*dleg(:,id))-0.5)*0.5
               end do
            end if

            if (randomnumber().lt.exp(-dE)) then
                bittable(1,en)=bittable(1,en)-1
                bittable(1,v)=bittable(1,v)+1

                config(1,n)=v
                config(2,n-1)=nv1
                config(2,n)=nv2
                if (s.gt.0) then
                   do i=1,s
                      id=nle(i,1)
                      z=dleg(:,id)+nle(i,2)*pos
                      dleg(:,id)=z
                   end do
                end if

            end if
        end if
    end if
end if
return

end subroutine

