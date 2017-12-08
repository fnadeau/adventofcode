#!/bin/bash

#--- Day 6: Probably a Fire Hazard ---
#
# Because your neighbors keep defeating you in the holiday house decorating
# contest year after year, you've decided to deploy one million lights in a
# 1000x1000 grid.
#
# Furthermore, because you've been especially nice this year, Santa has mailed
# you instructions on how to display the ideal lighting configuration.
#
# Lights in your grid are numbered from 0 to 999 in each direction; the lights
# at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions
# include whether to turn on, turn off, or toggle various inclusive ranges
# given as coordinate pairs. Each coordinate pair represents opposite corners
# of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore
# refers to 9 lights in a 3x3 square. The lights all start turned off.
#
# To defeat your neighbors this year, all you have to do is set up your lights
# by doing the instructions Santa sent you in order.
#
# For example:
#
# - turn on 0,0 through 999,999 would turn on (or leave on) every light.
# - toggle 0,0 through 999,0 would toggle the first line of 1000 lights,
#   turning off the ones that were on, and turning on the ones that were off.
# - turn off 499,499 through 500,500 would turn off (or leave off) the middle
#   four lights.
#
# After following the instructions, how many lights are lit?

INPUT=input
ROW=1000
COLUMN=1000
declare -A matrix
declare -A matrixLumen
count=0
lumen=0
declare -A rowMask

function rowToMask() {
	rowStart=$1
	rowStop=$(($2+1))
	step=0
	for ((i=0; i<32; i++)) do
		case $step in
			"0" )
				if (($rowStart > ((i+1)*32)-1))
				then
					rowMask[$i]=$((0x0))
				else
					rowMask[$i]=$((0xFFFFFFFF>>($rowStart-($i*32))))
					((step++))
					if (($rowStop <= ((i+1)*32)-1))
					then
						rowMask[$i]=$((0xFFFFFFFF<<(32-($rowStop-($i*32))) & rowMask[$i]))
						((step++))
					fi
				fi
				;;
			"1" )
				if (($rowStop > ((i+1)*32)-1))
				then
					rowMask[$i]=$((0xFFFFFFFF))
				else
					rowMask[$i]=$((0xFFFFFFFF<<(32-($rowStop-($i*32))) & 0xFFFFFFFF))
					((step++))
				fi
				;;
			"2" )
				rowMask[$i]=$((0x00000000))
				;;
			* )
				;;
		esac
	done
}

function countBit() {
	value=$1
	for ((k=0; k<32; k++)) do 
		((count+=(($value>>k) & 0x1)))
	done
}

for ((i=0;i<1000;i++)) do
	for ((j=0; j<32; j++)) do
		matrix[$i,$j]=0
	done
	for ((j=0; j<1000; j++)) do
		matrixLumen[$i,$j]=0
	done
	
done

while read line
do
	[[ "${line}" =~ (turn off|turn on|toggle)[[:space:]]([0-9]+),([0-9]+)[[:space:]]through[[:space:]]([0-9]+),([0-9]+) ]]
	command=${BASH_REMATCH[1]}
	x1=${BASH_REMATCH[2]}
	y1=${BASH_REMATCH[3]}
	x2=${BASH_REMATCH[4]}
	y2=${BASH_REMATCH[5]}
	rowToMask $y1 $y2
	case ${command} in
		"turn off")
			for ((i=$x1; i<=$x2; i++)) do
				for ((j=0; j<32; j++)) do
					matrix[$i,$j]=$((${matrix[$i,$j]} & ~${rowMask[$j]}))
				done
				for ((j=$y1; j<=$y2; j++)) do
					matrixLumen[$i,$j]=$((${matrixLumen[$i,$j]} > 0 ? ${matrixLumen[$i,$j]} - 1 : 0))
				done
			done
			;;
		"turn on")
			for ((i=$x1; i<=$x2; i++)) do
				for ((j=0; j<32; j++)) do
					matrix[$i,$j]=$((${matrix[$i,$j]} | ${rowMask[$j]}))
				done
				for ((j=$y1; j<=$y2; j++)) do
					((matrixLumen[$i,$j]++))
				done
			done
			;;
		"toggle")
			for ((i=$x1; i<=$x2; i++)) do
				for ((j=0; j<32; j++)) do
					matrix[$i,$j]=$((${matrix[$i,$j]} ^ ${rowMask[$j]}))
				done
				for ((j=$y1; j<=$y2; j++)) do
					((matrixLumen[$i,$j]+=2))
				done
			done
			;;
		*)
			echo "Wrong comand: $command $x1 $y1 $x2 $y2"
			continue
			;;
	esac
done < "${INPUT}"

for ((i=0; i<1000; i++)) do
	for ((j=0; j<32; j++)) do
		countBit ${matrix[$i,$j]}
	done
	for ((j=0; j<1000; j++)) do
		((lumen+=${matrixLumen[$i,$j]}))
	done
done

echo $count lights are lit
echo Total brightness is $lumen lumens

