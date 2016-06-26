import org.apache.spark.{SparkContext,SparkConf}

  val conf = new SparkConf().setAppName("spark-submit textfileIO")
  val sc   = new SparkContext(conf)
  
  val textRDD = sc.textFile("/user/cloudera/sqoop_import/departments_txt")
  //println(textRDD.count())
  //textRDD.take(5) foreach println
  textRDD.saveAsTextFile("/user/cloudera/spark-shell/spark-submit/departments_txt")
