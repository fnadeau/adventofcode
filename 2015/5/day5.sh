#!/bin/bash

# --- Day 5: Doesn't He Have Intern-Elves For This? ---
#
# Santa needs help figuring out which strings in his text file are naughty or
# nice.
#
# A nice string is one with all of the following properties:
#
# - It contains at least three vowels (aeiou only), like aei, xazegov, or
#   aeiouaeiouaeiou.
# - It contains at least one letter that appears twice in a row, like xx,
#   abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
# - It does not contain the strings ab, cd, pq, or xy, even if they are part of
#   one of the other requirements.
#
# For example:
#
# - ugknbfddgicrmopn is nice because it has at least three vowels
#   (u...i...o...), a double letter (...dd...), and none of the disallowed
#   substrings.
# - aaa is nice because it has at least three vowels and a double letter, even
#   though the letters used by different rules overlap.
# - jchzalrnumimnmhp is naughty because it has no double letter.
# - haegwjzuvuyypxyu is naughty because it contains the string xy.
# - dvszwmarrgswjxmb is naughty because it contains only one vowel.
#
# How many strings are nice?
#
# --- Part Two ---
#
# Realizing the error of his ways, Santa has switched to a better model of
# determining whether a string is naughty or nice. None of the old rules apply,
# as they are all clearly ridiculous.
#
# Now, a nice string is one with all of the following properties:
#
# - It contains a pair of any two letters that appears at least twice in the
#   string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like
#   aaa (aa, but it overlaps).
# - It contains at least one letter which repeats with exactly one letter
#   between them, like xyx, abcdefeghi (efe), or even aaa.
#
# For example:
#
# - qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and
#   a letter that repeats with exactly one letter between them (zxz).
# - xxyxx is nice because it has a pair that appears twice and a letter that
#   repeats with one between, even though the letters used by each rule overlap.
# - uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a
#   single letter between them.
# - ieodomkazucvgmuy is naughty because it has a repeating letter with one
#   between (odo), but no pair that appears twice.
#
# How many strings are nice under these new rules?

# 1- remove lines with naughty list
# 2- Keep lines that have any char that repeat itself 1 time
# 3- Keep only vowels
# 4- Count line that have three vowels or more
numNice=$(grep -v -E "(ab|cd|pq|xy)" input |  grep -E "(.)\1{1}" | sed -e "s/[^aeiou]//g" - | awk 'BEGIN {count=0} { if (length($0) > 2) count+=1 } END {print count}')
echo Number of nice child in part 1: $numNice

# 1- Keep lines that have any 2 char that repeat themself with none or any
#    number of char inbetween.
# 2- Keep lines that have any char which repeat itself with 1 char inbetween.
# 3- Count lines.
numNice=$(grep -E "((.){2}).*\1" input | grep -E "((.){1}).\1" | wc -l)
echo Number of nice child in part 2: $numNice

