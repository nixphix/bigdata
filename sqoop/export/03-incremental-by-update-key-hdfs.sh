#----------- using incremental import parameters -----------#
#--- data to this export is sourced by import script -> bigdata/sqoop/import/06-custom-import-for-export-demo.sh
#--- copy data to export dir
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/customers_custom/{01..05}
hdfs dfs -cp staging/sq_import/retail_db/customers_custom/01/* staging/sq_export/retail_db/customers_custom/01
hdfs dfs -ls -R /user/cloudera/staging/sq_export/retail_db/customers_custom/

#--- create target and staging table in mysql
#--- tgt table modeled after retail db and stg table without key contraint
mysql -u root -pcloudera 
CREATE TABLE sq_export.customers_inc LIKE retail_db.customers;
CREATE TABLE sq_export.customers_inc_stg AS SELECT * FROM retail_db.customers LIMIT 0;
ALTER TABLE sq_export.customers_inc_stg MODIFY customer_id int NOT NULL;
DESC sq_export.customers_inc;
DESC sq_export.customers_inc_stg;

#-----------            initial insert            ----------#
#--- now the tgt table is empty all the records will be exported
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--staging-table customers_inc_stg \
--table customers_inc \
--export-dir /user/cloudera/staging/sq_export/retail_db/customers_custom/01 \
--num-mappers 1

#--- check data in table
SELECT * FROM sq_export.customers_inc;

#-----------           update only mode           ----------#
#--- prepare data for update in hdfs
#--- lets change city,state and zip forcustomer with id 1 
#--- "Brownsville,TX,78521" will become "Farmville,FB,00000"
#--- modified data will be writen to hdfs 
hdfs dfs -cat /user/cloudera/staging/sq_export/retail_db/customers_custom/01/* \
| sed 's/Brownsville,TX,78521/Farmville,FB,00000/' \
| hdfs dfs -put - /user/cloudera/staging/sq_export/retail_db/customers_custom/02/data.csv

#--- now run export with update key as customer id in update only mode
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--table customers_inc \
--update-key customer_id \
--update-mode updateonly \
--export-dir /user/cloudera/staging/sq_export/retail_db/customers_custom/02 \
--num-mappers 1

#--- lets check data in table
SELECT * FROM sq_export.customers_inc;
