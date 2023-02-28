# Работа с awk

awk scripting explained with practical examples:
<http://arkit.co.in/linux/awk-scripting-explained/>
Еще примеры:
<https://habr.com/ru/company/ruvds/blog/665084/>

## Select with awk

```bash
ps aux | awk '{if ($1 == "ansible") print $2}' 
awk '$3 == F {print}' /tmp/backup.lst 
```

## Column to line with awk

`awk 'BEGIN { ORS = " " } { print }' infile`

Источник: <https://www.unix.com/shell-programming-and-scripting/178162-converting-column-row.html>  

## Awk в скобках

`awk -F'[()]' '{print $2}' file`

Источник: <https://stackoverflow.com/questions/18219030/how-to-extract-the-content-between-two-brackets-by-using-grep?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa>  

В квадратных скобках:
`-F [\]\[]`
Источник: <https://www.unix.com/shell-programming-and-scripting/245663-grep-number-between-square-brackets.html>