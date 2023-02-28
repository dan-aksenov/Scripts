# sed - stream editor 

## Text between matches

`sed -n "/START-WORD-HERE/,/END-WORD-HERE/p" input`
Источник: <http://www.cyberciti.biz/faq/howto-grep-text-between-two-words-in-unix-linux/>  

## Удалить разделитель разрядов (пробел). Превратить 1 000 1000

`sed -e 's/\([0-9]\)\s\([0-9]\{1\}\)/\1\2/' /tmp/copy.sql`

## Удалить пробелы в конце строк

`sed --in-place 's/[[:space:]]\+$//'`

## Вставить на вторую строчку со сдвигом вниз

`sed "15i avatar" Makefile.txt`
Источник: <http://stackoverflow.com/questions/15157659/add-text-to-file-at-certain-line-in-linux>  