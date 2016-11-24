#--------------------  hive import  --------------------#
#--- data preparation in mysql
# create table hive_import as select * from delimiters_test;
# select * from hive_import;
# make sure the table has four records

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

# describe table in hive, note that it is created with \001 and \n as field and row delimiters
USE retail_db;
DESCRIBE FORMATTED hive_import;

# check in hive if the data is correctly loaded
SELECT * FROM hive_import;

# in below queries you see that numeric nulls are detected by hive but string null is not
# null text in int column is recognized by hive but the null text in string columns is not recognized as null
SELECT * FROM hive_import WHERE id IS NULL;
SELECT * FROM hive_import WHERE null_num IS NULL;
SELECT * FROM hive_import WHERE text IS NULL;

# check the data file in hdfs, file path will be available in describe
# when working in a cluster it is better to use fully qualified hdfs path
# in the file null values in mysql have been exported as 'null' text instead of hive null representation  of \N
hdfs dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/hive_import 


#---second import
# with \N as null value placeholder
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table hive_import \
--null-string '\\N' \
--null-non-string '\\N' \
--hive-import \
--hive-overwrite \
--hive-table retail_db.hive_import \
--num-mappers 1

# now check the hive table if the text column is recognized as null
SELECT * FROM hive_import WHERE null_num IS NULL;
SELECT * FROM hive_import WHERE text IS NULL;

# check the data file in hdfs, notice that '\N' is used in lieu of "null" text
hdfs dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/hive_import 


#---third import
# , and \n as field and row delimiter respectively
# with \N as null value placeholder
hive -e "drop table retail_db.hive_import;"
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table hive_import \
--fields-terminated-by ',' \
--lines-terminated-by '\n' \
--null-string '\\N' \
--null-non-string '\\N' \
--hive-import \
--create-hive-table \
--hive-table retail_db.hive_import \
--num-mappers 1


# describe table in hive, note that it is created with , and \n as field and row delimiters
USE retail_db;
DESCRIBE FORMATTED hive_import;

# check the data file in hdfs
hdfs dfs -ls -R hdfs://quickstart.cloudera:8020/user/hive/warehouse/retail_db.db/hive_import 

# check the hive table
# notice that the comma in text column in the fourth record conflicts with the field separator
# sqoop can not handle this kind of issue unless hive default separators are used
SELECT * FROM hive_import;

