

USE MYSQL_DATABASE;
SOURCE /var/lib/mysql-files/dss.ddl;

load data  infile '/var/lib/mysql-files/region.tbl'   
into table REGION 
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n'; 


load data  infile '/var/lib/mysql-files/nation.tbl'   
into table NATION 
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n'; 

load data  infile '/var/lib/mysql-files/part.tbl'   
into table PART 
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n'; 

load data  infile '/var/lib/mysql-files/supplier.tbl'   
into table SUPPLIER 
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n'; 

load data  infile '/var/lib/mysql-files/partsupp.tbl'   
into table PARTSUPP 
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n';

load data  infile '/var/lib/mysql-files/customer.tbl'   
into table CUSTOMER 
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n'; 

load data  infile '/var/lib/mysql-files/orders.tbl'   
into table ORDERS
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n'; 

load data  infile '/var/lib/mysql-files/lineitem.tbl'   
into table LINEITEM 
fields terminated by '|' optionally enclosed by '"' escaped by '"'  
lines terminated by '\n';
