val textRDD = sc.textFile("/user/cloudera/sqoop_import/departments_txt")
textRDD.saveAsTextFile("/user/cloudera/spark-shell/output/departments_txt")
textRDD.saveAsObjectFile("/user/cloudera/spark-shell/output/departments_obj")

hdfs dfs -ls spark-shell/output
hdfs dfs -cat spark-shell/output/departments_txt/*
hdfs dfs -cat spark-shell/output/departments_obj/*

# read/write sequence file
# import hadoop lib for null writable data type
import org.apache.hadoop.io._
textRDD.map(row => (NullWritable.get(),row)).saveAsSequenceFile("/user/cloudera/spark-shell/output/departments_seq_null_txt")
textRDD.map(row => (row.split(",")(0).toInt,row.split(",")(1))).saveAsSequenceFile("/user/cloudera/spark-shell/output/departments_seq_intw_txt")

# import lib to use mr output 
import org.apache.hadoop.mapreduce.lib.output._
val path = "/user/cloudera/spark-shell/output/departments_seq_intw_txt_NewAPI"
textRDD.map(row => (new IntWritable(row.split(",")(0).toInt),new Text(row.split(",")(1)))).saveAsNewAPIHadoopFile(path, classOf[IntWritable], classOf[Text], classOf[SequenceFileOutputFormat[IntWritable,Text]])

