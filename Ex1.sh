#!/bin/bash

cd $HOME
mkdir -p students
if [ ! -f "./students/LCP_22-23_students.csv" ] 
then
    wget -v --tries=1 https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv --directory-prefix="./students"
fi
cd students
touch LCP_22-23_PoD_students.csv
touch LCP_22-23_Physics_students.csv
grep "PoD" LCP_22-23_students.csv > LCP_22-23_PoD_students.csv
grep "Physics" LCP_22-23_students.csv > LCP_22-23_Physics_students.csv
max=0
max_L='A'
for i in {A..Z}
    do
    #echo $i
    j=`grep -c -e "^$i" -v -e "^Family" LCP_22-23_Physics_students.csv ` # | awk 'NR>1{print $1}'
    echo "$i : $j"
    if [ j>max ]
    then
        max=$j
        max_L=$i
    fi
    done
echo "Max surname starting letter $max_L with $max entries"
lines=`grep -c LCP_22-23_Physics_students.csvcat `
i = 2
for [ i<=lines ]
    do
    g=(i-1)%18
    touch "Group$g.csv" 
    awk 'NR==i{print}' LCP_22-23_students.csv > "Group$g.csv"
    i++
    done