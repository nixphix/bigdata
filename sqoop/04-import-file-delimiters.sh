#-----------  using field, line delimiters and null replacement  -----------#
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


# import the table with \001 as field & \n as line delimiter and use \N for null values which is the default in hive
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table delimiters_test \
--fields-terminated-by '\001' \
--lines-terminated-by '\n' \
--null-non-string '\\N' \
--null-string '\\N' \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db \
--delete-target-dir \
-m 1

# check in hdfs 
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/delimiters_test
hdfs dfs -cat   /user/cloudera/staging/sq_import/retail_db/delimiters_test/part-m-00000

#-----------  using escape and enclosed options  -----------#
# data preparation in mysql
# insert into delimiters_test value(4,'hello, world!',99);

# using escape literal to escape comma in text field
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table delimiters_test \
--as-textfile \
--escaped-by \\ \
--optionally-enclosed-by \" \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db \
--delete-target-dir \
--num-mappers 1

# check in hdfs 
hdfs dfs -cat   /user/cloudera/staging/sq_import/retail_db/delimiters_test/part-m-00000


# using enclose literal to enclose all the fields 
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table delimiters_test \
--as-textfile \
--enclosed-by \" \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db \
--delete-target-dir \
--num-mappers 1

# check in hdfs 
hdfs dfs -cat   /user/cloudera/staging/sq_import/retail_db/delimiters_test/part-m-00000


# using enclosed optionally literal to enclose the text having comma
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table delimiters_test \
--as-textfile \
--optionally-enclosed-by \" \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db \
--delete-target-dir \
--num-mappers 1

# check in hdfs 
hdfs dfs -cat   /user/cloudera/staging/sq_import/retail_db/delimiters_test/part-m-00000

