rem sqlplus -s /nolog @stop_replication HP01 %1%

sqlplus -s /nolog @add_conflicts HP01 %1% PROM_CHARGE_LINE
sqlplus -s /nolog @add_conflicts HP01 %1% PROM_DOGOVOR_REG
sqlplus -s /nolog @add_conflicts HP01 %1% PROM_EDEVICE


rem sqlplus -s /nolog @start_replication HP01 %1%
exit