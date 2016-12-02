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

#--- copy the files to hdfs
