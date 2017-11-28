#! /bin/bash

# This script accepts a list of raw data values as an argument and outputs
# basic statictics about that data.

# Quit if file not found
if [ ! -f "$1" ]; then
  echo "Error: file $1 not found."
  exit 1
fi

# Preserve existing IFS
OLD_IFS=$IFS

# Check if IFS is supplied
if [ $# -eq 2 ]; then
  case $2 in
    space)
      IFS=' '
      ;;
    comma)
      IFS=','
      ;;
    semicolon)
      IFS=';'
      ;;
    *)
      echo "Warning: IFS specifier unrecognized. Using default setting."
  esac
fi

# Table formatting
table="%-20s %s \n"

# Initially set min and max to the first value in the data set
min=$(head -n 1 "$1")
max=$(head -n 1 "$1")

# Read data file into array
raw=()
while read data_value; do
  raw+=("$data_value")
done < "$1"

# Sort array
data=($(sort <<< "${raw[@]}"))

# Ensure IFS is set to default
IFS=OLD_IFS

# Find sum and count
for num in "${data[@]}"; do
  sum=$((sum+num))
  if ((num < min)); then
    min="$num"
  elif ((num > max)); then
    max="$num"
  fi
  ((n++))
done

# Find mean
mean=$(bc <<< "scale=8;$sum/$n")

# Find the variance and standard deviation
sum_sq=0
for num in "${data[@]}"; do
  diff=$(bc <<< "scale=8;$num-$mean")
  sq_diff=$(bc <<< "scale=8;$diff^2")
  sum_sq=$(bc <<< "scale=8;$sum_sq+$sq_diff")
done
v=$(bc <<< "scale=8;$sum_sq/($n-1)")
sx=$(bc <<< "scale=4;sqrt($v)")

# Find the median
if ((n % 2 == 0)); then
  med=$((data[(n/2)-1]+data[(n/2)]))
  med=$(bc <<< "scale=8;$med/2")
else
  med=$((data[n/2]))
fi

# Print table header
header="Descriptive Statistics of \"$1\""
echo "$header"

# Print table underline
size=${#header}; i=0
while ((i < size)); do
  printf "="
  ((i++))
done; echo

# Print descriptive statistics
printf "$table" \
"Sum" "$sum" \
"Count" "$n" \
"Min" "$min" \
"Max" "$max" \
"Mean" "$mean" \
"Variance" "$v" \
"Standard deviation" "$sx" \
"Median" "$med"
