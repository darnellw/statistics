# Bash scripts for statistical analyses

Simple bash scripts that perform various statistical analyses on data sets. Various examples of quantitative test data are available in each script's individual directory for convenience.

## **basic_stats.sh**
Outputs descriptive statistics of quantitative data sets contained in text files. Accepts two arguments: the name of the .txt file and an optional `IFS` specifier string (current options are `space`, `comma` and `semicolon`).
For example, to analyze data elements separated by newlines or spaces (default, assuming `IFS` is set to `' \t\n'`):
```
./basic_stats.sh data_1.txt
```
To analyze data separated by commas:
```
./basic_stats.sh data_2.txt comma
```
