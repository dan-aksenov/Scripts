\set param1 :scale
\set param2 :scale
\setrandom param1 1 999999
\setrandom param2 1 999999

select PARAM19 from coltable where PARAM3 = :param1 and PARAM19= :param2;
