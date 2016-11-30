-------------------------------------------------
--  creating partitioned table in static mode  --
-------------------------------------------------

-- set hive config for static partitioning
set hive.exec.dynamic.partition=false;
set hive.exec.dynamic.partition.mode=strict;

-- create temp store for files in hdfs 
dfs -mkdir -p /user/cloudera/staging/ephemeral/hive/orders-2014-01;

-- get the data from already partitioned data or from sqoop
dfs -ls /user/hive/warehouse/retail_db.db/orders_part_2;
dfs -cp /user/hive/warehouse/retail_db.db/orders_part_2/order_month=1/o*2014/00* staging/ephemeral/hive/orders-2014-01;
dfs -ls -R staging/ephemeral/hive/orders-2014-01;

-- create table with partition column
CREATE TABLE IF NOT EXISTS retail_db.orders_part_stat (
order_id int,
order_date date,
order_customer_id int,
order_status string )
PARTITIONED BY (order_year int, order_month int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- add partition
ALTER TABLE retail_db.orders_part_stat ADD PARTITION (order_year=2014,order_month=01);

-- insert from staging table
INSERT INTO retail_db.orders_part_stat PARTITION (order_year=2014, order_month=02)
SELECT order_id, to_date(order_date) order_date, order_customer_id,
order_status FROM default.orders WHERE year(order_date)=2014 AND month(order_date)=02 ;

-- load data from hdfs 
LOAD DATA INPATH '/user/cloudera/staging/ephemeral/hive/orders-2014-01/000000_0'
INTO TABLE retail_db.orders_part_stat PARTITION (order_year=2014,order_month=01);

-- check data in hdfs
dfs -ls -R /user/hive/warehouse/retail_db.db/orders_part_stat/;
