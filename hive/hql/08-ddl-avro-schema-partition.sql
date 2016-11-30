--------------------------------------------------------
--  creating partitioned hive table with avro format  --
--------------------------------------------------------

--- data source data import given here bigdata/sqoop/01-import-simple.sh
dfs -ls -R /user/cloudera/staging/sq_import/retail_db/orders_avro;
! cat /home/cloudera/data/avro/sqoop_import_orders.avsc;
dfs -mkdir -p /user/cloudera/staging/avro/schema/orders;
dfs -put /home/cloudera/data/avro/sqoop_import_orders.avsc /user/cloudera/staging/avro/schema/orders;
dfs -ls /user/cloudera/staging/avro/schema/orders;

--- create hive partitioned table
CREATE TABLE IF NOT EXISTS  retail_db.orders_avro_part
PARTITIONED BY (order_month int)
STORED AS AVRO
TBLPROPERTIES ('avro.schema.url'='/user/cloudera/staging/avro/schema/orders/sqoop_import_orders.avsc');

--- desc the table
DESCRIBE FORMATTED retail_db.orders_avro_part;

--- check hive partition settings, mode will be strict
set hive.exec.dynamic.partition;
set hive.exec.dynamic.partition.mode;

--- add partition, try 9 & 09 and see which one gets the data
ALTER TABLE retail_db.orders_avro_part ADD PARTITION(order_month=09);
ALTER TABLE retail_db.orders_avro_part ADD PARTITION(order_month=9);

--- check partition folders
dfs -ls hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_avro_part;

--- load data into table from retail_db.orders_avro
FROM retail_db.orders_avro
INSERT INTO retail_db.orders_avro_part PARTITION (order_month=9)
SELECT * 
WHERE month(FROM_UNIXTIME(cast(order_date/1000 as int))) = 9;

--- check partition folders
dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_avro_part;
dfs -rm -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_avro_part/order_month=09;

--- now switch partition mode to nonstrict to load dynamically
set hive.exec.dynamic.partition.mode=nonstrict;

--- lets load data for rest of the month
FROM retail_db.orders_avro o
INSERT INTO retail_db.orders_avro_part PARTITION (order_month)
SELECT o.*, month(FROM_UNIXTIME(cast(o.order_date/1000 as int))) order_month
WHERE month(FROM_UNIXTIME(cast(o.order_date/1000 as int))) <> 9;

--- check folders and files on hdfs
dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/orders_avro_part;

--- check data in hive
SELECT * FROM retail_db.orders_avro_part limit 10;
