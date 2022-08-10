# Databricks notebook source
from pyspark.sql.types import *
from pyspark.sql import SparkSession

# COMMAND ----------

database_name = 'test_db'
delta_table_name = 'test_delta_tb'
delta_location = f'/mnt/#{storage_account_container_name}#/test/stream/{delta_table_name}.delta'


# COMMAND ----------

schema = StructType().add('name',StringType(),False).add('status',StringType(),True).add('statustimeutc',TimestampType(),True).add('notifyflag',StringType(),True).add('battalion',IntegerType(),True).add('division',IntegerType(),True).add('bureau',IntegerType(),True).add('gpsbadind',StringType(),True).add('latitude',DoubleType(),True).add('longitude',DoubleType(),True).add('azimuth',DoubleType(),True).add('recordtype',StringType(),True).add('messageid',IntegerType(),True)

# COMMAND ----------


def createDeltaTable(database_name, table_name, table_schema, table_location):
    
    
    spark = SparkSession.builder.appName('test_app_dbk').getOrCreate()
    df = spark.createDataFrame(spark.sparkContext.emptyRDD(),table_schema)
    df.printSchema()
    
    df.write.format("delta").mode("overwrite").save(table_location)
    
    spark.sql(f'DROP TABLE IF EXISTS {database_name}.{table_name}')
    # spark.sql(f'DROP DATABASE IF EXISTS {database_name}')
    spark.sql(f'CREATE DATABASE IF NOT EXISTS {database_name}')
    
    spark.sql(f"CREATE TABLE {database_name}.{table_name} USING DELTA LOCATION '{table_location}'")
    emptyDF = spark.sql(f'SELECT * FROM {database_name}.{table_name}')
    display(emptyDF)
    
    describe_df = spark.sql(f'DESCRIBE {database_name}.{table_name}')
    display(describe_df)

# COMMAND ----------

createDeltaTable(database_name, delta_table_name, schema, delta_location)
