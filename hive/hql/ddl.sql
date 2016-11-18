--hive --version
--list databases
SHOW DATABASES;

--create a database
CREATE DATABASE IF NOT EXISTS RETAIL_DB
COMMENT 'This is Retail DB';

--list databases
SHOW DATABASES;

--switch database
USE RETAIL_DB;
SELECT CURRENT_DATABASE();

--check folder created for retail db
dfs -ls /user/hive/warehouse/;
dfs -ls /user/hive/warehouse/retail_db.db;
