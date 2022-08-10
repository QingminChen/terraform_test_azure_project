# # Databricks notebook source
# from pyspark.sql.types import *
# from pyspark.sql.functions import *
# import datetime
# import time
#
# from delta.tables import *
#
#
# # COMMAND ----------
#
# connect_string = dbutils.secrets.get('test_scope','EVHBShareKey')
# print(connect_string)
# source_event_hub = 'testevthub1'
#
# # COMMAND ----------
#
# service_credential = dbutils.secrets.get(scope="test_scope",key="testkvsecret2")
#
# spark.conf.set("fs.azure.account.auth.type.teststorage2222.dfs.core.windows.net", "OAuth")
# spark.conf.set("fs.azure.account.oauth.provider.type.teststorage2222.dfs.core.windows.net","org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
# spark.conf.set("fs.azure.account.oauth2.client.id.teststorage2222.dfs.core.windows.net", "af123379-59f7-45b0-a273-d940a370c092")
# spark.conf.set("fs.azure.account.oauth2.client.secret.teststorage2222.dfs.core.windows.net", service_credential)
# spark.conf.set("fs.azure.account.oauth2.client.endpoint.teststorage2222.dfs.core.windows.net", "https://login.microsoftonline.com/2890298d-6798-4ee8-8e84-320d2c1268cb/oauth2/token")
# spark.conf.set("spark.databricks.delta.formatCheck.enabled","false")
#
#
#
# conf = {}
# # conf['eventhubs.connectionstring'] = connect_string + ';entityPath=' + source_event_hub
# conf['eventhubs.connectionstring'] = sc._jvm.org.apache.spark.eventhubs.EventHubsUtils.encrypt(connect_string + ';entityPath=' + source_event_hub)
# input_stream_df = (spark.readStream
#                    .format('org.apache.spark.sql.eventhubs.EventHubsSourceProvider')
#                    .options(**conf)
#                    .load())
#
# input_stream_df.isStreaming
# input_stream_df.printSchema
# # allfiles.coalesce(1).write.format("csv").option("header", "false").save("/destination_path/single_csv_file/")
#
# # def foreach_batch_function(df, epoch_id):
# #     # Transform and write batchDF
# #     pass
#
# # input_stream_df.writeStream.foreachBatch(foreach_batch_function).start()
#
# # input_stream_df.writeStream.format("console").outputMode("complete").start()
#
# # COMMAND ----------
#
# # ALTER TABLE test_message_df SET TBLPROPERTIES (
# #    'delta.columnMapping.mode' = 'name',
# #    'delta.minReaderVersion' = '2',
# #    'delta.minWriterVersion' = '5')
#
# # COMMAND ----------
#
# message_df = input_stream_df.withColumn('Offset',col('offset').cast(LongType())).withColumn('Time (readable)',col('enqueuedTime').cast(TimestampType())).withColumn('Timestamp',col('enqueuedTime').cast(TimestampType())).withColumn('Body',col('body').cast(StringType())).select('Offset','Time (readable)','Timestamp','Body')
#
# message_df.isStreaming
# message_df.printSchema
#
# msgSchema = StructType().add("offset", "long").add("time", "timestamp").add("timestamp","timestamp").add("body","string")
#
# # message_df.writeStream.outputMode("append").format("csv").option("checkpointLocation","dbfs:/tmp/unitstatus").start("abfss://datalake@teststorage2222.dfs.core.windows.net/test/stream/test_message_df").awaitTermination() #right
#
# # message_df.writeStream.outputMode("append").format("delta").option("checkpointLocation","dbfs:/tmp/unitstatus").start("abfss://datalake@teststorage2222.dfs.core.windows.net/test/stream/test_message_df").awaitTermination() # has issue
#
#
#
#
# # COMMAND ----------
#
# database_name = 'test_db'
# delta_table_name = 'test_delta_tb'
#
# def send_mg_batch(micro_batch_df, micro_batch_id):
# #     print("batch_id:"+str(micro_batch_id)+",number of records:"+str(micro_batch_df.count()))
#     schema = StructType() \
#       .add('name',StringType(),False) \
#       .add('status',StringType(),True) \
#       .add('ovdhsp30',StringType(),True) \
#       .add('ovdhsp60',StringType(),True) \
#       .add('ovdnav30',StringType(),True) \
#       .add('ovdnav60',StringType(),True) \
#       .add('statustimeutc',StringType(),True) \
#       .add('unitlocked',StringType(),True) \
#       .add('location',StringType(),True) \
#       .add('current',StringType(),True) \
#       .add('baserfs',StringType(),True) \
#       .add('displaypage',StringType(),True) \
#       .add('displayfield',StringType(),True) \
#       .add('shadowpage',StringType(),True) \
#       .add('shadowfield',StringType(),True) \
#       .add('brokenmdt',StringType(),True) \
#       .add('type',StringType(),True) \
#       .add('tfsplit',StringType(),True) \
#       .add('notifyflag',StringType(),True) \
#       .add('activereserve',StringType(),True) \
#       .add('mutualaid',StringType(),True) \
#       .add('battalion',StringType(),True) \
#       .add('division',StringType(),False) \
#       .add('bureau',StringType(),True) \
#       .add('baserfsnbr',StringType(),True) \
#       .add('shopnbr',StringType(),True) \
#       .add('accessid',StringType(),True) \
#       .add('homepagenbr',StringType(),True) \
#       .add('homefieldnbr',StringType(),True) \
#       .add('gpsbadind',StringType(),True) \
#       .add('latitude',StringType(),True) \
#       .add('longitude',StringType(),True) \
#       .add('azimuth',StringType(),True) \
#       .add('velocity',StringType(),True) \
#       .add('utctime',StringType(),True) \
#       .add('attributes',StringType(),True) \
#       .add('recordtype',StringType(),True) \
#       .add('messageid',StringType(),True) \
#       .add('sendtime',StringType(),True) \
#       .add('seconds',StringType(),True) \
#       .add('nanos',StringType(),True) \
# #     micro_batch_df.count()
#     body_df = micro_batch_df.select(from_json(col('body'), schema).alias('data')).select('data.*')
#     body_df.show(n=1)
#     unit_status_df = body_df \
#        .withColumn('statustimeutc',current_timestamp()) \
#        .withColumn('utctime',current_timestamp()) \
#        .withColumn('battalion',body_df.battalion.cast(IntegerType())) \
#        .withColumn('division',body_df.division.cast(IntegerType())) \
#        .withColumn('bureau',body_df.bureau.cast(IntegerType())) \
#        .withColumn('latitude',body_df.latitude.cast(DoubleType())) \
#        .withColumn('longitude',body_df.longitude.cast(DoubleType())) \
#        .withColumn('azimuth',body_df.azimuth.cast(DoubleType())) \
#        .withColumn('messageid',body_df.messageid.cast(IntegerType())) \
#        .select('name','status','statustimeutc','notifyflag','battalion','division','bureau','gpsbadind','latitude','longitude','azimuth','recordtype','messageid')
#     unit_status_deduped_df = unit_status_df.dropDuplicates(['name'])
#     print("Number of recoreds in the unit_status_deduped_df:{unit_status_deduped_df.count()}")
#
#     deltaTable = DeltaTable.forName(spark, f'{database_name}.{delta_table_name}')
#     deltaTable.alias('t') \
#       .merge(unit_status_deduped_df.alias('s'),'s.name = t.name') \
#       .whenNotMatchedInsertAll() \
#       .whenMatchedUpdateAll() \
#       .execute()
#
#
#
#
#
# message_df.writeStream.option('checkpointLocation','dbfs:/tmp/unitstatus').foreachBatch(send_mg_batch).start()


