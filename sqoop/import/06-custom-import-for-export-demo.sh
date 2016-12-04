#----------- using custom query parameter -----------#
#--- customer data for sqoop incremental export demo
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--query 'select * from customers where $CONDITIONS limit 5' \
--target-dir /user/cloudera/staging/sq_import/retail_db/customers_custom/01 \
--num-mappers 1

#--- check data in hdfs 
hdfs dfs -cat /user/cloudera/staging/sq_import/retail_db/customers_custom/01/*
