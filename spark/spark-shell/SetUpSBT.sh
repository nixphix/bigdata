curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install sbt
 
cd /home/cloudera/spark/spark-shell/spark-submit/
vi textfileio.sbt

mkdir -p src/main/scala
cd src/main/scala

vi TextFileIO.scala

cd /home/cloudera/spark/spark-shell/spark-submit/
# sbt will download dependencies
sbt
package
# jar file will be created in 
#/home/cloudera/spark/spark-shell/spark-submit/target/scala-2.10/spark-submit-text-file-io_2.10-1.0.jar

# remove the folder if it exist
hdfs dfs -ls /user/cloudera/spark-shell/spark-submit/departments_txt
hdfs dfs -rm -R /user/cloudera/spark-shell/spark-submit/departments_txt
hdfs dfs -ls /user/cloudera/spark-shell/spark-submit/departments_txt

# submit the job
spark-submit \
--master local \
/home/cloudera/spark/spark-shell/spark-submit/target/scala-2.10/spark-submit-text-file-io_2.10-1.0.jar

# check output
hdfs dfs -ls /user/cloudera/spark-shell/spark-submit/departments_txt
hdfs dfs -cat /user/cloudera/spark-shell/spark-submit/departments_txt/*



