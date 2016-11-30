----------------------------------------------------------------------
--  creating hive table with avro data file and an external schema  --
----------------------------------------------------------------------

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

---notice that hive ordered the data for each table not for entire data
SELECT * FROM retail_db.departments_avro_data order by 1;

