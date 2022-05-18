# Grep

## Replace in multiple files

`grep -rl 'windows' ./ | xargs sed -i 's/windows/linux/g'`
Источник: <http://vasir.net/blog/ubuntu/replace_string_in_multiple_files>  

## Grep unique ip addresses

`grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"  /home/tmblka/logs/80-access.log | sort | uniq`

## cut & grep vs awk

Например,
`grep -v "#" /etc/inittab |cut -f 4 -d : -s`
выведет список программ, запускающихся init'ом (четвёртое поле, поля разделяются двоеточием).
Или  
`grep http://\\S\\+ -o /var/log/apache2/error.log`
выдаст список URL'ов из файла с ошибками (первый урл в строке).
… и никакого awk.
Источник: <https://habrahabr.ru/post/104546/>  

## pgrep

Команда `pgrep` грепает список исполняемых процессов
С ключом `-a`, команда также выдаст всю командную строку.
Источник: <https://habrahabr.ru/post/316414/>