#!/bin/bash

#list of args
args=("$@")

# if got less than 3 arguments :
if [  "$#"  -lt  3 ]
then
	echo "Number of parameters received : $#">&2
	echo "Usage : wordFinder.sh <valid file name> [More Files]... <char> <length>"
	exit 128 
fi

# the before end , end numbers
let N2=$#-2
let N3=$#-1
V2=${args[$N2],,}
V3=${args[$N3]}

# errors :
n='^[0-9]+$'
n2='^[a-z0-9]+$'
err=0


if [ ${#V2} -ne  1 ] || ! [[ $V2 =~ $n2 ]]
then
	echo "Only one char needed : $V2">&2
	err=1
fi


if ! [[ $V3 =~ $n ]] || [  $V3 -le  0 ]
then
	echo "Not a positive number : $V3">&2
	err=1
fi

if [ $err -eq 1 ]
then
	echo "Usage : wordFinder.sh <valid file name> [More Files]... <char> <length>"
	exit 128 
fi

for (( c=0; c<= "$#" - 3; c++ ))
do  
	FILE=${args[$c]}
	if [ ! -f "$FILE" ]; then
		echo "File does not exist : $FILE" >&2
		err=1
	fi
done

if [ $err -eq 1 ]
then
	echo "Usage : wordFinder.sh <valid file name> [More Files]... <char> <length>"
	exit 128 
fi

rm -f temp

touch temp

temp=$(pwd)/temp
chmod +w $temp
for (( c=0; c<= "$#" - 3; c++ ))
do  
	FILE=${args[$c]}
	cat $FILE >> $temp
	
done

temp2=null
tr -cs "[a-z] [A-Z] [0-9]" " " < $temp > $temp2
tr [:upper:] [:lower:] < $temp2 > $temp

let V3=${args[$N3]}-1

wo=\\b$V2\\w\\{$V3,1000\\}
grep -o -w $wo $temp | sort | uniq -c | sort -n | sed 's/^\s*//'


rm -f temp
rm -f null





