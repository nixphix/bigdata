/*
CTAS has these restrictions:
The target table cannot be a partitioned table.
The target table cannot be an external table.
The target table cannot be a list bucketing table.
*/

----------------------------------------------------------------------
--  creating a managed table in retail db with existing table data  --
----------------------------------------------------------------------

--source table
SELECT * FROM default.orders limit 10;
DESC default.orders;

--create table with existing data in hive
CREATE TABLE IF NOT EXISTS retail_db.orders_mth_yr 
COMMENT 'orders data with month and year column derived from data'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
AS
SELECT order_id,order_date,order_customer_id,order_status,
MONTH(order_date) order_month,YEAR(order_date) order_year
FROM default.orders
SORT BY order_year,order_month;

--describe table
DESCRIBE FORMATTED retail_db.orders_mth_yr;
SELECT * FROM retail_db.orders_mth_yr limit 10;

--------------------------------------------------------------------------
--  creating a managed table in retail db with existing table metadata  --
--------------------------------------------------------------------------

--create table
CREATE TABLE retail_db.orders_like
LIKE default.orders;

--desc table, note that table format matches that of model table, delimiters cannot be changed for new table
DESCRIBE FORMATTED retail_db.orders_like;
DESCRIBE FORMATTED default.orders;
