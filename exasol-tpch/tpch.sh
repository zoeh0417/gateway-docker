/home/EXAplus-6.2.9/exaplus -c localhost:8888 -u sys -p exasol  <<-EOF
CONNECT sys/exasol@127.0.0.1:8888;
create user tpch identified by "mstr123#";
create schema tpch;
grant all privileges to tpch WITH ADMIN OPTION;
grant all privileges on schema tpch to tpch ;
grant create session to tpch;
open schema tpch;
CREATE TABLE NATION  ( N_NATIONKEY  INTEGER NOT NULL,
                            N_NAME       CHAR(25) NOT NULL,
                            N_REGIONKEY  INTEGER NOT NULL,
                            N_COMMENT    VARCHAR(152));
CREATE TABLE REGION  ( R_REGIONKEY  INTEGER NOT NULL,
                            R_NAME       CHAR(25) NOT NULL,
                            R_COMMENT    VARCHAR(152));
CREATE TABLE PART  ( P_PARTKEY     INTEGER NOT NULL,
                          P_NAME        VARCHAR(55) NOT NULL,
                          P_MFGR        CHAR(25) NOT NULL,
                          P_BRAND       CHAR(10) NOT NULL,
                          P_TYPE        VARCHAR(25) NOT NULL,
                          P_SIZE        INTEGER NOT NULL,
                          P_CONTAINER   CHAR(10) NOT NULL,
                          P_RETAILPRICE DECIMAL(15,2) NOT NULL,
                          P_COMMENT     VARCHAR(23) NOT NULL );
CREATE TABLE SUPPLIER ( S_SUPPKEY     INTEGER NOT NULL,
                             S_NAME        CHAR(25) NOT NULL,
                             S_ADDRESS     VARCHAR(40) NOT NULL,
                             S_NATIONKEY   INTEGER NOT NULL,
                             S_PHONE       CHAR(15) NOT NULL,
                             S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                             S_COMMENT     VARCHAR(101) NOT NULL);
CREATE TABLE PARTSUPP ( PS_PARTKEY     INTEGER NOT NULL,
                             PS_SUPPKEY     INTEGER NOT NULL,
                             PS_AVAILQTY    INTEGER NOT NULL,
                             PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
                             PS_COMMENT     VARCHAR(199) NOT NULL );
CREATE TABLE CUSTOMER ( C_CUSTKEY     INTEGER NOT NULL,
                             C_NAME        VARCHAR(25) NOT NULL,
                             C_ADDRESS     VARCHAR(40) NOT NULL,
                             C_NATIONKEY   INTEGER NOT NULL,
                             C_PHONE       CHAR(15) NOT NULL,
                             C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                             C_MKTSEGMENT  CHAR(10) NOT NULL,
                             C_COMMENT     VARCHAR(117) NOT NULL);
CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER NOT NULL,
                           O_CUSTKEY        INTEGER NOT NULL,
                           O_ORDERSTATUS    CHAR(1) NOT NULL,
                           O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                           O_ORDERDATE      DATE NOT NULL,
                           O_ORDERPRIORITY  CHAR(15) NOT NULL,  
                           O_CLERK          CHAR(15) NOT NULL, 
                           O_SHIPPRIORITY   INTEGER NOT NULL,
                           O_COMMENT        VARCHAR(79) NOT NULL);
CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER NOT NULL,
                             L_PARTKEY     INTEGER NOT NULL,
                             L_SUPPKEY     INTEGER NOT NULL,
                             L_LINENUMBER  INTEGER NOT NULL,
                             L_QUANTITY    DECIMAL(15,2) NOT NULL,
                             L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
                             L_DISCOUNT    DECIMAL(15,2) NOT NULL,
                             L_TAX         DECIMAL(15,2) NOT NULL,
                             L_RETURNFLAG  CHAR(1) NOT NULL,
                             L_LINESTATUS  CHAR(1) NOT NULL,
                             L_SHIPDATE    DATE NOT NULL,
                             L_COMMITDATE  DATE NOT NULL,
                             L_RECEIPTDATE DATE NOT NULL,
                             L_SHIPINSTRUCT CHAR(25) NOT NULL,
                             L_SHIPMODE     CHAR(10) NOT NULL,
                             L_COMMENT      VARCHAR(44) NOT NULL);
IMPORT INTO tpch.nation FROM LOCAL CSV FILE '/home/TPCH/nation.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
IMPORT INTO tpch.region FROM LOCAL CSV FILE '/home/TPCH/region.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
IMPORT INTO tpch.part FROM LOCAL CSV FILE '/home/TPCH/part.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
IMPORT INTO tpch.supplier FROM LOCAL CSV FILE '/home/TPCH/supplier.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
IMPORT INTO tpch.partsupp FROM LOCAL CSV FILE '/home/TPCH/partsupp.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
IMPORT INTO tpch.customer FROM LOCAL CSV FILE '/home/TPCH/customer.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
IMPORT INTO tpch.orders FROM LOCAL CSV FILE '/home/TPCH/orders.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
IMPORT INTO tpch.lineitem FROM LOCAL CSV FILE '/home/TPCH/lineitem.csv' COLUMN SEPARATOR = '|' REJECT LIMIT 0;
exit;
EOF