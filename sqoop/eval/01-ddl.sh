#-----------  following eval job creates staging and sqoop export database  -----------#

sqoop eval \
--connect jdbc:mysql://quickstart.cloudera:3306 \
--username root \
--password cloudera \
--query "create database if not exists staging;" 

sqoop eval \
--connect jdbc:mysql://quickstart.cloudera:3306 \
--username root \
--password cloudera \
--query "create database if not exists sq_export;" 

