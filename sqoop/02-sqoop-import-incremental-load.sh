#---------------------------------------------------------#
# incremental load with orders table as text file
# first load
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table orders \
--as-textfile \
--where 'EXTRACT(YEAR FROM order_date) = 2013 AND EXTRACT(MONTH FROM order_date) = 07' \
--target-dir /user/cloudera/staging/sq_import/retail_db/orders_partition/ \
-m 1

# second load
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table orders \
--as-textfile \
--where 'EXTRACT(YEAR FROM order_date) = 2013 AND EXTRACT(MONTH FROM order_date) = 08' \
--target-dir /user/cloudera/staging/sq_import/retail_db/orders_partition/ \
--append \
-m 1

# check data in hdfs
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/orders_partition/

hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/orders/year*month=07/part*
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/orders/year*month=08/part*

