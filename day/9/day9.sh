#!/bin/bash

# --- Day 9: All in a Single Night ---
#
# Every year, Santa manages to deliver all of his presents in a single night.
#
# This year, however, he has some new locations to visit; his elves have
# provided him the distances between every pair of locations. He can start and
# end at any two (different) locations he wants, but he must visit each
# location exactly once. What is the shortest distance he can travel to achieve
# this?
#
# For example, given the following distances:
#
# - London to Dublin = 464
# - London to Belfast = 518
# - Dublin to Belfast = 141
#
# The possible routes are therefore:
#
# - Dublin -> London -> Belfast = 982
# - London -> Dublin -> Belfast = 605
# - London -> Belfast -> Dublin = 659
# - Dublin -> Belfast -> London = 659
# - Belfast -> Dublin -> London = 605
# - Belfast -> London -> Dublin = 982
#
# The shortest of these is London -> Dublin -> Belfast = 605, and so the answer
# is 605 in this example.
#
# What is the distance of the shortest route?
#
# --- Part Two ---
#
# The next year, just to show off, Santa decides to take the route with the
# longest distance instead.
#
# He can still start and end at any two (different) locations he wants, and he
# still must visit each location exactly once.
#
# For example, given the distances above, the longest route would be 982 via
# (for example) Dublin -> London -> Belfast.
#
# What is the distance of the longest route?

INPUT=input
declare -a cityList
declare -A cityListDist
declare -i shortestDist=99999999
declare -i longestDist=0

cityToIndex() {
	found=false
	index=-1
	for i in "${!cityList[@]}"; do 
		if [ $1 == ${cityList[$i]} ]
		then
			cityIndex=$i
			return
		fi
	done
	cityIndex=${#cityList[@]}
	cityList+=($1)
}

getDistance() {
	local list=$1
	local dist=0
	IFS=' ' read -r -a array <<< "$list"
	for i in $(seq 2 ${#array[@]})
	do
		a=$([ "${array[$(($i-2))]}" -lt "${array[$(($i-1))]}" ] && echo "${array[$(($i-2))]}" || echo "${array[$(($i-1))]}")
		b=$([ "${array[$(($i-2))]}" -lt "${array[$(($i-1))]}" ] && echo "${array[$(($i-1))]}" || echo "${array[$(($i-2))]}")
		((dist+=${cityListDist[$a,$b]}))
	done
	if [ $shortestDist -gt $dist ]; then
		echo new short dist $dist
		shortestDist=$dist
	fi
	if [ $longestDist -lt $dist ]; then
		echo new longest dist $dist
		longestDist=$dist
	fi
}

bruteList()
{
        if [ $1 -lt 1 ]
        then
                getDistance "$2"
        else
		eval value_${1}=0
		for j in $(seq 1 $1)
		do
			while true; do
				eval value=value_${1}
				if [[ -z "$2" ]]
				then
					bruteList $(($1-1)) "${!value}"
					eval value=value_${1}
					eval value_${1}=$((${!value}+1))
					break;
				elif [[ ! "$2" =~ ([[:space:]]|^)${!value}([[:space:]]|$) ]]
				then
					bruteList $(($1-1)) "$2 ${!value}"
					eval value=value_${1}
					eval value_${1}=$((${!value}+1))
					break
				fi
				eval value_${1}=$((${!value}+1))
			done
		done
        fi
}

while read line
do
	read src to dest equal dist <<< $(echo $line)
	cityToIndex $src
	srcIndex=$cityIndex
	cityToIndex $dest
	dstIndex=$cityIndex
	cityListDist[$srcIndex,$dstIndex]=$dist
done < "${INPUT}"

bruteList ${#cityList[@]}

