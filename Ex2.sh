#!/bin/bash

grep -v '^#' data.csv | sed -e 's/,//g' > data.txt #take the lines in data.csv that don't start with #, substitute (sed) element (-e) from , to nothing
even=0 #starting to count even
for i in `cat data.txt` #for element in the dump of the file, so the single number can be selected
do
    #IN BASH TRUE IS 0 AND 1 IS FALSE, [ ] make it interpret as bool, but (( )) is for numbers,  then converted to bools that way
    if (( $i%2 )) #%2 gives 0 if even, that correspond to true in bash
    then
        let even+=1 #update counter, let is mandatory
    fi
done
echo "even numbers = $even"
#setting new local variable to count
m=0
l=0
 #getting a set value for sigma, $ pass the value instead of the command, |bc make it compute in floating point operation, '' are ok because there are no variables
sigma=$( echo 'scale=6;100*sqrt(3)/2.0' | bc)
FILE="data.txt" #global variable FILE
lines=`grep '' -c $FILE` #counts all lines in file
i=1 #starts from second line
while [ $i -le $lines ] #cycle over number of lines
do
    line=`awk NR==$i $FILE` #line is the string of the single i line in FILE
    IFS=' ' read -r X Y Z x y z <<< "$line" #set variables X, Y, Z, x, y, z from the line using separator ' ', read requires <<<
    d=$( echo "scale=6;sqrt($X*$X+$Y*$Y+$Z*$Z)" | bc) # assign to d the distance computed
    #echo $d
    if [ `echo "$d < $sigma" | bc` -eq 0 ] #this is a bool op. because of -eq, check if d<=sigma, using bc to do calculation
    then
        let m++ #update more than
    else
        let l++ #update less than
    fi
    let i++ #update i
done
echo "there are $m of distance grater than $sigma"
echo "there are $l of distance smaller than $sigma"
if [ -z $1 ] #1 is the first input when calling the script, -z check if it is a NULL, apparently -z is bool op
then
    echo "This program requires an input for normalization"
    exit
fi
if [ $1 -lt 1 ] #check the normalization if <= 1
then
    echo "This program requires an input grater than 1 for normalization"
    exit
fi
for (( i=1; i<=$1; i++ )) #computing operation (())
do
    # DIFFERENCE -v for awk is value, for grep is "without"
    #-v passes i as a variable to awk; cycle over NF Number of Fields; $j content of j field, 
    #check if field equal to number and end ($); then print as float j/i
    awk -v i="$i" '{for(j=1;j<=NF;j++) if($j~/^[0-9]+$/) $j=sprintf("%.1f",$j/i)}1' data.txt > "data$i.csv"
    done
#[0-9]* for zero or more numbers; [0-9][0-9]* one or more; etc. those are patterns with 2 and 3 element resp. \1 \2 \3
# % echo "123 abc" | sed 's/[0-9]*/& &/'
# 123 123 abc
# sed y is like tr