#-----------  using field and line delimiters  -----------#
# data preparation in mysql
# mysql -u retail_dba -pcloudera -h quickstart.cloudera retail_db
# create table delimiters_test(id int not null auto_increment, text varchar(100), null_num int default null, primary key (id));
# insert into delimiters_test value(1,'hello world!',null);
# insert into delimiters_test value(2,'hello world!',10);
# insert into delimiters_test value(3,null,null);

# import the table with | as field & \n as line delimiter and replace number null with -1 & string nulls with 'NULL-STR'
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table delimiters_test \
--fields-terminated-by '|' \
--lines-terminated-by '\n' \
--null-non-string -1 \
--null-string 'NULL-STR' \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db \
--delete-target-dir \
-m 1

# check in hdfs 
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/delimiters_test
hdfs dfs -cat   /user/cloudera/staging/sq_import/retail_db/delimiters_test/part-m-00000
