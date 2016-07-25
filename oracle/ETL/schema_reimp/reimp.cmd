rem			dest schema src
sqlplus user/pass@%1 @drop %2
impdp user/pass@%1 schemas=%2 network_link=%3 logfile=%2 parallel=20