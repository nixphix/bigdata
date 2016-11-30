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

--- load data into table
