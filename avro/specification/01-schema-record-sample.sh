#-------------  create an avro record schema based on avro spec  -------------#
#--- base on doc http://avro.apache.org/docs/1.8.1/spec.html#schema_record

#--- create a schema employee 
cat > employee.avsc
{
  "type" : "record",
  "name" : "employee",
  "doc" : "employee table",
  "fields" : [ {"name" : "employee_id", "type" : "int", "default" : 0}, 
               {"name" : "employee_name", "type" : "string", "default" : "somebody"} ]
}

#--- create another schema based on employee with date of birth field
cat > employee_new_schema.avsc
{
  "type" : "record",
  "name" : "employee",
  "doc" : "employee table",
  "fields" : [ {"name" : "employee_id", "type" : "int", "default" : 0},
               {"name" : "employee_name", "type" : "string", "default" : "somebody"},
               {"name" : "employee_dob", "type" : "long", "default" : 637804800} ]
}

#--- generate some random data for these schema
avro-tools random --schema-file employee.avsc --count 5 employee.avro
avro-tools random --schema-file employee_new_schema.avsc --count 5 employee_new_schema.avro

#--- copy the files to hdfs
ls -ltr
hdfs dfs -mkdir -p /user/cloudera/staging/avro/schema/employee
hdfs dfs -mkdir -p /user/cloudera/staging/avro/data/employee
hdfs dfs -put employee*.avsc /user/cloudera/staging/avro/schema/employee
hdfs dfs -put employee*.avro /user/cloudera/staging/avro/data/employee
