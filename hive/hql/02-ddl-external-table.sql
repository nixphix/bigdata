--------------------------------------------------
--  creating an external table under retail db  --
--------------------------------------------------

--switch db and list tables
USE retail_db;
SHOW TABLES;

--creat an external table
CREATE EXTERNAL TABLE IF NOT EXISTS store_external (
store_id INT,
store_location STRING
)
COMMENT 'this is an external table under retail db schema'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

--describe and notice that the file location is inherited from parent db
