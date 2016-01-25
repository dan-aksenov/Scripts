#!/bin/bash

PS3='Выберите ваш любимый овощ: '

echo

choice_of()
{
select vegetable
# Если [in list] не задан, то 'select' использует аргументы, переданные функции.
do
  echo
  echo "Ваш любимый овощ - $vegetable."
  echo "Фу, какая гадость!"
  echo
  break
done
}

choice_of бобы рис морковь редиска помидор шпинат
#         $1   $2   $3       $4      $5      $6
#         передано в функцию choice_of()

exit 0