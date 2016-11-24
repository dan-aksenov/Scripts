# Install oracle_fdw for postgres
# 0. required config
# pg_conf mast be in path
# gcc required
# oracle instant client(clietn,sqlplus,sdk) required

cd /tmp
wget http://download.oracle.com/otn/linux/instantclient/121020/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
wget http://download.oracle.com/otn/linux/instantclient/121020/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
wget http://download.oracle.com/otn/linux/instantclient/121020/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

yum install -y oracle-*

export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib
#or
cat /etc/ld.so.conf.d/oracle.conf <<EOF
/usr/lib/oracle/12.1/client64/lib
EOF

# 1. Get fdw from git-hub. Mind the proxy
git clone https://github.com/laurenz/oracle_fdw
cd oracle_fdw

# 2. Compile
make
sudo make install

# 3. Create extention
psql -c "create extention oracle_fdw"

#CREATE SERVER oradb FOREIGN DATA WRAPPER oracle_fdw
#          OPTIONS (dbserver '//dbserver.mydomain.com/ORADB');
#GRANT USAGE ON FOREIGN SERVER oradb TO pguser;
#Then you can connect to PostgreSQL as "pguser" and define:

#CREATE USER MAPPING FOR pguser SERVER oradb
#          OPTIONS (user 'orauser', password 'orapwd');

#CREATE FOREIGN TABLE oratab (
#          id        integer           OPTIONS (key 'true')  NOT NULL,
#          text      character varying(30),
#          floating  double precision  NOT NULL
#       ) SERVER oradb OPTIONS (schema 'ORAUSER', table 'ORATAB');
#(Имя схемы и таблицы должны быть в верхнем регистре)
#select * from oratab;
