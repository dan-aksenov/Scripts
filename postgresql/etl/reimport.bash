# Script for partial reimport of PG's databases during upgrade.
# In normal circumstances pg_upgrade should be used.
dbs='database1 database2'
function reimp {
    psql -p 5433 -c "drop database $1"
    psql -p 5433 -c "create database $1"
    pg_dump -Fp -p 5432 $1 | psql -p 5433 $1 &>/tmp/$1.log }
export -f reimp
time parallel -j 4 --load 50% reimp '{}' ::: $dbs