#-------------------- avro tools --------------------#
#--- this will list the avro commands
avro-tools

#-------------------- cat --------------------#
# cat output the avro file in avro format either to std output or a file
# cat data to std output with -, offset will set records to skip and limit will set number of records to read
# notice that the output contains the schema and two records all in binary formate
avro-tools cat --offset 2 --limit 2 part-m-00000-departments.avro -

# lets save it to a file
# this will limit the data to first two records
avro-tools cat --limit 2 part-m-00000-departments.avro first-two-rec-departments.avro

# command will skip first two records and outputs next 2 records 
avro-tools cat --offset 2 --limit 2 part-m-00000-departments.avro next-two-rec-departments.avro

# command will skip first four records and outputs rest of departments 
avro-tools cat --offset 4 part-m-00000-departments.avro rest-of-the-departments.avro

#-------------------- concat --------------------#
# concat concatinates avro files
avro-tools concat first-two-rec-departments.avro next-two-rec-departments.avro rest-of-the-departments.avro departments.avro
view departments.avro

#-------------------- getmeta --------------------#
# prints meta data of avro file with compression codec information
avro-tools getmeta departments.avro

#-------------------- getschema --------------------#
# prints meta data of avro file as json file
avro-tools getschema departments.avro

# save the schema to a json file 
avro-tools getschema departments.avro | cat > departments_schema.json

#-------------------- random --------------------#
avro-tools random --schema-file departments_schema.json --count 5 -
