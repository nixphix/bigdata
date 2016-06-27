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
