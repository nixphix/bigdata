/************** hive context **************/
/* import hive context */
import org.apache.spark.sql.hive.HiveContext
val hc = new HiveContext(sc)

/** hive select 
 *  department_delim is not compressed with snappy
 *  hdfs dfs -ls /user/hive/warehouse/department_delim
 */
val deptRDD = hc.sql("select * from department_delim") 
deptRDD.collect.foreach(println)

/** hive insert
 *  check in hdfs before and after; a staging folder will be created by this command
 *  hdfs dfs -ls /user/hive/warehouse/department_delim
 *  hdfs dfs -cat /user/hive/warehouse/department_delim/*
 */
hc.sql("insert into department_delim select temp.* from (select 299, 'AdminX') temp")

/** hive create table as
 *  hive> select * from dept_hc;
 *  $ hdfs dfs -ls /user/hive/warehouse/dept_hc
 *  $ hdfs dfs -cat /user/hive/warehouse/dept_hc/*
 */
hc.sql("create table dept_hc as select  * from department_delim")

/************** json file io **************/
/** copy json input file to hdfs
 *  cd /home/cloudera/spark/dataset
 *  wget https://raw.githubusercontent.com/nixphix/bigdata/work-in-progress/spark/employees.json
 *  hdfs dfs -mkdir dataset
 *  hdfs dfs -copyFromLocal employees.json dataset
 *  hdfs dfs -cat dataset/*
 *  import and create sql context
 */
import org.apache.spark.sql.SQLContext
val sqlc = new SQLContext(sc)

// read json file
val jsonRDD = sqlc.jsonFile("dataset/employees.json")
jsonRDD.show()
jsonRDD.collect.foreach(println)

// querying json data as table 
jsonRDD.registerTempTable("Employee")
sqlc.sql("select * from Employee").collect.foreach(println)

/** save RDD data as json 
 *  check output in hdfs
 *  hdfs dfs -ls dataset/departments.json/*
 *  hdfs dfs -cat dataset/departments.json/*
 */
deptRDD.collect.foreach(println)
deptRDD.toJSON.saveAsTextFile("dataset/departments.json")

