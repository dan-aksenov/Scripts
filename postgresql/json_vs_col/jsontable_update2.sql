\set id :scale
\set id2 :scale
\setrandom id 1 300000 
\setrandom id2 1 300000

update jsontable set params = (select params from jsontable where id = :id2 and type = 1) where id = :id and type = 1;
