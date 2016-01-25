# ENV part
ORACLE_SID=axtest
ORAENV_ASK=NO
. oraenv
export primary=gamma2
export standby=gamma2_std
export cred=sys/pswd

# Functions part
function std_convert() {
mode=$1
dgmgrl $cred@$primary "convert database $standby to $mode standby"
}

function lag_check() {
alag=$(dgmgrl $cred@$primary "show database $standby" | grep "Apply Lag" | awk -F" " '{print $3}')
tlag=$(dgmgrl $cred@$primary "show database $standby" | grep "Transport Lag" | awk -F" " '{print $3}')
lag=$(($alag+$tlag))
echo $lag
}

{ echo Refresh started at; date; } | tr "\n" " "

# Actual refresh.
std_convert "physical"

echo Waiting for apply to finish. This may take hours...
while [ $(lag_check) -ge 0 ];do
        lag_check
        sleep 30
done

dgmgrl $cred@$primary "show database $standby" | grep "Lag"

std_convert "snapshot"

{ echo Refresh finished at; date; } | tr "\n" " "