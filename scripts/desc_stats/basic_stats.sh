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

# Read data file into array
data=()
while read data_value; do
  data+=($data_value)
done < "$1"

# Sort array
data_len="${#data[@]}"
for (( i=1; i<data_len; i++ )); do
  key="${data[$i]}"
  j=$((i-1))
  while ((j>=0 && data[j] > key)); do
    data[((j+1))]="${data[$j]}"
    j=$((j-1))
  done
  data[((j+1))]="$key"
done

# Ensure IFS is set to default
IFS=OLD_IFS

# Initially set min and max to the first value in the data set
min="${data[0]}"
max="${data[0]}"

# Find sum, min, max, and n
for num in "${data[@]}"; do
  sum=$((sum + num))
  if ((num < min)); then
    min="$num"
  elif ((num > max)); then
    max="$num"
  fi
  ((n++))
done

# Declare associative array for finding mode
declare -A counts

# Find mean
mean=$(bc <<< "scale=8; $sum/$n")

# Find the variance and standard deviation
sum_sq=0
for num in "${data[@]}"; do
  diff=$(bc <<< "scale=8; $num-$mean")
  sq_diff=$(bc <<< "scale=8; $diff^2")
  sum_sq=$(bc <<< "scale=8; $sum_sq+$sq_diff")
done
v=$(bc <<< "scale=8; $sum_sq/($n-1)")
sx=$(bc <<< "scale=4; sqrt($v)")

# Find the median and divide data into two sub-lists (to find Q1 and Q3)
if ((n % 2 == 0)); then
  med=$((data[(n/2)-1]+data[n/2]))
  med=$(bc <<< "scale=8; $med/2")
  sub_upper=("${data[@]:n/2}")
else
  med=$((data[n/2]))
  sub_upper=("${data[@]:n/2+1}")
fi
sub_lower=("${data[@]:0:n/2}")
sub_n=${#sub_lower[@]}  # Size of sub-lists

# Find Q1 and Q3
if ((sub_n % 2 == 0)); then
  q1=$((sub_lower[(sub_n/2)-1]+sub_lower[sub_n/2]))
  q1=$(bc <<< "scale=8; $q1/2")
  q3=$((sub_upper[(sub_n/2)-1]+sub_upper[sub_n/2]))
  q3=$(bc <<< "scale=8; $q3/2")
else
  q1=$((sub_lower[sub_n/2]))
  q3=$((sub_upper[sub_n/2]))
fi

# Find minimum and maximum usual value
min_usual=$(bc <<< "scale=8; $mean-(2*$sx)")
max_usual=$(bc <<< "scale=8; $mean+(2*$sx)")

# Print table header
header="Descriptive Statistics of \"$1\""
echo "$header"

# Print table underline
size=${#header}; i=0
while ((i < size)); do
  printf "="
  ((i++))
done; echo

# Table formatting
table="%-20s %s \n"

# Print descriptive statistics
printf "$table" \
"Sum" "$sum" \
"Count" "$n" \
"Mean" "$mean" \
"Variance" "$v" \
"Standard deviation" "$sx" \
"Minimum usual value" "$min_usual" \
"Maximum usual value" "$max_usual" \
"Min" "$min" \
"Q1" "$q1" \
"Median" "$med" \
"Q3" "$q3" \
"Max" "$max"
