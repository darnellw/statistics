# Bash scripts for statistical analyses

Simple bash scripts that perform various statistical analyses on data sets. Various examples of quantitative test data are available in each script's individual directory for convenience.

## **basic_stats.sh**
Outputs descriptive statistics of quantitative data sets contained in .txt files. Accepts two arguments: the name of the .txt file and an optional `IFS` specifier string (options are `space`, `semicolon`, and `comma`).
For example, to work with data elements separated by newlines (default, assuming `IFS` is set to `' \t\n'`):
```
./basic_stats.sh data_1.txt
```
To work with data separated by commas:
```
./basic_stats.sh data_3.csv comma
```
