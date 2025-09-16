program mainprogram

implicit none

include 'global.var'

integer ::ni,i,j,k,a,v,ip,jp,kp,time,ii,L2,Ntrial,ll
real    ::x,y,z,xp,yp,zp,r,pt
real*8  ::randomnumber

!initialize random generator
call SYSTEM_CLOCK(time)
call srand(time)
call initializerandomnumbergenerator(dble(rand()))

!load input
open(10,file='input.dat')
read(10,*) Nchain !chain size
read(10,*) L !box size L should be even (pair)
read(10,*) Niter !number of iterations
read(10,*) Nequ !number of MCS for equilibrium
read(10,*) Nmeas !number of measures
read(10,*) Ninter!interval between measures
read(10,*) kint !bending energy
read(10,*) dir  !Extrusion directionility
read(10,*) p !zero force processivity
read(10,*) ro !zero force LEF binding
read(10,*) km0 !zero force extrusion rate *1000
read(10,*) Ksmc !Spring constant between SMC legs *0.0062
read(10,*) Fe !Extrusion rate charectrisitic force *0.13
read(10,*) Fu !Unbinding rate charectrisitic force *0.13
read(10,*) Nlef !maximal number of LEF
read(10,*) Perm !Permebility of extruders
read(10,*) Fext !external force *0.13
close(10)

boundary=0
boundary(1)=2
boundary(Nchain)=2

ku0 = km0/p
kb = ku0*ro/(1-ro)

ikb=1
if (kb.gt.0.) then
    do while (kb**(1./real(ikb)).lt.0.001)
        ikb=ikb+1
    end do
end if
kb=kb**(1./real(ikb))

opp(1)=1
do i=1,6
    opp(2*i)=2*i+1
    opp(2*i+1)=2*i
end do
open(15,file='voisxyz.out')
open(16,file='costhet.out')
open(17,file='voisnn.out')
open(18,file='connec.out')
do i=1,13
    read(16,*) costhet(i,:)
    do j=1,13
        read(17,*) voisnn(:,i,j)
        read(18,*) connec(:,i,j)
    end do
    read(15,*) voisxyz(:,i)
end do
close(15)
close(16)
close(17)
close(18)
costhet=costhet*kint
x=0.
do i=2,13
    do j=2,13
        x=x+exp(-costhet(i,j))
    end do
end do
x=-log(x/real(12*12))
do i=1,13
    costhet(1,i)=x;
    costhet(i,1)=x;
end do

!initialize bittable
L2=L*L
do a=1,4*L2*L
    k=int((a-1)/(2*L2))+1
    j=int((a-1)/L-2*L*(k-1))+1
    i=a-L*(2*L*(k-1)+(j-1))
    x=(i-1)+0.5*(1-mod(j+mod(k+1,2),2))
    y=(j-1)*0.5
    z=(k-1)*0.5
    bittable(1,a)=0
    do v=1,12
        xp=x+voisxyz(1,v+1)
        yp=y+voisxyz(2,v+1)
        zp=z+voisxyz(3,v+1)
        if (xp.ge.L) xp=xp-L
        if (xp.lt.0) xp=xp+L
        if (yp.ge.L) yp=yp-L
        if (yp.lt.0) yp=yp+L
        if (zp.ge.L) zp=zp-L
        if (zp.lt.0) zp=zp+L
        ip=int(xp)+1
        jp=int(2*yp+1)
        kp=int(2*zp+1)
        bittable(v+1,a)=ip+(jp-1)*L+(kp-1)*2*L2
    end do
end do
write(*,*) 'lattice density:',real(Nchain)/real(4*L2*L)


open(15,file='eedz.out')

do i=1,Niter
    !generate initial configuration
   call initconfig4()
    eedz = 0.
    do j=1,Nchain-1
       v = config(2,j)
       eedz = eedz+voisxyz(:,v)
    end do
    !make measures
    contact=0
    state=0
    dleg=0.
    MCS = 0

    do j=1,Nequ
       do v=1,Nchain
          call trialmovetad()
       end do
    end do

    do j=1,Nequ
       MCS = MCS + 1
       Ntrial=Nchain+3*Nlef
       pt=real(Nlef)/real(Ntrial)
       do v=1,Ntrial
          r=randomnumber()
          if (r.lt.pt) then
             call trialbound()
          elseif (r.lt.2*pt) then
             call trialmoveex()
          elseif (r.lt.3*pt) then
             call trialunbound()
          else
             call trialmovetad()
          end if
       end do
    end do

    do j=1,Nmeas
       do k=1,Ninter
          MCS = MCS + 1
          Ntrial=Nchain+3*Nlef
          pt=real(Nlef)/real(Ntrial)
          do v=1,Ntrial
             r=randomnumber()
             if (r.lt.pt) then
                call trialbound()
             elseif (r.lt.2*pt) then
                call trialmoveex()
             elseif (r.lt.3*pt) then
                call trialunbound()
             else
                call trialmovetad()
             end if
          end do
       end do
       call output_eedz()
    end do
    call erase()
end do
close(15)

end program
