subroutine initconfig4()

implicit none

include 'global.var'

integer ::turn1(7),turn2(7),turn(7),lim,a,n,i,j,t,nv1,nv2,iv,en2,v,b,c(2,Nchain),k
real*8  ::randomnumber

bittable(1,:)=0

turn1=(/13,13,2,2,12,12,3/)
turn2=(/13,2,2,12,12,3,3/)

lim=L/2!2*L-1

config=0
a=int(4*L**3*randomnumber())+1
config(1,1)=a
bittable(1,a)=1
n=2
do i=1,lim
    if (mod(i,2).eq.1) then
        turn=turn1
    else
        turn=turn2
    end if
    do j=1,7
        config(2,n-1)=turn(j)
        config(1,n)=bittable(turn(j),config(1,n-1))
        bittable(1,config(1,n))=1
        n=n+1
    end do
    config(2,n-1)=11
    config(1,n)=bittable(11,config(1,n-1))
    bittable(1,config(1,n))=1
    n=n+1
end do
n=n-1

do while (n.ne.Nchain)
    t=int((n-1)*randomnumber())+1
    iv=int((voisnn(1,1,config(2,t))-1)*randomnumber())+1
    nv1=voisnn(2*iv,1,config(2,t))
    nv2=voisnn(2*iv+1,1,config(2,t))
    en2=config(1,t)
    if (nv1.eq.1) then
        v=en2
    else
        v=bittable(nv1,en2)
    end if
    b=bittable(1,v)
    if ((b.eq.0)) then
        c=config
        config(1,t+1)=v
        config(2,t)=nv1
        config(2,t+1)=nv2
        bittable(1,v)=1
        config(:,t+2:n+1)=c(:,t+1:n)
        n=n+1
    end if
end do

return

end subroutine

