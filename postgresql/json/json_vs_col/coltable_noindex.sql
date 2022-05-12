\set type :scale
\set param :scale
\setrandom param 1 999999
--\setrandom type 1 4

select param6 from coltable where type = 1 and param6 = :param;
