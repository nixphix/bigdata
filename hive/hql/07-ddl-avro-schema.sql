----------------------------------------------------------------------
--  creating hive table with avro data file and an external schema  --
----------------------------------------------------------------------

--- departments table
--- data preparation is here master/avro/avro-tools/01-avro-data-preparation.sh
dfs -put ~/data/avro/sqoop_import_departments.avsc /user/cloudera/staging/avro/schema/departments/sqoop_import_departments.avsc ;
dfs -ls /user/cloudera/staging/avro/schema/departments/sqoop_import_departments.avsc ;

--- create a managed hive table as follows
CREATE TABLE IF NOT EXISTS retail_db.departments_avro_data 
STORED AS AVRO
LOCATION '/user/cloudera/staging/avro/retail_db/departments/'
TBLPROPERTIES ( 'avro.schema.url'='/user/cloudera/staging/avro/schema/departments/sqoop_import_departments.avsc');

--- check data in hive
SELECT * FROM retail_db.departments_avro_data;

--- if data is not present in the location it can be loaded
LOAD DATA LOCAL INPATH '/home/cloudera/data/avro/part-m-00000-departments.avro' INTO TABLE retail_db.departments_avro_data;

--- notice that hive ordered the data for each table not for entire data
SELECT * FROM retail_db.departments_avro_data order by 1;


--- orders table
CREATE TABLE IF NOT EXISTS  retail_db.orders_avro
STORED AS AVRO
TBLPROPERTIES ('avro.schema.literal'='
{
  "type" : "record",
  "name" : "sqoop_import_orders",
  "doc" : "Sqoop import of orders",
  "fields" : [ {
    "name" : "order_id",
    "type" : [ "int", "null" ],
    "columnName" : "order_id",
    "sqlType" : "4"
  }, {
    "name" : "order_date",
    "type" : [ "long", "null" ],
    "columnName" : "order_date",
    "sqlType" : "93"
  }, {
    "name" : "order_customer_id",
    "type" : [ "int", "null" ],
    "columnName" : "order_customer_id",
    "sqlType" : "4"
  }, {
    "name" : "order_status",
    "type" : [ "string", "null" ],
    "columnName" : "order_status",
    "sqlType" : "12"
  } ],
  "tableName" : "orders"
}
');

--- desc the table
DESCRIBE FORMATTED retail_db.orders_avro;

--- load data into table
LOAD DATA INPATH '/user/cloudera/staging/sq_import/retail_db/orders_avro/part-m-00000.avro' INTO TABLE retail_db.orders_avro;

--- check data in the table, notice that date is coverted to unix timestamp bigint (milli second)
SELECT * FROM retail_db.orders_avro limit 10;

--- convert unix timestamp to date format
SELECT order_id, FROM_UNIXTIME(cast(order_date/1000 as int)) date, order_customer_id, order_status 
FROM retail_db.orders_avro limit 10;

--- extract month and year from the unix timestamp
SELECT month(FROM_UNIXTIME(cast(order_date/1000 as int))), 
year(FROM_UNIXTIME(cast(order_date/1000 as int))) 
FROM retail_db.orders_avro limit 10;
