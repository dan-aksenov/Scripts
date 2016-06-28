\set id :scale
\setrandom id 1 1200000

select params from jsontable where id = :id;