# Databricks notebook source
from pyspark.sql.types import *
from pyspark.sql.functions import *
import datetime
import time

from delta.tables import *

# COMMAND ----------

connect_string = dbutils.secrets.get('test_scope_tf', '#{secets_files_prepare_out_kv_evhub_share_str_name}#')
print(connect_string)
source_event_hub = '#{iaas_out_event_hub_name}#'

# COMMAND ----------

service_credential = dbutils.secrets.get(scope="test_scope_tf", key='#{key_vault_app_client_secret_name}#')

spark.conf.set("fs.azure.account.auth.type.#{storage_account_name}#.dfs.core.windows.net", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type.#{storage_account_name}#.dfs.core.windows.net",
               "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.#{storage_account_name}#.dfs.core.windows.net", "#{app_client_id}#")
spark.conf.set("fs.azure.account.oauth2.client.secret.#{storage_account_name}#.dfs.core.windows.net",
               service_credential)
spark.conf.set("fs.azure.account.oauth2.client.endpoint.#{storage_account_name}#.dfs.core.windows.net",
               "https://login.microsoftonline.com/#{client_current_tenant_id}#/oauth2/token")
spark.conf.set("spark.databricks.delta.formatCheck.enabled", "false")

conf = {}
# conf['eventhubs.connectionstring'] = connect_string + ';entityPath=' + source_event_hub
conf['eventhubs.connectionstring'] = sc._jvm.org.apache.spark.eventhubs.EventHubsUtils.encrypt(
    connect_string + ';entityPath=' + source_event_hub)
input_stream_df = (spark.readStream
                   .format('org.apache.spark.sql.eventhubs.EventHubsSourceProvider')
                   .options(**conf)
                   .load())

input_stream_df.isStreaming
input_stream_df.printSchema
# allfiles.coalesce(1).write.format("csv").option("header", "false").save("/destination_path/single_csv_file/")

# def foreach_batch_function(df, epoch_id):
#     # Transform and write batchDF
#     pass

# input_stream_df.writeStream.foreachBatch(foreach_batch_function).start()

# input_stream_df.writeStream.format("console").outputMode("complete").start()

# COMMAND ----------

# ALTER TABLE test_message_df SET TBLPROPERTIES (
#    'delta.columnMapping.mode' = 'name',
#    'delta.minReaderVersion' = '2',
#    'delta.minWriterVersion' = '5')

