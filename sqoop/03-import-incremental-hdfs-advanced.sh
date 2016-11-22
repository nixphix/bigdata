#----------- using incremental import parameters -----------#
#-----------             append mode             -----------#
# data preparation in mysql
# mysql -u retail_dba -pcloudera -h quickstart.cloudera retail_db
# create table orders_append as select * from orders where order_date < '2013-08-01 00:00:00';
# select count(1) from orders_append ; -- use this count with wc output in hdfs
# now import the orders_append table via sqoop

# first import 
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table orders_append \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db \
--num-mappers 1

# check data in hdfs
# hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/orders_append/part*
# hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/orders_append/part*0 | wc -l

# data preparation in mysql
# select count(1) from orders_append ; -- use this count with wc output in hdfs
# insert into orders_append select * from orders where order_date between '2013-08-01 00:00:00' and '2013-08-31 23:59:59';

# second import
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table orders_append \
--check-column order_date \
--incremental append \
--last-value '2013-07-31-23:59:59' \
--warehouse-dir /user/cloudera/staging/sq_import/retail_db \
--num-mappers 1

# check data in hdfs
# hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/orders_append/part*
# hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/orders_append/part*1 | wc -l

# parameter settings suggested by sqoop for next delta import
# following arguments:
# INFO tool.ImportTool:  --incremental append
# INFO tool.ImportTool:   --check-column order_date
# INFO tool.ImportTool:   --last-value 2013-08-31 00:00:00.0


#-----------          lastmodified mode          -----------#
