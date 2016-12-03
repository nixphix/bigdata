#--- make a staging diractory for all sqoop exports 
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/departments
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/departments_seq
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/departments_avro
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/departments_parq
hdfs dfs -mkdir -p /user/cloudera/staging/sq_export/retail_db/departments_zip

#--- create table departments in sq_export database
create table sq_export.departments like retail_db.departments;


#---------------------------------------------------------#
#--- export text data to database sq_export
#--- copy text data to export
hdfs dfs -cp /user/cloudera/staging/sq_import/retail_db/departments/* /user/cloudera/staging/sq_export/retail_db/departments

#--- source data is in text format, fields terminated by ',' and lines terminated by '\n'
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--export-dir /user/cloudera/staging/sq_export/retail_db/departments \
--table departments \
--direct 

#--- check data in target table and source
SELECT * FROM sq_export.departments;
hdfs dfs -cat /user/cloudera/staging/sq_export/retail_db/departments/*


#---------------------------------------------------------#
#--- export sequence file data to database sq_export
#--- copy data to export
hdfs dfs -cp /user/cloudera/staging/sq_import/retail_db/departments_seq/* /user/cloudera/staging/sq_export/retail_db/departments_seq

#--- truncate target table
truncate sq_export.departments;

#--- source data is in sequence file format
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--export-dir /user/cloudera/staging/sq_export/retail_db/departments_seq \
--table departments \
--num-mappers 1

#--- check data in target table and source
SELECT * FROM sq_export.departments;


#---------------------------------------------------------#
#--- export avro data to database sq_export
#--- copy data to export
hdfs dfs -cp /user/cloudera/staging/sq_import/retail_db/departments_avro/* /user/cloudera/staging/sq_export/retail_db/departments_avro

#--- truncate target table
truncate sq_export.departments;

#--- source data is in avro format
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--export-dir /user/cloudera/staging/sq_export/retail_db/departments_avro \
--table departments \
--num-mappers 1

#--- check data in target table and source
SELECT * FROM sq_export.departments;


#---------------------------------------------------------#
#--- export parquet data to database sq_export
#--- copy data to export
hdfs dfs -cp /user/cloudera/staging/sq_import/retail_db/departments_parq/* /user/cloudera/staging/sq_export/retail_db/departments_parq

#--- truncate target table
truncate sq_export.departments;

#--- source data is in parquet format
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--export-dir /user/cloudera/staging/sq_export/retail_db/departments_parq \
--table departments \
--num-mappers 1

#--- check data in target table and source
SELECT * FROM sq_export.departments;


#---------------------------------------------------------#
#--- export compressed data to database sq_export
#--- copy data to export
hdfs dfs -cp /user/cloudera/staging/sq_import/retail_db/departments_zip/* /user/cloudera/staging/sq_export/retail_db/departments_zip

#--- truncate target table
truncate sq_export.departments;

#--- source data is compressed
sqoop export \
--connect jdbc:mysql://quickstart.cloudera:3306/sq_export \
--username root \
--password cloudera \
--export-dir /user/cloudera/staging/sq_export/retail_db/departments_zip \
--table departments \
--num-mappers 1

#--- check data in target table and source
SELECT * FROM sq_export.departments;

