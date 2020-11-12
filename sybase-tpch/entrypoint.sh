#!/bin/bash
export SYBASE=/opt/sybase
source /opt/sybase/SYBASE.sh
sh /opt/sybase/SYBASE.sh && sh /opt/sybase/ASE-16_0/install/RUN_MYSYBASE > /dev/null &

#waiting for sybase to start
export STATUS=0
i=0
echo "STARTING... (about 100 sec)"
while [[ $STATUS -eq 0 ]] || [[ $i -lt 30 ]]; do
	sleep 1
	i=$((i+1))
	STATUS=$(grep "server name is 'MYSYBASE'" /opt/sybase/ASE-16_0/install/MYSYBASE.log | wc -c)
done

echo =============== SYBASE STARTED ==========================
cd /opt/sybase

if [ ! -z $SYBASE_USER ]; then
	echo "SYBASE_USER: $SYBASE_USER"	
else
	SYBASE_USER=TPCH
	echo "SYBASE_USER: $SYBASE_USER"
fi

if [ ! -z $SYBASE_PASSWORD ]; then
	echo "SYBASE_PASSWORD: $SYBASE_PASSWORD"	
else
	SYBASE_PASSWORD=mstr123#
	echo "SYBASE_PASSWORD: $SYBASE_PASSWORD"
fi

if [ ! -z $SYBASE_DB ]; then
	echo "SYBASE_DB: $SYBASE_DB"	
else
	SYBASE_DB=TPCH
	echo "SYBASE_DB: $SYBASE_DB"
fi

echo =============== CREATING LOGIN/PWD ==========================
cat <<-EOSQL > init1.sql
use master
go
disk resize name='master', size='4000m'
go
create database $SYBASE_DB on master = '2000m'
go
exec sp_extendsegment logsegment, $SYBASE_DB, master
go
create login $SYBASE_USER with password $SYBASE_PASSWORD
go
exec sp_dboption $SYBASE_DB, 'abort tran on log full', true
go
exec sp_dboption $SYBASE_DB, 'allow nulls by default', true
go
exec sp_dboption $SYBASE_DB, 'ddl in tran', true
go
exec sp_dboption $SYBASE_DB, 'trunc log on chkpt', true
go
exec sp_dboption $SYBASE_DB, 'full logging for select into', true
go
exec sp_dboption $SYBASE_DB, 'full logging for alter table', true
go
sp_dboption $SYBASE_DB, "select into", true
go
exec sp_dboption $SYBASE_DB,'select into/bulkcopy', true
go
EOSQL

/opt/sybase/OCS-16_0/bin/isql -Usa -PmyPassword -SMYSYBASE -i"./init1.sql"

echo =============== CREATING DB ==========================
cat <<-EOSQL > init2.sql
use $SYBASE_DB
go
sp_adduser '$SYBASE_USER', '$SYBASE_USER', null
go
grant create default to $SYBASE_USER
go
grant create table to $SYBASE_USER
go
grant create view to $SYBASE_USER
go
grant create rule to $SYBASE_USER
go
grant create function to $SYBASE_USER
go
grant create procedure to $SYBASE_USER
go
commit
go
EOSQL

/opt/sybase/OCS-16_0/bin/isql -Usa -PmyPassword -SMYSYBASE -i"./init2.sql"

echo =============== CREATING SCHEMA ==========================
cat <<-EOSQL > init3.sql
use $SYBASE_DB
go
create schema authorization $SYBASE_USER
go
EOSQL
/opt/sybase/OCS-16_0/bin/isql -Usa -PmyPassword -SMYSYBASE -i"./init3.sql"

