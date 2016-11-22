----------------------------------------------------------------------
--  creating an external table in retail db under warehouse folder  --
----------------------------------------------------------------------

--switch db and list tables
USE retail_db;
SHOW TABLES;

--create an external table
CREATE EXTERNAL TABLE IF NOT EXISTS store_external (
store_id INT,
store_location STRING
)
COMMENT 'this is an external table under retail db schema'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

--describe and notice that the file location is inherited from parent db
DESCRIBE FORMATTED store_external;
dfs -ls -R /user/hive/warehouse/retail_db.db/;

--load data
dfs -mkdir -p /user/cloudera/hive/src/;
dfs -put /home/cloudera/hive/data/store.csv /user/cloudera/hive/src/;
dfs -ls -R /user/cloudera/hive/src/;

LOAD DATA INPATH '/user/cloudera/hive/src/store.csv' INTO TABLE retail_db.store_external;
SELECT * FROM retail_db.store_external;

--data file is actually moved to destination dir from the src dir by load command
dfs -ls -R /user/hive/warehouse/retail_db.db;
dfs -ls -R /user/cloudera/hive/src;

--now drop the table and check if the the data file still exists
DROP TABLE retail_db.store_external;
dfs -ls -R /user/hive/warehouse/retail_db.db;

--cleanup
dfs -rm -R /user/hive/warehouse/retail_db.db/store_external;


---------------------------------------------------------------------
--  creating an external table in retail db under external folder  --
---------------------------------------------------------------------

--create external hdfs dir for the table and copy the src file again
dfs -mkdir -p /user/cloudera/hive/tbl_space/retail_db/store_external;
dfs -put /home/cloudera/hive/data/store.csv /user/cloudera/hive/src/;

--create an external table and load data
CREATE EXTERNAL TABLE IF NOT EXISTS retail_db.store_external (
store_id INT,
store_location STRING
)
COMMENT 'this is an external table under retail db schema'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/cloudera/hive/tbl_space/retail_db/store_external';
LOAD DATA INPATH '/user/cloudera/hive/src/store.csv' INTO TABLE retail_db.store_external;

--describe and notice that the file location is not in hive warehouse
DESCRIBE FORMATTED store_external;
dfs -ls -R /user/hive/warehouse/retail_db.db/;
dfs -ls -R /user/cloudera/hive/tbl_space/;

SELECT * FROM retail_db.store_external;

--drop table and check if the data persists
DROP TABLE retail_db.store_external;
dfs -ls -R /user/cloudera/hive/tbl_space/;
dfs -cat /user/cloudera/hive/tbl_space/retail_db/store_external/store.csv;

--cleanup move the src file back to src dir and delete table dir
dfs -mv /user/cloudera/hive/tbl_space/retail_db/store_external/store.csv /user/cloudera/hive/src/store.csv;
dfs -rm -R /user/cloudera/hive/tbl_space/retail_db/store_external;
dfs -ls -R /user/cloudera/hive/;

