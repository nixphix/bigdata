#--------------------  creating avro and avsc file  --------------------#
#--- creating avro files with sqoop 
# create local folder for avsc file
mkdir -p ~/data/avro
cd ~/data/avro
ls -ltr

# import departments table as avro file
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table departments \
--as-avrodatafile \
--target-dir /user/cloudera/staging/avro/retail_db/departments \
-m 1

# check data in hdfs and copy it to local
hdfs dfs -ls -R /user/cloudera/staging/avro/retail_db/departments
hdfs dfs -get /user/cloudera/staging/avro/retail_db/departments/part-m-00000.avro ~/data/avro

# check local file for java, avsc and avro file
ls -ltr
cat departments.avsc
view departments.avro

#--- preparing data in mysql
mysql -u retail_dba -pcloudera retail_db
create table dept_avro as select * from departments ;
select * from dept;
desc dept;
alter table dept alter department_id set default -1
desc dept;

# import departments table as avro file
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table dept \
--as-avrodatafile \
--target-dir /user/cloudera/staging/avro/retail_db/dept \
-m 1

# check data in hdfs and copy it to local
hdfs dfs -ls -R /user/cloudera/staging/avro/retail_db/dept
hdfs dfs -get /user/cloudera/staging/avro/retail_db/dept/part-m-00000.avro ~/data/avro

# check local file for avsc and avro file
# note that eventhough the source table has -1 as default value for department_id avro file indicates null as default
ls -ltr
cat dept.avsc
view dept.avro

#--- following will list the avro tools
avro-tools

