//#No Used　due to the azure cloud known limitation#
//resource "databricks_secret_scope" "test_scope_tf" {
//  name = "test_scope_tf"
//
//  keyvault_metadata {
//    resource_id = azurerm_key_vault.testkv22222tf.id
//    dns_name    = azurerm_key_vault.testkv22222tf.vault_uri
//  }
//
//  depends_on = [azurerm_databricks_workspace.test_dbk_wksp_tf]
//}

//    databricks = {
//      source = "hashicorp/databricks"
//    }

//provider "databricks" {
//}


terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

//provider "databricksnw" {
//  alias = "dbks_connect"
//}

data "azuread_client_config" "current" {
}

#In Used#
resource "azurerm_key_vault_access_policy" "testkv22222_access_policy_tf" {
  key_vault_id = var.iaas_out_kv_id
  tenant_id    = var.iaas_out_client_current_tenant_id
  object_id    = data.azuread_client_config.current.object_id
//  object_id    = var.iaas_out_app_service_principal_object_id  wrong


  key_permissions = [
    "Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","Purge",
  ]

  secret_permissions = [
    "Get","List","Set","Delete","Recover","Backup","Restore","Purge",
  ]

//  depends_on = [azurerm_key_vault.testkv22222tf,azuread_service_principal.test_active_directory_tf]
}

#In Used#
resource "azurerm_key_vault_secret" "testkvsecret2tf" {
  name         = "testkvsecret2tf"
  value        = var.iaas_out_client_secret_value
  key_vault_id = var.iaas_out_kv_id
  depends_on = [azurerm_key_vault_access_policy.testkv22222_access_policy_tf]
}
//#Can't be Used#
//resource "azurerm_key_vault_secret" "ApplicationClientIDtf" {
//  name         = "ApplicationClientIDtf"
//  value        = var.iaas_out_app_id
//  key_vault_id = var.iaas_out_kv_id
//  depends_on = [azurerm_key_vault_access_policy.testkv22222_access_policy_tf]
//}

#In Used#
resource "azurerm_key_vault_secret" "EVHBShareKeytf" {
  name         = "EVHBShareKeytf"
  value        = var.iaas_out_evthubnmspctf_connect_str
  key_vault_id = var.iaas_out_kv_id
  depends_on = [azurerm_key_vault_access_policy.testkv22222_access_policy_tf]
}

//#Can't be Used#
//resource "azurerm_key_vault_secret" "TenantIDtf" {
//  name         = "TenantIDtf"
//  value        = var.iaas_out_client_current_tenant_id
//  key_vault_id = var.iaas_out_kv_id
//  depends_on = [azurerm_key_vault_access_policy.testkv22222_access_policy_tf]
//}

//#Can't be Used#
//resource "azurerm_key_vault_secret" "StorageAccountNametf" {
//  name         = "StorageAccountNametf"
//  value        = var.iaas_out_storage_account_name
//  key_vault_id = var.iaas_out_kv_id
//  depends_on = [azurerm_key_vault_access_policy.testkv22222_access_policy_tf]
//}

//#No used
//data "azurerm_subscription" "primary" {
//}
//
//
//
#In Used#
resource "azurerm_role_assignment" "service_principal_2_storage" {
  scope                = var.iaas_out_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.iaas_out_app_service_principal_object_id
  skip_service_principal_aad_check = true
}

#In Used#
resource "azurerm_role_assignment" "service_principal_2_dbks_wsp" {
  scope                = var.iaas_out_databricks_wsp_id
  role_definition_name = "Contributor"
  principal_id         = var.iaas_out_app_service_principal_object_id
  skip_service_principal_aad_check = true
  depends_on = [var.iaas_out_dbks_wsp_depends_on]
}



#In Used#
data "databricks_current_user" "dbks_current" {
   depends_on = [var.iaas_out_dbks_wsp_depends_on,azurerm_role_assignment.service_principal_2_dbks_wsp]

}


#In Used#
resource "databricks_token" "pat" {
//  provider = databricks.dbks_connect
  comment  = "terraform_connect_dbks_wp"
//  // 25 day token
  lifetime_seconds = 2160000
//  depends_on = [azurerm_databricks_workspace.test_dbk_wksp_tf]
}

#In Used#
resource "databricks_cluster" "test_dbks_cluster_tf" {
  provider = databricks
  cluster_name            = "test_dbks_cluster_tf"
  spark_version           = "11.1.x-scala2.12"
  node_type_id            = "Standard_F4"
  driver_node_type_id     = "Standard_F4"
  autotermination_minutes = 20
  num_workers             = 0

  spark_conf = {
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }
  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
}

#In Used#
resource "databricks_library" "test_add_spark_azure_pkg_tf" {
  provider = databricks
  cluster_id = databricks_cluster.test_dbks_cluster_tf.id
  maven {
    coordinates = "com.microsoft.azure:azure-eventhubs-spark_2.12:2.3.22"
//    // exclusions block is optional
//    exclusions = ["org.apache.avro:avro"]
  }
//  depends_on = [databricks_cluster.test_dbks_cluster_tf] // in use
}

//#In Used#
//resource "databricks_notebook" "delta_table_config" {
//  provider = databricks
//  source = "/Users/chenqingmin/Codes/terraform_test_azure_project/src/delta_table_configuration.py"
//  path   = "${data.databricks_current_user.dbks_current.home}/src/delta_table_configuration.py"
//
////  depends_on = [databricks_cluster.test_dbks_cluster_tf] // in use
//}
//
//#In Used#
//resource "databricks_notebook" "key_config" {
//  provider = databricks
//  source = "/Users/chenqingmin/Codes/terraform_test_azure_project/src/key_configuration.py"
//  path   = "${data.databricks_current_user.dbks_current.home}/src/key_configuration.py"
//
////  depends_on = [databricks_cluster.test_dbks_cluster_tf] // in use
//}
//#In Used#
//resource "databricks_notebook" "streamming_app" {
//  provider = databricks
//  source = "/Users/chenqingmin/Codes/terraform_test_azure_project/src/streamming_app.py"
//  path   = "${data.databricks_current_user.dbks_current.home}/src/streamming_app.py"
//
////  depends_on = [databricks_cluster.test_dbks_cluster_tf] // in use
//}