#----------- without using incremental import parameters -----------#
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
--as-textfile \
--table orders \
--columns  order_id,order_date,order_customer_id,order_status \
--where 'EXTRACT(YEAR FROM order_date) = 2013 AND EXTRACT(MONTH FROM order_date) = 08' \
--target-dir /user/cloudera/staging/sq_import/retail_db/orders_partition/ \
--append \
-m 1

# check data in hdfs
hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/orders_partition/
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/orders_partition/part*

# third load, limiting data by boundary query (just a hack not a proper solution)
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--as-textfile \
--table orders \
--boundary-query "select min(order_date),max(order_date) \
  from orders where extract(year from order_date)=2013 \
  and extract(month from order_date)=09" \
--split-by order_date \
--target-dir /user/cloudera/staging/sq_import/retail_db/orders_partition \
--append \
--num-mappers 1

hdfs dfs -ls -R /user/cloudera/staging/sq_import/retail_db/orders_partition/
hdfs dfs -cat   /user/cloudera/staging/sq_import/retail_db/orders_partition/part*2

# cleanup
# hdfs dfs -rm -R /user/cloudera/staging/sq_import/retail_db/orders_partition
# hdfs dfs -rm /user/cloudera/staging/sq_import/retail_db/orders_partition/part*2
