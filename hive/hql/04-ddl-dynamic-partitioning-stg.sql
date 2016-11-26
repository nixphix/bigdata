------------------------------------------------------------------------------------
--  creating partitioned table in non strict mode, data feed from staging table   --
------------------------------------------------------------------------------------

-- set hive config for dynamic partitioning
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

-- create table with partition column
CREATE TABLE IF NOT EXISTS retail_db.orders_part (
order_id int,
order_date date,
order_customer_id int,
order_status string )
PARTITIONED BY (order_month string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- load data from existing table in staging.orders
INSERT INTO retail_db.orders_part PARTITION (order_month)
SELECT order_id, to_date(order_date) order_date, order_customer_id,
order_status, substr(order_date, 1, 7) order_month FROM default.orders;

-- check the data
SELECT * FROM retail_db.orders_part limit 10;
SELECT * FROM retail_db.orders_part where order_month='2013-09' limit 10;

-- check data in hdfs
dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_part;


----------------------------------------------------------------------------------------------------
--  creating partitioned table with two columns in non strict mode, data feed from staging table  --
----------------------------------------------------------------------------------------------------

-- create table with two partition column
CREATE TABLE IF NOT EXISTS retail_db.orders_part_2 (
order_id int,
order_date date,
order_customer_id int,
order_status string )
PARTITIONED BY (order_month int, order_year int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- load data from existing table in staging.orders
INSERT INTO retail_db.orders_part_2 PARTITION (order_month,order_year)
SELECT order_id, to_date(order_date) order_date, order_customer_id,
order_status, month(order_date) order_month, year(order_date) order_year FROM default.orders;

-- check the data
SELECT * FROM retail_db.orders_part_2 limit 10;
SELECT * FROM retail_db.orders_part_2 where order_month=09 limit 10;

-- check data in hdfs, notice that the folder is arranged as order_month/order_year
dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_part_2;

--- Now with correct order
-- create table with two partition column
CREATE TABLE IF NOT EXISTS retail_db.orders_part_3 (
order_id int,
order_date date,
order_customer_id int,
order_status string )
PARTITIONED BY (order_year int, order_month int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- load data from existing table in staging.orders
INSERT INTO retail_db.orders_part_3 PARTITION (order_month,order_year)
SELECT order_id, to_date(order_date) order_date, order_customer_id,
order_status, month(order_date) order_month, year(order_date) order_year FROM default.orders;

-- check data in hdfs 
-- notice that the folder is arranged as order_year/order_month but still there are 12 year folder !!! 
-- the orders in which you load also matters, in the insert statement month is feed first and then year second
-- so be mindfull of the order in which the partition columns are declared and loaded
dfs -ls hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_part_3;

-- check the data
-- this query will not return any value
SELECT * FROM retail_db.orders_part_3 where order_month=09 limit 10;
