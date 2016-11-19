--hive --version
--list databases
SHOW DATABASES;

--create a database
CREATE DATABASE IF NOT EXISTS retail_db
COMMENT 'This is Retail DB';

--list databases
SHOW DATABASES;

--switch database
USE retail_db;
SELECT CURRENT_DATABASE();

--check folder created for retail db
dfs -ls /user/hive/warehouse/;
dfs -ls /user/hive/warehouse/retail_db.db;

--create a table
CREATE TABLE store (
store_id INT COMMENT 'This is the id assigned to store',
store_location STRING COMMENT 'This is the location of store'
)
COMMENT 'Store Table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;

--describe
DESCRIBE store;
DESCRIBE FORMATTED store;

/*# CREATE INPUT DATA
**# CREATE A CSV FILE
 cat > store.csv
 1,madras
 2,bombay
 3,culcatta
 4,delhi
 <Ctrl+C>
**# CREATE A PSV FILE
 sed 's/,/|/g' store.csv | cat > store.psv
*/

--load date into hive table
--load csv instead of psv
LOAD DATA LOCAL INPATH '/home/cloudera/hive/data/store.csv' INTO TABLE retail_db.store;
SELECT * FROM retail_db.store;
dfs -ls /user/hive/warehouse/retail_db.db/store/;
dfs -cat /user/hive/warehouse/retail_db.db/store/store.csv;

--now load psv
TRUNCATE TABLE retail_db.store;
SELECT * FROM retail_db.store;
LOAD DATA LOCAL INPATH '/home/cloudera/hive/data/store.psv' INTO TABLE retail_db.store;
SELECT * FROM retail_db.store;
dfs -ls /user/hive/warehouse/retail_db.db/store/;
dfs -cat /user/hive/warehouse/retail_db.db/store/store.psv;

USE retail_db;
DESCRIBE FORMATTED store;

--insert updated data into the store table
/*# CREATE UPDATED INPUT DATA
 cat > store_upd.psv
 1|chennai
 2|mumbai
 3|kolkata
 4|delhi
 <Ctrl+C>
*/

--load into store table
SELECT * FROM retail_db.store;
LOAD DATA LOCAL INPATH '/home/cloudera/hive/data/store_upd.psv' INTO TABLE retail_db.store;
SELECT * FROM retail_db.store;

--now overwrite data in table
LOAD DATA LOCAL INPATH '/home/cloudera/hive/data/store_upd.psv' OVERWRITE INTO TABLE retail_db.store;
SELECT * FROM retail_db.store;

------------------------------------------------------
-- creating a managed db/table in separate location --
------------------------------------------------------

--create a table space outside hive warehouse dir
dfs -mkdir -p /user/cloudera/hive/tbl_space

--create a db with new table space
CREATE DATABASE managed_outside_hive 
COMMENT 'this database resides outside of hive defaul warehouse folder in hdfs' 
LOCATION '/user/cloudera/hive/tbl_space/managed_outside_hive';

--create a table
CREATE TABLE managed_outside_hive.test (
id INT
)
COMMENT 'a test table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

--in the description note "Table Type" and "Location"
DESCRIBE FORMATTED managed_outside_hive.test;

--generate data in bash
seq 1 10 > sequence.txt

--load data in the table
LOAD DATA LOCAL INPATH '/home/cloudera/hive/data/sequence.txt' INTO TABLE managed_outside_hive.test;
SELECT * FROM managed_outside_hive.test;
dfs -ls  /user/cloudera/hive/tbl_space/managed_outside_hive/test;
dfs -cat /user/cloudera/hive/tbl_space/managed_outside_hive/test/sequence.txt;

--drop db and see if the data is also wiped out
DROP DATABASE managed_outside_hive CASCADE;
dfs -ls  /user/cloudera/hive/tbl_space

