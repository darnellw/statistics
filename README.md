# Bash scripts for statistical analyses

Simple bash scripts that perform various statistical analyses on data sets.

## **basic_stats.sh**
Outputs descriptive statistics of quantitative data sets contained in .txt files. Accepts two arguments: the name of the .txt file and an optional IFS specifier string (options are 'space', 'semicolon', and 'comma').
For example, to work with data elements separated by newlines (default, assuming IFS is set to ' \t\t'):
```
./basic_stats.sh ../test_files/test_data_2.txt
```
To work with data separated by commas:
```
./basic_stats.sh ../test_files/test_data_3.txt comma
```
