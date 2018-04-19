# Script for partial reimport of PG's databases during upgrade.
# In normal circumstances pg_upgrade should be used.
# GNUParallel is required
dbs='database1 database2'
function reimp {
    psql -p 5433 -c "drop database $1"
    psql -p 5433 -c "create database $1"
    pg_dump -Fp -p 5432 $1 | psql -p 5433 $1 &>/tmp/$1.log }
export -f reimp

#--eta: Shows the estimated time remaining to run all jobs.
#--jobs 2: The number of commands to run at the same time, which in this case was set to 2.
#--load 80%": The maximum CPU load at which new jobs will not be started.
#--noswap": New jobs won't be started if there is both swap-in and swap-out activity.

time parallel -j 4 --load 50% --noswap reimp '{}' ::: $dbs