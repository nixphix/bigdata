import org.apache.spark.{SparkContext,SparkConf}
import java.time.ZoneDateTime
import java.time.format.DateTimeFormatter

object TextFileIO extends App{
  val conf = new SparkConf().setAppName("spark-submit textfileIO")
  val sc   = new SparkContext(conf)
  def getTimeStamp: String = DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(ZonedDateTime.now())
  
  val textRDD = sc.textFile("/user/cloudera/sqoop_import/departments_txt")
  println(textRDD.count())
  textRDD.take(5) foreach println
  textRDD.saveAsTextFile("/user/cloudera/spark-shell/spark-submit/departments_txt_"+getTimeStamp)
}
