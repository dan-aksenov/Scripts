#/bin/bash
now=$(date +"%m%d%Y_%H%M%S")
dump_dir=$1
mysqldump -u zabbix -pzabbix --all-databases 2>$dump_dir/mysql_dump_$now.log > $dump_dir/mysql_dump_$now.sql