# import hive context
import org.apache.spark.sql.hive.HiveContext
val hc = new HiveContext(sc)

/**hive select
   department_delim is not compressed with snappy
   hdfs dfs -ls /user/hive/warehouse/department_delim
  */
val deptRDD = hc.sql("select * from department_delim") 
deptRDD.collect.foreach(println)

/**hive insert
   check in hdfs before and after; a staging folder will be created by this command
   hdfs dfs -ls /user/hive/warehouse/department_delim
   hdfs dfs -cat /user/hive/warehouse/department_delim/*
  */
hc.sql("insert into department_delim select temp.* from (select 299, 'AdminX') temp")

/**hive create table as
   hive> select * from dept_hc;
   $ hdfs dfs -ls /user/hive/warehouse/dept_hc
   $ hdfs dfs -cat /user/hive/warehouse/dept_hc/*
  */
hc.sql("create table dept_hc as select  * from department_delim")
