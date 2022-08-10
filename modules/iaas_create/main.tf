//terraform {
//  required_providers {
//    databricks = {
//      source = "databricks/databricks"
//    }
//    azurerm = {
//      source  = "hashicorp/azurerm"
//      version = "=3.15.1"
//    }
//  }
//}


#In Used#
# Create a resource group
resource "azurerm_resource_group" "test_rs_gp_tf" {
  name     = var.rs_gp_tf_nm
  location = var.location
}


#In Used#
data "azuread_client_config" "current" {
}

#In Used#
resource "azurerm_key_vault" "testkv22222tf" {
  name                        = "testkv22222tf"
  location                    = azurerm_resource_group.test_rs_gp_tf.location
  resource_group_name         = azurerm_resource_group.test_rs_gp_tf.name
  tenant_id                   = data.azuread_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

//  access_policy {
//    tenant_id = data.azuread_client_config.current.tenant_id
//    object_id = data.azuread_client_config.current.object_id
//
//    key_permissions = [
//      "Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","Purge"
////      "Rotate","Get Rotation Policy","Set Rotation Policy"
//    ]
//
//    secret_permissions = [
//      "Get","List","Set","Delete","Recover","Backup","Restore","Purge"
//    ]
//
//    certificate_permissions = [
//      "Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","ManageContacts",
////      "Manage Certificate Authorities",
////      "Get Certificate Authorities",
////      "List Certificate Authorities",
////      "Set Certificate Authorities",
////      "Delete Certificate Authorities"
//    ]
//  }
  depends_on = [azurerm_resource_group.test_rs_gp_tf]
}

#In Used#
resource "azuread_application" "test_active_directory_tf" {
  display_name     = "test_active_directory_tf"
//  identifier_uris  = ["api://example-app"]
//  logo_image       = filebase64("/path/to/logo.png")
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"
  web {
    redirect_uris = ["https://qingmin.com/auth"]
  }
}

#In Used#
resource "azuread_service_principal" "test_active_directory_tf" {
  application_id = azuread_application.test_active_directory_tf.application_id
  app_role_assignment_required = false
  feature_tags {
    enterprise = true
    gallery = false
  }
  depends_on = [azuread_application.test_active_directory_tf]
}

#In Used#
resource "azuread_application_password" "test_active_directory_client_tf" {
  application_object_id = azuread_application.test_active_directory_tf.id
  display_name = "test_active_directory_client_tf"
  end_date = "2022-10-27T00:00:00Z"
  depends_on = [azuread_service_principal.test_active_directory_tf]
}

#In Used#
resource "azurerm_storage_account" "teststorage2222tf" {
  name                     = "teststorage2222tf"
  resource_group_name      = var.rs_gp_tf_nm
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [azurerm_resource_group.test_rs_gp_tf]
}

resource "azurerm_storage_container" "datalaketf" {
  name  = "datalaketf"
  storage_account_name = azurerm_storage_account.teststorage2222tf.name
  container_access_type = "private"
  depends_on = [azurerm_storage_account.teststorage2222tf]
}

#In Used#
resource "azurerm_eventhub_namespace" "testevthubnmspctf" {
  name                = "testevthubnmspctf"
  location            = var.location
  resource_group_name = var.rs_gp_tf_nm
  sku                 = "Basic"
  capacity            = 1
  depends_on = [azurerm_resource_group.test_rs_gp_tf]

}

#In Used#
resource "azurerm_eventhub" "testevthub1tf" {
  name                = "testevthub1tf"
  namespace_name      = azurerm_eventhub_namespace.testevthubnmspctf.name
  resource_group_name = var.rs_gp_tf_nm
  partition_count     = 2
  message_retention   = 1
  depends_on = [azurerm_eventhub_namespace.testevthubnmspctf]
}

#In Used#
resource "azurerm_databricks_workspace" "test_dbk_wksp_tf" {
  name                = "test_dbk_wksp_tf"
  resource_group_name = var.rs_gp_tf_nm
  location            = var.location
  sku                 = "trial"

  depends_on = [azurerm_resource_group.test_rs_gp_tf]
}