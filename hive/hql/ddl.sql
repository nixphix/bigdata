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

-- describe
DESCRIBE store;
DESCRIBE FORMATTED store;

/*# CREATE INPUT DATA
**# CREATE A CSV FILE
**cat > store.csv
**1,chennai
**2,mumbai
**3,kolkata
**4,delhi
**<Ctrl+C>
**# CREATE A PSV FILE
**sed 's/,/|/g' store.csv | cat > store.psv
*/

-- load date into hive table
-- load csv instead of psv
LOAD DATA LOCAL INPATH '/home/cloudera/hive/data/store.csv' INTO TABLE retail_db.store;
SELECT * FROM retail_db.store;
dfs -ls /user/hive/warehouse/retail_db.db/store/;
dfs -cat /user/hive/warehouse/retail_db.db/store/store.csv;

-- now load psv
TRUNCATE TABLE retail_db.store;
SELECT * FROM retail_db.store;
LOAD DATA LOCAL INPATH '/home/cloudera/hive/data/store.psv' INTO TABLE retail_db.store;
SELECT * FROM retail_db.store;
dfs -ls /user/hive/warehouse/retail_db.db/store/;
dfs -cat /user/hive/warehouse/retail_db.db/store/store.psv;

USE retail_db;
DESCRIBE FORMATTED store;







