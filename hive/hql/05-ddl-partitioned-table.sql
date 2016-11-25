------------------------------------------------------------------------
--  creating partitioned table in retail db with existing table data  --
------------------------------------------------------------------------

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
