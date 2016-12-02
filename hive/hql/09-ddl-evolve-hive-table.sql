-----------------------------------------------------------------------
--  creating hive table with avro format and then evolve the schema  --
-----------------------------------------------------------------------

--- create avro schema for a new table
--- bigdata/avro/specification/01-schema-record-sample.sh

--- creat a database avro
CREATE DATABASE avro;
USE avro;

--- create hive table employee
CREATE TABLE IF NOT EXISTS avro.employee
STORED AS AVRO
TBLPROPERTIES ('avro.schema.url'='/user/cloudera/staging/avro/schema/employee/employee.avsc');

--- describe employee table, load data and select the data
--- hint: to check the avro format data use hue, hue will render the data in json format
DESC FORMATTED avro.employee;
LOAD DATA INPATH '/user/cloudera/staging/avro/data/employee/employee.avro' INTO TABLE avro.employee;
SELECT * FROM avro.employee;

--- evolve the table by changing avro schema
--- it can be done by overwriting the schema file or altering the table properties
ALTER TABLE avro.employee SET TBLPROPERTIES ('avro.schema.url'='/user/cloudera/staging/avro/schema/employee/employee_new_schema.avsc');

--- now describe the table 
--- notice that schema file url has changed and a new column dob appears
DESC FORMATTED avro.employee;

--- for existing data it should return the default value 
SELECT * FROM avro.employee;

--- lets load data for new schema, do not overwrite we want keep the existing data
LOAD DATA INPATH '/user/cloudera/staging/avro/data/employee/employee_new_schema.avro' INTO TABLE avro.employee;
SELECT * FROM avro.employee;

