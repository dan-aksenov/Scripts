#!/bin/bash
# Some basic and best practice configs for newly created db's postgresql.conf file
PGCONF=/var/lib/pgsql/$PGVER/data/postgresql.conf
cat >> $PGCONF << EOF

#some minimal memory configs(subject to tune)
shared_buffers = 1024MB                
temp_buffers = 50MB                     
work_mem = 512MB  

#add stat_statements to libs
shared_preload_libraries = 'pg_stat_statements'

#add activities tracking
track_activities = on
track_counts = on
track_io_timing = on
track_functions = all
log_autovacuum_min_duration = 0		

#custom setting for stat_statements
pg_stat_statements.track = all
EOF
