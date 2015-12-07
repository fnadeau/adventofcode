#!/bin/bash

#--- Day 7: Some Assembly Required ---
#
# This year, Santa brought little Bobby Tables a set of wires and bitwise logic
# gates! Unfortunately, little Bobby is a little under the recommended age
# range, and he needs help assembling the circuit.
#
# Each wire has an identifier (some lowercase letters) and can carry a 16-bit
# signal (a number from 0 to 65535). A signal is provided to each wire by a
# gate, another wire, or some specific value. Each wire can only get a signal
# from one source, but can provide its signal to multiple destinations. A gate
# provides no signal until all of its inputs have a signal.
#
# The included instructions booklet describe how to connect the parts together:
# x AND y -> z means to connect wires x and y to an AND gate, and then connect
# its output to wire z.
#
# For example:
#
# - 123 -> x means that the signal 123 is provided to wire x.
# - x AND y -> z means that the bitwise AND of wire x and wire y is provided to
#   wire z.
# - p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and
#   then provided to wire q.
# - NOT e -> f means that the bitwise complement of the value from wire e is
#   provided to wire f.
# 
# Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for
# some reason, you'd like to emulate the circuit instead, almost all programming
# languages (for example, C, JavaScript, or Python) provide operators for these
# gates.
#
# For example, here is a simple circuit:
#
# - 123 -> x
# - 456 -> y
# - x AND y -> d
# - x OR y -> e
# - x LSHIFT 2 -> f
# - y RSHIFT 2 -> g
# - NOT x -> h
# - NOT y -> i
#
# After it is run, these are the signals on the wires:
#
# - d: 72
# - e: 507
# - f: 492
# - g: 114
# - h: 65412
# - i: 65079
# - x: 123
# - y: 456
#
# In little Bobby's kit's instructions booklet (provided as your puzzle input),
# what signal is ultimately provided to wire a?

INPUT=$1
declare -A signals

function getOperant() {
	if [[ "$1" =~ ^[0-9]+ ]]
	then
		echo $1
	elif [ "$1" == "" ]
	then
		echo ""
	else
		echo ${signals["$1"]}
	fi 
}

if [ ! -f $INPUT ]
then
	echo file $INPUT not found, usage: $0 input_file
	exit 0
fi

while [ "${signals["a"]}" = "" ]
do
	while read line
	do
		# Direct assignement
		if [[ "$line" =~ ^([a-z0-9]+)[[:space:]]-\>[[:space:]]([0-9a-z]+) ]]
		then
			operantA=$(getOperant ${BASH_REMATCH[1]})
			if [ "$operantA" != "" -a "${signals["${BASH_REMATCH[2]}"]}" == "" ]
			then
				signals["${BASH_REMATCH[2]}"]=$operantA
				echo New signal ${signals["${BASH_REMATCH[2]}"]}
				continue
			fi
		# NOT operator
		elif [[ "$line" =~ ^NOT[[:space:]]([0-9a-z]+)[[:space:]]-\>[[:space:]]([0-9a-z]+) ]]
		then
			if [ "${signals["${BASH_REMATCH[1]}"]}" != "" -a "${signals["${BASH_REMATCH[2]}"]}" == "" ]
			then
				signals["${BASH_REMATCH[2]}"]=$(( ~${signals["${BASH_REMATCH[1]}"]} ))
				echo New signal ${signals["${BASH_REMATCH[2]}"]} which is NOT $operantA
				continue
			fi
		# Multiple input operator
		elif [[ "$line" =~ ^([0-9a-z]+)[[:space:]]([A-Z]+)[[:space:]]([0-9a-z]+)[[:space:]]-\>[[:space:]]([0-9a-z]+) ]]
		then
			operantA=$(getOperant ${BASH_REMATCH[1]})
			operantB=$(getOperant ${BASH_REMATCH[3]})
			if [ "$operantA" != "" -a "$operantB" != "" -a "${signals["${BASH_REMATCH[4]}"]}" == "" ]
			then
				case ${BASH_REMATCH[2]} in
					"AND" )
						signals["${BASH_REMATCH[4]}"]=$(( $operantA & $operantB ))
						echo New signal ${signals["${BASH_REMATCH[4]}"]} which is $operantA AND $operantB
						;;
					"OR" )
						signals["${BASH_REMATCH[4]}"]=$(( $operantA | $operantB ))
						echo New signal ${signals["${BASH_REMATCH[4]}"]} which is $operantA OR $operantB
						;;
					"LSHIFT" )
						signals["${BASH_REMATCH[4]}"]=$(( $operantA << $operantB ))
						echo New signal ${signals["${BASH_REMATCH[4]}"]} which is $operantA LSHIFT $operantB
						;;
					"RSHIFT" )
						signals["${BASH_REMATCH[4]}"]=$(( $operantA >> $operantB ))
						echo New signal ${signals["${BASH_REMATCH[4]}"]} which is $operantA RSHIFT $operantB
						;;
					* )
						echo Dafuq am I doing here? $line : ${BASH_REMATCH[1]} .. ${BASH_REMATCH[2]}
						;;
				esac
			fi
		else
			echo Unknown operator: $line
		fi
	done < $INPUT;
done

