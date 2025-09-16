nchain=500
l=20
niter=1
nequ=1000000
nmeas=1000
ninter=1000
kint=3.217
dir=2
p=500.0
ro=0.5
km=1.0e-3
Ea=5.0
fe=1.5
fu=10.0
Nlef=10
perm=0.0
fext=3.0

t=$((4*${l}*${l}*${l}))
nd=13

sed -i.back -e '1c\'$'\n '$nchain' ::Nchain' input.dat
sed -i.back -e '2c\'$'\n '$l' ::L' input.dat
sed -i.back -e '3c\'$'\n '$niter' ::Niter' input.dat
sed -i.back -e '4c\'$'\n '$nequ' ::Nequ' input.dat
sed -i.back -e '5c\'$'\n '$nmeas' ::Nmeas' input.dat
sed -i.back -e '6c\'$'\n '$ninter' ::Ninter' input.dat
sed -i.back -e '7c\'$'\n '$kint' ::kint' input.dat
sed -i.back -e '8c\'$'\n '$dir' ::dir' input.dat
sed -i.back -e '9c\'$'\n '$p' ::p' input.dat
sed -i.back -e '10c\'$'\n '$ro' ::ro' input.dat
sed -i.back -e '11c\'$'\n '$km' ::km0' input.dat
sed -i.back -e '12c\'$'\n '$Ea' ::Ea' input.dat
sed -i.back -e '13c\'$'\n '$fe' ::Fe' input.dat
sed -i.back -e '14c\'$'\n '$fu' ::Fu' input.dat
sed -i.back -e '15c\'$'\n '$Nlef' ::Nlef' input.dat
sed -i.back -e '16c\'$'\n '$perm' ::Perm' input.dat
sed -i.back -e '17c\'$'\n '$fext' ::Fext' input.dat

sed -i.back -e '3c\'$'\n integer,dimension(2,'$nchain') ::config' global.var
sed -i.back -e '4c\'$'\n integer,dimension('$nd','$t') ::bittable' global.var
sed -i.back -e '8c\'$'\n integer,dimension(5,'$Nlef') ::contact' global.var
sed -i.back -e '9c\'$'\n real,dimension(3,'$Nlef') ::dleg' global.var
sed -i.back -e '10c\'$'\n integer,dimension('$nchain') ::boundary,state' global.var

make clean
make

echo 'Lancement du programme'
time ./lat