echo =============== CREATING TABLES & grant access==========================
cat <<-EOSQL > init4.sql
use $SYBASE_DB
go
CREATE TABLE NATION  ( N_NATIONKEY  INTEGER NOT NULL, N_NAME CHAR(25) NOT NULL, N_REGIONKEY INTEGER NOT NULL, N_COMMENT VARCHAR(152))
go
CREATE TABLE REGION  ( R_REGIONKEY INTEGER NOT NULL, R_NAME CHAR(25) NOT NULL,R_COMMENT VARCHAR(152))
go
CREATE TABLE PART  ( P_PARTKEY INTEGER NOT NULL, P_NAME VARCHAR(55) NOT NULL, P_MFGR CHAR(25) NOT NULL, P_BRAND CHAR(10) NOT NULL, P_TYPE VARCHAR(25) NOT NULL, P_SIZE INTEGER NOT NULL, P_CONTAINER CHAR(10) NOT NULL, P_RETAILPRICE DECIMAL(15,2) NOT NULL, P_COMMENT VARCHAR(23) NOT NULL )
go
CREATE TABLE SUPPLIER ( S_SUPPKEY INTEGER NOT NULL, S_NAME CHAR(25) NOT NULL, S_ADDRESS VARCHAR(40) NOT NULL, S_NATIONKEY INTEGER NOT NULL, S_PHONE CHAR(15) NOT NULL, S_ACCTBAL DECIMAL(15,2) NOT NULL, S_COMMENT VARCHAR(101) NOT NULL)
go
CREATE TABLE PARTSUPP ( PS_PARTKEY INTEGER NOT NULL, PS_SUPPKEY INTEGER NOT NULL, PS_AVAILQTY INTEGER NOT NULL, PS_SUPPLYCOST DECIMAL(15,2) NOT NULL, PS_COMMENT VARCHAR(199) NOT NULL )
go
CREATE TABLE CUSTOMER ( C_CUSTKEY INTEGER NOT NULL, C_NAME VARCHAR(25) NOT NULL, C_ADDRESS VARCHAR(40) NOT NULL, C_NATIONKEY INTEGER NOT NULL, C_PHONE CHAR(15) NOT NULL, C_ACCTBAL DECIMAL(15,2)   NOT NULL, C_MKTSEGMENT CHAR(10) NOT NULL, C_COMMENT VARCHAR(117) NOT NULL)
go
CREATE TABLE ORDERS ( O_ORDERKEY INTEGER NOT NULL, O_CUSTKEY INTEGER NOT NULL, O_ORDERSTATUS CHAR(1) NOT NULL, O_TOTALPRICE DECIMAL(15,2) NOT NULL, O_ORDERDATE DATE NOT NULL, O_ORDERPRIORITY CHAR(15) NOT NULL, O_CLERK CHAR(15) NOT NULL, O_SHIPPRIORITY INTEGER NOT NULL, O_COMMENT VARCHAR(79) NOT NULL)
go
CREATE TABLE LINEITEM ( L_ORDERKEY INTEGER NOT NULL, L_PARTKEY INTEGER NOT NULL, L_SUPPKEY INTEGER NOT NULL, L_LINENUMBER INTEGER NOT NULL, L_QUANTITY DECIMAL(15,2) NOT NULL, L_EXTENDEDPRICE DECIMAL(15,2) NOT NULL, L_DISCOUNT DECIMAL(15,2) NOT NULL, L_TAX DECIMAL(15,2) NOT NULL, L_RETURNFLAG CHAR(1) NOT NULL, L_LINESTATUS CHAR(1) NOT NULL, L_SHIPDATE DATE NOT NULL, L_COMMITDATE DATE NOT NULL, L_RECEIPTDATE DATE NOT NULL, L_SHIPINSTRUCT CHAR(25) NOT NULL, L_SHIPMODE CHAR(10) NOT NULL, L_COMMENT VARCHAR(44) NOT NULL)
go
grant all on NATION to TPCH
go
grant all on REGION to TPCH
go
grant all on PART to TPCH
go
grant all on SUPPLIER to TPCH
go
grant all on PARTSUPP to TPCH
go
grant all on CUSTOMER to TPCH
go
grant all on ORDERS to TPCH
go
grant all on LINEITEM to TPCH
go
commit
go
EOSQL
/opt/sybase/OCS-16_0/bin/isql -Usa -PmyPassword -SMYSYBASE -i"./init4.sql"
echo =============== Load Data from tbl==========================

bcp $SYBASE_DB.dbo.NATION in /tmp/nation.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE
bcp $SYBASE_DB.dbo.REGION in /tmp/region.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE
bcp $SYBASE_DB.dbo.PART in /tmp/part.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE
bcp $SYBASE_DB.dbo.SUPPLIER in /tmp/supplier.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE
bcp $SYBASE_DB.dbo.PARTSUPP in /tmp/partsupp.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE
bcp $SYBASE_DB.dbo.CUSTOMER in /tmp/customer.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE
bcp $SYBASE_DB.dbo.ORDERS in /tmp/orders.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE
bcp $SYBASE_DB.dbo.LINEITEM in /tmp/lineitem.tbl -c -t "|" -r "\n" -Usa -PmyPassword -SMYSYBASE

#trap 
while [ "$END" == '' ]; do
			sleep 1
			trap "/etc/init.d/sybase stop && END=1" INT TERM
done

