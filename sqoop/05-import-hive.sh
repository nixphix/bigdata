#--------------------  hive import  --------------------#
#--- data preparation in mysql
# create table hive_import as select * from delimiters_test;
# select * from hive_import;

#--- first import
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table hive_import \
--hive-import \
--create-hive-table \
--hive-table retail_db.hive_import \
--num-mappers 1
