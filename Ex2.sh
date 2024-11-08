#!/bin/bash

grep -v '^#' data.csv | sed -e 's/,//g' > data.txt
even=0
for i in `cat data.txt`
do
    if [ $i%2 ] #%2 gives 0 if even, that correspond to true in bash
    then
        let even+=1
    fi
done
echo "even numbers = $even"
m=0
l=0
sigma=$( echo 'scale=6;100*sqrt(3)/2.0' | bc)
FILE="data.txt"
lines=`grep '' -c $FILE`
i=1
while [ $i -le $lines ]
do
    line=`awk NR==$i $FILE`
    IFS=' ' read -r X Y Z x y z <<< "$line"
    d=$( echo "scale=6;sqrt($X*$X+$Y*$Y+$Z*$Z)" | bc)
    #echo $d
    if [ `echo "$d < $sigma" | bc` -eq 0 ]
    then
        let m++
    else
        let l++
    fi
    let i++
done
echo "there are $m of distance grater than $sigma"
echo "there are $l of distance smaller than $sigma"
if [ -z $1 ]
then
    echo "This program requires an input for normalization"
    exit
fi
if [ $1 -lt 1 ]
then
    echo "This program requires an input grater than 1 for normalization"
    exit
fi
for (( i=1; i<=$1; i++ ))
do
    #-v passes i as a variable to awk; cycle over NF Number of Fields; $j content of j field, 
    #check if field equal to number and end ($); then print as float j/i
    awk -v i="$i" '{for(j=1;j<=NF;j++) if($j~/^[0-9]+$/) $j=sprintf("%.1f",$j/i)}1' data.txt > "data$i.csv"
    done
#[0-9]* for zero or more numbers; [0-9][0-9]* one or more; etc. those are patterns with 2 and 3 element resp. \1 \2 \3
# % echo "123 abc" | sed 's/[0-9]*/& &/'
# 123 123 abc
# sed y is like tr