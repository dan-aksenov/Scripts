\set type :scale
\set param :scale
\setrandom param 1 999999
--\setrandom type 1 4

select PARAM3 from coltable where PARAM3 = :param;
