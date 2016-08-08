// read sample text file
val textRDD = sc.textFile("/user/cloudera/sqoop_import/departments_txt")

// save as text and object file
textRDD.saveAsTextFile("/user/cloudera/spark-shell/output/departments_txt")

// object file will be of type (NullWritable,BytesWritable)
textRDD.saveAsObjectFile("/user/cloudera/spark-shell/output/departments_obj")

/** check data in hdfs
  * hdfs dfs -ls spark-shell/output
  * hdfs dfs -cat spark-shell/output/departments_txt/*
  * hdfs dfs -cat spark-shell/output/departments_obj/*
  */
  
// import hadoop lib for null writable data type
import org.apache.hadoop.io._
// file output of type (NullWitable,Text)
textRDD.map(row => (NullWritable.get(),row)).saveAsSequenceFile("/user/cloudera/spark-shell/output/departments_seq_null_txt")
// file output of type (IntWitable,Text)
textRDD.map(row => (row.split(",")(0).toInt,row.split(",")(1))).saveAsSequenceFile("/user/cloudera/spark-shell/output/departments_seq_intw_txt")

// import lib to use mr output 
import org.apache.hadoop.mapreduce.lib.output._
val path = "/user/cloudera/spark-shell/output/departments_seq_intw_txt_NewAPI"
textRDD.map(row => (new IntWritable(row.split(",")(0).toInt),new Text(row.split(",")(1)))).saveAsNewAPIHadoopFile(path, classOf[IntWritable], classOf[Text], classOf[SequenceFileOutputFormat[IntWritable,Text]])

/************ read file ************/

// read object file
// cast input data to string to be able to print
val objRDD = sc.objectFile[String]("/user/cloudera/spark-shell/output/departments_obj")
objRDD.count()
objRDD.collect().foreach(println)

// read sequence file (NullWritable,Text)
val seqRDD = sc.sequenceFile("/user/cloudera/spark-shell/output/departments_seq_null_txt",classOf[NullWritable],classOf[Text])
seqRDD.count()
seqRDD.map{case(x,y) => (y.toString)}.collect.foreach(println)

// read sequence file (IntWritable,Text)
val seq2RDD = sc.sequenceFile("/user/cloudera/spark-shell/output/departments_seq_intw_txt",classOf[IntWritable],classOf[Text])
seq2RDD.count()
seq2RDD.map{case(x,y) => (x.get,y.toString)}.collect.foreach(println)

// read new api hadoop file
val newapiRDD = sc.sequenceFile("/user/cloudera/spark-shell/output/departments_seq_intw_txt_NewAPI",classOf[IntWritable],classOf[Text])
newapiRDD.count()
newapiRDD.map{case(x,y) => (x.get,y.toString)}.collect.foreach(println)
