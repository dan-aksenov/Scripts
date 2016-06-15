--Поиск по индексируемому полю

select * from coltable where type = 1 and param4='еМVрfLцXEOhSЫTxёQ50аоуQvщPХWmнSMuy7дХя6дOo1уТzЪнЕЫОoОиоИ3Дкql6ОлЁЦРPХЧюо90вЬАxК4NNsё0bj5кOwQW95ёЯЦ0qi0Zs16JВДЮЖЫцюВчaсэFAuggГmIY7JЩqKьнM31ЩЗаUZЦUёОЕЧМФв5я';
select * from coltable where param4='еМVрfLцXEOhSЫTxёQ50аоуQvщPХWmнSMuy7дХя6дOo1уТzЪнЕЫОoОиоИ3Дкql6ОлЁЦРPХЧюо90вЬАxК4NNsё0bj5кOwQW95ёЯЦ0qi0Zs16JВДЮЖЫцюВчaсэFAuggГmIY7JЩqKьнM31ЩЗаUZЦUёОЕЧМФв5я';

select * from coltable where PARAM3 = 31;
--122.410 ms
select * from coltable where PARAM3 = 31 and type =1;
--47.884  ms 
select PARAM3 from coltable where PARAM3 = 31;
--4.462 ms

select params->'PARAM3' from jsontable where params->'PARAM3' = '31';
--344.693 ms
select * from jsontable where params->'PARAM3' = '31';
--31.236 ms
select * from jsontable where params->'PARAM3' = '31' and type=1;
--61.162 ms
select params->'PARAM3' from jsontable where params->'PARAM3' = '31' and type=1;
--169.993 ms


--Поиск по неиндексируемому полю (в пределах одного значения TYPE)

--?select * from coltable where type = 1 and param4='еМVрfLцXEOhSЫTxёQ50аоуQvщPХWmнSMuy7дХя6дOo1уТzЪнЕЫОoОиоИ3Дкql6ОлЁЦРPХЧюо90вЬАxК4NNsё0bj5кOwQW95ёЯЦ0qi0Zs16JВДЮЖЫцюВчaсэFAuggГmIY7JЩqKьнM31ЩЗаUZЦUёОЕЧМФв5я';
--162.523 ms
--?select * from coltable where param4='еМVрfLцXEOhSЫTxёQ50аоуQvщPХWmнSMuy7дХя6дOo1уТzЪнЕЫОoОиоИ3Дкql6ОлЁЦРPХЧюо90вЬАxК4NNsё0bj5кOwQW95ёЯЦ0qi0Zs16JВДЮЖЫцюВчaсэFAuggГmIY7JЩqKьнM31ЩЗаUZЦUёОЕЧМФв5я';
--843.974 ms
select param6 from coltable where type = 1 and param6 = 36;
--228.222 ms
select * from coltable where param6 = 36;
--3579.060 ms

select * from jsontable where params->>'PARAM4' = 'еМVрfLцXEOhSЫTxёQ50аоуQvщPХWmнSMuy7дХя6дOo1уТzЪнЕЫОoОиоИ3Дкql6ОлЁЦРPХЧюо90вЬАxК4NNsё0bj5кOwQW95ёЯЦ0qi0Zs16JВДЮЖЫцюВчaсэFAuggГmIY7JЩqKьнM31ЩЗаUZЦUёОЕЧМФв5я';
--20733.535 ms
select * from jsontable where type = 1 params->>'PARAM4' = 'еМVрfLцXEOhSЫTxёQ50аоуQvщPХWmнSMuy7дХя6дOo1уТzЪнЕЫОoОиоИ3Дкql6ОлЁЦРPХЧюо90вЬАxК4NNsё0bj5кOwQW95ёЯЦ0qi0Zs16JВДЮЖЫцюВчaсэFAuggГmIY7JЩqKьнM31ЩЗаUZЦUёОЕЧМФв5я';
--3198.484 ms
select * from jsontable where params->'PARAM6' = '36' and type =1;
--4992.686 ms
select params->'PARAM19' from jsontable where params->'PARAM6' = '36';
--20669.257 ms

--Поиск по нескольким полям (в ключая индексируемые и неиндексируемые)

--2 fld indexed
select * from coltable where type = 1 and param3=6;
--89.357 ms 

select params->'PARAM19' from jsontable where params->'PARAM3' = '31' and params->'PARAM19' = '14';
--9.592 ms

--2 fld not indexed

--2 fld mixed

 
/* 
Добавление записей в таблицу
--coltable
--491 ms

--

Удаление записей из таблицы
Обновление нескольких колонок в таблице (по одной записи)
Массовое обновление нескольких колонок в таблице (в пределах одного значения TYPE)
Одновременная работа различных вариантов поиска и обновления по одной записи в 10-20 потоков
*/