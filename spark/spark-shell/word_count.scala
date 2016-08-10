/** download data 
 *  cd /home/cloudera/spark/dataset
 *  wget http://www.apache.org/licenses/LICENSE-2.0.txt -O apache.v2.0.txt
 *  hdfs dfs -put apache.v2.0.txt dataset
 *  check output in hdfs
 *  hdfs dfs -ls dataset/apache.v2.0_wordcount
 *  hdfs dfs -cat dataset/apache.v2.0_wordcount/*
 */
 
val wcRDD = sc.textFile("dataset/apache.v2.0.txt")
wcRDD.take(5).foreach(println)
wcRDD.flatMap(line => line.trim.split(" ")).take(5).foreach(println)
wcRDD.flatMap(line => line.trim.split(" ")).map(token => (token,1)).take(5).foreach(println)
wcRDD.flatMap(line => line.trim.split(" ")).map(token => (token,1)).reduceByKey((x,y) => (x+y)).take(5).foreach(println)
val wcntRDD = wcRDD.flatMap(line => line.trim.split(" ")).map(token => (token,1)).reduceByKey((x,y) => (x+y)).sortBy(_._2,false)
wcntRDD.take(5).foreach(println)
wcntRDD.count() // res28: Long = 594

wcntRDD.saveAsTextFile("dataset/apache.v2.0_wordcount")
