#!/bin/bash

cd $HOME #change working directory to $HOME
rm students/* #delete all elements int students/ if already present elements
rm -d students/ #delete the directory students, -d is needed
mkdir -p students #makes dir if not existent
if [ ! -f "./students/LCP_22-23_students.csv" ] #if not already present, as in if NOT -find PATH
then
    wget -v --tries=1 https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv --directory-prefix="./students" #import file in ./students
fi # if is composed of if, then, fi
cd students # pass to students directory
touch LCP_22-23_PoD_students.csv #create if not existing
touch LCP_22-23_Physics_students.csv #create if not existing
grep "PoD" LCP_22-23_students.csv > LCP_22-23_PoD_students.csv #copy only lines including PoD from file A to file B
grep "Physics" LCP_22-23_students.csv > LCP_22-23_Physics_students.csv #copy only lines including Physics from file A to file B
max=0 #setting a local variable (lowercase) to search maximum
max_L='A' #setting a local variable (lowercase) to search maximum corresponding letter
for i in {A..Z} #i assumes values in the alphabet capital letters
do
    # to j is assgined the return of the previous computed part inside `, the left part is executed then passed as input to the right part
    j=`grep -v -e  "^Family" LCP_22-23_students.csv | grep -c "^$i" LCP_22-23_students.csv` # first gives lines without Family Name (-v exludes -e is followed by the relative element), second counts starting with A
    echo "$i : $j" #print out both variable; the $ is required in order to obtain the stored value, but works only inside double apix ""
    if [ $j -gt $max ] #compare values, not string (> is for strings in bash, -gt is grater than for numbers)
    then
        max=$j #updating maximum
        max_L=$i #updating best letter
    fi
done #sintax for for is for do done
echo "Max surname starting letter $max_L with $max entries" # print found output
lines=`grep '' -c LCP_22-23_students.csv` #counts all lines in file
i=2 #starting from the third line
while [ $i -le $lines ] #for each line, it will print it inside a different file, according to the modulo 18
do
    let g=($i-1)%18 #real computation for variables needs let or (( ))
    file="Group$g.csv" #naming scheme that uses value of i, there are ""
    touch $file #create file
    awk NR==$i LCP_22-23_students.csv >> $file #selected line with awk
    let i+=1
done
#spacing is always wrong in bash, unless is necessary