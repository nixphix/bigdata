------------------------------------------------------------------------------
--  creating partitioned table in non strict mode, data feed from fs/hdfs   --
------------------------------------------------------------------------------

-- set hive config for dynamic partitioning
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

-- create temp store for files in hdfs 
dfs -mkdir -p /user/cloudera/staging/ephemeral/hive/orders-2014-01;

-- get the data from already partitioned data or from sqoop
dfs -ls /user/hive/warehouse/retail_db.db/orders_part_2;
dfs -cp /user/hive/warehouse/retail_db.db/orders_part_2/order_month=1/*2014/00*	 staging/ephemeral/hive/orders-2014-01;
dfs -ls -R staging/ephemeral/hive/orders-2014-01;

-- create table with partition column
CREATE TABLE IF NOT EXISTS retail_db.orders_part_fs (
order_id int,
order_date date,
order_customer_id int,
order_status string )
PARTITIONED BY (order_year int, order_month int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- load data from hdfs 
LOAD DATA INPATH '/user/cloudera/staging/ephemeral/hive/orders-2014-01/000000_0'
INTO TABLE retail_db.orders_part_fs PARTITION (order_year=2014,order_month=01);

-- check the data
SELECT * FROM retail_db.orders_part_fs limit 10;
SELECT * FROM retail_db.orders_part_fs where order_month=01 limit 10;

-- check data in hdfs
dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_part_fs;


