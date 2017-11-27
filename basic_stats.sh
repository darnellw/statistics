#! /bin/bash

# This script accepts a list of raw data values as an argument and outputs
# basic statictics about that data.

# Quit if file not found
if [ ! -f $1 ]; then
  echo "Error: file $1 not found."
  exit 1
fi

# Table formatting
table="%-20s %s \n"

# Variables
sum=0               # Sum
n=0                 # Count
min=$(head -n 1 $1) # Minimum
max=$(head -n 1 $1) # Maximum
mean=0              # Mean
sx=0                # Standard deviation
v=0                 # Variance

# Find sum and count
while read num; do
  sum=$((sum+num))
  if [ "$num" -lt "$min" ]; then
    min=$num
  elif [ "$num" -gt "$max" ]; then
    max=$num
  fi
  ((n++))
done < $1

# Find mean
mean=$(bc <<< "scale=8;$sum/$n")

# Find the variance and standard deviation
sum_sq=0
while read num; do
  diff=$(bc <<< "scale=8;$num-$mean")
  sq_diff=$(bc <<< "scale=8;$diff^2")
  sum_sq=$(bc <<< "scale=8;$sum_sq+$sq_diff")
done < $1
v=$(bc <<< "scale=8;$sum_sq/($n-1)")
sx=$(bc <<< "scale=4;sqrt($v)")

# Print table header
header="Statistics of \"$1\""
echo $header

# Print table underline
size=${#header}; i=0
while [ "$i" -lt "$size" ]; do
  printf "="
  ((i++))
done; echo

# Print statistics
printf "$table" \
"Sum" "$sum" \
"Count" "$n" \
"Min" "$min" \
"Max" "$max" \
"Mean" "$mean" \
"Variance" "$v" \
"Standard deviation" "$sx"
