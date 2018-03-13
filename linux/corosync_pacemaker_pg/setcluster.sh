#!/bin/bash

# list of nodes must be supplied as quoted, space separated list. ie "node1 node2".
NODES=$1

#pcs property set stonith-enabled="false"
pcs cluster cib pgsql_cfg
# floating ip address 'SCAN'
pcs -f pgsql_cfg resource create gpmasterIP IPaddr2 ip=SCAB_ip cidr_netmask=16 --group PGMGROUP

pcs -f pgsql_cfg resource create pgsql pgsql \
pgctl="/usr/pgsql-9.5/bin/pg_ctl" \
psql="/usr/pgsql-9.5/bin/psql" \
pgdata="/var/lib/pgsql/9.5/data" \
tmpdir="/var/lib/pgsql/tmp" \
socketdir="/var/lib/pgsql/tmp" \
pgport="5432" \
pgdba="postgres" \
node_list=$NODES \
rep_mode="sync" \
#restore_command="cp /var/lib/pgsql/pg_archive/%f %p" \
#archive_cleanup_command="/usr/pgsql-9.5/bin/pg_archivecleanup /var/lib/pgsql/pg_archive %r" \
primary_conninfo_opt="keepalives_idle=60 keepalives_interval=5 keepalives_count=5" \
# Clusters master VIP
master_ip="172.19.1.129" \
restart_on_promote='true' \
logfile="/var/lib/pgsql/tmp/dropme.log" \
op start   timeout="60s" interval="0s"  on-fail="restart" \
op monitor timeout="60s" interval="4s"  on-fail="restart" \
op monitor timeout="60s" interval="3s"  on-fail="restart" role="Master" \
op promote timeout="60s" interval="0s"  on-fail="restart" \
op demote  timeout="60s" interval="0s"  on-fail="stop"  \
op stop    timeout="60s" interval="0s"  on-fail="block" \
op notify  timeout="60s" interval="0s"

pcs -f pgsql_cfg resource master mspg pgsql master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
pcs -f pgsql_cfg constraint colocation add PGMGROUP with Master mspg INFINITY
pcs -f pgsql_cfg constraint order promote mspg then start PGMGROUP symmetrical=false score=INFINITY
pcs -f pgsql_cfg constraint order demote  mspg then stop  PGMGROUP symmetrical=false score=0
pcs -f pgsql_cfg property set no-quorum-policy="ignore"
pcs -f pgsql_cfg resource defaults resource-stickiness="INFINITY"
pcs -f pgsql_cfg resource defaults migration-threshold="1"
pcs cluster verify -V pgsql_cfg

echo pcs cluster cib-push pgsql_cfg
echo pcs cluster sync
