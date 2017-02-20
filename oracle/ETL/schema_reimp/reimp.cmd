rem	1 - dest 2 - schema 3 - src

set conn_string=user/pass@%1

sqlplus %conn_string% @drop %2
impdp %conn_string% schemas=%2 network_link=%3 logfile=%2 parallel=20