\set id :scale
\set id2 :scale
\setrandom id 1 300000
\setrandom id2 1 300000

update COLTABLE set PARAM33=(select param33 from coltable where id = :id2 and type =1) where id = :id and type = 1;
