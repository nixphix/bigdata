#----------- without incremental import parameters -----------#
#--- make staging directory for sqoop exports
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/orders_append/order_date=2013-07
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/orders_append/order_date=2013-08
hdfs dfs -ls -R /user/cloudera/staging/sq_export/retail_db/orders_append

#--- copy data files to respective partition directory
hdfs dfs -cp /user/cloudera/staging/sq_import/retail_db/orders_append/part-m-00000 \
/user/cloudera/staging/sq_export/retail_db/orders_append/order_date=2013-07

hdfs dfs -cp /user/cloudera/staging/sq_import/retail_db/orders_append/part-m-00001 \
/user/cloudera/staging/sq_export/retail_db/orders_append/order_date=2013-08

hdfs dfs -ls -R /user/cloudera/staging/sq_export/retail_db/orders_append

#--- create export table in mysql
#--- like clause will include primary constraint and autoincrement while creating table
CREATE TABLE sq_export.orders_append LIKE retail_db.orders;

#--- create staging table to stage data before inserting into target table
#--- staging table should not have any constraints like primary key which is why ctas is used to capture only column metadata
CREATE TABLE sq_export.orders_append_stg as select * from sq_export.orders_append limit 0;
ALTER TABLE  sq_export.orders_append_stg MODIFY order_id int not null;


#---------------------------------------------------------#
#--- first export 
#--- source data in hdfs, order date month should be 2013-07
hdfs dfs -cat staging/sq_export/retail_db/orders_append/order_date=2013-07/* | awk -F ',' '{print $2}' | cut -c1-7 | uniq

#--- export orders text data for 2013/07 month
#--- as the target table is empty update key and update mode are not necessary, no need to truncate staging table as well
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--staging-table orders_append_stg \
--table orders_append \
--export-dir /user/cloudera/staging/sq_export/retail_db/orders_append/order_date=2013-07 \
--num-mappers 1

#--- now check data in stg and tgt tables
#--- stg will be truncated after migrating data to tgt
SELECT * FROM sq_export.orders_append_stg LIMIT 5;
SELECT * FROM sq_export.orders_append LIMIT 5;
SELECT count(1) FROM sq_export.orders_append;

#--- check the year-month of the current data
SELECT DISTINCT  EXTRACT(YEAR FROM order_date) yr, EXTRACT(MONTH FROM order_date) mth FROM sq_export.orders_append;


#---------------------------------------------------------#
#--- second export 
#--- source data in hdfs, order date month should be 2013-08
hdfs dfs -cat staging/sq_export/retail_db/orders_append/order_date=2013-08/* | awk -F ',' '{print $2}' | cut -c1-7 | uniq

#--- insert data into stg table to see if that gets to tgt if stg table is not cleared explicitly
INSERT INTO sq_export.orders_append_stg VALUES (-1,CURRENT_TIMESTAMP(),-1,'CLOSED')

#--- check the data in stg and tgt tables
SELECT * FROM sq_export.orders_append_stg ;
SELECT DISTINCT  EXTRACT(YEAR FROM order_date) yr, EXTRACT(MONTH FROM order_date) mth FROM sq_export.orders_append;

#--- export orders text data for 2013/08 month
#--- as the target table already have 2013/07 data 
#--- this part file do not contain any data with same primary key, so its going to be insert-only
#--- we are exporting with out --clear-staging-table option to truncate stg table before loading data from hdfs
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--staging-table orders_append_stg \
--table orders_append \
--export-dir /user/cloudera/staging/sq_export/retail_db/orders_append/order_date=2013-08 \
--num-mappers 1

#--- sqoop export will fail with error message that stg table is non-empty
#--- run the same command with --clear-staging-table option to truncate stg table
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--clear-staging-table \
--staging-table orders_append_stg \
--table orders_append \
--export-dir /user/cloudera/staging/sq_export/retail_db/orders_append/order_date=2013-08 \
--num-mappers 1

#--- now check data in stg and tgt tables
#--- stg will be truncated after migrating data to tgt
SELECT * FROM sq_export.orders_append_stg ;
SELECT * FROM sq_export.orders_append LIMIT 5;
SELECT count(1) FROM sq_export.orders_append;

#--- check the year-month of the current data
SELECT DISTINCT  EXTRACT(YEAR FROM order_date) yr, EXTRACT(MONTH FROM order_date) mth FROM sq_export.orders_append;


