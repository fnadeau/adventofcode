#!/bin/bash

# --- Day 11: Corporate Policy ---
#
# Santa's previous password expired, and he needs help choosing a new one.
#
# To help him remember his new password after the old one expires, Santa has
# devised a method of coming up with a password based on the previous one.
# Corporate policy dictates that passwords must be exactly eight lowercase
# letters (for security reasons), so he finds his new password by incrementing
# his old password string repeatedly until it is valid.
#
# Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so
# on. Increase the rightmost letter one step; if it was z, it wraps around to a,
# and repeat with the next letter to the left until one doesn't wrap around.
#
# Unfortunately for Santa, a new Security-Elf recently started, and he has
# imposed some additional password requirements:
#
# - Passwords must include one increasing straight of at least three letters,
#   like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd 
#   doesn't count.
# - Passwords may not contain the letters i, o, or l, as these letters can be
#   mistaken for other characters and are therefore confusing.
# - Passwords must contain at least two different, non-overlapping pairs of
#   letters, like aa, bb, or zz.
#
# For example:
#
# - hijklmmn meets the first requirement (because it contains the straight hij) 
#   but fails the second requirement requirement (because it contains i and l).
# - abbceffg meets the third requirement (because it repeats bb and ff) but
#   fails the first requirement.
# - abbcegjk fails the third requirement, because it only has one double
#   letter (bb).
# - The next password after abcdefgh is abcdffaa.
# - The next password after ghijklmn is ghjaabcc, because you eventually skip
#   all the passwords that start with ghi..., since i is not allowed.
#
# Given Santa's current password (your puzzle input), what should his next
# password be?
#
# --- Part Two ---
#
# Santa's password expired again. What's the next one?

if [ -z "$1" ]
then
	INPUT=input
	startPwd=$(cat $INPUT)
else
	startPwd=$1
fi

isValidPwd() {
	passwd=$1
	valid=false
	#Condition 1, 3 incremental
	for (( i=0; i<$((${#passwd}-2)); i++))
	do
		c1=${passwd:$i:1}
		c2=$(echo -n "${passwd:$((i+1)):1}" | tr "a-z" "za-y")
		c3=$(echo -n "${passwd:$((i+2)):1}" | tr "a-z" "yza-x")
		if [ $c1 == $c2 ] && [ $c1 == $c3 ]
		then
			valid=true
			break
		fi
	done
	#Condition 2, no i,o or l allowed, check
	#Condifion 3, two double letter
	if [ "$valid" == "true" ]
	then
		valid=false
		found=0
		for (( i=0; i<$((${#passwd}-1)); i++))
		do
			c1=${passwd:$i:1}
			c2=${passwd:$((i+1)):1}
			if [ $c1 == $c2 ]
			then
				((found++))
				((i++))
				if [ $found -ge 2 ]
				then
					valid=true
					break
				fi
			fi
		done
	fi
	echo $valid
}

nextPwd() {
	current=$1
	len=${#current}
	for (( i=$((len-1)); i>=0; i--))
	do
		current=${current:0:$i}$(echo -n "${current:$i:1}" | tr "a-z" "b-hjj-kmm-npp-za")${current:$((i+1))}
		if [ "${current:$i:1}" != "a" ]
		then
			break;
		fi
	done
	echo $current
}

sanatize() {
	current=$1
	len=${#current}
	for (( i=0; i<$len; i++))
	do
		case "${current:$i:1}" in
			i|l|o )
			current=${current:0:$i}$(echo -n "${current:$i:1}" | tr "a-z" "b-hjj-kmm-npp-za")$(echo -n "${current:$((i+1))}" | tr "a-z" "a")
				;;
		esac
	done
	echo $current
}

echo Start password $startPwd

endPwd=$(sanatize $startPwd)
while [ $(isValidPwd $endPwd) == false ]
do
	endPwd=$(nextPwd $endPwd)
done
echo Part 1: Next valid is $endPwd

# Part 2
endPwd=$(nextPwd $endPwd)
while [ $(isValidPwd $endPwd) == false ]
do
        endPwd=$(nextPwd $endPwd)
done
echo Part 2: Next valid is $endPwd

