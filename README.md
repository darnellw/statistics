# Bash script for descriptive statistics

## **basic_stats.sh**
Outputs descriptive statistics of quantitative data sets contained in text files. Accepts two arguments: the name of the .txt file and an optional Internal Field Separator (`IFS`) specifier string (current options are `comma` and `semicolon`). Output consists of measures of center, measures of variation, the five-number summary, and more.

For example, to analyze data elements separated by newlines or spaces (assuming `IFS` is set to the default value of `' \t\n'`):
```
./basic_stats.sh data_1.txt
```
The example data file `data_3.csv` contains data separated by commas. Using the `comma` specifier:
```
./basic_stats.sh data_3.txt comma
```
