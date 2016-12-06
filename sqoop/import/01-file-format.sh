#!/bin/sh
# simple sqoop import from mysql
# mysql -h quickstart.cloudera -u retail_dba -pcloudera retail_db

# create the staging dir in hdfs
hdfs dfs -mkdir -p /user/cloudera/staging/sq_import/retail_db

#---------------------------------------------------------#
# import departments table from mysql
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table departments \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db #--target-dir /user/cloudera/staging/sq_import/retail_db/departments

# check data in hdfs
# note that folder departments have been created by sqoop, also find 4 part files created by default 4 mappers 
# and that output format is textfile with '\n'as row delimiter & ',' as field delimiter
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/departments/*

#---------------------------------------------------------#
# import departments table as sequence file
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table departments \
--target-dir /user/cloudera/staging/sq_import/retail_db/departments_seq \
--as-sequencefile \
--num-mappers 1

# check data in hdfs
# note that there is only one part file due to num mappers setting and the file is in binary format (not readable)
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/departments_seq
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/departments_seq/*

#---------------------------------------------------------#
# import departments table as avro file
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--query 'select * from departments where $CONDITIONS' \
--split-by department_id \
--target-dir /user/cloudera/staging/sq_import/retail_db/departments_avro \
--as-avrodatafile \
-m 2

# check data in hdfs
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/departments_avro
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/departments_avro/*

# check local file for avsc file, since this is a custom query the file will be named queryresult
ls -ltr
cat sqoop_import_QueryResult.avsc

#---------------------------------------------------------#
# import departments table as parquetfile
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table departments \
--as-parquetfile \
--target-dir /user/cloudera/staging/sq_import/retail_db/departments_parq \
--num-mappers 1

# check data in hdfs, note the additional files created for parquetfile format
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/departments_parq
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/departments_parq/*.parquet

#---------------------------------------------------------#
# import departments table and store it as compressed file
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table departments \
--as-textfile \
--compress \
--target-dir /user/cloudera/staging/sq_import/retail_db/departments_zip \
--num-mappers 1

# check data in hdfs
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/departments_zip
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/departments_zip/part-m-00000.gz

#---------------------------------------------------------#
# import orders table as avro file
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table orders \
--target-dir /user/cloudera/staging/sq_import/retail_db/orders_avro \
--as-avrodatafile \
--num-mappers 1

# check data in hdfs
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/orders_avro
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/orders_avro/*

# check local file for avsc file
ls -ltr
cat sqoop_import_orders.avsc
