#!/bin/bash

cd $HOME
rm students/*
rm -d students/
mkdir -p students #makes dir if not existent
if [ ! -f "./students/LCP_22-23_students.csv" ] #if not already present 
then
    wget -v --tries=1 https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv --directory-prefix="./students" #import file in ./students
fi
cd students
touch LCP_22-23_PoD_students.csv #create if not existing
touch LCP_22-23_Physics_students.csv
grep "PoD" LCP_22-23_students.csv > LCP_22-23_PoD_students.csv #copy only lines including PoD
grep "Physics" LCP_22-23_students.csv > LCP_22-23_Physics_students.csv
max=0
max_L='A'
for i in {A..Z}
do
    j=`grep -v -e  "^Family" LCP_22-23_students.csv | grep -c "^$i" LCP_22-23_students.csv` # first gives lines without Family Name, second counts starting with A
    echo "$i : $j"
    if [ $j -gt $max ] #compare values, not string
    then
        max=$j
        max_L=$i
    fi
done
echo "Max surname starting letter $max_L with $max entries"
lines=`grep '' -c LCP_22-23_students.csv`
i=2
while [ $i -le $lines ]
do
    let g=($i-1)%18 #real computation for variables needs let or (( ))
    file="Group$g.csv"
    touch $file
    awk NR==$i LCP_22-23_students.csv >> $file #selected line with awk
    let i+=1
done
#spacing is always wrong in bash, unless is necessary