# COMMAND ----------

message_df = input_stream_df.withColumn('Offset', col('offset').cast(LongType())).withColumn('Time (readable)',
                                                                                             col('enqueuedTime').cast(
                                                                                                 TimestampType())).withColumn(
    'Timestamp', col('enqueuedTime').cast(TimestampType())).withColumn('Body', col('body').cast(StringType())).select(
    'Offset', 'Time (readable)', 'Timestamp', 'Body')

message_df.isStreaming
message_df.printSchema

msgSchema = StructType().add("offset", "long").add("time", "timestamp").add("timestamp", "timestamp").add("body",
                                                                                                          "string")

# message_df.writeStream.outputMode("append").format("csv").option("checkpointLocation","dbfs:/tmp/unitstatus").start("abfss://datalake@teststorage2222.dfs.core.windows.net/test/stream/test_message_df").awaitTermination() #right

# message_df.writeStream.outputMode("append").format("delta").option("checkpointLocation","dbfs:/tmp/unitstatus").start("abfss://datalake@teststorage2222.dfs.core.windows.net/test/stream/test_message_df").awaitTermination() # has issue


# COMMAND ----------

database_name = 'test_db'
delta_table_name = 'test_delta_tb'


def send_mg_batch(micro_batch_df, micro_batch_id):
    #     print("batch_id:"+str(micro_batch_id)+",number of records:"+str(micro_batch_df.count()))
    schema = StructType() \
        .add('name', StringType(), False) \
        .add('status', StringType(), True) \
        .add('ovdhsp30', StringType(), True) \
        .add('ovdhsp60', StringType(), True) \
        .add('ovdnav30', StringType(), True) \
        .add('ovdnav60', StringType(), True) \
        .add('statustimeutc', StringType(), True) \
        .add('unitlocked', StringType(), True) \
        .add('location', StringType(), True) \
        .add('current', StringType(), True) \
        .add('baserfs', StringType(), True) \
        .add('displaypage', StringType(), True) \
        .add('displayfield', StringType(), True) \
        .add('shadowpage', StringType(), True) \
        .add('shadowfield', StringType(), True) \
        .add('brokenmdt', StringType(), True) \
        .add('type', StringType(), True) \
        .add('tfsplit', StringType(), True) \
        .add('notifyflag', StringType(), True) \
        .add('activereserve', StringType(), True) \
        .add('mutualaid', StringType(), True) \
        .add('battalion', StringType(), True) \
        .add('division', StringType(), False) \
        .add('bureau', StringType(), True) \
        .add('baserfsnbr', StringType(), True) \
        .add('shopnbr', StringType(), True) \
        .add('accessid', StringType(), True) \
        .add('homepagenbr', StringType(), True) \
        .add('homefieldnbr', StringType(), True) \
        .add('gpsbadind', StringType(), True) \
        .add('latitude', StringType(), True) \
        .add('longitude', StringType(), True) \
        .add('azimuth', StringType(), True) \
        .add('velocity', StringType(), True) \
        .add('utctime', StringType(), True) \
        .add('attributes', StringType(), True) \
        .add('recordtype', StringType(), True) \
        .add('messageid', StringType(), True) \
        .add('sendtime', StringType(), True) \
        .add('seconds', StringType(), True) \
        .add('nanos', StringType(), True) \
        #     micro_batch_df.count()
    body_df = micro_batch_df.select(from_json(col('body'), schema).alias('data')).select('data.*')
    body_df.show(n=1)
    unit_status_df = body_df \
        .withColumn('statustimeutc', current_timestamp()) \
        .withColumn('utctime', current_timestamp()) \
        .withColumn('battalion', body_df.battalion.cast(IntegerType())) \
        .withColumn('division', body_df.division.cast(IntegerType())) \
        .withColumn('bureau', body_df.bureau.cast(IntegerType())) \
        .withColumn('latitude', body_df.latitude.cast(DoubleType())) \
        .withColumn('longitude', body_df.longitude.cast(DoubleType())) \
        .withColumn('azimuth', body_df.azimuth.cast(DoubleType())) \
        .withColumn('messageid', body_df.messageid.cast(IntegerType())) \
        .select('name', 'status', 'statustimeutc', 'notifyflag', 'battalion', 'division', 'bureau', 'gpsbadind',
                'latitude', 'longitude', 'azimuth', 'recordtype', 'messageid')
    unit_status_deduped_df = unit_status_df.dropDuplicates(['name'])
    print("Number of recoreds in the unit_status_deduped_df:{unit_status_deduped_df.count()}")

    deltaTable = DeltaTable.forName(spark, f'{database_name}.{delta_table_name}')
    deltaTable.alias('t') \
        .merge(unit_status_deduped_df.alias('s'), 's.name = t.name') \
        .whenNotMatchedInsertAll() \
        .whenMatchedUpdateAll() \
        .execute()


message_df.writeStream.option('checkpointLocation', 'dbfs:/tmp/unitstatus').foreachBatch(send_mg_batch).start()


