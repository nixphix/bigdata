#--------------------  creating avro and avsc file  --------------------#
#--- creating avro files with sqoop 
# create local folder for avsc file
mkdir -p ~/data/avro
cd ~/data/avro
ls -ltr

#--- first import
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
hdfs dfs -get /user/cloudera/staging/avro/retail_db/departments/part-m-00000.avro ~/data/avro/part-m-00000-departments.avro

# check local file for java, avsc and avro file
ls -ltr
cat sqoop_import_departments.avsc
view part-m-00000-departments.avro


#--- second import
#--- preparing data in mysql
mysql -u retail_dba -pcloudera retail_db
create table dept_avro as select * from departments ;
select * from dept_avro;
desc dept_avro;
alter table dept_avro alter department_id set default -1;
desc dept_avro;

# import departments table as avro file
sqoop import \
--connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username retail_dba \
--password cloudera \
--table dept_avro \
--as-avrodatafile \
--target-dir /user/cloudera/staging/avro/retail_db/dept_avro \
-m 1

# check data in hdfs and copy it to local
hdfs dfs -ls -R /user/cloudera/staging/avro/retail_db/dept_avro
hdfs dfs -get /user/cloudera/staging/avro/retail_db/dept_avro/part-m-00000.avro ~/data/avro/part-m-00000-dept.avro

# check local file for avsc and avro file
# note that eventhough the source table has -1 as default value for department_id avro file indicates null as default
ls -ltr
cat sqoop_import_dept_avro.avsc
view part-m-00000-dept.avro
